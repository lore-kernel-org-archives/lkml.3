Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaBJXdM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:33:12 -0500
Received: from mail.efficios.com ([78.47.125.74]:52095 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaBJXdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:33:07 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Feb 2014 18:33:06 EST
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH] Fix: module signature vs tracepoints: add new TAINT_UNSIGNED_MODULE
Date: Mon, 10 Feb 2014 18:23:20 -0500
Message-Id: <1392074600-21977-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users have reported being unable to trace non-signed modules loaded
within a kernel supporting module signature.

This is caused by tracepoint.c:tracepoint_module_coming() refusing to
take into account tracepoints sitting within force-loaded modules
(TAINT_FORCED_MODULE). The reason for this check, in the first place, is
that a force-loaded module may have a struct module incompatible with
the layout expected by the kernel, and can thus cause a kernel crash
upon forced load of that module on a kernel with CONFIG_TRACEPOINTS=y.

Tracepoints, however, specifically accept TAINT_OOT_MODULE and
TAINT_CRAP, since those modules do not lead to the "very likely system
crash" issue cited above for force-loaded modules.

With kernels having CONFIG_MODULE_SIG=y (signed modules), a non-signed
module is tainted re-using the TAINT_FORCED_MODULE taint flag.
Unfortunately, this means that Tracepoints treat that module as a
force-loaded module, and thus silently refuse to consider any tracepoint
within this module.

Since an unsigned module does not fit within the "very likely system
crash" category of tainting, add a new TAINT_UNSIGNED_MODULE taint flag
to specifically address this taint behavior, and accept those modules
within Tracepoints. This flag is assigned to the letter 'N', since all
the more obvious ones (e.g. 'S') were already taken.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: David Howells <dhowells@redhat.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kernel.h        |    1 +
 include/trace/events/module.h |    3 ++-
 kernel/module.c               |    4 +++-
 kernel/panic.c                |    1 +
 kernel/tracepoint.c           |    5 +++--
 5 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 196d1ea..4710900 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -469,6 +469,7 @@ extern enum system_states {
 #define TAINT_CRAP			10
 #define TAINT_FIRMWARE_WORKAROUND	11
 #define TAINT_OOT_MODULE		12
+#define TAINT_UNSIGNED_MODULE		13
 
 extern const char hex_asc[];
 #define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 1619327..1788a02 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -23,7 +23,8 @@ struct module;
 #define show_module_flags(flags) __print_flags(flags, "",	\
 	{ (1UL << TAINT_PROPRIETARY_MODULE),	"P" },		\
 	{ (1UL << TAINT_FORCED_MODULE),		"F" },		\
-	{ (1UL << TAINT_CRAP),			"C" })
+	{ (1UL << TAINT_CRAP),			"C" },		\
+	{ (1UL << TAINT_UNSIGNED_MODULE),	"N" })
 
 TRACE_EVENT(module_load,
 
diff --git a/kernel/module.c b/kernel/module.c
index d24fcf2..73ca01a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1013,6 +1013,8 @@ static size_t module_flags_taint(struct module *mod, char *buf)
 		buf[l++] = 'F';
 	if (mod->taints & (1 << TAINT_CRAP))
 		buf[l++] = 'C';
+	if (mod->taints & (1 << TAINT_UNSIGNED_MODULE))
+		buf[l++] = 'N';
 	/*
 	 * TAINT_FORCED_RMMOD: could be added.
 	 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
@@ -3214,7 +3216,7 @@ static int load_module(struct load_info *info, const char __user *uargs,
 		pr_notice_once("%s: module verification failed: signature "
 			       "and/or  required key missing - tainting "
 			       "kernel\n", mod->name);
-		add_taint_module(mod, TAINT_FORCED_MODULE, LOCKDEP_STILL_OK);
+		add_taint_module(mod, TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
 	}
 #endif
 
diff --git a/kernel/panic.c b/kernel/panic.c
index 6d63003..98588e0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -210,6 +210,7 @@ static const struct tnt tnts[] = {
 	{ TAINT_CRAP,			'C', ' ' },
 	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
 	{ TAINT_OOT_MODULE,		'O', ' ' },
+	{ TAINT_UNSIGNED_MODULE,	'N', ' ' },
 };
 
 /**
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 29f2654..e7903c1 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -639,9 +639,10 @@ static int tracepoint_module_coming(struct module *mod)
 	/*
 	 * We skip modules that taint the kernel, especially those with different
 	 * module headers (for forced load), to make sure we don't cause a crash.
-	 * Staging and out-of-tree GPL modules are fine.
+	 * Staging, out-of-tree, and non-signed GPL modules are fine.
 	 */
-	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
+	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP) |
+			(1 << TAINT_UNSIGNED_MODULE)))
 		return 0;
 	mutex_lock(&tracepoints_mutex);
 	tp_mod = kmalloc(sizeof(struct tp_module), GFP_KERNEL);
-- 
1.7.10.4

