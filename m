Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3A1QnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:43:04 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34037 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab3A1Qmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:42:53 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 05/15] PCI: Lock down BAR access in secure boot environments
Date: Mon, 28 Jan 2013 11:42:29 -0500
Message-Id: <1359391359-25783-6-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any hardware that can potentially generate DMA has to be locked down from
userspace in order to avoid it being possible for an attacker to cause
arbitrary kernel behaviour. Default to paranoid - in future we can
potentially relax this for sufficiently IOMMU-isolated devices.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/pci/pci-sysfs.c | 9 +++++++++
 drivers/pci/proc.c      | 8 +++++++-
 drivers/pci/syscall.c   | 2 +-
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c6e9bb..b966089 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -622,6 +622,9 @@ pci_write_config(struct file* filp, struct kobject *kobj,
 	loff_t init_off = off;
 	u8 *data = (u8*) buf;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (off > dev->cfg_size)
 		return 0;
 	if (off + count > dev->cfg_size) {
@@ -928,6 +931,9 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	resource_size_t start, end;
 	int i;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
 		if (res == &pdev->resource[i])
 			break;
@@ -1035,6 +1041,9 @@ pci_write_resource_io(struct file *filp, struct kobject *kobj,
 		      struct bin_attribute *attr, char *buf,
 		      loff_t off, size_t count)
 {
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
 }
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 9b8505c..35580bc 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -139,6 +139,9 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	int size = dp->size;
 	int cnt;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)
@@ -219,6 +222,9 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 #endif /* HAVE_PCI_MMAP */
 	int ret = 0;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	switch (cmd) {
 	case PCIIOC_CONTROLLER:
 		ret = pci_domain_nr(dev->bus);
@@ -259,7 +265,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	struct pci_filp_private *fpriv = file->private_data;
 	int i, ret;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (!capable(CAP_SYS_RAWIO) || !capable(CAP_COMPROMISE_KERNEL))
 		return -EPERM;
 
 	/* Make sure the caller is mapping a real resource for this device */
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index e1c1ec5..97e785f 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -92,7 +92,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 	u32 dword;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) || !capable(CAP_COMPROMISE_KERNEL))
 		return -EPERM;
 
 	dev = pci_get_bus_and_slot(bus, dfn);
-- 
1.8.0.2

