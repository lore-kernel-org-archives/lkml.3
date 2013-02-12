Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab3BLVnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:43:50 -0500
Received: from mail-qc0-f201.google.com ([209.85.216.201]:58492 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3BLVnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:43:49 -0500
Date: Tue, 12 Feb 2013 14:43:45 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        David Airlie <airlied@linux.ie>
Subject: Re: linux-next: Tree for Feb 12 (drm_pci.c)
Message-ID: <20130212214345.GB27624@google.com>
References: <20130212160953.b80a57fec99e4bd9afb4b601@canb.auug.org.au>
 <511A6868.5010605@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511A6868.5010605@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 08:06:00AM -0800, Randy Dunlap wrote:
> On 02/11/13 21:09, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20130211:
> > 
> 
> 
> when CONFIG_PCI is not enabled (on x86_64):
> 
>   CC [M]  drivers/gpu/drm/drm_pci.o
> drivers/gpu/drm/drm_pci.c: In function 'drm_pcie_get_speed_cap_mask':
> drivers/gpu/drm/drm_pci.c:485:2: error: implicit declaration of function 'pcie_capability_read_dword' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[4]: *** [drivers/gpu/drm/drm_pci.o] Error 1

This one is my fault.  I sent the following patch to Dave to fix it up.


commit ed0708e69f71fab656afc1c891f3c54c9b105664
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Fri Feb 8 15:18:35 2013 -0700

    drm/pci: define drm_pcie_get_speed_cap_mask() only when CONFIG_PCI=y
    
    Move drm_pcie_get_speed_cap_mask() under #ifdef CONFIG_PCI because it
    it used only for PCI devices (evergreen, r600, r770), and it uses
    PCI interfaces that only exist when CONFIG_PCI=y.
    
    Previously, we tried to compile drm_pcie_get_speed_cap_mask() even when
    CONFIG_PCI=n, which fails.
    
    Tested-by: Fengguang Wu <fengguang.wu@intel.com>
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 754bc96..2b818c7 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -439,33 +439,6 @@ int drm_pci_init(struct drm_driver *driver, struct pci_driver *pdriver)
 	return 0;
 }
 
-#else
-
-int drm_pci_init(struct drm_driver *driver, struct pci_driver *pdriver)
-{
-	return -1;
-}
-
-#endif
-
-EXPORT_SYMBOL(drm_pci_init);
-
-/*@}*/
-void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver)
-{
-	struct drm_device *dev, *tmp;
-	DRM_DEBUG("\n");
-
-	if (driver->driver_features & DRIVER_MODESET) {
-		pci_unregister_driver(pdriver);
-	} else {
-		list_for_each_entry_safe(dev, tmp, &driver->device_list, driver_item)
-			drm_put_dev(dev);
-	}
-	DRM_INFO("Module unloaded\n");
-}
-EXPORT_SYMBOL(drm_pci_exit);
-
 int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
 {
 	struct pci_dev *root;
@@ -514,3 +487,30 @@ int drm_pcie_get_speed_cap_mask(struct drm_device *dev, u32 *mask)
 	return 0;
 }
 EXPORT_SYMBOL(drm_pcie_get_speed_cap_mask);
+
+#else
+
+int drm_pci_init(struct drm_driver *driver, struct pci_driver *pdriver)
+{
+	return -1;
+}
+
+#endif
+
+EXPORT_SYMBOL(drm_pci_init);
+
+/*@}*/
+void drm_pci_exit(struct drm_driver *driver, struct pci_driver *pdriver)
+{
+	struct drm_device *dev, *tmp;
+	DRM_DEBUG("\n");
+
+	if (driver->driver_features & DRIVER_MODESET) {
+		pci_unregister_driver(pdriver);
+	} else {
+		list_for_each_entry_safe(dev, tmp, &driver->device_list, driver_item)
+			drm_put_dev(dev);
+	}
+	DRM_INFO("Module unloaded\n");
+}
+EXPORT_SYMBOL(drm_pci_exit);
