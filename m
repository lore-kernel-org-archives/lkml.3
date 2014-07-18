Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795AbaGRKDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:03:30 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:55773 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934383AbaGRKD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:03:27 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH v3 1/3] ACPI: ARM64 does not have a BIOS add config for BIOS table scan.
Date: Fri, 18 Jul 2014 18:02:52 +0800
Message-Id: <1405677774-16787-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405677774-16787-1-git-send-email-hanjun.guo@linaro.org>
References: <1405677774-16787-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Gregory <graeme.gregory@linaro.org>

With the addition of ARM64 that does not have a traditional BIOS to
scan, add a config option which is selected on x86 (ia64 doesn't need
it either, it is EFI/UEFI based system) to do the traditional BIOS
scanning for tables.

Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/x86/Kconfig     |    1 +
 drivers/acpi/Kconfig |    3 +++
 drivers/acpi/osl.c   |    4 +++-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749e..6d9f1d8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -131,6 +131,7 @@ config X86
 	select HAVE_CC_STACKPROTECTOR
 	select GENERIC_CPU_AUTOPROBE
 	select HAVE_ARCH_AUDITSYSCALL
+	select ACPI_LEGACY_TABLES_LOOKUP if ACPI
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index a34a228..970524c 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -42,6 +42,9 @@ menuconfig ACPI
 
 if ACPI
 
+config ACPI_LEGACY_TABLES_LOOKUP
+	bool
+
 config ACPI_SLEEP
 	bool
 	depends on SUSPEND || HIBERNATION
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index bad25b0..3abe9b2 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -259,12 +259,14 @@ acpi_physical_address __init acpi_os_get_root_pointer(void)
 			       "System description tables not found\n");
 			return 0;
 		}
-	} else {
+	} else if (IS_ENABLED(CONFIG_ACPI_LEGACY_TABLES_LOOKUP)) {
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

