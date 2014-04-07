Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069AbaDGW3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:29:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028AbaDGW2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:28:50 -0400
Subject: [PATCH 1/3] vfio/pci: Fix sizing of DPA and THP express capabilities
From: Alex Williamson <alex.williamson@redhat.com>
To: alex.williamson@redhat.com
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Mon, 07 Apr 2014 16:28:49 -0600
Message-ID: <20140407222848.12761.73514.stgit@bling.home>
In-Reply-To: <20140407221857.12761.73684.stgit@bling.home>
References: <20140407221857.12761.73684.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sizing the TPH capability we store the register containing the
table size into the 'dword' variable, but then use the uninitialized
'byte' variable to analyze the size.  The table size is also actually
reported as an N-1 value, so correct sizing to account for this.

The round_up() for both TPH and DPA is unnecessary, remove it.

Detected by Coverity: CID 714665 & 715156

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 83cd157..e50790e 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -1126,8 +1126,7 @@ static int vfio_ext_cap_len(struct vfio_pci_device *vdev, u16 ecap, u16 epos)
 			return pcibios_err_to_errno(ret);
 
 		byte &= PCI_DPA_CAP_SUBSTATE_MASK;
-		byte = round_up(byte + 1, 4);
-		return PCI_DPA_BASE_SIZEOF + byte;
+		return PCI_DPA_BASE_SIZEOF + byte + 1;
 	case PCI_EXT_CAP_ID_TPH:
 		ret = pci_read_config_dword(pdev, epos + PCI_TPH_CAP, &dword);
 		if (ret)
@@ -1136,9 +1135,9 @@ static int vfio_ext_cap_len(struct vfio_pci_device *vdev, u16 ecap, u16 epos)
 		if ((dword & PCI_TPH_CAP_LOC_MASK) == PCI_TPH_LOC_CAP) {
 			int sts;
 
-			sts = byte & PCI_TPH_CAP_ST_MASK;
+			sts = dword & PCI_TPH_CAP_ST_MASK;
 			sts >>= PCI_TPH_CAP_ST_SHIFT;
-			return PCI_TPH_BASE_SIZEOF + round_up(sts * 2, 4);
+			return PCI_TPH_BASE_SIZEOF + (sts * 2) + 2;
 		}
 		return PCI_TPH_BASE_SIZEOF;
 	default:

