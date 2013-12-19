Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab3LSUgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:36:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756314Ab3LSUgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:36:38 -0500
Date: Thu, 19 Dec 2013 12:36:23 -0800
From: tip-bot for Jan Beulich <tipbot@zytor.com>
Message-ID: <tip-fce7d3bfc0ae70ca2a57868f2a9708b13185fd1f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, tony.luck@intel.com, matt.fleming@intel.com,
        JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, tony.luck@intel.com, matt.fleming@intel.com,
        JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
References: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/efi: Don'
 t select EFI from certain special ACPI drivers
Git-Commit-ID: fce7d3bfc0ae70ca2a57868f2a9708b13185fd1f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 19 Dec 2013 12:36:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fce7d3bfc0ae70ca2a57868f2a9708b13185fd1f
Gitweb:     http://git.kernel.org/tip/fce7d3bfc0ae70ca2a57868f2a9708b13185fd1f
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Mon, 16 Dec 2013 14:39:40 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 19 Dec 2013 21:32:46 +0100

x86/efi: Don't select EFI from certain special ACPI drivers

Commit 7ea6c6c1 ("Move cper.c from drivers/acpi/apei to
drivers/firmware/efi") results in CONFIG_EFI being enabled even
when the user doesn't want this. Since ACPI APEI used to build
fine without UEFI (and as far as I know also has no functional
depency on it), at least in that case using a reverse dependency
is wrong (and a straight one isn't needed).

Whether the same is true for ACPI_EXTLOG I don't know - if there
is a functional dependency, it should depend on EFI rather than
selecting it. It certainly has (currently) no build dependency.

Adjust Kconfig and build logic so that the bad dependency gets
avoided.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>
Link: http://lkml.kernel.org/r/52AF1EBC020000780010DBF9@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/acpi/Kconfig          | 1 -
 drivers/acpi/apei/Kconfig     | 1 -
 drivers/firmware/Makefile     | 1 +
 drivers/firmware/efi/Kconfig  | 6 +++---
 drivers/firmware/efi/Makefile | 2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5d92485..4770de5 100644
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
index 786294b..3650b21 100644
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
index 299fad6..5373dc5 100644
--- a/drivers/firmware/Makefile
+++ b/drivers/firmware/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
 
 obj-$(CONFIG_GOOGLE_FIRMWARE)	+= google/
 obj-$(CONFIG_EFI)		+= efi/
+obj-$(CONFIG_UEFI_CPER)		+= efi/
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 3150aa4..6aecbc8 100644
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
index 9ba156d..6c2a41e 100644
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
