Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3CMXe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:34:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17537 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441Ab3CMX2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 08/27] PCI: Use for_each_pci_resource() with IOV releated functions
Date: Wed, 13 Mar 2013 16:28:03 -0700
Message-Id: <1363217302-14383-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/iov.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ee599f2..baf6c80 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -93,17 +93,20 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	pci_setup_device(virtfn);
 	virtfn->dev.parent = dev->dev.parent;
 
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_resource(dev, res, i, PCI_IOV_RES) {
+		struct resource *virtfn_res;
+
 		if (!res->parent)
 			continue;
-		virtfn->resource[i].name = pci_name(virtfn);
-		virtfn->resource[i].flags = res->flags;
+
+		virtfn_res = pci_dev_resource_n(virtfn, i - PCI_IOV_RESOURCES);
+		virtfn_res->name = pci_name(virtfn);
+		virtfn_res->flags = res->flags;
 		size = resource_size(res);
 		do_div(size, iov->total_VFs);
-		virtfn->resource[i].start = res->start + size * id;
-		virtfn->resource[i].end = virtfn->resource[i].start + size - 1;
-		rc = request_resource(res, &virtfn->resource[i]);
+		virtfn_res->start = res->start + size * id;
+		virtfn_res->end = virtfn_res->start + size - 1;
+		rc = request_resource(res, virtfn_res);
 		BUG_ON(rc);
 	}
 
@@ -305,9 +308,8 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 		return -EIO;
 
 	nres = 0;
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		bars |= (1 << (i + PCI_IOV_RESOURCES));
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_resource(dev, res, i, PCI_IOV_RES) {
+		bars |= 1 << i;
 		if (res->parent)
 			nres++;
 	}
@@ -465,10 +467,9 @@ found:
 	pci_write_config_dword(dev, pos + PCI_SRIOV_SYS_PGSIZE, pgsz);
 
 	nres = 0;
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_resource(dev, res, i, PCI_IOV_RES) {
 		i += __pci_read_base(dev, pci_bar_unknown, res,
-				     pos + PCI_SRIOV_BAR + i * 4);
+			     pos + PCI_SRIOV_BAR + (i - PCI_IOV_RESOURCES) * 4);
 		if (!res->flags)
 			continue;
 		if (resource_size(res) & (PAGE_SIZE - 1)) {
@@ -511,10 +512,8 @@ found:
 	return 0;
 
 failed:
-	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
-		res = dev->resource + PCI_IOV_RESOURCES + i;
+	for_each_pci_resource(dev, res, i, PCI_IOV_RES)
 		res->flags = 0;
-	}
 
 	return rc;
 }
-- 
1.7.10.4

