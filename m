Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab3LPKeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:34:25 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49648 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129Ab3LPKeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:34:23 -0500
Message-ID: <1387190061.9255.30.camel@x41.thuisdomein>
Subject: [PATCH 1/2] ahci: bail out on ICH6 before using AHCI BAR
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Dec 2013 11:34:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2013 10:34:22.0056 (UTC) FILETIME=[62179680:01CEFA4A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check for "combined mode" (which disables ahci support) on ICH6 is
done after the first use of AHCI BAR. But if ahci is not enabled AHCI
BAR is initialized to 0x00000000. (At least it is on the ICH6-M I tested
this on. If I understand the datasheet correctly it should also be on
ICH6R.) This apparently makes the call of
pcim_iomap_regions_request_all() return -EINVAL. And we end up with
    ahci: probe of 0000:00:1f.2 failed with error -22

(at warning level) in the logs.

So check for "combined mode" before calling
pcim_iomap_regions_request_all().

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested on a laptop that always uses ICH6-M in "combined mode" (so with
ahci support disabled). I don't think I have any hardware with an ICH6R.

 drivers/ata/ahci.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b55c88d..4ba3bde 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1238,15 +1238,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	/* AHCI controllers often implement SFF compatible interface.
-	 * Grab all PCI BARs just in case.
-	 */
-	rc = pcim_iomap_regions_request_all(pdev, 1 << ahci_pci_bar, DRV_NAME);
-	if (rc == -EBUSY)
-		pcim_pin_device(pdev);
-	if (rc)
-		return rc;
-
 	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
 	    (pdev->device == 0x2652 || pdev->device == 0x2653)) {
 		u8 map;
@@ -1264,6 +1255,15 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
+	/* AHCI controllers often implement SFF compatible interface.
+	 * Grab all PCI BARs just in case.
+	 */
+	rc = pcim_iomap_regions_request_all(pdev, 1 << ahci_pci_bar, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(pdev);
+	if (rc)
+		return rc;
+
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
-- 
1.8.1.4

