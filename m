Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244Ab3HSQLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:11:13 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:49976 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3HSQLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:11:08 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: [PATCH 02/10] PCI: Lock down BAR access when module security is enabled
Date: Mon, 19 Aug 2013 12:10:11 -0400
Message-Id: <1376928619-3775-2-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
References: <1376928619-3775-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any hardware that can potentially generate DMA has to be locked down from
userspace in order to avoid it being possible for an attacker to modify
kernel code, allowing them to circumvent disabled module loading or module
signing. Default to paranoid - in future we can potentially relax this for
sufficiently IOMMU-isolated devices.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/pci/pci-sysfs.c | 10 ++++++++++
 drivers/pci/proc.c      |  8 +++++++-
 drivers/pci/syscall.c   |  3 ++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index c0dbe1f..cd4e35f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/vgaarb.h>
 #include <linux/pm_runtime.h>
+#include <linux/module.h>
 #include "pci.h"
 
 static int sysfs_initialized;	/* = 0 */
@@ -624,6 +625,9 @@ pci_write_config(struct file* filp, struct kobject *kobj,
 	loff_t init_off = off;
 	u8 *data = (u8*) buf;
 
+	if (secure_modules())
+		return -EPERM;
+
 	if (off > dev->cfg_size)
 		return 0;
 	if (off + count > dev->cfg_size) {
@@ -930,6 +934,9 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 	resource_size_t start, end;
 	int i;
 
+	if (secure_modules())
+		return -EPERM;
+
 	for (i = 0; i < PCI_ROM_RESOURCE; i++)
 		if (res == &pdev->resource[i])
 			break;
@@ -1037,6 +1044,9 @@ pci_write_resource_io(struct file *filp, struct kobject *kobj,
 		      struct bin_attribute *attr, char *buf,
 		      loff_t off, size_t count)
 {
+	if (secure_modules())
+		return -EPERM;
+
 	return pci_resource_io(filp, kobj, attr, buf, off, count, true);
 }
 
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index cdc7836..e3d498b 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -117,6 +117,9 @@ proc_bus_pci_write(struct file *file, const char __user *buf, size_t nbytes, lof
 	int size = dev->cfg_size;
 	int cnt;
 
+	if (secure_modules())
+		return -EPERM;
+
 	if (pos >= size)
 		return 0;
 	if (nbytes >= size)
@@ -196,6 +199,9 @@ static long proc_bus_pci_ioctl(struct file *file, unsigned int cmd,
 #endif /* HAVE_PCI_MMAP */
 	int ret = 0;
 
+	if (secure_modules())
+		return -EPERM;
+
 	switch (cmd) {
 	case PCIIOC_CONTROLLER:
 		ret = pci_domain_nr(dev->bus);
@@ -234,7 +240,7 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 	struct pci_filp_private *fpriv = file->private_data;
 	int i, ret;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (!capable(CAP_SYS_RAWIO) || secure_modules())
 		return -EPERM;
 
 	/* Make sure the caller is mapping a real resource for this device */
diff --git a/drivers/pci/syscall.c b/drivers/pci/syscall.c
index e1c1ec5..bffbf71 100644
--- a/drivers/pci/syscall.c
+++ b/drivers/pci/syscall.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/pci.h>
 #include <linux/syscalls.h>
+#include <linux/module.h>
 #include <asm/uaccess.h>
 #include "pci.h"
 
@@ -92,7 +93,7 @@ SYSCALL_DEFINE5(pciconfig_write, unsigned long, bus, unsigned long, dfn,
 	u32 dword;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_ADMIN) || secure_modules())
 		return -EPERM;
 
 	dev = pci_get_bus_and_slot(bus, dfn);
-- 
1.8.3.1

