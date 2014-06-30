Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972AbaF3VwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:52:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:5061 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752266AbaF3Vvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:51:46 -0400
Message-Id: <20140630215144.416698132@goodmis.org>
User-Agent: quilt/0.63-1
Date: Mon, 30 Jun 2014 17:50:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 1/4] tracing/uprobes: Revert "Support mix of ftrace and perf"
References: <20140630215038.852406012@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-tracing-uprobes-Revert-Support-mix-of-ftrace-and-per.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

This reverts commit 43fe98913c9f67e3b523615ee3316f9520a623e0.

This patch is very wrong. Firstly, this change leads to unbalanced
uprobe_unregister(). Just for example,

	# perf probe -x /lib/libc.so.6 syscall
	# echo 1 >> /sys/kernel/debug/tracing/events/probe_libc/enable
	# perf record -e probe_libc:syscall whatever

after that uprobe is dead (unregistered) but the user of ftrace/perf
can't know this, and it looks as if nobody hits this probe.

This would be easy to fix, but there are other reasons why it is not
simple to mix ftrace and perf. If nothing else, they can't share the
same ->consumer.filter. This is fixable too, but probably we need to
fix the poorly designed uprobe_register() interface first. At least
"register" and "apply" should be clearly separated.

Link: http://lkml.kernel.org/p/20140627170136.GA18319@redhat.com

Cc: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: stable@vger.kernel.org # v3.14
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_uprobe.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 04fdb5de823c..08e7970bf3f9 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -893,6 +893,9 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 	int ret;
 
 	if (file) {
+		if (tu->tp.flags & TP_FLAG_PROFILE)
+			return -EINTR;
+
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link)
 			return -ENOMEM;
@@ -901,8 +904,12 @@ probe_event_enable(struct trace_uprobe *tu, struct ftrace_event_file *file,
 		list_add_tail_rcu(&link->list, &tu->tp.files);
 
 		tu->tp.flags |= TP_FLAG_TRACE;
-	} else
+	} else {
+		if (tu->tp.flags & TP_FLAG_TRACE)
+			return -EINTR;
+
 		tu->tp.flags |= TP_FLAG_PROFILE;
+	}
 
 	ret = uprobe_buffer_enable();
 	if (ret < 0)
-- 
2.0.0


