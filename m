Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936225Ab3DIUOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:14:36 -0400
Received: from 8bytes.org ([85.214.48.195]:36430 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936187Ab3DIUNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:34 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 6/9] iommu/amd: Add early maps for ioapic and hpet
Date: Tue,  9 Apr 2013 22:13:01 +0200
Message-Id: <1365538384-12426-7-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:33 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766d23678176116505
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed in a later patch were ioapic_map and hpet_map
entries are created before the slab allocator is initialized
(and thus add_special_device() can't be used).

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu_init.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 3a210f0..2a3b1b1 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -213,6 +213,13 @@ enum iommu_init_state {
 	IOMMU_INIT_ERROR,
 };
 
+/* Early ioapic and hpet maps from kernel command line */
+#define EARLY_MAP_SIZE		4
+static struct devid_map __initdata early_ioapic_map[EARLY_MAP_SIZE];
+static struct devid_map __initdata early_hpet_map[EARLY_MAP_SIZE];
+static int __initdata early_ioapic_map_size;
+static int __initdata early_hpet_map_size;
+
 static enum iommu_init_state init_state = IOMMU_START_STATE;
 
 static int amd_iommu_enable_interrupts(void);
@@ -738,6 +745,31 @@ static int __init add_special_device(u8 type, u8 id, u16 devid, bool cmd_line)
 	return 0;
 }
 
+static int __init add_early_maps(void)
+{
+	int i, ret;
+
+	for (i = 0; i < early_ioapic_map_size; ++i) {
+		ret = add_special_device(IVHD_SPECIAL_IOAPIC,
+					 early_ioapic_map[i].id,
+					 early_ioapic_map[i].devid,
+					 early_ioapic_map[i].cmd_line);
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < early_hpet_map_size; ++i) {
+		ret = add_special_device(IVHD_SPECIAL_HPET,
+					 early_hpet_map[i].id,
+					 early_hpet_map[i].devid,
+					 early_hpet_map[i].cmd_line);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Reads the device exclusion range from ACPI and initializes the IOMMU with
  * it
@@ -774,6 +806,12 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	u32 dev_i, ext_flags = 0;
 	bool alias = false;
 	struct ivhd_entry *e;
+	int ret;
+
+
+	ret = add_early_maps();
+	if (ret)
+		return ret;
 
 	/*
 	 * First save the recommended feature enable bits from ACPI
-- 
1.7.9.5


