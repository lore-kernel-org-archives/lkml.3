Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaCaMw7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:52:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184AbaCaMw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:52:57 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Boyer <jwboyer@fedoraproject.org>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: [PATCH] Add initcall_blacklist kernel parameter [v2]
Date: Mon, 31 Mar 2014 08:52:01 -0400
Message-Id: <1396270321-20007-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a module is built into the kernel the module_init() function becomes
an initcall.  Sometimes debugging through dynamic debug can help,
however, debugging built in kernel modules is typically done by changing
the .config, recompiling, and booting the new kernel in an effort to
determine exactly which module caused a problem.

This patchset can be useful stand-alone or combined with initcall_debug.
There are cases where some initcalls can hang the machine before the
console can be flushed, which can make initcall_debug output
inaccurate.  Having the ability to skip initcalls can help further
debugging of these scenarios.

Usage: initcall_blacklist=<list of comma separated initcalls>

ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
the log contains:

	blacklisted initcall sgi_uv_sysfs_init
	...
	...
	function sgi_uv_sysfs_init returning without executing

ex) added "initcall_blacklist=foo_bar,sgi_uv_sysfs_init" as a kernel parameter
and the log contains:

	initcall blacklisted foo_bar
	initcall blacklisted sgi_uv_sysfs_init
	...
	...
	function sgi_uv_sysfs_init returning without executing

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>

[v2]: A few people recommended that I add code to allow for a list of
initcalls as there maybe dependencies between initcalls such that one cannot
be made without the other.  I also updated the patch description.
---
 Documentation/kernel-parameters.txt |    4 +++
 init/main.c                         |   50 +++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..df7fe82 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1268,6 +1268,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			for working out where the kernel is dying during
 			startup.
 
+	initcall_blacklist=  [KNL] Do not execute a comma-separated list of
+			initcall functions.  Useful for debugging built-in
+			modules and initcalls.
+
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
diff --git a/init/main.c b/init/main.c
index 9c7fd4c..4ac9b2e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -77,6 +77,7 @@
 #include <linux/sched_clock.h>
 #include <linux/context_tracking.h>
 #include <linux/random.h>
+#include <linux/list.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -666,6 +667,34 @@ static void __init do_ctors(void)
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
+struct blacklist_entry {
+	struct list_head next;
+	char *buf;
+};
+
+static __initdata_or_module LIST_HEAD(blacklisted_initcalls);
+
+static int __init initcall_blacklist(char *str)
+{
+	char *str_entry;
+	struct blacklist_entry *entry;
+
+	/* str argument is a comma-separated list of functions */
+	do {
+		str_entry = strsep(&str, ",");
+		if (str_entry) {
+			pr_debug("initcall blacklisted %s\n", str_entry);
+			entry = alloc_bootmem(sizeof(*entry));
+			entry->buf = alloc_bootmem(strlen(str_entry));
+			strncpy(entry->buf, str_entry, strlen(str_entry));
+			list_add(&entry->next, &blacklisted_initcalls);
+		}
+	} while (str_entry);
+
+	return 0;
+}
+__setup("initcall_blacklist=", initcall_blacklist);
+
 static int __init_or_module do_one_initcall_debug(initcall_t fn)
 {
 	ktime_t calltime, delta, rettime;
@@ -689,6 +718,19 @@ int __init_or_module do_one_initcall(initcall_t fn)
 	int count = preempt_count();
 	int ret;
 	char msgbuf[64];
+	char fn_name[128] = "\0";
+	struct list_head *tmp;
+	struct blacklist_entry *entry;
+
+	snprintf(fn_name, 128, "%pf", fn);
+	list_for_each(tmp, &blacklisted_initcalls) {
+		entry = list_entry(tmp, struct blacklist_entry, next);
+		if (!strcmp(fn_name, entry->buf)) {
+			pr_debug("initcall %pf returning without executing\n",
+				 fn);
+			return -EPERM;
+		}
+	}
 
 	if (initcall_debug)
 		ret = do_one_initcall_debug(fn);
@@ -765,9 +807,17 @@ static void __init do_initcall_level(int level)
 static void __init do_initcalls(void)
 {
 	int level;
+	struct list_head *tmp, *next;
+	struct blacklist_entry *entry;
 
 	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++)
 		do_initcall_level(level);
+
+	list_for_each_safe(tmp, next, &blacklisted_initcalls) {
+		entry = list_entry(tmp, struct blacklist_entry, next);
+		free_bootmem(entry->buf, strlen(entry->buf));
+		free_bootmem(entry, sizeof(*entry));
+	}
 }
 
 /*
-- 
1.7.9.3

