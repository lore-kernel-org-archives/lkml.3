Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbaGCP77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:59:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbaGCP76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:59:58 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [RE-RESEND PATCH] vgaarb: We can own non-decoded resources
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Ville =?utf-8?b?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Date: Thu, 03 Jul 2014 09:59:51 -0600
Message-ID: <20140703155914.8524.94699.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VGA arbiter does not allow devices to "own" resources that it
doesn't "decode".  However, it does allow devices to "lock" resources
that it doesn't decode.  This gets us into trouble because locking
the resource goes through the same bridge routing updates regardless
of whether we decode the resource.  This means that when a non-decoded
resource is released, the bridge is left with VGA routing enabled and
locking a different device won't clear it.

This happens in the following scenario:

VGA device 01:00.0 (VGA1) is owned by the radeon driver, which
registers a set_vga_decode function which releases legacy VGA decodes.

VGA device 02:00.0 (VGA2) is any VGA device.

VGA1 user locks VGA resources triggering first_use callback of
set_vga_decoded, clearing "decode" and "owns" of legacy resources
on VGA1.

VGA1 user unlocks VGA resources.

VGA2 user locks VGA resources, which skips VGA1 as conflicting as it
does not "own" legacy resources, although VGA routing is still enabled
for the VGA1 bridge.  VGA routing is enabled on VGA2 bridge.

VGA2 may or may not receive VGA transactions depending on the bus
priority of VGA1 vs VGA2 bridge.

To resolve this, we need to allow devices to "own" resources that they
do not "decode".  This way we can track bus ownership of VGA.  When a
device decodes VGA, it only means that we must update the command bits
in cases where the conflicting device is on the same bus.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@redhat.com>
---

Can someone please claim ownership of vgaarb?

 drivers/gpu/vga/vgaarb.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index af02597..d2077f0 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -237,12 +237,10 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 		if (conflict->locks & lwants)
 			return conflict;
 
-		/* Ok, now check if he owns the resource we want. We don't need
-		 * to check "decodes" since it should be impossible to own
-		 * own legacy resources you don't decode unless I have a bug
-		 * in this code...
+		/* Ok, now check if it owns the resource we want.  We can
+		 * lock resources that are not decoded, therefore a device
+		 * can own resources it doesn't decode.
 		 */
-		WARN_ON(conflict->owns & ~conflict->decodes);
 		match = lwants & conflict->owns;
 		if (!match)
 			continue;
@@ -254,13 +252,19 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 		flags = 0;
 		pci_bits = 0;
 
+		/* If we can't control legacy resources via the bridge, we
+		 * also need to disable normal decoding.
+		 */
 		if (!conflict->bridge_has_one_vga) {
-			vga_irq_set_state(conflict, false);
-			flags |= PCI_VGA_STATE_CHANGE_DECODES;
-			if (match & (VGA_RSRC_LEGACY_MEM|VGA_RSRC_NORMAL_MEM))
+			if ((match & conflict->decodes) & VGA_RSRC_LEGACY_MEM)
 				pci_bits |= PCI_COMMAND_MEMORY;
-			if (match & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
+			if ((match & conflict->decodes) & VGA_RSRC_LEGACY_IO)
 				pci_bits |= PCI_COMMAND_IO;
+
+			if (pci_bits) {
+				vga_irq_set_state(conflict, false);
+				flags |= PCI_VGA_STATE_CHANGE_DECODES;
+			}
 		}
 
 		if (change_bridge)
@@ -268,18 +272,19 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 
 		pci_set_vga_state(conflict->pdev, false, pci_bits, flags);
 		conflict->owns &= ~match;
-		/* If he also owned non-legacy, that is no longer the case */
-		if (match & VGA_RSRC_LEGACY_MEM)
+
+		/* If we disabled normal decoding, reflect it in owns */
+		if (pci_bits & PCI_COMMAND_MEMORY)
 			conflict->owns &= ~VGA_RSRC_NORMAL_MEM;
-		if (match & VGA_RSRC_LEGACY_IO)
+		if (pci_bits & PCI_COMMAND_IO)
 			conflict->owns &= ~VGA_RSRC_NORMAL_IO;
 	}
 
 enable_them:
 	/* ok dude, we got it, everybody conflicting has been disabled, let's
-	 * enable us. Make sure we don't mark a bit in "owns" that we don't
-	 * also have in "decodes". We can lock resources we don't decode but
-	 * not own them.
+	 * enable us.  Mark any bits in "owns" regardless of whether we
+	 * decoded them.  We can lock resources we don't decode, therefore
+	 * we must track them via "owns".
 	 */
 	flags = 0;
 	pci_bits = 0;
@@ -291,7 +296,7 @@ enable_them:
 		if (wants & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
 			pci_bits |= PCI_COMMAND_IO;
 	}
-	if (!!(wants & VGA_RSRC_LEGACY_MASK))
+	if (wants & VGA_RSRC_LEGACY_MASK)
 		flags |= PCI_VGA_STATE_CHANGE_BRIDGE;
 
 	pci_set_vga_state(vgadev->pdev, true, pci_bits, flags);
@@ -299,7 +304,7 @@ enable_them:
 	if (!vgadev->bridge_has_one_vga) {
 		vga_irq_set_state(vgadev, true);
 	}
-	vgadev->owns |= (wants & vgadev->decodes);
+	vgadev->owns |= wants;
 lock_them:
 	vgadev->locks |= (rsrc & VGA_RSRC_LEGACY_MASK);
 	if (rsrc & VGA_RSRC_LEGACY_IO)
@@ -649,7 +654,6 @@ static inline void vga_update_device_decodes(struct vga_device *vgadev,
 	old_decodes = vgadev->decodes;
 	decodes_removed = ~new_decodes & old_decodes;
 	decodes_unlocked = vgadev->locks & decodes_removed;
-	vgadev->owns &= ~decodes_removed;
 	vgadev->decodes = new_decodes;
 
 	pr_info("vgaarb: device changed decodes: PCI:%s,olddecodes=%s,decodes=%s:owns=%s\n",

