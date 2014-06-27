Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbaF0Dul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:50:41 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:37597 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaF0Duj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:50:39 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>, rric@kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Charles.Garcia-Tobin@arm.com,
        lorenzo.pieralisi@arm.com, linaro-acpi@lists.linaro.org,
        Graeme Gregory <graeme.gregory@linaro.org>
Subject: [PATCH v4 01/13] acpi: arm64 does not have a BIOS add config for BIOS table scan.
Date: Fri, 27 Jun 2014 11:49:24 +0800
Message-Id: <1403840976-7456-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <graeme.gregory@linaro.org>

With the addition of ARM64 that does not have a traditional BIOS to
scan, add a config option which is selected on x86 and ia64 to do
the traditional BIOS scanning for tables.

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
---
 arch/ia64/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 drivers/acpi/Kconfig |    3 +++
 drivers/acpi/osl.c   |    4 +++-
 4 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 2f3abcf..f82b352 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -47,6 +47,7 @@ config IA64
 	select MODULES_USE_ELF_RELA
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select HAVE_ARCH_AUDITSYSCALL
+	select ACPI_SCAN_BIOS_NOT_EFI
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..4865d44 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -131,6 +131,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select ACPI_SCAN_BIOS_NOT_EFI
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index a34a228..70eaf7a 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -2,6 +2,9 @@
 # ACPI Configuration
 #
 
+config ACPI_SCAN_BIOS_NOT_EFI
+	bool
+
 menuconfig ACPI
 	bool "ACPI (Advanced Configuration and Power Interface) Support"
 	depends on !IA64_HP_SIM
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index bad25b0..5ba0b74 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -259,12 +259,14 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 			       "System description tables not found\n");
 			return 0;
 		}
-	} else {
+	} else if (IS_ENABLED(CONFIG_ACPI_SCAN_BIOS_NOT_EFI)) {
 		acpi_physical_address pa = 0;
 
 		acpi_find_root_pointer(&pa);
 		return pa;
 	}
+
+	return 0;
 }
 
 /* Must be called with 'acpi_ioremap_lock' or RCU read lock held. */
-- 
1.7.9.5

