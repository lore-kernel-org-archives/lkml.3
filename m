Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3ARMda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:33:30 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:59310 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3ARMdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:33:24 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v2 55/76] sysctl: Enable PARISC "unaligned-trap" to be used cross-arch
Date: Fri, 18 Jan 2013 17:55:09 +0530
Message-ID: <1358511930-7424-56-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PARISC defines /proc/sys/kernel/unaligned-trap to runtime toggle
unaligned access emulation.

The exact mechanics of enablig/disabling are still arch specific, we can
make the sysctl usable by other arches.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
---
 arch/parisc/Kconfig |    1 +
 init/Kconfig        |    8 ++++++++
 kernel/sysctl.c     |    7 ++++++-
 3 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index b77feff..8c76095 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -20,6 +20,7 @@ config PARISC
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
+	select SYSCTL_ARCH_UNALIGN_ALLOW
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
diff --git a/init/Kconfig b/init/Kconfig
index a733964..325df23 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1240,6 +1240,14 @@ config SYSCTL_ARCH_UNALIGN_NO_WARN
 	  unaligned access emulation going on under the hood.
 	  see arch/ia64/kernel/unaligned.c for reference
 
+config SYSCTL_ARCH_UNALIGN_ALLOW
+	bool
+	help
+	  Enable support for /proc/sys/kernel/unaligned-trap
+	  Allows arches to define/use @unaligned_enabled to runtime toggle
+	  the unaligned access emulation.
+	  see arch/parisc/kernel/unaligned.c for reference
+
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 840fd5e..c4cd655 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -157,13 +157,16 @@ extern int sysctl_tsb_ratio;
 
 #ifdef __hppa__
 extern int pwrsw_enabled;
-extern int unaligned_enabled;
 #endif
 
 #ifdef CONFIG_IA64
 extern int unaligned_dump_stack;
 #endif
 
+#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
+extern int unaligned_enabled;
+#endif
+
 #ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
 extern int no_unaligned_warning;
 #endif
@@ -548,6 +551,8 @@ static struct ctl_table kern_table[] = {
 	 	.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#endif
+#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
 	{
 		.procname	= "unaligned-trap",
 		.data		= &unaligned_enabled,
-- 
1.7.4.1

