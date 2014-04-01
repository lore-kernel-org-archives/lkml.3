Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaDAXwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:52:18 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:47671 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaDAXwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:52:15 -0400
Date: Tue, 1 Apr 2014 18:52:12 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: alex.williamson@redhat.com
Cc: gregkh@linuxfoundation.org, stuart.yoder@freescale.com,
        kvm@vger.kernel.org, jan.kiszka@siemens.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, mhocko@suse.cz, bhelgaas@google.com,
        Varun.Sethi@freescale.com, kvmarm@lists.cs.columbia.edu,
        rafael.j.wysocki@intel.com, agraf@suse.de, linux-pci@vger.kernel.org,
        linux@roeck-us.net, konrad.wilk@oracle.com, d.kasatkin@samsung.com,
        tj@kernel.org, scottwood@freescale.com,
        a.motakis@virtualopensystems.com, tech@virtualopensystems.com,
        Bharat.Bhushan@freescale.com, toshi.kani@hp.com,
        a.rigo@virtualopensystems.com, iommu@lists.linux-foundation.org,
        joe@perches.com, christoffer.dall@linaro.org,
        kim.phillips@freescale.com
Subject: Re: [RFC PATCH] PCI: Introduce new device binding path using
 pci_dev.driver_override
Message-Id: <20140401185212.7229f2c114c7e95089f00e90@linaro.org>
In-Reply-To: <20140401161851.18815.31108.stgit@bling.home>
References: <20140401161851.18815.31108.stgit@bling.home>
X-Mailer: Sylpheed 3.4.0beta5 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Apr 2014 10:28:54 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> The driver_override field allows us to specify the driver for a device
> rather than relying on the driver to provide a positive match of the
> device.  This shortcuts the existing process of looking up the vendor
> and device ID, adding them to the driver new_id, binding the device,
> then removing the ID, but it also provides a couple advantages.
> 
> First, the above process allows the driver to bind to any device
> matching the new_id for the window where it's enabled.  This is often
> not desired, such as the case of trying to bind a single device to a
> meta driver like pci-stub or vfio-pci.  Using driver_override we can
> do this deterministically using:
> 
> echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> 
> Previously we could not invoke drivers_probe after adding a device
> to new_id for a driver as we get non-deterministic behavior whether
> the driver we intend or the standard driver will claim the device.
> Now it becomes a deterministic process, only the driver matching
> driver_override will probe the device.
> 
> To return the device to the standard driver, we simply clear the
> driver_override and reprobe the device, ex:
> 
> echo > /sys/bus/pci/devices/0000:03:00.0/preferred_driver
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> 
> Another advantage to this approach is that we can specify a driver
> override to force a specific binding or prevent any binding.  For
> instance when an IOMMU group is exposed to userspace through VFIO
> we require that all devices within that group are owned by VFIO.
> However, devices can be hot-added into an IOMMU group, in which case
> we want to prevent the device from binding to any driver (preferred
> driver = "none") or perhaps have it automatically bind to vfio-pci.
> With driver_override it's a simple matter for this field to be set
> internally when the device is first discovered to prevent driver
> matches.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> Apologies for the exceptionally long cc list, this is a follow-up to
> Stuart's "Subject: mechanism to allow a driver to bind to any device"
> thread.  This is effectively a v2 of the proof-of-concept patch I
> posted in that thread.  This version changes to use a dummy id struct
> to return on an "override" match, which removes the collateral damage
> and greatly simplifies the patch.  This feels fairly well baked for
> PCI and I would expect that platform drivers could do a similar
> implementation.  From there perhaps we can discuss whether there's
> any advantage to placing driver_override on struct device.  The logic
> for incorporating it into the match still needs to happen per bus
> driver, so it might only contribute to consistency of the show/store
> sysfs attributes to move it up to struct device.  Please comment.

Sounds like Greg likes this approach more than {drv,dev}_sysfs_only.

The diff below is the result of duplicating and converting this patch
for platform devices, and, indeed, binding a device to the
vfio-platform driver succeeds with:

echo vfio-platform > /sys/bus/platform/devices/fff51000.ethernet/driver_override
echo fff51000.ethernet > /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
echo fff51000.ethernet > /sys/bus/platform/drivers_probe

However, it's almost pure duplication modulo the bus match code.  The
only other place I can see where to put the common bus check is
drivers/base/base.h:driver_match_device(), which I'm guessing is
off-limits?  So should we leave this as per-bus code, and somehow
refactor driver_override_{show,store}?

Kim

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index bc78848..621c5bd2 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -22,6 +22,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/idr.h>
 #include <linux/acpi.h>
+#include <linux/limits.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -693,8 +694,49 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 }
 static DEVICE_ATTR_RO(modalias);
 
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	char *driver_override, *old = pdev->driver_override;
+
+	if (count > PATH_MAX)
+		return -EINVAL;
+
+	driver_override = kstrndup(buf, count, GFP_KERNEL);
+	if (!driver_override)
+		return -ENOMEM;
+
+	while (strlen(driver_override) &&
+	       driver_override[strlen(driver_override) - 1] == '\n')
+		driver_override[strlen(driver_override) - 1] = '\0';
+
+	if (strlen(driver_override)) {
+		pdev->driver_override = driver_override;
+	} else {
+		kfree(driver_override);
+		pdev->driver_override = NULL;
+	}
+
+	kfree(old);
+
+	return count;
+}
+
+static ssize_t driver_override_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	return sprintf(buf, "%s\n", pdev->driver_override);
+}
+static DEVICE_ATTR_RW(driver_override);
+
+
 static struct attribute *platform_dev_attrs[] = {
 	&dev_attr_modalias.attr,
+	&dev_attr_driver_override.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(platform_dev);
@@ -750,6 +792,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct platform_driver *pdrv = to_platform_driver(drv);
 
+	/* When driver_override is set, only bind to the matching driver */
+	if (pdev->driver_override)
+		return !strcmp(pdev->driver_override, drv->name);
+
 	/* Attempt an OF style match first */
 	if (of_driver_match_device(dev, drv))
 		return 1;
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 16f6654..7ffe809 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -28,6 +28,7 @@ struct platform_device {
 	struct resource	*resource;
 
 	const struct platform_device_id	*id_entry;
+	char *driver_override; /* Driver name to force a match */
 
 	/* MFD cell pointer */
 	struct mfd_cell *mfd_cell;

