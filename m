Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaDQXoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:44:10 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56511 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751314AbaDQXn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:43:57 -0400
Message-Id: <20140417234355.790231466@goodmis.org>
User-Agent: quilt/0.61-1
Date: Thu, 17 Apr 2014 19:42:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <stable@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 2/2] tracing/uprobes: Fix uprobe_cpu_buffer memory leak
References: <20140417234256.185058335@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-tracing-uprobes-Fix-uprobe_cpu_buffer-memory-leak.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Forgot to free uprobe_cpu_buffer percpu page in uprobe_buffer_disable().

Link: http://lkml.kernel.org/p/534F8B3F.1090407@huawei.com

Cc: stable@vger.kernel.org # v3.14+
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 930e514..c082a74 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -732,9 +732,15 @@ static int uprobe_buffer_enable(void)
 
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
-- 
1.8.5.3


