Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaDQIGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:06:50 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:35397 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaDQIGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:06:40 -0400
Message-ID: <534F8B3F.1090407@huawei.com>
Date: Thu, 17 Apr 2014 16:05:19 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung.kim@lge.com>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing/uprobes: fix uprobe_cpu_buffer memory leak
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to free uprobe_cpu_buffer percpu page in uprobe_buffer_disable.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace_uprobe.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index e447336..071d3bb 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -729,9 +729,15 @@ static int uprobe_buffer_enable(void)

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
1.8.3.1

