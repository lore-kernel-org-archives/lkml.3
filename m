Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbaIENx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:53:26 -0400
Received: from 8bytes.org ([81.169.241.247]:38903 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932415AbaIENxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:53:24 -0400
Date: Fri, 5 Sep 2014 15:53:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Su, Friendy" <Friendy.Su@sony.com.cn>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] iommu/amd: set iommu for early mapped ioapic/hpet
Message-ID: <20140905135320.GP28786@8bytes.org>
References: <053191AD6E9023439BF3970DE870051856D1EF3AC5@APSHAXMS02.ap.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <053191AD6E9023439BF3970DE870051856D1EF3AC5@APSHAXMS02.ap.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 07:25:14PM +0800, Su, Friendy wrote:
> This issue is found on a mother board whose BIOS reports wrong
> IOAPIC devid in IVHD table. Without this fix, the early mapped
> does not really override IVHD. So that the wrong reported IOAPIC
> does not work.

The problem you describe here should also be fixed by this (simpler)
patch. Can you test this please?

Thanks,

	Joerg

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 3783e0b..b0522f1 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -712,7 +712,7 @@ static void __init set_dev_entry_from_acpi(struct amd_iommu *iommu,
 	set_iommu_for_device(iommu, devid);
 }
 
-static int __init add_special_device(u8 type, u8 id, u16 devid, bool cmd_line)
+static int __init add_special_device(u8 type, u8 id, u16 *devid, bool cmd_line)
 {
 	struct devid_map *entry;
 	struct list_head *list;
@@ -731,6 +731,8 @@ static int __init add_special_device(u8 type, u8 id, u16 devid, bool cmd_line)
 		pr_info("AMD-Vi: Command-line override present for %s id %d - ignoring\n",
 			type == IVHD_SPECIAL_IOAPIC ? "IOAPIC" : "HPET", id);
 
+		*devid = entry->devid;
+
 		return 0;
 	}
 
@@ -739,7 +741,7 @@ static int __init add_special_device(u8 type, u8 id, u16 devid, bool cmd_line)
 		return -ENOMEM;
 
 	entry->id	= id;
-	entry->devid	= devid;
+	entry->devid	= *devid;
 	entry->cmd_line	= cmd_line;
 
 	list_add_tail(&entry->list, list);
@@ -754,7 +756,7 @@ static int __init add_early_maps(void)
 	for (i = 0; i < early_ioapic_map_size; ++i) {
 		ret = add_special_device(IVHD_SPECIAL_IOAPIC,
 					 early_ioapic_map[i].id,
-					 early_ioapic_map[i].devid,
+					 &early_ioapic_map[i].devid,
 					 early_ioapic_map[i].cmd_line);
 		if (ret)
 			return ret;
@@ -763,7 +765,7 @@ static int __init add_early_maps(void)
 	for (i = 0; i < early_hpet_map_size; ++i) {
 		ret = add_special_device(IVHD_SPECIAL_HPET,
 					 early_hpet_map[i].id,
-					 early_hpet_map[i].devid,
+					 &early_hpet_map[i].devid,
 					 early_hpet_map[i].cmd_line);
 		if (ret)
 			return ret;
@@ -978,10 +980,17 @@ static int __init init_iommu_from_acpi(struct amd_iommu *iommu,
 				    PCI_SLOT(devid),
 				    PCI_FUNC(devid));
 
-			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
-			ret = add_special_device(type, handle, devid, false);
+			ret = add_special_device(type, handle, &devid, false);
 			if (ret)
 				return ret;
+
+			/*
+			 * add_special_device might update the devid in case a
+			 * command-line override is present. So call
+			 * set_dev_entry_from_acpi after add_special_device.
+			 */
+			set_dev_entry_from_acpi(iommu, devid, e->flags, 0);
+
 			break;
 		}
 		default:
