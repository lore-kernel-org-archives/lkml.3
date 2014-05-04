Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaEDRHz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 13:07:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41221 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaEDRHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 13:07:53 -0400
Date: Sun, 4 May 2014 10:07:25 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-197725de65477bc8509b41388157c1a2283542bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richard@nod.at, tglx@linutronix.de
In-Reply-To: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/espfix] x86, espfix: Make espfix64 a Kconfig option,
  fix UML
Git-Commit-ID: 197725de65477bc8509b41388157c1a2283542bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  197725de65477bc8509b41388157c1a2283542bb
Gitweb:     http://git.kernel.org/tip/197725de65477bc8509b41388157c1a2283542bb
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sun, 4 May 2014 10:00:49 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 4 May 2014 10:00:49 -0700

x86, espfix: Make espfix64 a Kconfig option, fix UML

Make espfix64 a hidden Kconfig option.  This fixes the x86-64 UML
build which had broken due to the non-existence of init_espfix_bsp()
in UML: since UML uses its own Kconfig, this option does not appear in
the UML build.

This also makes it possible to make support for 16-bit segments a
configuration option, for the people who want to minimize the size of
the kernel.

Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/1398816946-3351-1-git-send-email-hpa@linux.intel.com
---
 arch/x86/Kconfig          | 4 ++++
 arch/x86/kernel/Makefile  | 2 +-
 arch/x86/kernel/smpboot.c | 2 +-
 init/main.c               | 2 +-
 4 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 25d2c6f..9a952a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -914,6 +914,10 @@ config VM86
 	  XFree86 to initialize some video cards via BIOS. Disabling this
 	  option saves about 6k.
 
+config X86_ESPFIX64
+	def_bool y
+	depends on X86_64
+
 config TOSHIBA
 	tristate "Toshiba Laptop support"
 	depends on X86_32
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 1cc3789..491ef3e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-y			+= syscall_$(BITS).o vsyscall_gtod.o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
-obj-$(CONFIG_X86_64)	+= espfix_64.o
+obj-$(CONFIG_X86_ESPFIX64)	+= espfix_64.o
 obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 61a5350..5d93ac1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -246,7 +246,7 @@ static void notrace start_secondary(void *unused)
 	/*
 	 * Enable the espfix hack for this CPU
 	 */
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	init_espfix_ap();
 #endif
 
diff --git a/init/main.c b/init/main.c
index 70fc00e..58c132d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -617,7 +617,7 @@ asmlinkage void __init start_kernel(void)
 	if (efi_enabled(EFI_RUNTIME_SERVICES))
 		efi_enter_virtual_mode();
 #endif
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_X86_ESPFIX64
 	/* Should be run before the first non-init thread is created */
 	init_espfix_bsp();
 #endif
