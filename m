Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaGJVvb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:51:31 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:32894 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGJVv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:51:28 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>
Subject: [PATCH 12/83] hsa/radeon: Add kfd mmap handler
Date: Fri, 11 Jul 2014 00:50:12 +0300
Message-Id: <1405029027-6085-11-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the kfd mmap handler that maps the physical address
of a doorbell page to a user-space virtual address. That virtual address
belongs to the process that uses the doorbell page.

This mmap handler is called only from within the kernel and not to be
called from user-mode mmap of /dev/kfd.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/hsa/radeon/kfd_chardev.c  | 20 +++++++++
 drivers/gpu/hsa/radeon/kfd_doorbell.c | 85 +++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
index 7a56a8f..0b5bc74 100644
--- a/drivers/gpu/hsa/radeon/kfd_chardev.c
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -39,6 +39,7 @@ static const struct file_operations kfd_fops = {
 	.owner = THIS_MODULE,
 	.unlocked_ioctl = kfd_ioctl,
 	.open = kfd_open,
+	.mmap = kfd_mmap,
 };
 
 static int kfd_char_dev_major = -1;
@@ -131,3 +132,22 @@ kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 	return err;
 }
+
+static int
+kfd_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	unsigned long pgoff = vma->vm_pgoff;
+	struct kfd_process *process;
+
+	process = radeon_kfd_get_process(current);
+	if (IS_ERR(process))
+		return PTR_ERR(process);
+
+	if (pgoff < KFD_MMAP_DOORBELL_START)
+		return -EINVAL;
+
+	if (pgoff < KFD_MMAP_DOORBELL_END)
+		return radeon_kfd_doorbell_mmap(process, vma);
+
+	return -EINVAL;
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_doorbell.c b/drivers/gpu/hsa/radeon/kfd_doorbell.c
index 79a9d4b..e1d8506 100644
--- a/drivers/gpu/hsa/radeon/kfd_doorbell.c
+++ b/drivers/gpu/hsa/radeon/kfd_doorbell.c
@@ -70,3 +70,88 @@ void radeon_kfd_doorbell_init(struct kfd_dev *kfd)
 	kfd->doorbell_process_limit = doorbell_process_limit;
 }
 
+/* This is the /dev/kfd mmap (for doorbell) implementation. We intend that this is only called through map_doorbells,
+** not through user-mode mmap of /dev/kfd. */
+int radeon_kfd_doorbell_mmap(struct kfd_process *process, struct vm_area_struct *vma)
+{
+	unsigned int device_index;
+	struct kfd_dev *dev;
+	phys_addr_t start;
+
+	BUG_ON(vma->vm_pgoff < KFD_MMAP_DOORBELL_START || vma->vm_pgoff >= KFD_MMAP_DOORBELL_END);
+
+	/* For simplicitly we only allow mapping of the entire doorbell allocation of a single device & process. */
+	if (vma->vm_end - vma->vm_start != doorbell_process_allocation())
+		return -EINVAL;
+
+	/* device_index must be GPU ID!! */
+	device_index = vma->vm_pgoff - KFD_MMAP_DOORBELL_START;
+
+	dev = radeon_kfd_device_by_id(device_index);
+	if (dev == NULL)
+		return -EINVAL;
+
+	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE | VM_DONTDUMP | VM_PFNMAP;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	start = dev->doorbell_base + process->pasid * doorbell_process_allocation();
+
+	pr_debug("kfd: mapping doorbell page in radeon_kfd_doorbell_mmap\n"
+		 "     target user address == 0x%016llX\n"
+		 "     physical address    == 0x%016llX\n"
+		 "     vm_flags            == 0x%08lX\n"
+		 "     size                == 0x%08lX\n",
+		 (long long unsigned int) vma->vm_start, start, vma->vm_flags,
+		 doorbell_process_allocation());
+
+	return io_remap_pfn_range(vma,
+				vma->vm_start,
+				start >> PAGE_SHIFT,
+				doorbell_process_allocation(),
+				vma->vm_page_prot);
+}
+
+/* Map the doorbells for a single process & device. This will indirectly call radeon_kfd_doorbell_mmap.
+** This assumes that the process mutex is being held. */
+static int
+map_doorbells(struct file *devkfd, struct kfd_process *process, struct kfd_dev *dev)
+{
+	struct kfd_process_device *pdd = radeon_kfd_get_process_device_data(dev, process);
+
+	if (pdd == NULL)
+		return -ENOMEM;
+
+	if (pdd->doorbell_mapping == NULL) {
+		unsigned long offset = (KFD_MMAP_DOORBELL_START + dev->id) << PAGE_SHIFT;
+		doorbell_t __user *doorbell_mapping;
+
+		doorbell_mapping = (doorbell_t __user *)vm_mmap(devkfd, 0, doorbell_process_allocation(), PROT_WRITE,
+								MAP_SHARED, offset);
+		if (IS_ERR(doorbell_mapping))
+			return PTR_ERR(doorbell_mapping);
+
+		pdd->doorbell_mapping = doorbell_mapping;
+	}
+
+	return 0;
+}
+
+/* Get the user-mode address of a doorbell. Assumes that the process mutex is being held. */
+doorbell_t __user *radeon_kfd_get_doorbell(struct file *devkfd, struct kfd_process *process, struct kfd_dev *dev,
+					   unsigned int doorbell_index)
+{
+	struct kfd_process_device *pdd;
+	int err;
+
+	BUG_ON(doorbell_index > MAX_DOORBELL_INDEX);
+
+	err = map_doorbells(devkfd, process, dev);
+	if (err)
+		return ERR_PTR(err);
+
+	pdd = radeon_kfd_get_process_device_data(dev, process);
+	BUG_ON(pdd == NULL); /* map_doorbells would have failed otherwise */
+
+	return &pdd->doorbell_mapping[doorbell_index];
+}
+
-- 
1.9.1

