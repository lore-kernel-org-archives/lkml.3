Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3CZTCC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:02:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab3CZTCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:02:00 -0400
Subject: [PATCH 1/2] vfio-pci: Use byte granularity in config map
To: alex.williamson@redhat.com, shangw@linux.vnet.ibm.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 26 Mar 2013 12:17:03 -0600
Message-ID: <20130326181703.27467.45144.stgit@bling.home>
In-Reply-To: <20130326180454.27467.7011.stgit@bling.home>
References: <20130326180454.27467.7011.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config map previously used a byte per dword to map regions of
config space to capabilities.  Modulo a bug where we round the length
of capabilities down instead of up, this theoretically works well and
saves space so long as devices don't try to hide registers in the gaps
between capabilities.  Unfortunately they do exactly that so we need
byte granularity on our config space map.  Increase the allocation of
the config map and split accesses at capability region boundaries.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |   88 +++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 41 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 964ff22..5d5fc75 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -800,9 +800,6 @@ static int vfio_find_cap_start(struct vfio_pci_device *vdev, int pos)
 	u8 cap;
 	int base = (pos >= PCI_CFG_SPACE_SIZE) ? PCI_CFG_SPACE_SIZE :
 						 PCI_STD_HEADER_SIZEOF;
-	base /= 4;
-	pos /= 4;
-
 	cap = vdev->pci_config_map[pos];
 
 	if (cap == PCI_CAP_ID_BASIC)
@@ -812,7 +809,7 @@ static int vfio_find_cap_start(struct vfio_pci_device *vdev, int pos)
 	while (pos - 1 >= base && vdev->pci_config_map[pos - 1] == cap)
 		pos--;
 
-	return pos * 4;
+	return pos;
 }
 
 static int vfio_msi_config_read(struct vfio_pci_device *vdev, int pos,
@@ -1229,8 +1226,8 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 		}
 
 		/* Sanity check, do we overlap other capabilities? */
-		for (i = 0; i < len; i += 4) {
-			if (likely(map[(pos + i) / 4] == PCI_CAP_ID_INVALID))
+		for (i = 0; i < len; i++) {
+			if (likely(map[pos + i] == PCI_CAP_ID_INVALID))
 				continue;
 
 			pr_warn("%s: %s pci config conflict @0x%x, was cap 0x%x now cap 0x%x\n",
@@ -1238,7 +1235,7 @@ static int vfio_cap_init(struct vfio_pci_device *vdev)
 				pos + i, map[pos + i], cap);
 		}
 
-		memset(map + (pos / 4), cap, len / 4);
+		memset(map + pos, cap, len);
 		ret = vfio_fill_vconfig_bytes(vdev, pos, len);
 		if (ret)
 			return ret;
@@ -1313,8 +1310,8 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 			hidden = true;
 		}
 
