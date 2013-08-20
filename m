Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3HTS1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:27:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab3HTS1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:27:48 -0400
Subject: [PATCH v3] vfio-pci: PCI hot reset interface
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        benh@kernel.crashing.org, bhelgaas@google.com
Date: Tue, 20 Aug 2013 12:27:43 -0600
Message-ID: <20130820182536.7893.85481.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current VFIO_DEVICE_RESET interface only maps to PCI use cases
where we can isolate the reset to the individual PCI function.  This
means the device must support FLR (PCIe or AF), PM reset on D3hot->D0
transition, device specific reset, or be a singleton device on a bus
for a secondary bus reset.  FLR does not have widespread support,
PM reset is not very reliable, and bus topology is dictated by the
system and device design.  We need to provide a means for a user to
induce a bus reset in cases where the existing mechanisms are not
available or not reliable.

This device specific extension to VFIO provides the user with this
ability.  Two new ioctls are introduced:
 - VFIO_DEVICE_PCI_GET_HOT_RESET_INFO
 - VFIO_DEVICE_PCI_HOT_RESET

The first provides the user with information about the extent of
devices affected by a hot reset.  This is essentially a list of
devices and the IOMMU groups they belong to.  The user may then
initiate a hot reset by calling the second ioctl.  We must be
careful that the user has ownership of all the affected devices
found via the first ioctl, so the second ioctl takes a list of file
descriptors for the VFIO groups affected by the reset.  Each group
must have IOMMU protection established for the ioctl to succeed.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: Use PCI bus iterators.  Depends on pci_walk_slot() patch
v3: #include <linux/file.h> per Al Viro

 drivers/vfio/pci/vfio_pci.c |  280 +++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vfio.h   |   38 ++++++
 2 files changed, 317 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index cef6002..1dfec392 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -13,6 +13,7 @@
 
 #include <linux/device.h>
 #include <linux/eventfd.h>
+#include <linux/file.h>
 #include <linux/interrupt.h>
 #include <linux/iommu.h>
 #include <linux/module.h>
@@ -227,6 +228,104 @@ static int vfio_pci_get_irq_count(struct vfio_pci_device *vdev, int irq_type)
 	return 0;
 }
 
