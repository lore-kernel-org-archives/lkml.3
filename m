Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaF0SdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:33:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaF0SdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:33:08 -0400
Date: Fri, 27 Jun 2014 19:01:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] tracing/uprobes: Revert "Support mix of ftrace and
	perf"
Message-ID: <20140627170136.GA18319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140627170116.GA18298@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: stable@vger.kernel.org # v3.14
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_uprobe.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 04fdb5d..08e7970 100644
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
1.5.5.1

