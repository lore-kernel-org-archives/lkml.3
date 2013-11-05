Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3KELjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:39:02 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47678 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3KELiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:38:04 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-5d-5278d89b52ac
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v2 09/11] skd: cleanup skd_do_inq_page_da()
Date: Tue, 05 Nov 2013 12:37:07 +0100
Message-id: <1383651429-4322-10-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
References: <1383651429-4322-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO7sGxVBBptnW1j09pxkt1h9t5/N
	YuOM9awWZ39dZbE42/SG3eLyrjlsDmwel8+Werzfd5XNo2/LKkaPO+c+MHl83iQXwBrFZZOS
	mpNZllqkb5fAlbHtcUrBefGKs+cfMTYwzhLpYuTkkBAwkWg8+IkFwhaTuHBvPVsXIxeHkMB0
	Roklu7YyQjhdTBKv+64ygVSxCVhJTGxfxQhiiwgIS+zvaGUBKWIWWMAoMXnHHHaQhLCAtcTx
	Dz/BilgEVCWW/NjCBmLzCnhI7Fx7lRFinbzE0/t9YHFOoPiVS2/AeoUE3CW2fdzLOoGRdwEj
	wypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4FB6JrWDcWWDxSFGAQ5GJR7eB2fLg4RYE8uK
	K3MPMUpwMCuJ8LYdqQgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUI
	JsvEwSnVwNjOvHFNwa0XPgpPFJdxvBNLf7V36c3W0A8yNeZ/Pb0mOCjl2hb83BDNd33O5qjI
	N4czW4LvB33ok/BTTXgVpOSp+8sh88laSf/X3088e6ZiXy+dYrXoa4H+nuopHXsjF9axC2mz
	/5Neo3XnWewzlo7aPPMdO3zD2D6/1wnKjnzfplbLwZv4TImlOCPRUIu5qDgRAPRXVBohAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

skdev->pdev and skdev->pdev->bus are always different than NULL in
skd_do_inq_page_da() so simplify the code accordingly.

Also cache skdev->pdev value in pdev variable while at it.

Cc: Akhil Bhansali <abhansali@stec-inc.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/block/skd_main.c | 39 +++++++++++++--------------------------
 1 file changed, 13 insertions(+), 26 deletions(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 70118a1..2886a8c 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -2590,6 +2590,7 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 			       volatile struct fit_comp_error_info *skerr,
 			       uint8_t *cdb, uint8_t *buf)
 {
+	struct pci_dev *pdev = skdev->pdev;
 	unsigned max_bytes;
 	struct driver_inquiry_data inq;
 	u16 val;
@@ -2601,36 +2602,22 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 
 	inq.page_code = DRIVER_INQ_EVPD_PAGE_CODE;
 
-	if (skdev->pdev && skdev->pdev->bus) {
-		skd_get_link_info(skdev->pdev,
-				  &inq.pcie_link_speed, &inq.pcie_link_lanes);
-		inq.pcie_bus_number = cpu_to_be16(skdev->pdev->bus->number);
-		inq.pcie_device_number = PCI_SLOT(skdev->pdev->devfn);
-		inq.pcie_function_number = PCI_FUNC(skdev->pdev->devfn);
+	skd_get_link_info(pdev, &inq.pcie_link_speed, &inq.pcie_link_lanes);
+	inq.pcie_bus_number = cpu_to_be16(pdev->bus->number);
+	inq.pcie_device_number = PCI_SLOT(pdev->devfn);
+	inq.pcie_function_number = PCI_FUNC(pdev->devfn);
 
-		pci_read_config_word(skdev->pdev, PCI_VENDOR_ID, &val);
-		inq.pcie_vendor_id = cpu_to_be16(val);
+	pci_read_config_word(pdev, PCI_VENDOR_ID, &val);
+	inq.pcie_vendor_id = cpu_to_be16(val);
 
-		pci_read_config_word(skdev->pdev, PCI_DEVICE_ID, &val);
-		inq.pcie_device_id = cpu_to_be16(val);
+	pci_read_config_word(pdev, PCI_DEVICE_ID, &val);
+	inq.pcie_device_id = cpu_to_be16(val);
 
-		pci_read_config_word(skdev->pdev, PCI_SUBSYSTEM_VENDOR_ID,
-				     &val);
-		inq.pcie_subsystem_vendor_id = cpu_to_be16(val);
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &val);
+	inq.pcie_subsystem_vendor_id = cpu_to_be16(val);
 
-		pci_read_config_word(skdev->pdev, PCI_SUBSYSTEM_ID, &val);
-		inq.pcie_subsystem_device_id = cpu_to_be16(val);
-	} else {
-		inq.pcie_bus_number = 0xFFFF;
-		inq.pcie_device_number = 0xFF;
-		inq.pcie_function_number = 0xFF;
-		inq.pcie_link_speed = 0xFF;
-		inq.pcie_link_lanes = 0xFF;
-		inq.pcie_vendor_id = 0xFFFF;
-		inq.pcie_device_id = 0xFFFF;
-		inq.pcie_subsystem_vendor_id = 0xFFFF;
-		inq.pcie_subsystem_device_id = 0xFFFF;
-	}
+	pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &val);
+	inq.pcie_subsystem_device_id = cpu_to_be16(val);
 
 	/* Driver version, fixed lenth, padded with spaces on the right */
 	inq.driver_version_length = sizeof(inq.driver_version);
-- 
1.8.2.3

