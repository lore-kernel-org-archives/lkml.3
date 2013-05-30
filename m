Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967527Ab3E3FqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 01:46:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:55420 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967488Ab3E3FqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 01:46:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="321746786"
From: Xudong Hao <xudong.hao@intel.com>
To: bhelgaas@google.com
Cc: yinghai@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xudong Hao <xudong.hao@intel.com>
Subject: [PATCH] PCI: set correct value for iov device before device
Date: Thu, 30 May 2013 13:45:34 +0800
Message-Id: <1369892734-26244-1-git-send-email-xudong.hao@intel.com>
X-Mailer: git-send-email 1.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since device registering is put into pci_device_add(), it must set value of
Virtual Function device's member before the pci_dev is put to device tree. Or
some relevant subsystem of driver model such as xen will report a incorrect
IOV device to Xen hypervior.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
---
 drivers/pci/iov.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index c93071d..43d3de9 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -110,12 +110,12 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	if (reset)
 		__pci_reset_function(virtfn);
 
-	pci_device_add(virtfn, virtfn->bus);
-	mutex_unlock(&iov->dev->sriov->lock);
-
 	virtfn->physfn = pci_dev_get(dev);
 	virtfn->is_virtfn = 1;
 
+	pci_device_add(virtfn, virtfn->bus);
+	mutex_unlock(&iov->dev->sriov->lock);
+
 	rc = pci_bus_add_device(virtfn);
 	sprintf(buf, "virtfn%u", id);
 	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
-- 
1.7.12.1

