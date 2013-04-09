Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936273Ab3DIUOh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:14:37 -0400
Received: from 8bytes.org ([85.214.48.195]:36429 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936175Ab3DIUNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:13:34 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 5/9] iommu/amd: Extend IVRS special device data structure
Date: Tue,  9 Apr 2013 22:13:00 +0200
Message-Id: <1365538384-12426-6-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365538384-12426-1-git-send-email-joro@8bytes.org>
References: <1365538384-12426-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  9 22:13:33 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5164766d23678395620859
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the devid_map data structure to allow
ioapic and hpet entries in ivrs to be overridden on the
kernel command line.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu_init.c  |   28 +++++++++++++++++++---------
 drivers/iommu/amd_iommu_types.h |    1 +
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 6dc8d8d..3a210f0 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -708,20 +708,30 @@ static int __init add_special_device(u8 type, u8 id, u16 devid, bool cmd_line)
 	struct devid_map *entry;
 	struct list_head *list;
 
-	if (type != IVHD_SPECIAL_IOAPIC && type != IVHD_SPECIAL_HPET)
+	if (type == IVHD_SPECIAL_IOAPIC)
+		list = &ioapic_map;
+	else if (type == IVHD_SPECIAL_HPET)
+		list = &hpet_map;
+	else
 		return -EINVAL;
 
+	list_for_each_entry(entry, list, list) {
+		if (!(entry->id == id && entry->cmd_line))
+			continue;
+
+		pr_info("AMD-Vi: Command-line override present for %s id %d - ignoring\n",
+			type == IVHD_SPECIAL_IOAPIC ? "IOAPIC" : "HPET", id);
+
+		return 0;
+	}
+
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
 
-	entry->id    = id;
-	entry->devid = devid;
-
-	if (type == IVHD_SPECIAL_IOAPIC)
-		list = &ioapic_map;
-	else
-		list = &hpet_map;
+	entry->id	= id;
+	entry->devid	= devid;
+	entry->cmd_line	= cmd_line;
 
 	list_add_tail(&entry->list, list);
 
@@ -929,7 +939,7 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 				    PCI_FUNC(devid));
 
 			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
-			ret = add_special_device(type, handle, devid);
+			ret = add_special_device(type, handle, devid, false);
 			if (ret)
 				return ret;
 			break;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e38ab43..f0a85fa 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -591,6 +591,7 @@ struct devid_map {
 	struct list_head list;
 	u8 id;
 	u16 devid;
+	bool cmd_line;
 };
 
 /* Map HPET and IOAPIC ids to the devid used by the IOMMU */
-- 
1.7.9.5