-		for (i = 0; i < len; i += 4) {
-			if (likely(map[(epos + i) / 4] == PCI_CAP_ID_INVALID))
+		for (i = 0; i < len; i++) {
+			if (likely(map[epos + i] == PCI_CAP_ID_INVALID))
 				continue;
 
 			pr_warn("%s: %s pci config conflict @0x%x, was ecap 0x%x now ecap 0x%x\n",
@@ -1329,7 +1326,7 @@ static int vfio_ecap_init(struct vfio_pci_device *vdev)
 		 */
 		BUILD_BUG_ON(PCI_EXT_CAP_ID_MAX >= PCI_CAP_ID_INVALID);
 
-		memset(map + (epos / 4), ecap, len / 4);
+		memset(map + epos, ecap, len);
 		ret = vfio_fill_vconfig_bytes(vdev, epos, len);
 		if (ret)
 			return ret;
@@ -1376,10 +1373,12 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	int ret;
 
 	/*
-	 * Config space, caps and ecaps are all dword aligned, so we can
-	 * use one byte per dword to record the type.
+	 * Config space, caps and ecaps are all dword aligned, so we could
+	 * use one byte per dword to record the type.  However, there are
+	 * no requiremenst on the length of a capability, so the gap between
+	 * capabilities needs byte granularity.
 	 */
-	map = kmalloc(pdev->cfg_size / 4, GFP_KERNEL);
+	map = kmalloc(pdev->cfg_size, GFP_KERNEL);
 	if (!map)
 		return -ENOMEM;
 
@@ -1392,9 +1391,9 @@ int vfio_config_init(struct vfio_pci_device *vdev)
 	vdev->pci_config_map = map;
 	vdev->vconfig = vconfig;
 
-	memset(map, PCI_CAP_ID_BASIC, PCI_STD_HEADER_SIZEOF / 4);
-	memset(map + (PCI_STD_HEADER_SIZEOF / 4), PCI_CAP_ID_INVALID,
-	       (pdev->cfg_size - PCI_STD_HEADER_SIZEOF) / 4);
+	memset(map, PCI_CAP_ID_BASIC, PCI_STD_HEADER_SIZEOF);
+	memset(map + PCI_STD_HEADER_SIZEOF, PCI_CAP_ID_INVALID,
+	       pdev->cfg_size - PCI_STD_HEADER_SIZEOF);
 
 	ret = vfio_fill_vconfig_bytes(vdev, 0, PCI_STD_HEADER_SIZEOF);
 	if (ret)
@@ -1449,6 +1448,22 @@ void vfio_config_free(struct vfio_pci_device *vdev)
 	vdev->msi_perm = NULL;
 }
 
+/*
+ * Find the remaining number of bytes in a dword that match the given
+ * position.  Stop at either the end of the capability or the dword boundary.
+ */
+static size_t vfio_pci_cap_remaining_dword(struct vfio_pci_device *vdev,
+					   loff_t pos)
+{
+	u8 cap = vdev->pci_config_map[pos];
+	size_t i;
+
+	for (i = 1; (pos + i) % 4 && vdev->pci_config_map[pos + i] == cap; i++)
+		/* nop */;
+
+	return i;
+}
+
 static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 				 size_t count, loff_t *ppos, bool iswrite)
 {
@@ -1457,19 +1472,27 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 	__le32 val = 0;
 	int cap_start = 0, offset;
 	u8 cap_id;
-	ssize_t ret = count;
+	ssize_t ret;
 
-	if (*ppos < 0 || *ppos + count > pdev->cfg_size)
+	if (*ppos < 0 || *ppos >= pdev->cfg_size ||
+	    *ppos + count > pdev->cfg_size)
 		return -EFAULT;
 
 	/*
-	 * gcc can't seem to figure out we're a static function, only called
-	 * with count of 1/2/4 and hits copy_from_user_overflow without this.
+	 * Chop accesses into aligned chunks containing no more than a
+	 * single capability.  Caller increments to the next chunk.
 	 */
-	if (count > sizeof(val))
-		return -EINVAL;
+	count = min(count, vfio_pci_cap_remaining_dword(vdev, *ppos));
+	if (count >= 4 && !(*ppos % 4))
+		count = 4;
+	else if (count >= 2 && !(*ppos % 2))
+		count = 2;
+	else
+		count = 1;
+
+	ret = count;
 
-	cap_id = vdev->pci_config_map[*ppos / 4];
+	cap_id = vdev->pci_config_map[*ppos];
 
 	if (cap_id == PCI_CAP_ID_INVALID) {
 		if (iswrite)
@@ -1485,11 +1508,6 @@ static ssize_t vfio_config_do_rw(struct vfio_pci_device *vdev, char __user *buf,
 		return ret;
 	}
 
-	/*
-	 * All capabilities are minimum 4 bytes and aligned on dword
-	 * boundaries.  Since we don't support unaligned accesses, we're
-	 * only ever accessing a single capability.
-	 */
 	if (*ppos >= PCI_CFG_SPACE_SIZE) {
 		WARN_ON(cap_id > PCI_EXT_CAP_ID_MAX);
 
@@ -1545,20 +1563,8 @@ ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev, char __user *buf,
 
 	pos &= VFIO_PCI_OFFSET_MASK;
 
-	/*
-	 * We want to both keep the access size the caller users as well as
-	 * support reading large chunks of config space in a single call.
-	 * PCI doesn't support unaligned accesses, so we can safely break
-	 * those apart.
-	 */
 	while (count) {
-		if (count >= 4 && !(pos % 4))
-			ret = vfio_config_do_rw(vdev, buf, 4, &pos, iswrite);
-		else if (count >= 2 && !(pos % 2))
-			ret = vfio_config_do_rw(vdev, buf, 2, &pos, iswrite);
-		else
-			ret = vfio_config_do_rw(vdev, buf, 1, &pos, iswrite);
-
+		ret = vfio_config_do_rw(vdev, buf, count, &pos, iswrite);
 		if (ret < 0)
 			return ret;
 

