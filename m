Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3LPOjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:39:47 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57742 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LPOjp convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 16 Dec 2013 09:39:45 -0500
Message-Id: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 16 Dec 2013 14:39:40 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <tony.luck@intel.com>
Cc: "Matt Fleming" <matt.fleming@intel.com>, <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] don't select EFI from certain special ACPI drivers
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7ea6c6c1 ("Move cper.c from drivers/acpi/apei to
drivers/firmware/efi") results in CONFIG_EFI being enabled even when
the user doesn't want this. Since ACPI APEI used to build fine without
UEFI (and as far as I know also has no functional depency on it), at
least in that case using a reverse dependency is wrong (and a straight
one isn't needed).

Whether the same is true for ACPI_EXTLOG I don't know - if there is a
functional dependency, it should depend on EFI rather than selecting
it. It certainly has (currently) no build dependency.

Adjust Kconfig and build logic so that the bad dependency gets avoided.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 drivers/acpi/Kconfig          |    1 -
 drivers/acpi/apei/Kconfig     |    1 -
 drivers/firmware/Makefile     |    1 +
 drivers/firmware/efi/Kconfig  |    6 +++---
 drivers/firmware/efi/Makefile |    2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

--- 3.13-rc4/drivers/acpi/Kconfig
+++ 3.13-rc4-ACPI-CPER-no-EFI/drivers/acpi/Kconfig
@@ -348,7 +348,6 @@ source "drivers/acpi/apei/Kconfig"
 config ACPI_EXTLOG
 	tristate "Extended Error Log support"
 	depends on X86_MCE && X86_LOCAL_APIC
-	select EFI
 	select UEFI_CPER
 	default n
 	help
--- 3.13-rc4/drivers/acpi/apei/Kconfig
+++ 3.13-rc4-ACPI-CPER-no-EFI/drivers/acpi/apei/Kconfig
@@ -2,7 +2,6 @@ config ACPI_APEI
 	bool "ACPI Platform Error Interface (APEI)"
 	select MISC_FILESYSTEMS
 	select PSTORE
-	select EFI
 	select UEFI_CPER
 	depends on X86
 	help
--- 3.13-rc4/drivers/firmware/Makefile
+++ 3.13-rc4-ACPI-CPER-no-EFI/drivers/firmware/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
 obj-$(CONFIG_EFI)		+= efi/
+obj-$(CONFIG_UEFI_CPER)		+= efi/
--- 3.13-rc4/drivers/firmware/efi/Kconfig
+++ 3.13-rc4-ACPI-CPER-no-EFI/drivers/firmware/efi/Kconfig
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
--- 3.13-rc4/drivers/firmware/efi/Makefile
+++ 3.13-rc4-ACPI-CPER-no-EFI/drivers/firmware/efi/Makefile
@@ -1,7 +1,7 @@
 #
 # Makefile for linux kernel
 #
-obj-y					+= efi.o vars.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o



