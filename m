Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3FFSRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:17:04 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10635 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab3FFSPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:15:54 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com, gong.chen@linux.intel.com,
        greg.pearson@hp.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v3 3/6] PCI/AER: Set dev->__aer_firmware_first only for matching devices
Date: Thu,  6 Jun 2013 12:10:48 -0600
Message-Id: <1370542251-27387-4-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
References: <1370542251-27387-1-git-send-email-betty.dall@hp.com>
Author: Bjorn Helgaas <bhelgaas@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we always updated info->firmware_first, even for HEST entries
that didn't match the device.  Therefore, if the last HEST descriptor was
a PCIe structure that didn't match the device, we always cleared
dev->__aer_firmware_first.
    
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index e7ea573..cf611ab 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -54,16 +54,16 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 {
 	struct aer_hest_parse_info *info = data;
 	struct acpi_hest_aer_common *p;
-	int ff = 0;
+	int ff;
 
 	p = (struct acpi_hest_aer_common *)(hest_hdr + 1);
+	ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
 	if (p->flags & ACPI_HEST_GLOBAL) {
 		if (hest_match_type(hest_hdr, info->pci_dev))
-			ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
+			info->firmware_first = ff;
 	} else
 		if (hest_match_pci(p, info->pci_dev))
-			ff = !!(p->flags & ACPI_HEST_FIRMWARE_FIRST);
-	info->firmware_first = ff;
+			info->firmware_first = ff;
 
 	return 0;
 }
