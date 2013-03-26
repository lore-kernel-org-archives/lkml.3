Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995Ab3CZTZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab3CZTZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:25:11 -0400
Subject: [PATCH 2/2] vfio-pci: Enable raw access to unassigned config space
To: alex.williamson@redhat.com, shangw@linux.vnet.ibm.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 26 Mar 2013 12:17:10 -0600
Message-ID: <20130326181709.27467.1721.stgit@bling.home>
In-Reply-To: <20130326180454.27467.7011.stgit@bling.home>
References: <20130326180454.27467.7011.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices like be2net hide registers between the gaps in capabilities
and architected regions of PCI config space.  Our choices to support
such devices is to either build an ever growing and unmanageable white
list or rely on hardware isolation to protect us.  These registers are
really no different than MMIO or I/O port space registers, which we
don't attempt to regulate, so treat PCI config space in the same way.

Reported-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |   78 +++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 5d5fc75..072fdac 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -273,9 +273,10 @@ static int vfio_direct_config_read(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-static int vfio_direct_config_write(struct vfio_pci_device *vdev, int pos,
-				    int count, struct perm_bits *perm,
-				    int offset, __le32 val)
+/* Raw access skips any kind of virtualization */
+static int vfio_raw_config_write(struct vfio_pci_device *vdev, int pos,
+				 int count, struct perm_bits *perm,
+				 int offset, __le32 val)
 {
 	int ret;
 
@@ -286,13 +287,36 @@ static int vfio_direct_config_write(struct vfio_pci_device *vdev, int pos,
 	return count;
 }
 
-/* Default all regions to read-only, no-virtualization */
+static int vfio_raw_config_read(struct vfio_pci_device *vdev, int pos,
+				int count, struct perm_bits *perm,
+				int offset, __le32 *val)
+{
+	int ret;
+
+	ret = vfio_user_config_read(vdev->pdev, pos, val, count);
+	if (ret)
+		return pcibios_err_to_errno(ret);
+
+	return count;
+}
+
+/* Default capability regions to read-only, no-virtualization */
 static struct perm_bits cap_perms[PCI_CAP_ID_MAX + 1] = {
 	[0 ... PCI_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
 };
 static struct perm_bits ecap_perms[PCI_EXT_CAP_ID_MAX + 1] = {
 	[0 ... PCI_EXT_CAP_ID_MAX] = { .readfn = vfio_direct_config_read }
 };
+/*
+ * Default unassigned regions to raw read-write access.  Some devices
+ * require this to function as they hide registers between the gaps in
+ * config space (be2net).  Like MMIO and I/O port registers, we have
+ * to trust the hardware isolation.
+ */
+static struct perm_bits unassigned_perms = {
+	.readfn = vfio_raw_config_read,
+	.writefn = vfio_raw_config_write
+};
 
 static void free_perm_bits(struct perm_bits *perm)
 {
@@ -778,16 +802,16 @@ int __init vfio_pci_init_perm_bits(void)
 
 	/* Capabilities */
 	ret |= init_pci_cap_pm_perm(&cap_perms[PCI_CAP_ID_PM]);
-	cap_perms[PCI_CAP_ID_VPD].writefn = vfio_direct_config_write;
+	cap_perms[PCI_CAP_ID_VPD].writefn = vfio_raw_config_write;
 	ret |= init_pci_cap_pcix_perm(&cap_perms[PCI_CAP_ID_PCIX]);
-	cap_perms[PCI_CAP_ID_VNDR].writefn = vfio_direct_config_write;
+	cap_perms[PCI_CAP_ID_VNDR].writefn = vfio_raw_config_write;
 	ret |= init_pci_cap_exp_perm(&cap_perms[PCI_CAP_ID_EXP]);
 	ret |= init_pci_cap_af_perm(&cap_perms[PCI_CAP_ID_AF]);
 
 	/* Extended capabilities */
 	ret |= init_pci_ext_cap_err_perm(&ecap_perms[PCI_EXT_CAP_ID_ERR]);
 	ret |= init_pci_ext_cap_pwr_perm(&ecap_perms[PCI_EXT_CAP_ID_PWR]);
-	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_direct_config_write;
+	ecap_perms[PCI_EXT_CAP_ID_VNDR].writefn = vfio_raw_config_write;
 
 	if (ret)
 		vfio_pci_uninit_perm_bits();
@@ -1495,35 +1519,25 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 	cap_id = vdev->pci_config_map[*ppos];
 
 	if (cap_id == PCI_CAP_ID_INVALID) {
-		if (iswrite)
-			return ret; /* drop */
-
-		/*
-		 * Per PCI spec 3.0, section 6.1, reads from reserved and
-		 * unimplemented registers return 0
-		 */
-		if (copy_to_user(buf, &val, count))
-			return -EFAULT;
-
-		return ret;
-	}
-
-	if (*ppos >= PCI_CFG_SPACE_SIZE) {
-		WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
-
-		perm = &ecap_perms[cap_id];
-		cap_start = vfio_find_cap_start(vdev, *ppos);
-
+		perm = &unassigned_perms;
+		cap_start = *ppos;
 	} else {
-		WARN_ON(cap_id > PCI_CAP_ID_MAX);
+		if (*ppos >= PCI_CFG_SPACE_SIZE) {
+			WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
+
+			perm = &ecap_perms[cap_id];
+			cap_start = vfio_find_cap_start(vdev, *ppos);
+		} else {
+			WARN_ON(cap_id > PCI_CAP_ID_MAX);
 
-		perm = &cap_perms[cap_id];
+			perm = &cap_perms[cap_id];
 
-		if (cap_id == PCI_CAP_ID_MSI)
-			perm = vdev->msi_perm;
+			if (cap_id == PCI_CAP_ID_MSI)
+				perm = vdev->msi_perm;
 
-		if (cap_id > PCI_CAP_ID_BASIC)
-			cap_start = vfio_find_cap_start(vdev, *ppos);
+			if (cap_id > PCI_CAP_ID_BASIC)
+				cap_start = vfio_find_cap_start(vdev, *ppos);
+		}
 	}
 
 	WARN_ON(!cap_start && cap_id != PCI_CAP_ID_BASIC);

