Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3FKQBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:01:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3FKQBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:01:44 -0400
Subject: [PATCH 1/3] vfio: Don't overreact to DEL_DEVICE
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 11 Jun 2013 10:01:43 -0600
Message-ID: <20130611160142.9995.29479.stgit@bling.home>
In-Reply-To: <20130611155848.9995.41709.stgit@bling.home>
References: <20130611155848.9995.41709.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUS_NOTIFY_DEL_DEVICE triggers IOMMU drivers to remove devices from
their iommu group, but there's really nothing we can do about it at
this point.  If the device is in use, then the vfio sub-driver will
block the device_del from completing until it's released.  If the
device is not in use or not owned by a vfio sub-driver, then we
really don't care that it's being removed.

The current code can be triggered just by unloading an sr-iov driver
(ex. igb) while the VFs are attached to vfio-pci because it makes an
incorrect assumption about the ordering of driver remove callbacks
vs the DEL_DEVICE notification.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |   29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 6d78736..1bed313 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -492,27 +492,6 @@ static int vfio_group_nb_add_dev(struct vfio_group *group, struct device *dev)
 	return 0;
 }
 
-static int vfio_group_nb_del_dev(struct vfio_group *group, struct device *dev)
-{
-	struct vfio_device *device;
-
-	/*
-	 * Expect to fall out here.  If a device was in use, it would
-	 * have been bound to a vfio sub-driver, which would have blocked
-	 * in .remove at vfio_del_group_dev.  Sanity check that we no
-	 * longer track the device, so it's safe to remove.
-	 */
-	device = vfio_group_get_device(group, dev);
-	if (likely(!device))
-		return 0;
-
-	WARN("Device %s removed from live group %d!\n", dev_name(dev),
-	     iommu_group_id(group->iommu_group));
-
-	vfio_device_put(device);
-	return 0;
-}
-
 static int vfio_group_nb_verify(struct vfio_group *group, struct device *dev)
 {
 	/* We don't care what happens when the group isn't in use */
@@ -543,7 +522,13 @@ static int vfio_iommu_group_notifier(struct notifier_block *nb,
 		vfio_group_nb_add_dev(group, dev);
 		break;
 	case IOMMU_GROUP_NOTIFY_DEL_DEVICE:
-		vfio_group_nb_del_dev(group, dev);
+		/*
+		 * Nothing to do here.  If the device is in use, then the
+		 * vfio sub-driver should block the remove callback until
+		 * it is unused.  If the device is unused or attached to a
+		 * stub driver, then it should be released and we don't
+		 * care that it will be going away.
+		 */
 		break;
 	case IOMMU_GROUP_NOTIFY_BIND_DRIVER:
 		pr_debug("%s: Device %s, group %d binding to driver\n",

