Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751249Ab3BOTLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:11:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3BOTLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:11:43 -0500
Subject: [PATCH] vfio: Protect vfio_dev_present against device_del
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: vijaymohan.pandarathil@hp.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Fri, 15 Feb 2013 12:11:40 -0700
Message-ID: <20130215191106.27285.51179.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vfio_dev_present is meant to give us a wait_event callback so that we
can block removing a device from vfio until it becomes unused.  The
root of this check depends on being able to get the iommu group from
the device.  Unfortunately if the BUS_NOTIFY_DEL_DEVICE notifier has
fired then the device-group reference is no longer searchable and we
fail the lookup.

We don't need to go to such extents for this though.  We have a
reference to the device, from which we can acquire a reference to the
group.  We can then use the group reference to search for the device
and properly block removal.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/vfio.c |   33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 12c264d..8e6dcec 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -642,33 +642,16 @@ int vfio_add_group_dev(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(vfio_add_group_dev);
 
-/* Test whether a struct device is present in our tracking */
-static bool vfio_dev_present(struct device *dev)
+/* Given a referenced group, check if it contains the device */
+static bool vfio_dev_present(struct vfio_group *group, struct device *dev)
 {
-	struct iommu_group *iommu_group;
-	struct vfio_group *group;
 	struct vfio_device *device;
 
-	iommu_group = iommu_group_get(dev);
-	if (!iommu_group)
-		return false;
-
-	group = vfio_group_get_from_iommu(iommu_group);
-	if (!group) {
-		iommu_group_put(iommu_group);
-		return false;
-	}
-
 	device = vfio_group_get_device(group, dev);
-	if (!device) {
-		vfio_group_put(group);
-		iommu_group_put(iommu_group);
+	if (!device)
 		return false;
-	}
 
 	vfio_device_put(device);
-	vfio_group_put(group);
-	iommu_group_put(iommu_group);
 	return true;
 }
 
@@ -682,10 +665,18 @@ void *vfio_del_group_dev(struct device *dev)
 	struct iommu_group *iommu_group = group->iommu_group;
 	void *device_data = device->device_data;
 
+	/*
+	 * The group exists so long as we have a device reference.  Get
+	 * a group reference and use it to scan for the device going away.
+	 */
+	vfio_group_get(group);
+
 	vfio_device_put(device);
 
 	/* TODO send a signal to encourage this to be released */
-	wait_event(vfio.release_q, !vfio_dev_present(dev));
+	wait_event(vfio.release_q, !vfio_dev_present(group, dev));
+
+	vfio_group_put(group);
 
 	iommu_group_put(iommu_group);
 

