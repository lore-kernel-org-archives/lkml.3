Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3AXLLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:11:47 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:34155 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3AXLLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:11:00 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 49/71] sysctl: Enable PARISC "unaligned-trap" to be used cross-arch
Date: Thu, 24 Jan 2013 16:36:13 +0530
Message-ID: <1359025589-22277-30-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
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
 kernel/sysctl.c     |    5 +++++
 3 files changed, 14 insertions(+), 0 deletions(-)

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
index be8b7f5..01180da 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1232,6 +1232,14 @@ config SYSCTL_EXCEPTION_TRACE
 	help
 	  Enable support for /proc/sys/debug/exception-trace.
 
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
index c88878d..878b4c4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -157,6 +157,9 @@ extern int sysctl_tsb_ratio;
 
 #ifdef __hppa__
 extern int pwrsw_enabled;
+#endif
+
+#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
 extern int unaligned_enabled;
 #endif
 
@@ -545,6 +548,8 @@ static struct ctl_table kern_table[] = {
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

