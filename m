Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272Ab3E1XUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:20:15 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:53662 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758468Ab3E1XUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:20:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RFC] PM / Runtime: Rework the "runtime idle" helper routine
Date: Wed, 29 May 2013 01:29:06 +0200
Message-ID: <1463685.qFyr66vqF2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The "runtime idle" helper routine, rpm_idle(), currently ignores
return values from .runtime_idle() callbacks executed by it.

However, it turns out that many subsystems use the generic idle
callback routine pm_generic_runtime_idle() which checks the return
value of the driver's callback and executes pm_runtime_suspend() for
the device unless that value is different from 0.  If that logic is
moved to rpm_idle() instead, pm_generic_runtime_idle() can be dropped
and its users will not need any .runtime_idle() callbacks any more.

Moreover, the PCI subsystem's .runtime_idle() routine,
pci_pm_runtime_idle(), works in analogy with the generic one and if
rpm_idle() calls rpm_suspend() after 0 has been returned by the
.runtime_idle() callback executed by it, that routine will not be
necessary any more and may be dropped.

To reduce overall code duplication make the changes described above.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

The patch doesn't break compilation for me, but it hasn't been tested
otherwise.  It applies on top of the linux-pm.git tree's linux-next branch.

Thanks,
Rafael

---
 Documentation/power/runtime_pm.txt |    5 -----
 arch/arm/mach-omap2/omap_device.c  |    7 +------
 drivers/acpi/device_pm.c           |    1 -
 drivers/amba/bus.c                 |    2 +-
 drivers/base/platform.c            |    1 -
 drivers/base/power/domain.c        |    1 -
 drivers/base/power/generic_ops.c   |   23 -----------------------
 drivers/base/power/runtime.c       |   12 +++++-------
 drivers/i2c/i2c-core.c             |    2 +-
 drivers/mmc/core/sdio_bus.c        |    2 +-
 drivers/pci/pci-driver.c           |   27 ---------------------------
 drivers/spi/spi.c                  |    2 +-
 drivers/usb/core/port.c            |    1 -
 include/linux/pm_runtime.h         |    2 --
 14 files changed, 10 insertions(+), 78 deletions(-)

