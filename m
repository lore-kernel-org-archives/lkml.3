Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab3LKXzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:55:48 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49958 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3LKXzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:55:44 -0500
Date: Wed, 11 Dec 2013 15:54:27 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>, Rik van Riel <riel@redhat.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>, Rob Landley <rob@landley.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org
Subject: [PATCH v3] kexec: add sysctl to disable kexec_load
Message-ID: <20131211235427.GA23999@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For general-purpose (i.e. distro) kernel builds it makes sense to build with
CONFIG_KEXEC to allow end users to choose what kind of things they want to do
with kexec. However, in the face of trying to lock down a system with such
a kernel, there needs to be a way to disable kexec_load (much like module
loading can be disabled). Without this, it is too easy for the root user to
modify kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are
set. With this change, it is still possible to load an image for use later,
then disable kexec_load so the image (or lack of image) can't be altered.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Rik van Riel <riel@redhat.com>
---
v3:
 - renamed and clarified to kexec_load_disabled; Eric W. Biederman
v2:
 - updated sysctl documentation; akpm
---
 Documentation/sysctl/kernel.txt |   15 ++++++++++++++-
 include/linux/kexec.h           |    1 +
 kernel/kexec.c                  |    3 ++-
 kernel/sysctl.c                 |   13 +++++++++++++
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 26b7ee491df8..3e1846427eda 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -33,6 +33,7 @@ show up in /proc/sys/kernel:
 - domainname
 - hostname
 - hotplug
+- kexec_load_disabled
 - kptr_restrict
 - kstack_depth_to_print       [ X86 only ]
 - l2cr                        [ PPC only ]
@@ -287,6 +288,18 @@ Default value is "/sbin/hotplug".
 
 ==============================================================
 
+kexec_load_disabled:
+
+A toggle indicating if the kexec_load syscall has been disabled. This
+value defaults to 0 (false: kexec_load enabled), but can be set to 1
+(true: kexec_load disabled). Once true, kexec can no longer be used, and
+the toggle cannot be set back to false. This allows a kexec image to be
+loaded before disabling the syscall, allowing a system to set up (and
+later use) an image without it being altered. Generally used together
+with the "modules_disabled" sysctl.
+
+==============================================================
+
 kptr_restrict:
 
 This toggle indicates whether restrictions are placed on
@@ -331,7 +344,7 @@ A toggle value indicating if modules are allowed to be loaded
 in an otherwise modular kernel.  This toggle defaults to off
 (0), but can be set true (1).  Once true, modules can be
 neither loaded nor unloaded, and the toggle cannot be set back
-to false.
+to false.  Generally used with the "kexec_load_disabled" toggle.
 
 ==============================================================
 
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d78d28a733b1..a3e842f6867e 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -170,6 +170,7 @@ unsigned long paddr_vmcoreinfo_note(void);
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
+extern int kexec_load_disabled;
 
 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 490afc03627e..9405ae68feb4 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -929,6 +929,7 @@ static int kimage_load_segment(struct kimage *image,
  */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
+int kexec_load_disabled;
 
 static DEFINE_MUTEX(kexec_mutex);
 
@@ -939,7 +940,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!capable(CAP_SYS_BOOT) || kexec_load_disabled)
 		return -EPERM;
 
 	/*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a604726d0b..ea4bb8152a34 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -62,6 +62,7 @@
 #include <linux/capability.h>
 #include <linux/binfmts.h>
 #include <linux/sched/sysctl.h>
+#include <linux/kexec.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -614,6 +615,18 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_KEXEC
+	{
+		.procname	= "kexec_load_disabled",
+		.data		= &kexec_load_disabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		/* only handle a transition from default "0" to "1" */
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &one,
+	},
+#endif
 #ifdef CONFIG_MODULES
 	{
 		.procname	= "modprobe",
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
