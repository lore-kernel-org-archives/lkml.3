Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3JKG1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:27:31 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:47630 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab3JKG12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:27:28 -0400
From: Kim Phillips <kim.phillips@linaro.org>
To: Bhushan Bharat <R65777@freescale.com>, Wood Scott <B07421@freescale.com>,
        Yoder Stuart <B08248@freescale.com>, christoffer.dall@linaro.org,
        alex.williamson@redhat.com, linux-kernel@vger.kernel.org,
        a.motakis@virtualopensystems.com, agraf@suse.de,
        Sethi Varun <B16395@freescale.com>, peter.maydell@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: [PATCH 1/4] driver core: Add new device_driver flag to allow binding via sysfs only
Date: Fri, 11 Oct 2013 01:27:17 -0500
Message-Id: <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381418830.7979.405.camel@snotra.buserror.net>
References: <1381418830.7979.405.camel@snotra.buserror.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO supports pass-through of devices to user space - for sake
of illustration, say a PCI e1000 device:

- the e1000 is first unbound from the PCI e1000 driver via sysfs
- the vfio-pci driver is told via new_id that it now handles e1000 devices
- the e1000 is explicitly bound to vfio-pci through sysfs

However, now we have two drivers in the system that both handle e1000
devices.  A hotplug event could then occur and it is ambiguous as to which
driver will claim the device.  The desired semantics is that vfio-pci is
only bound to devices by explicit request in sysfs.  This patch makes this
possible by introducing a sysfs_bind_only flag in struct device_driver.

Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
---
this patchset is available on top of the WIP exynos-iommu v10 [1] and
vfio-platform v2 [2] patchsets, here:

git://git.linaro.org/people/kimphill/linux.git binding-dev

[1] http://www.spinics.net/lists/linux-samsung-soc/msg23301.html
[2] http://www.spinics.net/lists/kvm/msg96701.html

 drivers/base/dd.c      | 5 ++++-
 include/linux/device.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 35fa368..6f85279 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -389,7 +389,7 @@ static int __device_attach(struct device_driver *drv, void *data)
 {
 	struct device *dev = data;
 
-	if (!driver_match_device(drv, dev))
+	if (drv->sysfs_bind_only || !driver_match_device(drv, dev))
 		return 0;
 
 	return driver_probe_device(drv, dev);
@@ -476,6 +476,9 @@ static int __driver_attach(struct device *dev, void *data)
  */
 int driver_attach(struct device_driver *drv)
 {
+	if (drv->sysfs_bind_only)
+		return 0;
+
 	return bus_for_each_dev(drv->bus, NULL, drv, __driver_attach);
 }
 EXPORT_SYMBOL_GPL(driver_attach);
diff --git a/include/linux/device.h b/include/linux/device.h
index 2a9d6ed..e63c3fe 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -203,6 +203,7 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
  * @owner:	The module owner.
  * @mod_name:	Used for built-in modules.
  * @suppress_bind_attrs: Disables bind/unbind via sysfs.
+ * @sysfs_bind_only: Only allow bind/unbind via sysfs.
  * @of_match_table: The open firmware table.
  * @acpi_match_table: The ACPI match table.
  * @probe:	Called to query the existence of a specific device,
@@ -236,6 +237,7 @@ struct device_driver {
 	const char		*mod_name;	/* used for built-in modules */
 
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	bool sysfs_bind_only;		/* only allow bind/unbind via sysfs */
 
 	const struct of_device_id	*of_match_table;
 	const struct acpi_device_id	*acpi_match_table;
-- 
1.8.4

