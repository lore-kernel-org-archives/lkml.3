Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3BOVqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 16:46:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab3BOVq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 16:46:29 -0500
Subject: [PATCH v2] vfio-pci: Manage user power state transitions
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Fri, 15 Feb 2013 14:46:28 -0700
Message-ID: <20130215214510.7117.97846.stgit@bling.home>
In-Reply-To: <20130215191228.27383.1844.stgit@bling.home>
References: <20130215191228.27383.1844.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We give the user access to change the power state of the device but
certain transitions result in an uninitialized state which the user
cannot resolve.  To fix this we need to mark the PowerState field of
the PMCSR register read-only and effect the requested change on behalf
of the user.  This has the added benefit that pdev->current_state
remains accurate while controlled by the user.

The primary example of this bug is a QEMU guest doing a reboot where
the device it put into D3 on shutdown and becomes unusable on the next
boot because the device did a soft reset on D3->D0 (NoSoftRst-).

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

v2: sparse found a type error when calling pci_set_power_state.  Fixed here

 drivers/vfio/pci/vfio_pci_config.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index f1dde2c..1fd1895 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -587,12 +587,30 @@ static int __init init_pci_cap_basic_perm(struct perm_bits *perm)
 	return 0;
 }
 
+static int vfio_pm_config_write(struct vfio_pci_device *vdev, int pos,
+				int count, struct perm_bits *perm,
+				int offset, __le32 val)
+{
+	count = vfio_default_config_write(vdev, pos, count, perm, offset, val);
+	if (count < 0)
+		return count;
+
+	if (offset == PCI_PM_CTRL) {
+		pci_power_t state = le32_to_cpu(val) & PCI_PM_CTRL_STATE_MASK;
+		pci_set_power_state(vdev->pdev, state);
+	}
+
+	return count;
+}
+
 /* Permissions for the Power Management capability */
 static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 {
 	if (alloc_perm_bits(perm, pci_cap_length[PCI_CAP_ID_PM]))
 		return -ENOMEM;
 
+	perm->writefn = vfio_pm_config_write;
+
 	/*
 	 * We always virtualize the next field so we can remove
 	 * capabilities from the chain if we want to.
@@ -600,10 +618,11 @@ static int __init init_pci_cap_pm_perm(struct perm_bits *perm)
 	p_setb(perm, PCI_CAP_LIST_NEXT, (u8)ALL_VIRT, NO_WRITE);
 
 	/*
-	 * Power management is defined *per function*,
-	 * so we let the user write this
+	 * Power management is defined *per function*, so we can let
+	 * the user change power state, but we trap and initiate the
+	 * change ourselves, so the state bits are read-only.
 	 */
-	p_setd(perm, PCI_PM_CTRL, NO_VIRT, ALL_WRITE);
+	p_setd(perm, PCI_PM_CTRL, NO_VIRT, ~PCI_PM_CTRL_STATE_MASK);
 	return 0;
 }
 

