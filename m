Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933746AbaE2Ffs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:35:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252AbaE2Ee6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:34:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.14 031/140] tracing/uprobes: Fix uprobe_cpu_buffer memory leak
Date: Wed, 28 May 2014 21:32:50 -0700
Message-Id: <20140529043053.386069244@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit 6ea6215fe394e320468589d9bba464a48f6d823a upstream.

Forgot to free uprobe_cpu_buffer percpu page in uprobe_buffer_disable().

Link: http://lkml.kernel.org/p/534F8B3F.1090407@huawei.com

Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_uprobe.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -728,9 +728,15 @@ static int uprobe_buffer_enable(void)
 
 static void uprobe_buffer_disable(void)
 {
+	int cpu;
+
 	BUG_ON(!mutex_is_locked(&event_mutex));
 
 	if (--uprobe_buffer_refcnt == 0) {
+		for_each_possible_cpu(cpu)
+			free_page((unsigned long)per_cpu_ptr(uprobe_cpu_buffer,
+							     cpu)->buf);
+
 		free_percpu(uprobe_cpu_buffer);
 		uprobe_cpu_buffer = NULL;
 	}


