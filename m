Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaCZOB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:01:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbaCZOBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:01:24 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-doc@vger.kernel.org
Subject: [PATCH] Add initcall_blacklist kernel parameter
Date: Wed, 26 Mar 2014 10:00:41 -0400
Message-Id: <1395842441-17923-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a module is built into the kernel, the modules's module_init()
function becomes an initcall.  Debugging built in kernel modules is
typically done by changing the .config, recompiling, and booting the new
kernel in an effort to determine exactly which module caused a problem.
This is a wasteful time consuming process as it may be repeated several times
before determining precisely what caused the problem.

This patch has been useful in identifying problems with built-in modules and
initcalls.  It allows a user to skip an initcall to see if the kernel
would continue to boot properly without requiring recompiles.

Usage: initcall_blacklist=<initcall function>

ex) added "initcall_blacklist=sgi_uv_sysfs_init" as a kernel parameter and
the log contains:

	blacklisted initcall sgi_uv_sysfs_init
	...
	...
	function sgi_uv_sysfs_init returning without executing

Cc: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 Documentation/kernel-parameters.txt |    4 ++++
 init/main.c                         |   16 ++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda..dadc43b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1268,6 +1268,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			for working out where the kernel is dying during
 			startup.
 
+	initcall_blacklist=  [KNL] Stop executing the specified initcall
+			function.  Useful for debugging built-in modules and
+			initcalls.
+
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
 	inport.irq=	[HW] Inport (ATI XL and Microsoft) busmouse driver
diff --git a/init/main.c b/init/main.c
index 9c7fd4c..a34677c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -666,6 +666,15 @@ static void __init do_ctors(void)
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
+static char blacklist_buf[128] = "\0";
+static int initcall_blacklist(char *str)
+{
+	snprintf(blacklist_buf, 127, "%s", str);
+	pr_debug("blacklisted initcall %s\n", blacklist_buf);
+	return 0;
+}
+__setup("initcall_blacklist=", initcall_blacklist);
+
 static int __init_or_module do_one_initcall_debug(initcall_t fn)
 {
 	ktime_t calltime, delta, rettime;
@@ -689,6 +698,13 @@ int __init_or_module do_one_initcall(initcall_t fn)
 	int count = preempt_count();
 	int ret;
 	char msgbuf[64];
+	char fn_name[128] = "\0";
+
+	snprintf(fn_name, 127, "%pf", fn);
+	if (!strcmp(fn_name, blacklist_buf)) {
+		pr_debug("function %pf returning without executing\n", fn);
+		return -EPERM;
+	}
 
 	if (initcall_debug)
 		ret = do_one_initcall_debug(fn);
-- 
1.7.9.3

