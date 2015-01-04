Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbbADQDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 11:03:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbbADQCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 11:02:32 -0500
Date: Sun, 4 Jan 2015 18:02:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: sasha.levin@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, stable@vger.kernel.org
Subject: [PATCH 2/3] virtio_pci: defer kfree until release callback
Message-ID: <1420386340-7719-3-git-send-email-mst@redhat.com>
References: <1420386340-7719-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420386340-7719-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sasha Levin <sasha.levin@oracle.com>

A struct device which has just been unregistered can live on past the
point at which a driver decides to drop it's initial reference to the
kobject gained on allocation.

This implies that when releasing a virtio device, we can't free a struct
virtio_device until the underlying struct device has been released,
which might not happen immediately on device_unregister().

Unfortunately, this is exactly what virtio pci does:
it has an empty release callback, and frees memory immediately
after unregistering the device.

This causes an easy to reproduce crash if CONFIG_DEBUG_KOBJECT_RELEASE
it enabled.

To fix, free the memory only once we know the device is gone in the release
callback.

Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_pci_legacy.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 08d1915..4beaee3 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -213,11 +213,10 @@ static const struct virtio_config_ops virtio_pci_config_ops = {
 
 static void virtio_pci_release_dev(struct device *_d)
 {
-	/*
-	 * No need for a release method as we allocate/free
-	 * all devices together with the pci devices.
-	 * Provide an empty one to avoid getting a warning from core.
-	 */
+	struct virtio_device *vdev = dev_to_virtio(_d);
+	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
+
+	kfree(vp_dev);
 }
 
 /* the PCI probing function */
@@ -311,5 +310,4 @@ void virtio_pci_legacy_remove(struct pci_dev *pci_dev)
 	pci_iounmap(pci_dev, vp_dev->ioaddr);
 	pci_release_regions(pci_dev);
 	pci_disable_device(pci_dev);
-	kfree(vp_dev);
 }
-- 
MST

