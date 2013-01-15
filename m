Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab3AOBvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 20:51:39 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:8418 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab3AOBvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 20:51:38 -0500
From: Stoney Wang <song-bo.wang@hp.com>
To: suresh.b.siddha@intel.com
Cc: linbao.zhang@hp.com, greg.pearson@hp.com, linux-kernel@vger.kernel.org,
        Stoney Wang <song-bo.wang@hp.com>
Subject: [PATCH] x86/apic: check FADT settings after enable x2apic
Date: Tue, 15 Jan 2013 09:50:36 +0800
Message-Id: <1358214636-4801-1-git-send-email-song-bo.wang@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OS will enable x2apic mode even BIOS default in xapic mode.

FADT settings check (commit ea0dcf903e7d76aa5d483d876215fedcfdfe140f)
should be applied after detect default mode and change the mode (enable_IR_x2apic called)

Signed-off-by: Stoney Wang <song-bo.wang@hp.com>
---
 arch/x86/kernel/apic/x2apic_phys.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index e03a1e1..76ea60d 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -20,18 +20,22 @@ static int set_x2apic_phys_mode(char *arg)
 }
 early_param("x2apic_phys", set_x2apic_phys_mode);
 
-static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int x2apic_fadt_phys(void)
 {
-	if (x2apic_phys)
-		return x2apic_enabled();
-	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
-		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
-		x2apic_enabled()) {
+	if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
 		printk(KERN_DEBUG "System requires x2apic physical mode\n");
 		return 1;
 	}
-	else
-		return 0;
+	return 0;
+}
+
+static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+{
+	if (x2apic_enabled())
+		return x2apic_phys || x2apic_fadt_phys();
+
+	return 0;
 }
 
 static void
@@ -85,7 +89,10 @@ static int x2apic_phys_probe(void)
 	if (x2apic_mode && x2apic_phys)
 		return 1;
 
-	return apic == &apic_x2apic_phys;
+	if (apic == &apic_x2apic_phys)
+		return 1;
+
+	return x2apic_enabled() && x2apic_fadt_phys();
 }
 
 static struct apic apic_x2apic_phys = {
-- 
1.7.1

