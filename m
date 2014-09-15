Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbaIOWtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:49:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51043 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbaIOWRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 073/187] x86, ia64: Move EFI_FB vga_default_device() initialization to pci_vga_fixup()
Date: Mon, 15 Sep 2014 15:08:03 -0700
Message-Id: <1410818997-9432-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

commit 20cde694027e7477cc532833e38ab9fcaa83fb64 upstream.

Commit b4aa0163056b ("efifb: Implement vga_default_device() (v2)") added
efifb vga_default_device() so EFI systems that do not load shadow VBIOS or
setup VGA get proper value for boot_vga PCI sysfs attribute on the
corresponding PCI device.

Xorg doesn't detect devices when boot_vga=0, e.g., on some EFI systems such
as MacBookAir2,1.  Xorg detects the GPU and finds the DRI device but then
bails out with "no devices detected".

Note: When vga_default_device() is set boot_vga PCI sysfs attribute
reflects its state.  When unset this attribute is 1 whenever
IORESOURCE_ROM_SHADOW flag is set.

With introduction of sysfb/simplefb/simpledrm efifb is getting obsolete
while having native drivers for the GPU also makes selecting sysfb/efifb
optional.

Remove the efifb implementation of vga_default_device() and initialize
vgaarb's vga_default_device() with the PCI GPU that matches boot
screen_info in pci_fixup_video().

[bhelgaas: remove unused "dev" in efifb_setup()]
Fixes: b4aa0163056b ("efifb: Implement vga_default_device() (v2)")
Tested-by: Anibal Francisco Martinez Cortina <linuxkid.zeuz@gmail.com>
Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Matthew Garrett <matthew.garrett@nebula.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/ia64/pci/fixup.c      | 22 ++++++++++++++++++++++
 arch/x86/include/asm/vga.h |  6 ------
 arch/x86/pci/fixup.c       | 21 +++++++++++++++++++++
 drivers/video/efifb.c      | 39 ---------------------------------------
 4 files changed, 43 insertions(+), 45 deletions(-)

diff --git a/arch/ia64/pci/fixup.c b/arch/ia64/pci/fixup.c
index 5dc969d..62fb9ba 100644
--- a/arch/ia64/pci/fixup.c
+++ b/arch/ia64/pci/fixup.c
@@ -5,6 +5,7 @@
 
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/screen_info.h>
 
 #include <asm/machvec.h>
 
@@ -38,6 +39,27 @@ static void pci_fixup_video(struct pci_dev *pdev)
 	if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
 		return;
 
+	if (!vga_default_device()) {
+		resource_size_t start, end;
+		int i;
+
+		/* Does firmware framebuffer belong to us? */
+		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+				continue;
+
+			start = pci_resource_start(pdev, i);
+			end  = pci_resource_end(pdev, i);
+
+			if (!start || !end)
+				continue;
+
+			if (screen_info.lfb_base >= start &&
+			    (screen_info.lfb_base + screen_info.lfb_size) < end)
+				vga_set_default_device(pdev);
+		}
+	}
+
 	/* Is VGA routed to us? */
 	bus = pdev->bus;
 	while (bus) {
diff --git a/arch/x86/include/asm/vga.h b/arch/x86/include/asm/vga.h
index 44282fb..c4b9dc2 100644
--- a/arch/x86/include/asm/vga.h
+++ b/arch/x86/include/asm/vga.h
@@ -17,10 +17,4 @@
 #define vga_readb(x) (*(x))
 #define vga_writeb(x, y) (*(y) = (x))
 
-#ifdef CONFIG_FB_EFI
-#define __ARCH_HAS_VGA_DEFAULT_DEVICE
-extern struct pci_dev *vga_default_device(void);
-extern void vga_set_default_device(struct pci_dev *pdev);
-#endif
-
 #endif /* _ASM_X86_VGA_H */
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index b046e07..4ee44d4 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -325,6 +325,27 @@ static void pci_fixup_video(struct pci_dev *pdev)
 	struct pci_bus *bus;
 	u16 config;
 
+	if (!vga_default_device()) {
+		resource_size_t start, end;
+		int i;
+
+		/* Does firmware framebuffer belong to us? */
+		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
+			if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+				continue;
+
+			start = pci_resource_start(pdev, i);
+			end  = pci_resource_end(pdev, i);
+
+			if (!start || !end)
+				continue;
+
+			if (screen_info.lfb_base >= start &&
+			    (screen_info.lfb_base + screen_info.lfb_size) < end)
+				vga_set_default_device(pdev);
+		}
+	}
+
 	/* Is VGA routed to us? */
 	bus = pdev->bus;
 	while (bus) {
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index cd7c0df..201ab4f 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -19,8 +19,6 @@
 
 static bool request_mem_succeeded = false;
 
-static struct pci_dev *default_vga;
-
 static struct fb_var_screeninfo efifb_defined = {
 	.activate		= FB_ACTIVATE_NOW,
 	.height			= -1,
@@ -85,23 +83,10 @@ static struct fb_ops efifb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-struct pci_dev *vga_default_device(void)
-{
-	return default_vga;
-}
-
-EXPORT_SYMBOL_GPL(vga_default_device);
-
-void vga_set_default_device(struct pci_dev *pdev)
-{
-	default_vga = pdev;
-}
-
 static int efifb_setup(char *options)
 {
 	char *this_opt;
 	int i;
-	struct pci_dev *dev = NULL;
 
 	if (options && *options) {
 		while ((this_opt = strsep(&options, ",")) != NULL) {
@@ -127,30 +112,6 @@ static int efifb_setup(char *options)
 		}
 	}
 
-	for_each_pci_dev(dev) {
-		int i;
-
-		if ((dev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
-			continue;
-
-		for (i=0; i < DEVICE_COUNT_RESOURCE; i++) {
-			resource_size_t start, end;
-
-			if (!(pci_resource_flags(dev, i) & IORESOURCE_MEM))
-				continue;
-
-			start = pci_resource_start(dev, i);
-			end  = pci_resource_end(dev, i);
-
-			if (!start || !end)
-				continue;
-
-			if (screen_info.lfb_base >= start &&
-			    (screen_info.lfb_base + screen_info.lfb_size) < end)
-				default_vga = dev;
-		}
-	}
-
 	return 0;
 }
 
-- 
1.9.1

