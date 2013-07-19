Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966063Ab3GSFuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:50:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965291Ab3GSFWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:22:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xudong Hao <xudong.hao@intel.com>, Jiang Liu <jiang.liu@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 24/38] PCI: Finish SR-IOV VF setup before adding the device
Date: Thu, 18 Jul 2013 22:21:40 -0700
Message-Id: <20130719052049.532797847@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052047.858393825@linuxfoundation.org>
References: <20130719052047.858393825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xudong Hao <xudong.hao@intel.com>

commit fbf33f516bdbcc2ab1ba1e54dfb720b0cfaa6874 upstream.

Commit 4f535093cf "PCI: Put pci_dev in device tree as early as possible"
moves device registering from pci_bus_add_devices() to pci_device_add().
That causes problems for virtual functions because device_add(&virtfn->dev)
is called before setting the virtfn->is_virtfn flag, which then causes Xen
to report PCI virtual functions as PCI physical functions.

Fix it by setting virtfn->is_virtfn before calling pci_device_add().

[Jiang Liu]: Move the setting of virtfn->is_virtfn ahead further for better
readability and modify changelog.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/iov.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -92,6 +92,8 @@ static int virtfn_add(struct pci_dev *de
 	pci_read_config_word(dev, iov->pos + PCI_SRIOV_VF_DID, &virtfn->device);
 	pci_setup_device(virtfn);
 	virtfn->dev.parent = dev->dev.parent;
+	virtfn->physfn = pci_dev_get(dev);
+	virtfn->is_virtfn = 1;
 
 	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
 		res = dev->resource + PCI_IOV_RESOURCES + i;
@@ -113,9 +115,6 @@ static int virtfn_add(struct pci_dev *de
 	pci_device_add(virtfn, virtfn->bus);
 	mutex_unlock(&iov->dev->sriov->lock);
 
-	virtfn->physfn = pci_dev_get(dev);
-	virtfn->is_virtfn = 1;
-
 	rc = pci_bus_add_device(virtfn);
 	sprintf(buf, "virtfn%u", id);
 	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);


