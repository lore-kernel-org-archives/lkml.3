Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaDIBwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:52:31 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:52849
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147AbaDIBw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:52:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz13e6Kzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h17326ah8275bh1de097h186068hz2dh2a8h839h944hd24he5bhf0ah1220h1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
Date: Tue, 8 Apr 2014 20:47:26 -0500
From: Kim Phillips <kim.phillips@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>, <gregkh@linuxfoundation.org>
CC: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <konrad.wilk@oracle.com>, <stuart.yoder@freescale.com>,
        <libvir-list@redhat.com>, <iommu@lists.linux-foundation.org>,
        <tech@virtualopensystems.com>, <kvmarm@lists.cs.columbia.edu>,
        <linux-kernel@vger.kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        <christoffer.dall@linaro.org>
Subject: [PATCH] driver core: platform: add device binding path
 'driver_override'
Message-ID: <20140408204726.7a8f4cd6fbd05d0464720b30@freescale.com>
In-Reply-To: <20140404201818.14389.86188.stgit@bling.home>
References: <20140404201818.14389.86188.stgit@bling.home>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by platform device drivers, such as the vfio-platform driver [1],
in order to bypass the existing OF, ACPI, id_table and name string matches,
and successfully be able to be bound to any device, like so:

echo vfio-platform > /sys/bus/platform/devices/fff51000.ethernet/driver_override
echo fff51000.ethernet > /sys/bus/platform/devices/fff51000.ethernet/driver/unbind
echo fff51000.ethernet > /sys/bus/platform/drivers_probe

This mimics "PCI: Introduce new device binding path using
pci_dev.driver_override" [2], which is an interface enhancement
for more deterministic PCI device binding, e.g., when in the
presence of hotplug.

[1] http://lkml.iu.edu/hypermail/linux/kernel/1402.1/00177.html
[2] http://lists-archives.com/linux-kernel/28030441-pci-introduce-new-device-binding-path-using-pci_dev-driver_override.html

Suggested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
changes since RFC:
- fixed message Subject to properly reflect a new platform device
patch (instead of leaving it as a reply to the PCI version)
- addressed Guenter Roeck's comment
- updated [2] with link to later (Apr.4th) revision of the PCI patch
- updated documentation to address Christoffer Dall's comments to
  previous version of [2]
- added a Suggested-by, and re-posted as a reply to the PCI patch,
  should they be applied together

 Documentation/ABI/testing/sysfs-bus-platform | 20 ++++++++++++
 drivers/base/platform.c                      | 46 ++++++++++++++++++++++++++++
 include/linux/platform_device.h              |  1 +
 3 files changed, 67 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-platform

diff --git a/Documentation/ABI/testing/sysfs-bus-platform b/Documentation/ABI/testing/sysfs-bus-platform
new file mode 100644
index 0000000..5172a61
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-bus-platform
@@ -0,0 +1,20 @@
+What:		/sys/bus/platform/devices/.../driver_override
+Date:		April 2014
+Contact:	Kim Phillips <kim.phillips@freescale.com>
+Description:
+		This file allows the driver for a device to be specified which
+		will override standard OF, ACPI, ID table, and name matching.
+		When specified, only a driver with a name matching the value
+		written to driver_override will have an opportunity to bind
+		to the device.  The override is specified by writing a string
+		to the driver_override file (echo vfio-platform > \
+		driver_override) and may be cleared with an empty string
+		(echo > driver_override).  This returns the device to standard
+		matching rules binding.  Writing to driver_override does not
+		automatically unbind the device from its current driver or make
+		any attempt to automatically load the specified driver.  If no
+		driver with a matching name is currently loaded in the kernel,
+		the device will not bind to any driver.  This also allows
+		devices to opt-out of driver binding using a driver_override
+		name such as "none".  Only a single driver may be specified in
+		the override, there is no support for parsing delimiters.
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index e714709..a0909cb 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -22,6 +22,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/idr.h>
 #include <linux/acpi.h>
+#include <linux/limits.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -690,8 +691,49 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *a,
 }
 static DEVICE_ATTR_RO(modalias);
 
+static ssize_t driver_override_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	char *driver_override, *old = pdev->driver_override, *cp;
+
+	if (count > PATH_MAX)
+		return -EINVAL;
+
+	driver_override = kstrndup(buf, count, GFP_KERNEL);
+	if (!driver_override)
+		return -ENOMEM;
+
+	cp = strchr(driver_override, '\n');
+	if (cp)
+		*cp = '\0';
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
@@ -747,6 +789,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
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
index 16f6654..153d303 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -28,6 +28,7 @@ struct platform_device {
 	struct resource	*resource;
 
 	const struct platform_device_id	*id_entry;
+	char *driver_override; /* Driver name to force a match */
 
 	/* MFD cell pointer */
 	struct mfd_cell *mfd_cell;
-- 
1.9.1

