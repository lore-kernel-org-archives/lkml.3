Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaJFPHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaJFPHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:07:13 -0400
Date: Mon, 6 Oct 2014 18:10:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 01/15] virtio_pci: fix virtio spec compliance on restore
Message-ID: <1412608214-31944-2-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412608214-31944-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On restore, virtio pci does the following:
+ set features
+ init vqs etc - device can be used at this point!
+ set ACKNOWLEDGE,DRIVER and DRIVER_OK status bits

This is in violation of the virtio spec, which
requires the following order:
- ACKNOWLEDGE
- DRIVER
- init vqs
- DRIVER_OK

This behaviour will break with hypervisors that assume spec compliant
behaviour.  It seems like a good idea to have this patch applied to
stable branches to reduce the support butden for the hypervisors.

Cc: stable@vger.kernel.org
Cc: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 3d1463c..0f2db51 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -789,6 +789,7 @@ static int virtio_pci_restore(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 	struct virtio_driver *drv;
+	unsigned status = 0;
 	int ret;
 
 	drv = container_of(vp_dev->vdev.dev.driver,
@@ -799,14 +800,41 @@ static int virtio_pci_restore(struct device *dev)
 		return ret;
 
 	pci_set_master(pci_dev);
+	/* We always start by resetting the device, in case a previous
+	 * driver messed it up. */
+	vp_reset(&vp_dev->vdev);
+
+	/* Acknowledge that we've seen the device. */
+	status |= VIRTIO_CONFIG_S_ACKNOWLEDGE;
+	vp_set_status(&vp_dev->vdev, status);
+
+	/* Maybe driver failed before freeze.
+	 * Restore the failed status, for debugging. */
+	status |= vp_dev->saved_status & VIRTIO_CONFIG_S_FAILED;
+	vp_set_status(&vp_dev->vdev, status);
+
+	if (!drv)
+		return 0;
+
+	/* We have a driver! */
+	status |= VIRTIO_CONFIG_S_DRIVER;
+	vp_set_status(&vp_dev->vdev, status);
+
 	vp_finalize_features(&vp_dev->vdev);
 
-	if (drv && drv->restore)
-		ret = drv->restore(&vp_dev->vdev);
+	if (!drv->restore)
+		return 0;
+
+	ret = drv->restore(&vp_dev->vdev);
+	if (ret) {
+		status |= VIRTIO_CONFIG_S_FAILED;
+		vp_set_status(&vp_dev->vdev, status);
+		return ret;
+	}
 
 	/* Finally, tell the device we're all set */
-	if (!ret)
-		vp_set_status(&vp_dev->vdev, vp_dev->saved_status);
+	status |= VIRTIO_CONFIG_S_DRIVER_OK;
+	vp_set_status(&vp_dev->vdev, status);
 
 	return ret;
 }
-- 
MST