Index: linux-pm/drivers/base/power/runtime.c
===================================================================
--- linux-pm.orig/drivers/base/power/runtime.c
+++ linux-pm/drivers/base/power/runtime.c
@@ -293,11 +293,8 @@ static int rpm_idle(struct device *dev,
 	/* Pending requests need to be canceled. */
 	dev->power.request = RPM_REQ_NONE;
 
-	if (dev->power.no_callbacks) {
-		/* Assume ->runtime_idle() callback would have suspended. */
-		retval = rpm_suspend(dev, rpmflags);
+	if (dev->power.no_callbacks)
 		goto out;
-	}
 
 	/* Carry out an asynchronous or a synchronous idle notification. */
 	if (rpmflags & RPM_ASYNC) {
@@ -306,7 +303,8 @@ static int rpm_idle(struct device *dev,
 			dev->power.request_pending = true;
 			queue_work(pm_wq, &dev->power.work);
 		}
-		goto out;
+		trace_rpm_return_int(dev, _THIS_IP_, 0);
+		return 0;
 	}
 
 	dev->power.idle_notification = true;
@@ -326,14 +324,14 @@ static int rpm_idle(struct device *dev,
 		callback = dev->driver->pm->runtime_idle;
 
 	if (callback)
-		__rpm_callback(callback, dev);
+		retval = __rpm_callback(callback, dev);
 
 	dev->power.idle_notification = false;
 	wake_up_all(&dev->power.wait_queue);
 
  out:
 	trace_rpm_return_int(dev, _THIS_IP_, retval);
-	return retval;
+	return retval ? retval : rpm_suspend(dev, rpmflags);
 }
 
 /**
Index: linux-pm/drivers/base/power/generic_ops.c
===================================================================
--- linux-pm.orig/drivers/base/power/generic_ops.c
+++ linux-pm/drivers/base/power/generic_ops.c
@@ -12,29 +12,6 @@
 
 #ifdef CONFIG_PM_RUNTIME
 /**
- * pm_generic_runtime_idle - Generic runtime idle callback for subsystems.
- * @dev: Device to handle.
- *
- * If PM operations are defined for the @dev's driver and they include
- * ->runtime_idle(), execute it and return its error code, if nonzero.
- * Otherwise, execute pm_runtime_suspend() for the device and return 0.
- */
-int pm_generic_runtime_idle(struct device *dev)
-{
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-
-	if (pm && pm->runtime_idle) {
-		int ret = pm->runtime_idle(dev);
-		if (ret)
-			return ret;
-	}
-
-	pm_runtime_suspend(dev);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(pm_generic_runtime_idle);
-
-/**
  * pm_generic_runtime_suspend - Generic runtime suspend callback for subsystems.
  * @dev: Device to suspend.
  *
Index: linux-pm/include/linux/pm_runtime.h
===================================================================
--- linux-pm.orig/include/linux/pm_runtime.h
+++ linux-pm/include/linux/pm_runtime.h
@@ -37,7 +37,6 @@ extern void pm_runtime_enable(struct dev
 extern void __pm_runtime_disable(struct device *dev, bool check_resume);
 extern void pm_runtime_allow(struct device *dev);
 extern void pm_runtime_forbid(struct device *dev);
-extern int pm_generic_runtime_idle(struct device *dev);
 extern int pm_generic_runtime_suspend(struct device *dev);
 extern int pm_generic_runtime_resume(struct device *dev);
 extern void pm_runtime_no_callbacks(struct device *dev);
@@ -143,7 +142,6 @@ static inline bool pm_runtime_active(str
 static inline bool pm_runtime_status_suspended(struct device *dev) { return false; }
 static inline bool pm_runtime_enabled(struct device *dev) { return false; }
 
-static inline int pm_generic_runtime_idle(struct device *dev) { return 0; }
 static inline int pm_generic_runtime_suspend(struct device *dev) { return 0; }
 static inline int pm_generic_runtime_resume(struct device *dev) { return 0; }
 static inline void pm_runtime_no_callbacks(struct device *dev) {}
Index: linux-pm/arch/arm/mach-omap2/omap_device.c
===================================================================
--- linux-pm.orig/arch/arm/mach-omap2/omap_device.c
+++ linux-pm/arch/arm/mach-omap2/omap_device.c
@@ -591,11 +591,6 @@ static int _od_runtime_suspend(struct de
 	return ret;
 }
 
-static int _od_runtime_idle(struct device *dev)
-{
-	return pm_generic_runtime_idle(dev);
-}
-
 static int _od_runtime_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -653,7 +648,7 @@ static int _od_resume_noirq(struct devic
 struct dev_pm_domain omap_device_pm_domain = {
 	.ops = {
 		SET_RUNTIME_PM_OPS(_od_runtime_suspend, _od_runtime_resume,
-				   _od_runtime_idle)
+				   NULL)
 		USE_PLATFORM_PM_SLEEP_OPS
 		.suspend_noirq = _od_suspend_noirq,
 		.resume_noirq = _od_resume_noirq,
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -886,7 +886,6 @@ static struct dev_pm_domain acpi_general
 #ifdef CONFIG_PM_RUNTIME
 		.runtime_suspend = acpi_subsys_runtime_suspend,
 		.runtime_resume = acpi_subsys_runtime_resume,
-		.runtime_idle = pm_generic_runtime_idle,
 #endif
 #ifdef CONFIG_PM_SLEEP
 		.prepare = acpi_subsys_prepare,
Index: linux-pm/drivers/amba/bus.c
===================================================================
--- linux-pm.orig/drivers/amba/bus.c
+++ linux-pm/drivers/amba/bus.c
@@ -284,7 +284,7 @@ static const struct dev_pm_ops amba_pm =
 	SET_RUNTIME_PM_OPS(
 		amba_pm_runtime_suspend,
 		amba_pm_runtime_resume,
-		pm_generic_runtime_idle
+		NULL
 	)
 };
 
Index: linux-pm/drivers/base/power/domain.c
===================================================================
--- linux-pm.orig/drivers/base/power/domain.c
+++ linux-pm/drivers/base/power/domain.c
@@ -2143,7 +2143,6 @@ void pm_genpd_init(struct generic_pm_dom
 	genpd->max_off_time_changed = true;
 	genpd->domain.ops.runtime_suspend = pm_genpd_runtime_suspend;
 	genpd->domain.ops.runtime_resume = pm_genpd_runtime_resume;
-	genpd->domain.ops.runtime_idle = pm_generic_runtime_idle;
 	genpd->domain.ops.prepare = pm_genpd_prepare;
 	genpd->domain.ops.suspend = pm_genpd_suspend;
 	genpd->domain.ops.suspend_late = pm_genpd_suspend_late;
Index: linux-pm/drivers/base/platform.c
===================================================================
--- linux-pm.orig/drivers/base/platform.c
+++ linux-pm/drivers/base/platform.c
@@ -888,7 +888,6 @@ int platform_pm_restore(struct device *d
 static const struct dev_pm_ops platform_dev_pm_ops = {
 	.runtime_suspend = pm_generic_runtime_suspend,
 	.runtime_resume = pm_generic_runtime_resume,
-	.runtime_idle = pm_generic_runtime_idle,
 	USE_PLATFORM_PM_SLEEP_OPS
 };
 
Index: linux-pm/drivers/i2c/i2c-core.c
===================================================================
--- linux-pm.orig/drivers/i2c/i2c-core.c
+++ linux-pm/drivers/i2c/i2c-core.c
@@ -435,7 +435,7 @@ static const struct dev_pm_ops i2c_devic
 	SET_RUNTIME_PM_OPS(
 		pm_generic_runtime_suspend,
 		pm_generic_runtime_resume,
-		pm_generic_runtime_idle
+		NULL
 	)
 };
 
Index: linux-pm/drivers/mmc/core/sdio_bus.c
===================================================================
--- linux-pm.orig/drivers/mmc/core/sdio_bus.c
+++ linux-pm/drivers/mmc/core/sdio_bus.c
@@ -211,7 +211,7 @@ static const struct dev_pm_ops sdio_bus_
 	SET_RUNTIME_PM_OPS(
 		pm_generic_runtime_suspend,
 		pm_generic_runtime_resume,
-		pm_generic_runtime_idle
+		NULL
 	)
 };
 
Index: linux-pm/drivers/spi/spi.c
===================================================================
--- linux-pm.orig/drivers/spi/spi.c
+++ linux-pm/drivers/spi/spi.c
@@ -223,7 +223,7 @@ static const struct dev_pm_ops spi_pm =
 	SET_RUNTIME_PM_OPS(
 		pm_generic_runtime_suspend,
 		pm_generic_runtime_resume,
-		pm_generic_runtime_idle
+		NULL
 	)
 };
 
Index: linux-pm/drivers/usb/core/port.c
===================================================================
--- linux-pm.orig/drivers/usb/core/port.c
+++ linux-pm/drivers/usb/core/port.c
@@ -141,7 +141,6 @@ static const struct dev_pm_ops usb_port_
 #ifdef CONFIG_PM_RUNTIME
 	.runtime_suspend =	usb_port_runtime_suspend,
 	.runtime_resume =	usb_port_runtime_resume,
-	.runtime_idle =		pm_generic_runtime_idle,
 #endif
 };
 
Index: linux-pm/Documentation/power/runtime_pm.txt
===================================================================
--- linux-pm.orig/Documentation/power/runtime_pm.txt
+++ linux-pm/Documentation/power/runtime_pm.txt
@@ -660,11 +660,6 @@ Subsystems may wish to conserve code spa
 management callbacks provided by the PM core, defined in
 driver/base/power/generic_ops.c:
 
-  int pm_generic_runtime_idle(struct device *dev);
-    - invoke the ->runtime_idle() callback provided by the driver of this
-      device, if defined, and call pm_runtime_suspend() for this device if the
-      return value is 0 or the callback is not defined
-
   int pm_generic_runtime_suspend(struct device *dev);
     - invoke the ->runtime_suspend() callback provided by the driver of this
       device and return its result, or return -EINVAL if not defined
Index: linux-pm/drivers/pci/pci-driver.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-driver.c
+++ linux-pm/drivers/pci/pci-driver.c
@@ -1046,32 +1046,6 @@ static int pci_pm_runtime_resume(struct
 	return rc;
 }
 
-static int pci_pm_runtime_idle(struct device *dev)
-{
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
-
-	/*
-	 * If pci_dev->driver is not set (unbound), the device should
-	 * always remain in D0 regardless of the runtime PM status
-	 */
-	if (!pci_dev->driver)
-		goto out;
-
-	if (!pm)
-		return -ENOSYS;
-
-	if (pm->runtime_idle) {
-		int ret = pm->runtime_idle(dev);
-		if (ret)
-			return ret;
-	}
-
-out:
-	pm_runtime_suspend(dev);
-	return 0;
-}
-
 #else /* !CONFIG_PM_RUNTIME */
 
 #define pci_pm_runtime_suspend	NULL
@@ -1099,7 +1073,6 @@ const struct dev_pm_ops pci_dev_pm_ops =
 	.restore_noirq = pci_pm_restore_noirq,
 	.runtime_suspend = pci_pm_runtime_suspend,
 	.runtime_resume = pci_pm_runtime_resume,
-	.runtime_idle = pci_pm_runtime_idle,
 };
 
 #define PCI_PM_OPS_PTR	(&pci_dev_pm_ops)

