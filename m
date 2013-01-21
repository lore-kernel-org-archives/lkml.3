Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3AUVVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:21:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3AUVV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:28 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v10 04/11] PCI: Fix a device reference count leakage issue in pci_dev_present()
Date: Mon, 21 Jan 2013 13:20:45 -0800
Message-Id: <1358803252-20639-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function pci_get_dev_by_id() will hold a reference count on the pci device
returned, so pci_dev_present() should release the corresponding reference
count to avoid memory leakage.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/search.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index bf969ba..d0627fa 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -319,13 +319,13 @@ int pci_dev_present(const struct pci_device_id *ids)
 	WARN_ON(in_interrupt());
 	while (ids->vendor || ids->subvendor || ids->class_mask) {
 		found = pci_get_dev_by_id(ids, NULL);
-		if (found)
-			goto exit;
+		if (found) {
+			pci_dev_put(found);
+			return 1;
+		}
 		ids++;
 	}
-exit:
-	if (found)
-		return 1;
+
 	return 0;
 }
 EXPORT_SYMBOL(pci_dev_present);
-- 
1.7.10.4

