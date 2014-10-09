Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932735AbaJIVcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:32:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59308 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757526AbaJIVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 099/163] vgaarb: Don't default exclusively to first video device with mem+io
Date: Thu,  9 Oct 2014 14:02:04 -0700
Message-Id: <1412888588-26755-100-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>

commit 86fd887b7fe350819dae5b55e7fef05b511c8656 upstream.

Commit 20cde694027e ("x86, ia64: Move EFI_FB vga_default_device()
initialization to pci_vga_fixup()") moved boot video device detection from
efifb to x86 and ia64 pci/fixup.c.

For dual-GPU Apple computers above change represents a regression as code
in efifb did forcefully override vga_default_device while the merge did not
(vgaarb happens prior to PCI fixup).

To improve on initial device selection by vgaarb (it cannot know if PCI
device not behind bridges see/decode legacy VGA I/O or not), move the
screen_info based check from pci_video_fixup() to vgaarb's init function and
use it to refine/override decision taken while adding the individual PCI
VGA devices.  This way PCI fixup has no reason to adjust vga_default_device
anymore but can depend on its value for flagging shadowed VBIOS.

This has the nice benefit of removing duplicated code but does introduce a
would cause compile to fail without it.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=84461
Reported-and-Tested-By: Andreas Noever <andreas.noever@gmail.com>
Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Matthew Garrett <matthew.garrett@nebula.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/ia64/pci/fixup.c    | 23 +----------------------
 arch/x86/pci/fixup.c     | 25 +------------------------
 drivers/gpu/vga/vgaarb.c | 38 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 39 insertions(+), 47 deletions(-)

diff --git a/arch/ia64/pci/fixup.c b/arch/ia64/pci/fixup.c
index 62fb9ba..25cf65f 100644
--- a/arch/ia64/pci/fixup.c
+++ b/arch/ia64/pci/fixup.c
@@ -39,27 +39,6 @@ static void pci_fixup_video(struct pci_dev *pdev)
 	if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
 		return;
 
-	if (!vga_default_device()) {
-		resource_size_t start, end;
-		int i;
-
-		/* Does firmware framebuffer belong to us? */
-		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
-				continue;
-
-			start = pci_resource_start(pdev, i);
-			end  = pci_resource_end(pdev, i);
-
-			if (!start || !end)
-				continue;
-
-			if (screen_info.lfb_base >= start &&
-			    (screen_info.lfb_base + screen_info.lfb_size) < end)
-				vga_set_default_device(pdev);
-		}
-	}
-
 	/* Is VGA routed to us? */
 	bus = pdev->bus;
 	while (bus) {
@@ -85,7 +64,7 @@ static void pci_fixup_video(struct pci_dev *pdev)
 	pci_read_config_word(pdev, PCI_COMMAND, &config);
 	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
-		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
+		dev_printk(KERN_DEBUG, &pdev->dev, "Video device with shadowed ROM\n");
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 4ee44d4..ed4de42 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -325,27 +325,6 @@ static void pci_fixup_video(struct pci_dev *pdev)
 	struct pci_bus *bus;
 	u16 config;
 
-	if (!vga_default_device()) {
-		resource_size_t start, end;
-		int i;
-
-		/* Does firmware framebuffer belong to us? */
-		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
-				continue;
-
-			start = pci_resource_start(pdev, i);
-			end  = pci_resource_end(pdev, i);
-
-			if (!start || !end)
-				continue;
-
-			if (screen_info.lfb_base >= start &&
-			    (screen_info.lfb_base + screen_info.lfb_size) < end)
-				vga_set_default_device(pdev);
-		}
-	}
-
 	/* Is VGA routed to us? */
 	bus = pdev->bus;
 	while (bus) {
@@ -371,9 +350,7 @@ static void pci_fixup_video(struct pci_dev *pdev)
 	pci_read_config_word(pdev, PCI_COMMAND, &config);
 	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
-		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
-		if (!vga_default_device())
-			vga_set_default_device(pdev);
+		dev_printk(KERN_DEBUG, &pdev->dev, "Video device with shadowed ROM\n");
 	}
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index af02597..366641d 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -41,6 +41,7 @@
 #include <linux/poll.h>
 #include <linux/miscdevice.h>
 #include <linux/slab.h>
+#include <linux/screen_info.h>
 
 #include <linux/uaccess.h>
 
@@ -580,8 +581,11 @@ static bool vga_arbiter_add_pci_device(struct pci_dev *pdev)
 	 */
 #ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
 	if (vga_default == NULL &&
-	    ((vgadev->owns & VGA_RSRC_LEGACY_MASK) == VGA_RSRC_LEGACY_MASK))
+	    ((vgadev->owns & VGA_RSRC_LEGACY_MASK) == VGA_RSRC_LEGACY_MASK)) {
+		pr_info("vgaarb: setting as boot device: PCI:%s\n",
+			pci_name(pdev));
 		vga_set_default_device(pdev);
+	}
 #endif
 
 	vga_arbiter_check_bridge_sharing(vgadev);
@@ -1316,6 +1320,38 @@ static int __init vga_arb_device_init(void)
 	pr_info("vgaarb: loaded\n");
 
 	list_for_each_entry(vgadev, &vga_list, list) {
+#if defined(CONFIG_X86) || defined(CONFIG_IA64)
+		/* Override I/O based detection done by vga_arbiter_add_pci_device()
+		 * as it may take the wrong device (e.g. on Apple system under EFI).
+		 *
+		 * Select the device owning the boot framebuffer if there is one.
+		 */
+		resource_size_t start, end;
+		int i;
+
+		/* Does firmware framebuffer belong to us? */
+		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+			if (!(pci_resource_flags(vgadev->pdev, i) & IORESOURCE_MEM))
+				continue;
+
+			start = pci_resource_start(vgadev->pdev, i);
+			end  = pci_resource_end(vgadev->pdev, i);
+
+			if (!start || !end)
+				continue;
+
+			if (screen_info.lfb_base < start ||
+			    (screen_info.lfb_base + screen_info.lfb_size) >= end)
+				continue;
+			if (!vga_default_device())
+				pr_info("vgaarb: setting as boot device: PCI:%s\n",
+					pci_name(vgadev->pdev));
+			else if (vgadev->pdev != vga_default_device())
+				pr_info("vgaarb: overriding boot device: PCI:%s\n",
+					pci_name(vgadev->pdev));
+			vga_set_default_device(vgadev->pdev);
+		}
+#endif
 		if (vgadev->bridge_has_one_vga)
 			pr_info("vgaarb: bridge control possible %s\n", pci_name(vgadev->pdev));
 		else
-- 
1.9.1

