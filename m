Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729Ab3HOWh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540Ab3HOWhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:37:55 -0400
Subject: [PATCH 1/2] vgaarb: Don't disable resources that are not owned
To: linux-kernel@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: airlied@redhat.com, intel-gfx@lists.freedesktop.org,
        ville.syrjala@linux.intel.com
Date: Thu, 15 Aug 2013 16:37:53 -0600
Message-ID: <20130815223752.27642.55038.stgit@bling.home>
In-Reply-To: <20130815222835.27642.15330.stgit@bling.home>
References: <20130815222835.27642.15330.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a device does not own a resource then we don't need to disable it.
This resolves the case where an Intel IGD device can be configured to
disable decode of VGA memory but we still need the arbiter to handle
VGA I/O port routing.  When the IGD device is in conflict, only
PCI_COMMAND_IO should be disabled since VGA memory does not require
arbitration on this device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/vga/vgaarb.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index e893f6e..ea56471 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -257,9 +257,9 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 		if (!conflict->bridge_has_one_vga) {
 			vga_irq_set_state(conflict, false);
 			flags |= PCI_VGA_STATE_CHANGE_DECODES;
-			if (lwants & (VGA_RSRC_LEGACY_MEM|VGA_RSRC_NORMAL_MEM))
+			if (match & (VGA_RSRC_LEGACY_MEM|VGA_RSRC_NORMAL_MEM))
 				pci_bits |= PCI_COMMAND_MEMORY;
-			if (lwants & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
+			if (match & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
 				pci_bits |= PCI_COMMAND_IO;
 		}
 
@@ -267,11 +267,11 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 			flags |= PCI_VGA_STATE_CHANGE_BRIDGE;
 
 		pci_set_vga_state(conflict->pdev, false, pci_bits, flags);
-		conflict->owns &= ~lwants;
+		conflict->owns &= ~match;
 		/* If he also owned non-legacy, that is no longer the case */
-		if (lwants & VGA_RSRC_LEGACY_MEM)
+		if (match & VGA_RSRC_LEGACY_MEM)
 			conflict->owns &= ~VGA_RSRC_NORMAL_MEM;
-		if (lwants & VGA_RSRC_LEGACY_IO)
+		if (match & VGA_RSRC_LEGACY_IO)
 			conflict->owns &= ~VGA_RSRC_NORMAL_IO;
 	}
 

