Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaKRPDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:03:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbaKROJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:42 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 083/206] virtio_pci: fix virtio spec compliance on restore
Date: Tue, 18 Nov 2014 15:07:18 +0100
Message-Id: <a5f37e6cb8c60f4a066ca9d2d4bcb6af002af4eb.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6fbc198cf623944ab60a1db6d306a4d55cdd820d upstream.

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

Cc: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/virtio/virtio_pci.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 98917fc872a4..e2ccc0f8e40a 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -792,6 +792,7 @@ static int virtio_pci_restore(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 	struct virtio_driver *drv;
+	unsigned status = 0;
 	int ret;
 
 	drv = container_of(vp_dev->vdev.dev.driver,
@@ -802,14 +803,40 @@ static int virtio_pci_restore(struct device *dev)
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
+	if (drv->restore) {
 		ret = drv->restore(&vp_dev->vdev);
+		if (ret) {
+			status |= VIRTIO_CONFIG_S_FAILED;
+			vp_set_status(&vp_dev->vdev, status);
+			return ret;
+		}
+	}
 
 	/* Finally, tell the device we're all set */
-	if (!ret)
-		vp_set_status(&vp_dev->vdev, vp_dev->saved_status);
+	status |= VIRTIO_CONFIG_S_DRIVER_OK;
+	vp_set_status(&vp_dev->vdev, status);
 
 	return ret;
 }
-- 
2.1.3

