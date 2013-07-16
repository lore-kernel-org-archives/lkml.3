Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab3GPRe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:34:59 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:60723 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933612Ab3GPRe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:34:56 -0400
From: Richard Henderson <rth@twiddle.net>
To: linux-kernel@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, mattst88@gmail.com, linux-alpha@vger.kernel.org
Subject: [RFC PATCH 02/10] alpha: Notice if we're being run under QEMU
Date: Tue, 16 Jul 2013 10:34:10 -0700
Message-Id: <1373996058-13399-3-git-send-email-rth@twiddle.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373996058-13399-1-git-send-email-rth@twiddle.net>
References: <1373996058-13399-1-git-send-email-rth@twiddle.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building a generic kernel, do a run-time check on the serial
number, like we do for MILO.  When building a custom kernel, make
this a configure-time check.

Signed-off-by: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/Kconfig               | 14 ++++++++++++++
 arch/alpha/include/asm/machvec.h | 18 ++++++++++++------
 arch/alpha/kernel/setup.c        | 13 ++++++++++++-
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 082d9b4..2053f215 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -488,6 +488,20 @@ config VGA_HOSE
 	  which always have multiple hoses, and whose consoles support it.
 
 
+config ALPHA_QEMU
+	bool "Run under QEMU emulation"
+	depends on !ALPHA_GENERIC
+	---help---
+	  Assume the presence of special features supported by QEMU PALcode
+	  that reduce the overhead of system emulation.
+
+	  Generic kernels will auto-detect QEMU.  But when building a
+	  system-specific kernel, the assumption is that we want to
+	  elimiate as many runtime tests as possible.
+
+	  If unsure, say N.
+
+
 config ALPHA_SRM
 	bool "Use SRM as bootloader" if ALPHA_CABRIOLET || ALPHA_AVANTI_CH || ALPHA_EB64P || ALPHA_PC164 || ALPHA_TAKARA || ALPHA_EB164 || ALPHA_ALCOR || ALPHA_MIATA || ALPHA_LX164 || ALPHA_SX164 || ALPHA_NAUTILUS || ALPHA_NONAME
 	depends on TTY
diff --git a/arch/alpha/include/asm/machvec.h b/arch/alpha/include/asm/machvec.h
index 72dbf23..4ac9016 100644
--- a/arch/alpha/include/asm/machvec.h
+++ b/arch/alpha/include/asm/machvec.h
@@ -126,13 +126,19 @@ extern struct alpha_machine_vector alpha_mv;
 
 #ifdef CONFIG_ALPHA_GENERIC
 extern int alpha_using_srm;
+extern int alpha_using_qemu;
 #else
-#ifdef CONFIG_ALPHA_SRM
-#define alpha_using_srm 1
-#else
-#define alpha_using_srm 0
-#endif
+# ifdef CONFIG_ALPHA_SRM
+#  define alpha_using_srm 1
+# else
+#  define alpha_using_srm 0
+# endif
+# ifdef CONFIG_ALPHA_QEMU
+#  define alpha_using_qemu 1
+# else
+#  define alpha_using_qemu 0
+# endif
 #endif /* GENERIC */
 
-#endif
+#endif /* __KERNEL__ */
 #endif /* __ALPHA_MACHVEC_H */
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index 9e3107cc5..c38d6a1 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -115,10 +115,17 @@ unsigned long alpha_agpgart_size = DEFAULT_AGP_APER_SIZE;
 
 #ifdef CONFIG_ALPHA_GENERIC
 struct alpha_machine_vector alpha_mv;
+#endif
+
+#ifndef alpha_using_srm
 int alpha_using_srm;
 EXPORT_SYMBOL(alpha_using_srm);
 #endif
 
+#ifndef alpha_using_qemu
+int alpha_using_qemu;
+#endif
+
 static struct alpha_machine_vector *get_sysvec(unsigned long, unsigned long,
 					       unsigned long);
 static struct alpha_machine_vector *get_sysvec_byname(const char *);
@@ -529,11 +536,15 @@ setup_arch(char **cmdline_p)
 	atomic_notifier_chain_register(&panic_notifier_list,
 			&alpha_panic_block);
 
-#ifdef CONFIG_ALPHA_GENERIC
+#ifndef alpha_using_srm
 	/* Assume that we've booted from SRM if we haven't booted from MILO.
 	   Detect the later by looking for "MILO" in the system serial nr.  */
 	alpha_using_srm = strncmp((const char *)hwrpb->ssn, "MILO", 4) != 0;
 #endif
+#ifndef alpha_using_qemu
+	/* Similarly, look for QEMU.  */
+	alpha_using_qemu = strstr((const char *)hwrpb->ssn, "QEMU") != 0;
+#endif
 
 	/* If we are using SRM, we want to allow callbacks
 	   as early as possible, so do this NOW, and then
-- 
1.8.1.4

