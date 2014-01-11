Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaAKDLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 22:11:21 -0500
Received: from mail1.windriver.com ([147.11.146.13]:40886 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaAKDLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 22:11:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] fs/proc: don't use module_init for non-modular core code
Date: Fri, 10 Jan 2014 22:11:08 -0500
Message-ID: <1389409868-14045-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PROC_FS is a bool, so this code is either present or
absent.  It will never be modular, so using module_init
as an alias for __initcall is rather misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this,
we'd have to add module.h to obviously non-modular code,
and that would be ugly at best.

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of fs_initcall (which
makes sense for fs code) will thus change these registrations
from level 6-device to level 5-fs (i.e. slightly earlier).
However no observable impact of that small difference has
been observed during testing, or is expected.

Also note that this change uncovers a missing semicolon
bug in the registration of vmcore_init as an initcall.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
index 82676e3fcd1d..cbd82dff7e81 100644
--- a/fs/proc/cmdline.c
+++ b/fs/proc/cmdline.c
@@ -26,4 +26,4 @@ static int __init proc_cmdline_init(void)
 	proc_create("cmdline", 0, NULL, &cmdline_proc_fops);
 	return 0;
 }
-module_init(proc_cmdline_init);
+fs_initcall(proc_cmdline_init);
diff --git a/fs/proc/consoles.c b/fs/proc/consoles.c
index 51942d5abcec..290ba85cb900 100644
--- a/fs/proc/consoles.c
+++ b/fs/proc/consoles.c
@@ -109,4 +109,4 @@ static int __init proc_consoles_init(void)
 	proc_create("consoles", 0, NULL, &proc_consoles_operations);
 	return 0;
 }
-module_init(proc_consoles_init);
+fs_initcall(proc_consoles_init);
diff --git a/fs/proc/cpuinfo.c b/fs/proc/cpuinfo.c
index 5a1e539a234b..06f4d31e0396 100644
--- a/fs/proc/cpuinfo.c
+++ b/fs/proc/cpuinfo.c
@@ -21,4 +21,4 @@ static int __init proc_cpuinfo_init(void)
 	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
 	return 0;
 }
-module_init(proc_cpuinfo_init);
+fs_initcall(proc_cpuinfo_init);
diff --git a/fs/proc/devices.c b/fs/proc/devices.c
index b14347167c35..50493edc30e5 100644
--- a/fs/proc/devices.c
+++ b/fs/proc/devices.c
@@ -67,4 +67,4 @@ static int __init proc_devices_init(void)
 	proc_create("devices", 0, NULL, &proc_devinfo_operations);
 	return 0;
 }
-module_init(proc_devices_init);
+fs_initcall(proc_devices_init);
diff --git a/fs/proc/interrupts.c b/fs/proc/interrupts.c
index 05029c0e2f24..a352d5703b41 100644
--- a/fs/proc/interrupts.c
+++ b/fs/proc/interrupts.c
@@ -50,4 +50,4 @@ static int __init proc_interrupts_init(void)
 	proc_create("interrupts", 0, NULL, &proc_interrupts_operations);
 	return 0;
 }
-module_init(proc_interrupts_init);
+fs_initcall(proc_interrupts_init);
diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index 5ed0e52d6aa0..39e6ef32f0bd 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -639,4 +639,4 @@ static int __init proc_kcore_init(void)
 
 	return 0;
 }
-module_init(proc_kcore_init);
+fs_initcall(proc_kcore_init);
diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index bdfabdaefdce..05f8dcdb086e 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -61,4 +61,4 @@ static int __init proc_kmsg_init(void)
 	proc_create("kmsg", S_IRUSR, NULL, &proc_kmsg_operations);
 	return 0;
 }
-module_init(proc_kmsg_init);
+fs_initcall(proc_kmsg_init);
diff --git a/fs/proc/loadavg.c b/fs/proc/loadavg.c
index 1afa4dd4cae2..aec66e6c2060 100644
--- a/fs/proc/loadavg.c
+++ b/fs/proc/loadavg.c
@@ -42,4 +42,4 @@ static int __init proc_loadavg_init(void)
 	proc_create("loadavg", 0, NULL, &loadavg_proc_fops);
 	return 0;
 }
-module_init(proc_loadavg_init);
+fs_initcall(proc_loadavg_init);
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 24270eceddbf..136e548d9567 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -220,4 +220,4 @@ static int __init proc_meminfo_init(void)
 	proc_create("meminfo", 0, NULL, &meminfo_proc_fops);
 	return 0;
 }
-module_init(proc_meminfo_init);
+fs_initcall(proc_meminfo_init);
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index 5f9bc8a746c9..d4a35746cab9 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -131,4 +131,4 @@ static int __init proc_nommu_init(void)
 	return 0;
 }
 
-module_init(proc_nommu_init);
+fs_initcall(proc_nommu_init);
diff --git a/fs/proc/page.c b/fs/proc/page.c
index cab84b6272ed..02174a610315 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -219,4 +219,4 @@ static int __init proc_page_init(void)
 	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
 	return 0;
 }
-module_init(proc_page_init);
+fs_initcall(proc_page_init);
diff --git a/fs/proc/softirqs.c b/fs/proc/softirqs.c
index 62604be9f58d..ad8a77f94beb 100644
--- a/fs/proc/softirqs.c
+++ b/fs/proc/softirqs.c
@@ -41,4 +41,4 @@ static int __init proc_softirqs_init(void)
 	proc_create("softirqs", 0, NULL, &proc_softirqs_operations);
 	return 0;
 }
-module_init(proc_softirqs_init);
+fs_initcall(proc_softirqs_init);
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 1cf86c0e8689..6f599c62f0cc 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -221,4 +221,4 @@ static int __init proc_stat_init(void)
 	proc_create("stat", 0, NULL, &proc_stat_operations);
 	return 0;
 }
-module_init(proc_stat_init);
+fs_initcall(proc_stat_init);
diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index 061894625903..7141b8d0ca9e 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -49,4 +49,4 @@ static int __init proc_uptime_init(void)
 	proc_create("uptime", 0, NULL, &uptime_proc_fops);
 	return 0;
 }
-module_init(proc_uptime_init);
+fs_initcall(proc_uptime_init);
diff --git a/fs/proc/version.c b/fs/proc/version.c
index 76817a60678c..d2154eb6d78f 100644
--- a/fs/proc/version.c
+++ b/fs/proc/version.c
@@ -31,4 +31,4 @@ static int __init proc_version_init(void)
 	proc_create("version", 0, NULL, &version_proc_fops);
 	return 0;
 }
-module_init(proc_version_init);
+fs_initcall(proc_version_init);
diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 9100d6959886..2ca7ba047f04 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -1082,7 +1082,7 @@ static int __init vmcore_init(void)
 		proc_vmcore->size = vmcore_size;
 	return 0;
 }
-module_init(vmcore_init)
+fs_initcall(vmcore_init);
 
 /* Cleanup function for vmcore module. */
 void vmcore_cleanup(void)
-- 
1.8.5.2

