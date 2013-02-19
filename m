Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934424Ab3BSSy5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:54:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54538 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab3BSSyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:54:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stoney Wang <song-bo.wang@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 75/81] x86/apic: Work around boot failure on HP ProLiant DL980 G7 Server systems
Date: Tue, 19 Feb 2013 15:49:38 -0300
Message-Id: <1361299784-8830-76-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stoney Wang <song-bo.wang@hp.com>

commit cb214ede7657db458fd0b2a25ea0b28dbf900ebc upstream.

When a HP ProLiant DL980 G7 Server boots a regular kernel,
there will be intermittent lost interrupts which could
result in a hang or (in extreme cases) data loss.

The reason is that this system only supports x2apic physical
mode, while the kernel boots with a logical-cluster default
setting.

This bug can be worked around by specifying the "x2apic_phys" or
"nox2apic" boot option, but we want to handle this system
without requiring manual workarounds.

The BIOS sets ACPI_FADT_APIC_PHYSICAL in FADT table.
As all apicids are smaller than 255, BIOS need to pass the
control to the OS with xapic mode, according to x2apic-spec,
chapter 2.9.

Current code handle x2apic when BIOS pass with xapic mode
enabled:

When user specifies x2apic_phys, or FADT indicates PHYSICAL:

1. During madt oem check, apic driver is set with xapic logical
   or xapic phys driver at first.

2. enable_IR_x2apic() will enable x2apic_mode.

3. if user specifies x2apic_phys on the boot line, x2apic_phys_probe()
   will install the correct x2apic phys driver and use x2apic phys mode.
   Otherwise it will skip the driver will let x2apic_cluster_probe to
   take over to install x2apic cluster driver (wrong one) even though FADT
   indicates PHYSICAL, because x2apic_phys_probe does not check
   FADT PHYSICAL.

Add checking x2apic_fadt_phys in x2apic_phys_probe() to fix the
problem.

Signed-off-by: Stoney Wang <song-bo.wang@hp.com>
[ updated the changelog and simplified the code ]
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1360263182-16226-1-git-send-email-yinghai@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/apic/x2apic_phys.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index c17e982..d14fee3 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -20,18 +20,19 @@ static int set_x2apic_phys_mode(char *arg)
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
@@ -114,7 +115,7 @@ static void init_x2apic_ldr(void)
 
 static int x2apic_phys_probe(void)
 {
-	if (x2apic_mode && x2apic_phys)
+	if (x2apic_mode && (x2apic_phys || x2apic_fadt_phys()))
 		return 1;
 
 	return apic == &apic_x2apic_phys;
-- 
1.7.9.5

