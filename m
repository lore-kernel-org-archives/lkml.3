Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3LSHz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 02:55:29 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34754 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab3LSHzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 02:55:25 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com,
        Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de,
        JBeulich@suse.com, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: [TEST PATCH 14/14] acpi: add early parameter to set CMOS RTC Not Present bit for testing
Date: Thu, 19 Dec 2013 15:51:55 +0800
Message-Id: <1387439515-8926-15-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for testing that will not go to any git tree.

Add a early kernel parameter to set CMOS RTC Not Present bit in
acpi_gbl_FADT variable for testing. Use acpi_no_cmos_rtc=1 to enable
this bit to block rtc cmos interface.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/kernel/acpi/boot.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6c0b43b..64925dd 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -83,6 +83,8 @@ static u64 acpi_lapic_addr __initdata = APIC_DEFAULT_PHYS_BASE;
 #warning ACPI uses CMPXCHG, i486 and later hardware
 #endif
 
+static bool acpi_no_cmos_rtc;
+
 /* --------------------------------------------------------------------------
                               Boot-time Configuration
    -------------------------------------------------------------------------- */
@@ -1531,6 +1533,13 @@ int __init acpi_boot_init(void)
 	 */
 	acpi_table_parse(ACPI_SIG_FADT, acpi_parse_fadt);
 
+	/* Dummy NO_CMOS_RTC enable option to fake out RTC CMOS */
+	if (acpi_no_cmos_rtc) {
+		acpi_gbl_FADT.header.revision = 5;
+		acpi_gbl_FADT.boot_flags |= ACPI_FADT_NO_CMOS_RTC;
+		pr_info("acpi: Set NO_CMOS_RTC bit in FADT for testing\n");
+	}
+
 	/*
 	 * Process the Multiple APIC Description Table (MADT), if present
 	 */
@@ -1673,3 +1682,11 @@ void __init arch_reserve_mem_area(acpi_physical_address addr, size_t size)
 	e820_add_region(addr, size, E820_ACPI);
 	update_e820();
 }
+
+/* Dummy NO_CMOS_RTC enable option to fake out RTC CMOS */
+static int __init setup_acpi_no_cmos_rtc(char *arg)
+{
+	acpi_no_cmos_rtc = true;
+	return 0;
+}
+early_param("acpi_no_cmos_rtc", setup_acpi_no_cmos_rtc);
-- 
1.6.4.2

