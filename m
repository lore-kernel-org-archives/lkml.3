Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936232Ab3DIUOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:14:16 -0400
Received: from 8bytes.org ([85.214.48.195]:36432 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936202Ab3DIUNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:35 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 7/9] iommu/amd: Add ioapic and hpet ivrs override
Date: Tue,  9 Apr 2013 22:13:02 +0200
Message-Id: <1365538384-12426-8-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:33 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766d23671850053133
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two new kernel commandline parameters ivrs_ioapic and
ivrs_hpet to override the Id->DeviceId mapping from the IVRS
ACPI table. This can be used to work around broken BIOSes to
get interrupt remapping working on AMD systems.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu_init.c |   64 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 2a3b1b1..030d6ab 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -2145,8 +2145,68 @@ static int __init parse_amd_iommu_options(char *str)
 	return 1;
 }
 
-__setup("amd_iommu_dump", parse_amd_iommu_dump);
-__setup("amd_iommu=", parse_amd_iommu_options);
+static int __init parse_ivrs_ioapic(char *str)
+{
+	unsigned int bus, dev, fn;
+	int ret, id, i;
+	u16 devid;
+
+	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
+
+	if (ret != 4) {
+		pr_err("AMD-Vi: Invalid command line: ivrs_ioapic%s\n", str);
+		return 1;
+	}
+
+	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
+		pr_err("AMD-Vi: Early IOAPIC map overflow - ignoring ivrs_ioapic%s\n",
+			str);
+		return 1;
+	}
+
+	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+
+	i				= early_ioapic_map_size++;
+	early_ioapic_map[i].id		= id;
+	early_ioapic_map[i].devid	= devid;
+	early_ioapic_map[i].cmd_line	= true;
+
+	return 1;
+}
+
+static int __init parse_ivrs_hpet(char *str)
+{
+	unsigned int bus, dev, fn;
+	int ret, id, i;
+	u16 devid;
+
+	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
+
+	if (ret != 4) {
+		pr_err("AMD-Vi: Invalid command line: ivrs_hpet%s\n", str);
+		return 1;
+	}
+
+	if (early_hpet_map_size == EARLY_MAP_SIZE) {
+		pr_err("AMD-Vi: Early HPET map overflow - ignoring ivrs_hpet%s\n",
+			str);
+		return 1;
+	}
+
+	devid = ((bus & 0xff) << 8) | ((dev & 0x1f) << 3) | (fn & 0x7);
+
+	i				= early_hpet_map_size++;
+	early_hpet_map[i].id		= id;
+	early_hpet_map[i].devid		= devid;
+	early_hpet_map[i].cmd_line	= true;
+
+	return 1;
+}
+
+__setup("amd_iommu_dump",	parse_amd_iommu_dump);
+__setup("amd_iommu=",		parse_amd_iommu_options);
+__setup("ivrs_ioapic",		parse_ivrs_ioapic);
+__setup("ivrs_hpet",		parse_ivrs_hpet);
 
 IOMMU_INIT_FINISH(amd_iommu_detect,
 		  gart_iommu_hole_init,
-- 
1.7.9.5


