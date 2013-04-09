Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936157Ab3DIUN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:13:58 -0400
Received: from 8bytes.org ([85.214.48.195]:36431 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936204Ab3DIUNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:35 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 8/9] iommu/amd: Don't report firmware bugs with cmd-line ivrs overrides
Date: Tue,  9 Apr 2013 22:13:03 +0200
Message-Id: <1365538384-12426-9-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:33 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766d23671117444802
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the IVRS entries for IOAPIC and HPET are overridden on
the kernel command line, a problem detected in the check
function might not be a firmware bug anymore. So disable
the firmware bug reporting if the user provided valid
ivrs_ioapic or ivrs_hpet entries on the command line.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu_init.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 030d6ab..9767941 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -219,6 +219,7 @@ static struct devid_map __initdata early_ioapic_map[EARLY_MAP_SIZE];
 static struct devid_map __initdata early_hpet_map[EARLY_MAP_SIZE];
 static int __initdata early_ioapic_map_size;
 static int __initdata early_hpet_map_size;
+static bool __initdata cmdline_maps;
 
 static enum iommu_init_state init_state = IOMMU_START_STATE;
 
@@ -1686,18 +1687,28 @@ static void __init free_on_init_error(void)
 
 static bool __init check_ioapic_information(void)
 {
+	const char *fw_bug = FW_BUG;
 	bool ret, has_sb_ioapic;
 	int idx;
 
 	has_sb_ioapic = false;
 	ret           = false;
 
+	/*
+	 * If we have map overrides on the kernel command line the
+	 * messages in this function might not describe firmware bugs
+	 * anymore - so be careful
+	 */
+	if (cmdline_maps)
+		fw_bug = "";
+
 	for (idx = 0; idx < nr_ioapics; idx++) {
 		int devid, id = mpc_ioapic_id(idx);
 
 		devid = get_ioapic_devid(id);
 		if (devid < 0) {
-			pr_err(FW_BUG "AMD-Vi: IOAPIC[%d] not in IVRS table\n", id);
+			pr_err("%sAMD-Vi: IOAPIC[%d] not in IVRS table\n",
+				fw_bug, id);
 			ret = false;
 		} else if (devid == IOAPIC_SB_DEVID) {
 			has_sb_ioapic = true;
@@ -1714,11 +1725,11 @@ static bool __init check_ioapic_information(void)
 		 * when the BIOS is buggy and provides us the wrong
 		 * device id for the IOAPIC in the system.
 		 */
-		pr_err(FW_BUG "AMD-Vi: No southbridge IOAPIC found in IVRS table\n");
+		pr_err("%sAMD-Vi: No southbridge IOAPIC found\n", fw_bug);
 	}
 
 	if (!ret)
-		pr_err("AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)\n");
+		pr_err("AMD-Vi: Disabling interrupt remapping\n");
 
 	return ret;
 }
@@ -2166,6 +2177,7 @@ static int __init parse_ivrs_ioapic(char *str)
 
 	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
 
+	cmdline_maps			= true;
 	i				= early_ioapic_map_size++;
 	early_ioapic_map[i].id		= id;
 	early_ioapic_map[i].devid	= devid;
@@ -2195,6 +2207,7 @@ static int __init parse_ivrs_hpet(char *str)
 
 	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
 
+	cmdline_maps			= true;
 	i				= early_hpet_map_size++;
 	early_hpet_map[i].id		= id;
 	early_hpet_map[i].devid		= devid;
-- 
1.7.9.5


