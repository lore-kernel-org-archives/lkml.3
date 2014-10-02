Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaJBKJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:09:22 -0400
Received: from 8bytes.org ([81.169.241.247]:45149 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaJBKJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:09:16 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, jroedel@suse.de,
        joro@8bytes.org
Subject: [PATCH 2/2] iommu/vt-d: Work around broken RMRR firmware entries
Date: Thu,  2 Oct 2014 12:09:08 +0200
Message-Id: <1412244548-27617-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412244548-27617-1-git-send-email-joro@8bytes.org>
References: <1412244548-27617-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The VT-d specification states that an RMRR entry in the DMAR
table needs to specify the full path to the device. This is
also how newer Linux kernels implement it.

Unfortunatly older drivers just match for the target device
and not the full path to the device, so that BIOS vendors
implement that behavior into their BIOSes to make them work
with older Linux kernels. But those RMRR entries break on
newer Linux kernels.

Work around this issue by adding a fall-back into the RMRR
matching code to match those old RMRR entries too.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/dmar.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 6ba28b0..371ff33 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -178,17 +178,33 @@ static bool dmar_match_pci_path(struct dmar_pci_notify_info *info, int bus,
 	int i;
 
 	if (info->bus != bus)
-		return false;
+		goto fallback;
 	if (info->level != count)
-		return false;
+		goto fallback;
 
 	for (i = 0; i < count; i++) {
 		if (path[i].device != info->path[i].device ||
 		    path[i].function != info->path[i].function)
-			return false;
+			goto fallback;
 	}
 
 	return true;
+
+fallback:
+
+	if (count != 1)
+		return false;
+
+	i = info->level - 1;
+	if (bus              == info->path[i].bus &&
+	    path[0].device   == info->path[i].device &&
+	    path[0].function == info->path[i].function) {
+		pr_info(FW_BUG "RMRR entry for device %02x:%02x.%x is broken - applying workaround\n",
+			bus, path[0].device, path[0].function);
+		return true;
+	}
+
+	return false;
 }
 
 /* Return: > 0 if match found, 0 if no match found, < 0 if error happens */
-- 
1.9.1

