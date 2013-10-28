Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab3J1Sx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:53:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:31537 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab3J1Sx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:53:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="313904345"
From: "Luck, Tony" <tony.luck@intel.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, Christoph Hellwig <hch@infradead.org>,
        Chen Gong <gong.chen@linux.intel.com>, X86-ML <x86@kernel.org>
Subject: [PATCH] Move cper.c from drivers/acpi/apei to drivers/firmware/efi
In-Reply-To: <20131027204648.GG1982@console-pimps.org>
Date: Mon, 28 Oct 2013 11:53:53 -0700
Message-Id: <526eb2c117027ea234@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cper.c contains code to decode and print "Common Platform Error Records".
Originally added under drivers/acpi/apei because the only user was in that
same directory - but now we have another consumer, and we shouldn't have
to force CONFIG_ACPI_APEI get access to this code.

Since CPER is defined in the UEFI specification - the logical home for
this code is under drivers/firmware/efi/

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Matt: as discussed earlier on the mailing list ... just looking
for your "Acked-by" so this can go on top of the patch series in
the x86/mce branch of the tip tree that already makes a bunch of
changes to cper.c

Based on Chen Gong's original patch that moved cper.c to lib/

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 252f0e818a49..08eadb4a57cb 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -374,7 +374,9 @@ source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
 	tristate "Extended Error Log support"
-	depends on X86_MCE && ACPI_APEI
+	depends on X86_MCE
+	select EFI
+	select UEFI_CPER
 	default n
 	help
 	  Certain usages such as Predictive Failure Analysis (PFA) require
diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
index f0c1ce95a0ec..786294bb682c 100644
--- a/drivers/acpi/apei/Kconfig
+++ b/drivers/acpi/apei/Kconfig
@@ -2,6 +2,8 @@ config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
+	select EFI
+	select UEFI_CPER
 	depends on X86
 	help
 	  APEI allows to report errors (for example from the chipset)
diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
index d1d1bc0a4ee1..5d575a955940 100644
--- a/drivers/acpi/apei/Makefile
+++ b/drivers/acpi/apei/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_ACPI_APEI_GHES)	+= ghes.o
 obj-$(CONFIG_ACPI_APEI_EINJ)	+= einj.o
 obj-$(CONFIG_ACPI_APEI_ERST_DEBUG) += erst-dbg.o
 
-apei-y := apei-base.o hest.o cper.o erst.o
+apei-y := apei-base.o hest.o erst.o
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index b0fc7c79dfbb..8dfdd2a1cf12 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -36,4 +36,7 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 	  backend for pstore by default. This setting can be overridden
 	  using the efivars module's pstore_disable parameter.
 
+config UEFI_CPER
+	defbool n
+
 endmenu
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 99245ab5a79c..9ba156d3c775 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -4,3 +4,4 @@
 obj-y					+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
+obj-$(CONFIG_UEFI_CPER)			+= cper.o
diff --git a/drivers/acpi/apei/cper.c b/drivers/firmware/efi/cper.c
similarity index 100%
rename from drivers/acpi/apei/cper.c
rename to drivers/firmware/efi/cper.c
