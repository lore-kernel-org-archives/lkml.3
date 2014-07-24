Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbaGXM7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:59:50 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37835 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758743AbaGXM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:59:48 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Graeme Gregory <graeme.gregory@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <will.deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi-private@linaro.org,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 1/3] ACPI / ACPICA: Introduce ARM Boot Architecture Flags in FADT
Date: Thu, 24 Jul 2014 20:59:15 +0800
Message-Id: <1406206757-15512-2-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406206757-15512-1-git-send-email-hanjun.guo@linaro.org>
References: <1406206757-15512-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Power State Coordination Interface (PSCI) defines an API that
can be used to coordinate power control amongst the various supervisory
systems concurrently running on a device. ACPI support for this
technology would require the addition of two flags: PSCI_COMPLIANT and
PSCI_USE_HVC. When set, the former signals to the OS that the hardware
is PSCI compliant. The latter selects the appropriate conduit for PSCI
calls by toggling between Hypervisor Calls (HVC) and Secure Monitor
Calls (SMC).

An ARM Boot Architecture Flags structure to support new ARM hardware
was introduced in FADT in ACPI 5.1, add the code accordingly to
implement that in ACPICA core.

Since ACPI 5.1 doesn't support self defined PSCI function IDs,
which means that only PSCI 0.2+ is supported in ACPI.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 include/acpi/actbl.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/acpi/actbl.h b/include/acpi/actbl.h
index 1cc7ef1..e339a28 100644
--- a/include/acpi/actbl.h
+++ b/include/acpi/actbl.h
@@ -270,7 +270,8 @@ struct acpi_table_fadt {
 	u32 flags;		/* Miscellaneous flag bits (see below for individual flags) */
 	struct acpi_generic_address reset_register;	/* 64-bit address of the Reset register */
 	u8 reset_value;		/* Value to write to the reset_register port to reset the system */
-	u8 reserved4[3];	/* Reserved, must be zero */
+	u16 arm_boot_flags;	/* ARM Boot Architecture Flags (see below for individual flags) */
+	u8 minor_version;	/* Minor version of this FADT structure */
 	u64 Xfacs;		/* 64-bit physical address of FACS */
 	u64 Xdsdt;		/* 64-bit physical address of DSDT */
 	struct acpi_generic_address xpm1a_event_block;	/* 64-bit Extended Power Mgt 1a Event Reg Blk address */
@@ -285,7 +286,7 @@ struct acpi_table_fadt {
 	struct acpi_generic_address sleep_status;	/* 64-bit Sleep Status register (ACPI 5.0) */
 };
 
-/* Masks for FADT Boot Architecture Flags (boot_flags) [Vx]=Introduced in this FADT revision */
+/* Masks for FADT IA-PC Boot Architecture Flags (boot_flags) [Vx]=Introduced in this FADT revision */
 
 #define ACPI_FADT_LEGACY_DEVICES    (1)  	/* 00: [V2] System has LPC or ISA bus devices */
 #define ACPI_FADT_8042              (1<<1)	/* 01: [V3] System has an 8042 controller on port 60/64 */
@@ -296,6 +297,11 @@ struct acpi_table_fadt {
 
 #define FADT2_REVISION_ID               3
 
+/* Masks for FADT ARM Boot Architecture Flags (arm_boot_flags) */
+
+#define ACPI_FADT_PSCI_COMPLIANT    (1)  	/* 00: PSCI 0.2+ is implemented */
+#define ACPI_FADT_PSCI_USE_HVC      (1<<1)	/* 01: HVC must be used instead of SMC as the PSCI conduit */
+
 /* Masks for FADT flags */
 
 #define ACPI_FADT_WBINVD            (1)	/* 00: [V1] The WBINVD instruction works properly */
@@ -399,7 +405,7 @@ struct acpi_table_desc {
  *     FADT V5  size: 0x10C
  */
 #define ACPI_FADT_V1_SIZE       (u32) (ACPI_FADT_OFFSET (flags) + 4)
-#define ACPI_FADT_V2_SIZE       (u32) (ACPI_FADT_OFFSET (reserved4[0]) + 3)
+#define ACPI_FADT_V2_SIZE       (u32) (ACPI_FADT_OFFSET (arm_boot_flags) + 3)
 #define ACPI_FADT_V3_SIZE       (u32) (ACPI_FADT_OFFSET (sleep_control))
 #define ACPI_FADT_V5_SIZE       (u32) (sizeof (struct acpi_table_fadt))
 
-- 
1.7.9.5

