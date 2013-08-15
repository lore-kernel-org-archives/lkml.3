Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab3HOWiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab3HOWiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:38:01 -0400
Subject: [PATCH 2/2] vgaarb: Fix VGA decodes changes
To: linux-kernel@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: airlied@redhat.com, intel-gfx@lists.freedesktop.org,
        ville.syrjala@linux.intel.com
Date: Thu, 15 Aug 2013 16:37:59 -0600
Message-ID: <20130815223759.27642.50609.stgit@bling.home>
In-Reply-To: <20130815222835.27642.15330.stgit@bling.home>
References: <20130815222835.27642.15330.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When VGA decodes change we need to do a bit more evaluation of exactly what
has changed.  We don't necessarily give up all the old owns resources and
we need to account for resources with locks.  The new algorithm is: If
something is added, update decodes.  If legacy resources were added and
none were there before, we have a new participant.  If something is
removed, update decodes.  If we previously owned it, we no longer own it.
If it was previously locked, invalidate all locks and release it.  If
legacy resources were removed and none are left, remove the participant
from VGA arbitration.

Previously we updated decodes, released ownership of everything that was
previously decoded, ignored all locks, and went off looking for another
device to transfer VGA to.  In a test case where Intel IGD removes only
legacy VGA memory decoding, this left the arbiter switching to discrete
graphics without actually disabling legacy VGA IO from the IGD.  As a
bonus, we bumped up the count of VGA arbitration participants for no
good reason.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/vga/vgaarb.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index ea56471..4ee444c 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -644,10 +644,13 @@ bail:
 static inline void vga_update_device_decodes(struct vga_device *vgadev,
 					     int new_decodes)
 {
-	int old_decodes;
+	int old_decodes, decodes_removed, decodes_unlocked;
 	struct vga_device *new_vgadev, *conflict;
 
 	old_decodes = vgadev->decodes;
+	decodes_removed = ~new_decodes & old_decodes;
+	decodes_unlocked = vgadev->locks & decodes_removed;
+	vgadev->owns &= ~decodes_removed;
 	vgadev->decodes = new_decodes;
 
 	pr_info("vgaarb: device changed decodes: PCI:%s,olddecodes=%s,decodes=%s:owns=%s\n",
@@ -656,31 +659,22 @@ static inline void vga_update_device_decodes(struct vga_device *vgadev,
 		vga_iostate_to_str(vgadev->decodes),
 		vga_iostate_to_str(vgadev->owns));
 
-
-	/* if we own the decodes we should move them along to
-	   another card */
-	if ((vgadev->owns & old_decodes) && (vga_count > 1)) {
-		/* set us to own nothing */
-		vgadev->owns &= ~old_decodes;
-		list_for_each_entry(new_vgadev, &vga_list, list) {
-			if ((new_vgadev != vgadev) &&
-			    (new_vgadev->decodes & VGA_RSRC_LEGACY_MASK)) {
-				pr_info("vgaarb: transferring owner from PCI:%s to PCI:%s\n", pci_name(vgadev->pdev), pci_name(new_vgadev->pdev));
-				conflict = __vga_tryget(new_vgadev, VGA_RSRC_LEGACY_MASK);
-				if (!conflict)
-					__vga_put(new_vgadev, VGA_RSRC_LEGACY_MASK);
-				break;
-			}
-		}
+	/* if we removed locked decodes, lock count goes to zero, and release */
+	if (decodes_unlocked) {
+		if (decodes_unlocked & VGA_RSRC_LEGACY_IO)
+			vgadev->io_lock_cnt = 0;
+		if (decodes_unlocked & VGA_RSRC_LEGACY_MEM)
+			vgadev->mem_lock_cnt = 0;
+		__vga_put(vgadev, decodes_unlocked);
 	}
 
 	/* change decodes counter */
-	if (old_decodes != new_decodes) {
-		if (new_decodes & (VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM))
-			vga_decode_count++;
-		else
-			vga_decode_count--;
-	}
+	if (old_decodes & VGA_RSRC_LEGACY_MASK &&
+	    !(new_decodes & VGA_RSRC_LEGACY_MASK))
+		vga_decode_count--;
+	if (!(old_decodes & VGA_RSRC_LEGACY_MASK) &&
+	    new_decodes & VGA_RSRC_LEGACY_MASK)
+		vga_decode_count++;
 	pr_debug("vgaarb: decoding count now is: %d\n", vga_decode_count);
 }
 

