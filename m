Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3L1BSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 20:18:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab3L1BS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 20:18:29 -0500
Date: Fri, 27 Dec 2013 17:17:57 -0800
Message-Id: <201312280117.rBS1HvV3005194@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.13-rc6
Cc: <stable@vger.kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Jan Beulich <jbeulich@suse.com>,
        Len Brown <len.brown@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 27 Dec 2013 17:18:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to fce7d3bfc0ae70ca2a57868f2a9708b13185fd1f:

  x86/efi: Don't select EFI from certain special ACPI drivers (2013-12-19 21:32:46 +0100)


There is a small EFI fix and a big power regression fix in this batch.
My queue also had a fix for downing a CPU when there are insufficient
number of IRQ vectors available, but I'm holding that one for now due
to recent bug reports.

----------------------------------------------------------------
Jan Beulich (1):
      x86/efi: Don't select EFI from certain special ACPI drivers

Len Brown (1):
      x86 idle: Repair large-server 50-watt idle-power regression

 arch/x86/kernel/cpu/intel.c   | 3 ++-
 drivers/acpi/Kconfig          | 1 -
 drivers/acpi/apei/Kconfig     | 1 -
 drivers/firmware/Makefile     | 1 +
 drivers/firmware/efi/Kconfig  | 6 +++---
 drivers/firmware/efi/Makefile | 2 +-
 drivers/idle/intel_idle.c     | 3 +++
 7 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index dc1ec0dff939..ea04b342c026 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -387,7 +387,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
-	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
+	if (c->x86 == 6 && cpu_has_clflush &&
+	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
 		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
 
 #ifdef CONFIG_X86_64
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5d9248526d78..4770de5707b9 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -348,7 +348,6 @@ source "drivers/acpi/apei/Kconfig"
 config ACPI_EXTLOG
 	tristate "Extended Error Log support"
 	depends on X86_MCE && X86_LOCAL_APIC
-	select EFI
 	select UEFI_CPER
 	default n
 	help
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index 786294bb682c..3650b2183227 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -2,7 +2,6 @@ config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
-	select EFI
 	select UEFI_CPER
 	depends on X86
 	help
diff --git a/drivers/firmware/Makefile b/drivers/firmware/Makefile
index 299fad6b5867..5373dc5b6011 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
 obj-$(CONFIG_EFI)		+= efi/
+obj-$(CONFIG_UEFI_CPER)		+= efi/
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 3150aa4874e8..6aecbc86ec94 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -36,7 +36,7 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 	  backend for pstore by default. This setting can be overridden
 	  using the efivars module's pstore_disable parameter.
 
-config UEFI_CPER
-	def_bool n
-
 endmenu
+
+config UEFI_CPER
+	bool
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 9ba156d3c775..6c2a41ec21ba 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for linux kernel
 #
-obj-y					+= efi.o vars.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 92d1206482a6..f80b700f821c 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -377,6 +377,9 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	if (!current_set_polling_and_test()) {
 
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
