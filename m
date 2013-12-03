Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3LCMew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:34:52 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:58687 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab3LCMet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:34:49 -0500
Date: Tue, 3 Dec 2013 12:34:46 +0000
From: Kim Phillips <kim.phillips@linaro.org>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kvm@vger.kernel.org, scottwood@freescale.com, R65777@freescale.com,
        B07421@freescale.com, B08248@freescale.com,
        christoffer.dall@linaro.org, alex.williamson@redhat.com,
        a.motakis@virtualopensystems.com, agraf@suse.de, B16395@freescale.com
Subject: [REPOST][PATCH 1/2] driver core: Add new device_driver flag to
 allow binding via sysfs only
Message-Id: <20131203123446.42fbff34a8ebd7afd38159a5@linaro.org>
X-Mailer: Sylpheed 3.4.0beta5 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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
rebased onto 3.13-rc2, and reposted from first submission which
recieved no comments:

https://lkml.org/lkml/2013/10/11/53

 drivers/base/dd.c      | 5 ++++-
 include/linux/device.h | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 0605176..b83b16d 100644
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
index 952b010..ed441d1 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -200,6 +200,7 @@ extern struct klist *bus_get_device_klist(struct bus_type *bus);
  * @owner:	The module owner.
  * @mod_name:	Used for built-in modules.
  * @suppress_bind_attrs: Disables bind/unbind via sysfs.
+ * @sysfs_bind_only: Only allow bind/unbind via sysfs.
  * @of_match_table: The open firmware table.
  * @acpi_match_table: The ACPI match table.
  * @probe:	Called to query the existence of a specific device,
@@ -233,6 +234,7 @@ struct device_driver {
 	const char		*mod_name;	/* used for built-in modules */
 
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	bool sysfs_bind_only;		/* only allow bind/unbind via sysfs */
 
 	const struct of_device_id	*of_match_table;
 	const struct acpi_device_id	*acpi_match_table;
-- 
1.8.5

