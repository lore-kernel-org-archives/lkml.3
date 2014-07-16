Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbaGPTBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:01:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760510AbaGPTBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:01:20 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/3] vfio-pci: Release devices with BusMaster disabled
To: alex.williamson@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Wed, 16 Jul 2014 13:01:19 -0600
Message-ID: <20140716190118.4153.62519.stgit@gimli.home>
In-Reply-To: <20140716184645.4153.86129.stgit@gimli.home>
References: <20140716184645.4153.86129.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our current open/release path looks like this:

vfio_pci_open
  vfio_pci_enable
    pci_enable_device
    pci_save_state
    pci_store_saved_state

vfio_pci_release
  vfio_pci_disable
    pci_disable_device
    pci_restore_state

pci_enable_device() doesn't modify PCI_COMMAND_MASTER, so if a device
comes to us with it enabled, it persists through the open and gets
stored as part of the device saved state.  We then restore that saved
state when released, which can allow the device to attempt to continue
to do DMA.  When the group is disconnected from the domain, this will
get caught by the IOMMU, but if there are other devices in the group,
the device may continue running and interfere with the user.  Even in
the former case, IOMMUs don't necessarily behave well and a stream of
blocked DMA can result in unpleasant behavior on the host.

Explicitly disable Bus Master as we're enabling the device and
slightly re-work release to make sure that pci_disable_device() is
the last thing that touches the device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/vfio/pci/vfio_pci.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 010e0f8..36d8332 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -44,6 +44,9 @@ static int vfio_pci_enable(struct vfio_pci_device *vdev)
 	u16 cmd;
 	u8 msix_pos;
 
+	/* Don't allow our initial saved state to include busmaster */
+	pci_clear_master(pdev);
+
 	ret = pci_enable_device(pdev);
 	if (ret)
 		return ret;
@@ -99,7 +102,8 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	struct pci_dev *pdev = vdev->pdev;
 	int bar;
 
-	pci_disable_device(pdev);
+	/* Stop the device from further DMA */
+	pci_clear_master(pdev);
 
 	vfio_pci_set_irqs_ioctl(vdev, VFIO_IRQ_SET_DATA_NONE |
 				VFIO_IRQ_SET_ACTION_TRIGGER,
@@ -128,7 +132,7 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 			__func__, dev_name(&pdev->dev));
 
 		if (!vdev->reset_works)
-			return;
+			goto out;
 
 		pci_save_state(pdev);
 	}
@@ -151,6 +155,8 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	}
 
 	pci_restore_state(pdev);
+out:
+	pci_disable_device(pdev);
 }
 
 static void vfio_pci_release(void *device_data)

