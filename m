Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3BDUaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:30:00 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41635 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab3BDU36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:29:58 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Stoney Wang <song-bo.wang@hp.com>,
        Yinghai Lu <yinghai@kernel.org>, stable@kernel.org
Subject: [PATCH] x86, apic: Check fadt x2apic phys in x2apic_phys_probe()
Date: Mon,  4 Feb 2013 12:29:27 -0800
Message-Id: <1360009767-3633-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130204110304.GD24173@gmail.com>
References: <20130204110304.GD24173@gmail.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoney Wang <song-bo.wang@hp.com>

When HP ProLiant DL980 G7 Server boot without x2apic_phys, there will be
intermittent lost interrupts and could result in a hang or data loss.

Those systems only work with x2apic phys mode so BIOS set
ACPI_FADT_APIC_PHYSICAL in FADT table.
Also because all apicids are less then 255, BIOS need to pass the control
to the OS with xapic mode, according to x2apic-spec, chapter 2.9.

Current code handle x2apic when BIOS pass with xapic mode:

When user specify x2apic_phys, or FADT indicates PHYSICAL.
During madt oem check, apic driver is set with xapic logical or
xapic phys driver at first.
Later enable_IR_x2apic() will enable x2apic_mode.
After that, x2apic_phys_probe() will install right x2apic phys driver
if user specify x2apic_phys,
but will skip and let x2apic_cluster_probe to take over to install
wrong apic driver (x2apic cluster) when FADT indicates
PHYSICAL, because x2apic_phys_probe does not check FADT PHYSICAL.

Add checking x2apic_fadt_phys in x2apic_phys_probe() to fix the problem.

-v3: update the change according to Ingo.

[ changelog, and simplify code - Yinghai Lu ]
Signed-off-by: Stoney Wang <song-bo.wang@hp.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 arch/x86/kernel/apic/x2apic_phys.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/x2apic_phys.c
+++ linux-2.6/arch/x86/kernel/apic/x2apic_phys.c
@@ -20,18 +20,19 @@ static int set_x2apic_phys_mode(char *ar
 }
 early_param("x2apic_phys", set_x2apic_phys_mode);
 
-static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static bool x2apic_fadt_phys(void)
 {
-	if (x2apic_phys)
-		return x2apic_enabled();
-	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
-		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
-		x2apic_enabled()) {
+	if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
 		printk(KERN_DEBUG "System requires x2apic physical mode\n");
-		return 1;
+		return true;
 	}
-	else
-		return 0;
+	return false;
+}
+
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	return x2apic_enabled() && (x2apic_phys || x2apic_fadt_phys());
 }
 
 static void
@@ -82,7 +83,7 @@ static void init_x2apic_ldr(void)
 
 static int x2apic_phys_probe(void)
 {
-	if (x2apic_mode && x2apic_phys)
+	if (x2apic_mode && (x2apic_phys || x2apic_fadt_phys()))
 		return 1;
 
 	return apic == &apic_x2apic_phys;
