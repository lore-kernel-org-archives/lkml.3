Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab3I3N1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:27:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:55738 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab3I3N1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:27:12 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-f5-52497c2f7ed2
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: axboe@kernel.dk
Cc: abhansali@stec-inc.com, jmoyer@redhat.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 10/14] skd: cleanup skd_do_inq_page_da()
Date: Mon, 30 Sep 2013 15:25:51 +0200
Message-id: <1380547556-17719-11-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
References: <1380547556-17719-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e+xgK5BjWeQwaxDbBa9PSfZLVbf7Wez
	2DhjPavF2V9XWSzONr1ht7i8aw6bA5vH5bOlHu/3XWXz6NuyitHjzrkPTB6fN8kFsEZx2aSk
	5mSWpRbp2yVwZZzZPIut4Lx4xdH2r0wNjLNEuhg5OSQETCQePl3ACmGLSVy4t56ti5GLQ0hg
	EaPE7POzmSCcLiaJrw+bGEGq2ASsJCa2rwKzRQSEJfZ3tLKAFDELNDFKbFwyhw0kISxgIXFo
	+iOwsSwCqhJbHnwAa+AV8JQ48H4/G8Q6eYmn9/vAbE6g+P/bR8FqhAQ8JL4dusw0gZF3ASPD
	KkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgYHomtYNxZYPFIUYBDkYlHt4Jyz2ChFgTy4or
	cw8xSnAwK4nwipd5BgnxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgST
	ZeLglGpglM13aNtbVh3pKqCwo465hnPLteAfzlW35c5XvH27R0XHMPHGWp4JLBsdc1r6neQU
	dhpmqNuf0v5vs7p0+tubKl+vmz668H5v9heGV5M/TWxV/+Sk8zNAtc/lWmTa2yizL7KOvwpv
	ntywuo3lg6Zwp1dO+UMrmWW7IyMW596uKQ07dDir49IbJZbijERDLeai4kQABK1/xSICAAA=
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
index 9fe910d..2ff8e37 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -2896,6 +2896,7 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 			       volatile struct fit_comp_error_info *skerr,
 			       uint8_t *cdb, uint8_t *buf)
 {
+	struct pci_dev *pdev = skdev->pdev;
 	unsigned max_bytes;
 	struct driver_inquiry_data inq;
 	u16 val;
@@ -2906,36 +2907,22 @@ static void skd_do_inq_page_da(struct skd_device *skdev,
 
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

