Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3LQXoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 18:44:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3LQXoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 18:44:00 -0500
Subject: [PATCH v2 4/4] pci: Rename PCI_VC_PORT_REG1/2 to PCI_VC_PORT_CAP1/2
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: ddutile@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 17 Dec 2013 16:43:57 -0700
Message-ID: <20131217234357.2310.8530.stgit@bling.home>
In-Reply-To: <20131217233741.2310.78334.stgit@bling.home>
References: <20131217233741.2310.78334.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are set of two capability registers, it's pretty much given that
they're registers, so reflect their purpose in the name.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/vc.c                   |   28 ++++++++++++++--------------
 drivers/vfio/pci/vfio_pci_config.c |   12 ++++++------
 include/uapi/linux/pci_regs.h      |   18 +++++++++---------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/vc.c b/drivers/pci/vc.c
index c10567e4..7e1304d 100644
--- a/drivers/pci/vc.c
+++ b/drivers/pci/vc.c
@@ -104,7 +104,7 @@ static void pci_vc_load_port_arb_table(struct pci_dev *dev, int pos, int res)
 static void pci_vc_enable(struct pci_dev *dev, int pos, int res)
 {
 	int ctrl_pos, status_pos, id, pos2, evcc, i, ctrl_pos2, status_pos2;
-	u32 ctrl, header, reg1, ctrl2;
+	u32 ctrl, header, cap1, ctrl2;
 	struct pci_dev *link = NULL;
 
 	/* Enable VCs from the downstream device */
@@ -129,8 +129,8 @@ static void pci_vc_enable(struct pci_dev *dev, int pos, int res)
 	if (!pos2)
 		goto enable;
 
-	pci_read_config_dword(dev->bus->self, pos2 + PCI_VC_PORT_REG1, &reg1);
-	evcc = reg1 & PCI_VC_REG1_EVCC;
+	pci_read_config_dword(dev->bus->self, pos2 + PCI_VC_PORT_CAP1, &cap1);
+	evcc = cap1 & PCI_VC_CAP1_EVCC;
 
 	/* VC0 is hardwired enabled, so we can start with 1 */
 	for (i = 1; i < evcc + 1; i++) {
@@ -188,7 +188,7 @@ static int pci_vc_do_save_buffer(struct pci_dev *dev, int pos,
 				 struct pci_cap_saved_state *save_state,
 				 bool save)
 {
-	u32 reg1;
+	u32 cap1;
 	char evcc, lpevcc, parb_size;
 	int i, len = 0;
 	u8 *buf = save_state ? (u8 *)save_state->cap.data : NULL;
@@ -201,13 +201,13 @@ static int pci_vc_do_save_buffer(struct pci_dev *dev, int pos,
 		return -ENOMEM;
 	}
 
-	pci_read_config_dword(dev, pos + PCI_VC_PORT_REG1, &reg1);
+	pci_read_config_dword(dev, pos + PCI_VC_PORT_CAP1, &cap1);
 	/* Extended VC Count (not counting VC0) */
-	evcc = reg1 & PCI_VC_REG1_EVCC;
+	evcc = cap1 & PCI_VC_CAP1_EVCC;
 	/* Low Priority Extended VC Count (not counting VC0) */
-	lpevcc = (reg1 & PCI_VC_REG1_LPEVCC) >> 4;
+	lpevcc = (cap1 & PCI_VC_CAP1_LPEVCC) >> 4;
 	/* Port Arbitration Table Entry Size (bits) */
-	parb_size = 1 << ((reg1 & PCI_VC_REG1_ARB_SIZE) >> 10);
+	parb_size = 1 << ((cap1 & PCI_VC_CAP1_ARB_SIZE) >> 10);
 
 	/*
 	 * Port VC Control Register contains VC Arbitration Select, which
@@ -231,20 +231,20 @@ static int pci_vc_do_save_buffer(struct pci_dev *dev, int pos,
 	 * in Port VC Capability Register 2 then save/restore it next.
 	 */
 	if (lpevcc) {
-		u32 reg2;
+		u32 cap2;
 		int vcarb_offset;
 
-		pci_read_config_dword(dev, pos + PCI_VC_PORT_REG2, &reg2);
-		vcarb_offset = ((reg2 & PCI_VC_REG2_ARB_OFF) >> 24) * 16;
+		pci_read_config_dword(dev, pos + PCI_VC_PORT_CAP2, &cap2);
+		vcarb_offset = ((cap2 & PCI_VC_CAP2_ARB_OFF) >> 24) * 16;
 
 		if (vcarb_offset) {
 			int size, vcarb_phases = 0;
 
-			if (reg2 & PCI_VC_REG2_128_PHASE)
+			if (cap2 & PCI_VC_CAP2_128_PHASE)
 				vcarb_phases = 128;
-			else if (reg2 & PCI_VC_REG2_64_PHASE)
+			else if (cap2 & PCI_VC_CAP2_64_PHASE)
 				vcarb_phases = 64;
-			else if (reg2 & PCI_VC_REG2_32_PHASE)
+			else if (cap2 & PCI_VC_CAP2_32_PHASE)
 				vcarb_phases = 32;
 
 			/* Fixed 4 bits per phase per lpevcc (plus VC0) */
diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index ffd0632..83cd157 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -975,20 +975,20 @@ static int vfio_vc_cap_len(struct vfio_pci_device *vdev, u16 pos)
 	int ret, evcc, phases, vc_arb;
 	int len = PCI_CAP_VC_BASE_SIZEOF;
 
-	ret = pci_read_config_dword(pdev, pos + PCI_VC_PORT_REG1, &tmp);
+	ret = pci_read_config_dword(pdev, pos + PCI_VC_PORT_CAP1, &tmp);
 	if (ret)
 		return pcibios_err_to_errno(ret);
 
-	evcc = tmp & PCI_VC_REG1_EVCC; /* extended vc count */
-	ret = pci_read_config_dword(pdev, pos + PCI_VC_PORT_REG2, &tmp);
+	evcc = tmp & PCI_VC_CAP1_EVCC; /* extended vc count */
+	ret = pci_read_config_dword(pdev, pos + PCI_VC_PORT_CAP2, &tmp);
 	if (ret)
 		return pcibios_err_to_errno(ret);
 
-	if (tmp & PCI_VC_REG2_128_PHASE)
+	if (tmp & PCI_VC_CAP2_128_PHASE)
 		phases = 128;
-	else if (tmp & PCI_VC_REG2_64_PHASE)
+	else if (tmp & PCI_VC_CAP2_64_PHASE)
 		phases = 64;
-	else if (tmp & PCI_VC_REG2_32_PHASE)
+	else if (tmp & PCI_VC_CAP2_32_PHASE)
 		phases = 32;
 	else
 		phases = 0;
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 5eefacd..d0160cc 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -677,15 +677,15 @@
 #define PCI_ERR_ROOT_ERR_SRC	52	/* Error Source Identification */
 
 /* Virtual Channel */
-#define PCI_VC_PORT_REG1	4
-#define  PCI_VC_REG1_EVCC	0x00000007	/* extended VC count */
-#define  PCI_VC_REG1_LPEVCC	0x00000070	/* low prio extended VC count */
-#define  PCI_VC_REG1_ARB_SIZE	0x00000c00
-#define PCI_VC_PORT_REG2	8
-#define  PCI_VC_REG2_32_PHASE		0x00000002
-#define  PCI_VC_REG2_64_PHASE		0x00000004
-#define  PCI_VC_REG2_128_PHASE		0x00000008
-#define  PCI_VC_REG2_ARB_OFF		0xff000000
+#define PCI_VC_PORT_CAP1	4
+#define  PCI_VC_CAP1_EVCC	0x00000007	/* extended VC count */
+#define  PCI_VC_CAP1_LPEVCC	0x00000070	/* low prio extended VC count */
+#define  PCI_VC_CAP1_ARB_SIZE	0x00000c00
+#define PCI_VC_PORT_CAP2	8
+#define  PCI_VC_CAP2_32_PHASE		0x00000002
+#define  PCI_VC_CAP2_64_PHASE		0x00000004
+#define  PCI_VC_CAP2_128_PHASE		0x00000008
+#define  PCI_VC_CAP2_ARB_OFF		0xff000000
 #define PCI_VC_PORT_CTRL	12
 #define  PCI_VC_PORT_CTRL_LOAD_TABLE	0x00000001
 #define PCI_VC_PORT_STATUS	14