+struct vfio_pci_walk_info {
+	int ret;
+	void *data;
+};
+
+static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
+{
+	struct vfio_pci_walk_info *walk = data;
+	int *count = walk->data;
+
+	(*count)++;
+	return walk->ret;
+}
+
+struct vfio_pci_fill_info {
+	int max;
+	int cur;
+	struct vfio_pci_dependent_device *devices;
+};
+
+static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
+{
+	struct vfio_pci_walk_info *walk = data;
+	struct vfio_pci_fill_info *fill = walk->data;
+	struct iommu_group *iommu_group;
+
+	if (fill->cur == fill->max) {
+		walk->ret = -EAGAIN; /* Something changed, try again */
+		return walk->ret;
+	}
+
+	iommu_group = iommu_group_get(&pdev->dev);
+	if (!iommu_group) {
+		walk->ret = -EPERM; /* Cannot reset non-isolated devices */
+		return walk->ret;
+	}
+
+	fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
+	fill->devices[fill->cur].bus = pdev->bus->number;
+	fill->devices[fill->cur].devfn = pdev->devfn;
+	fill->cur++;
+	iommu_group_put(iommu_group);
+	return walk->ret;
+}
+
+struct vfio_pci_group_entry {
+	struct vfio_group *group;
+	int id;
+};
+
+struct vfio_pci_group_info {
+	int count;
+	struct vfio_pci_group_entry *groups;
+};
+
+static int vfio_pci_validate_devs(struct pci_dev *pdev, void *data)
+{
+	struct vfio_pci_walk_info *walk = data;
+	struct vfio_pci_group_info *info = walk->data;
+	struct iommu_group *group;
+	int id, i;
+
+	group = iommu_group_get(&pdev->dev);
+	if (!group) {
+		walk->ret = -EPERM;
+		return walk->ret;
+	}
+
+	id = iommu_group_id(group);
+
+	for (i = 0; i < info->count; i++)
+		if (info->groups[i].id == id)
+			break;
+
+	iommu_group_put(group);
+
+	if (i == info->count)
+		walk->ret = -EINVAL;
+
+	return walk->ret;
+}
+
+static int vfio_pci_for_each_slot_or_bus(struct pci_dev *pdev,
+					 int (*fn)(struct pci_dev *,
+						   void *data), void *data,
+					 bool slot)
+{
+	struct vfio_pci_walk_info info = { .ret = 0, .data = data };
+
+	if (slot)
+		pci_walk_slot(pdev->slot, fn, &info);
+	else
+		pci_walk_bus(pdev->bus, fn, &info);
+
+	return info.ret;
+}
+
 static long vfio_pci_ioctl(void *device_data,
 			   unsigned int cmd, unsigned long arg)
 {
@@ -407,10 +506,189 @@ static long vfio_pci_ioctl(void *device_data,
 
 		return ret;
 
-	} else if (cmd == VFIO_DEVICE_RESET)
+	} else if (cmd == VFIO_DEVICE_RESET) {
 		return vdev->reset_works ?
 			pci_reset_function(vdev->pdev) : -EINVAL;
 
+	} else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
+		struct vfio_pci_hot_reset_info hdr;
+		struct vfio_pci_fill_info fill = { 0 };
+		struct vfio_pci_dependent_device *devices = NULL;
+		bool slot = false;
+		int ret = 0;
+
+		minsz = offsetofend(struct vfio_pci_hot_reset_info, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (hdr.argsz < minsz)
+			return -EINVAL;
+
+		hdr.flags = 0;
+
+		/* Can we do a slot or bus reset or neither? */
+		if (!pci_probe_reset_slot(vdev->pdev->slot))
+			slot = true;
+		else if (pci_probe_reset_bus(vdev->pdev->bus))
+			return -ENODEV;
+
+		/* How many devices are affected? */
+		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
+						    vfio_pci_count_devs,
+						    &fill.max, slot);
+		if (ret)
+			return ret;
+
+		WARN_ON(!fill.max); /* Should always be at least one */
+
+		/*
+		 * If there's enough space, fill it now, otherwise return
+		 * -ENOSPC and the number of devices affected.
+		 */
+		if (hdr.argsz < sizeof(hdr) + (fill.max * sizeof(*devices))) {
+			ret = -ENOSPC;
+			hdr.count = fill.max;
+			goto reset_info_exit;
+		}
+
+		devices = kcalloc(fill.max, sizeof(*devices), GFP_KERNEL);
+		if (!devices)
+			return -ENOMEM;
+
+		fill.devices = devices;
+
+		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
+						    vfio_pci_fill_devs,
+						    &fill, slot);
+
+		/*
+		 * If a device was removed between counting and filling,
+		 * we may come up short of fill.max.  If a device was
+		 * added, we'll have a return of -EAGAIN above.
+		 */
+		if (!ret)
+			hdr.count = fill.cur;
+
+reset_info_exit:
+		if (copy_to_user((void __user *)arg, &hdr, minsz))
+			ret = -EFAULT;
+
+		if (!ret) {
+			if (copy_to_user((void __user *)(arg + minsz), devices,
+					 hdr.count * sizeof(*devices)))
+				ret = -EFAULT;
+		}
+
+		kfree(devices);
+		return ret;
+
+	} else if (cmd == VFIO_DEVICE_PCI_HOT_RESET) {
+		struct vfio_pci_hot_reset hdr;
+		int32_t *group_fds;
+		struct vfio_pci_group_entry *groups;
+		struct vfio_pci_group_info info;
+		bool slot = false;
+		int i, count = 0, ret = 0;
+
+		minsz = offsetofend(struct vfio_pci_hot_reset, count);
+
+		if (copy_from_user(&hdr, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (hdr.argsz < minsz || hdr.flags)
+			return -EINVAL;
+
+		/* Can we do a slot or bus reset or neither? */
+		if (!pci_probe_reset_slot(vdev->pdev->slot))
+			slot = true;
+		else if (pci_probe_reset_bus(vdev->pdev->bus))
+			return -ENODEV;
+
+		/*
+		 * We can't let userspace give us an arbitrarily large
+		 * buffer to copy, so verify how many we think there
+		 * could be.  Note groups can have multiple devices so
+		 * one group per device is the max.
+		 */
+		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
+						    vfio_pci_count_devs,
+						    &count, slot);
+		if (ret)
+			return ret;
+
+		/* Somewhere between 1 and count is OK */
+		if (!hdr.count || hdr.count > count)
+			return -EINVAL;
+
+		group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
+		groups = kcalloc(hdr.count, sizeof(*groups), GFP_KERNEL);
+		if (!group_fds || !groups) {
+			kfree(group_fds);
+			kfree(groups);
+			return -ENOMEM;
+		}
+
+		if (copy_from_user(group_fds, (void __user *)(arg + minsz),
+				   hdr.count * sizeof(*group_fds))) {
+			kfree(group_fds);
+			kfree(groups);
+			return -EFAULT;
+		}
+
+		/*
+		 * For each group_fd, get the group through the vfio external
+		 * user interface and store the group and iommu ID.  This
+		 * ensures the group is held across the reset.
+		 */
+		for (i = 0; i < hdr.count; i++) {
+			struct vfio_group *group;
+			struct fd f = fdget(group_fds[i]);
+			if (!f.file) {
+				ret = -EBADF;
+				break;
+			}
+
+			group = vfio_group_get_external_user(f.file);
+			fdput(f);
+			if (IS_ERR(group)) {
+				ret = PTR_ERR(group);
+				break;
+			}
+
+			groups[i].group = group;
+			groups[i].id = vfio_external_user_iommu_id(group);
+		}
+
+		kfree(group_fds);
+
+		/* release reference to groups on error */
+		if (ret)
+			goto hot_reset_release;
+
+		info.count = hdr.count;
+		info.groups = groups;
+
+		/*
+		 * Test whether all the affected devices are contained
+		 * by the set of groups provided by the user.
+		 */
+		ret = vfio_pci_for_each_slot_or_bus(vdev->pdev,
+						    vfio_pci_validate_devs,
+						    &info, slot);
+		if (!ret)
+			/* User has access, do the reset */
+			ret = slot ? pci_reset_slot(vdev->pdev->slot) :
+				     pci_reset_bus(vdev->pdev->bus);
+
+hot_reset_release:
+		for (i--; i >= 0; i--)
+			vfio_group_put_external_user(groups[i].group);
+
+		kfree(groups);
+		return ret;
+	}
+
 	return -ENOTTY;
 }
 
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 916e444..0fd47f5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -324,6 +324,44 @@ enum {
 	VFIO_PCI_NUM_IRQS
 };
 
+/**
+ * VFIO_DEVICE_GET_PCI_HOT_RESET_INFO - _IORW(VFIO_TYPE, VFIO_BASE + 12,
+ *					      struct vfio_pci_hot_reset_info)
+ *
+ * Return: 0 on success, -errno on failure:
+ *	-enospc = insufficient buffer, -enodev = unsupported for device.
+ */
+struct vfio_pci_dependent_device {
+	__u32	group_id;
+	__u16	segment;
+	__u8	bus;
+	__u8	devfn; /* Use PCI_SLOT/PCI_FUNC */
+};
+
+struct vfio_pci_hot_reset_info {
+	__u32	argsz;
+	__u32	flags;
+	__u32	count;
+	struct vfio_pci_dependent_device	devices[];
+};
+
+#define VFIO_DEVICE_GET_PCI_HOT_RESET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
+
+/**
+ * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
+ *				    struct vfio_pci_hot_reset)
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+struct vfio_pci_hot_reset {
+	__u32	argsz;
+	__u32	flags;
+	__u32	count;
+	__s32	group_fds[];
+};
+
+#define VFIO_DEVICE_PCI_HOT_RESET	_IO(VFIO_TYPE, VFIO_BASE + 13)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**

