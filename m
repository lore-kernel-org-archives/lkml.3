Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751243Ab3LIXjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:39:35 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48194 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab3LIXje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:39:34 -0500
Date: Mon, 9 Dec 2013 15:38:29 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, kexec@lists.infradead.org
Subject: [PATCH] kexec: add sysctl to disable kexec
Message-ID: <20131209233829.GA3501@www.outflux.net>
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
a kernel, there needs to be a way to disable kexec (much like module loading
can be disabled). Without this, it is too easy for the root user to modify
kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are set.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/kexec.h |    1 +
 kernel/kexec.c        |    3 ++-
 kernel/sysctl.c       |   13 +++++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d78d28a733b1..a1503ed4dde5 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -170,6 +170,7 @@ unsigned long paddr_vmcoreinfo_note(void);
 
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
+extern int kexec_disabled;
 
 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 490afc03627e..9d44ed203ee7 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -929,6 +929,7 @@ static int kimage_load_segment(struct kimage *image,
  */
 struct kimage *kexec_image;
 struct kimage *kexec_crash_image;
+int kexec_disabled;
 
 static DEFINE_MUTEX(kexec_mutex);
 
@@ -939,7 +940,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	int result;
 
 	/* We only trust the superuser with rebooting the system. */
-	if (!capable(CAP_SYS_BOOT))
+	if (!capable(CAP_SYS_BOOT) || kexec_disabled)
 		return -EPERM;
 
 	/*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 34a604726d0b..07869ce3642d 100644
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
+		.procname	= "kexec_disabled",
+		.data		= &kexec_disabled,
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
