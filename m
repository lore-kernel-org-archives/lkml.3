Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaGHAyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:54:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbaGGXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:54:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.15 103/122] tracing/uprobes: Revert "Support mix of ftrace and perf"
Date: Mon,  7 Jul 2014 16:57:45 -0700
Message-Id: <20140707235737.334853048@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 48212542067a7ff6cbe829dbae279c2ff7557b44 upstream.

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
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_uprobe.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -893,6 +893,9 @@ probe_event_enable(struct trace_uprobe *
 	int ret;
 
 	if (file) {
+		if (tu->tp.flags & TP_FLAG_PROFILE)
+			return -EINTR;
+
 		link = kmalloc(sizeof(*link), GFP_KERNEL);
 		if (!link)
 			return -ENOMEM;
@@ -901,8 +904,12 @@ probe_event_enable(struct trace_uprobe *
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


