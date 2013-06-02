Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab3FBVqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 17:46:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56967 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab3FBVpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 17:45:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/2, v2] PM / Runtime: Rework the "runtime idle" helper routine
Date: Sun, 02 Jun 2013 23:52:31 +0200
Message-ID: <29156715.ksdUTA6va9@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2033252.LiVeuYIhnT@vostro.rjw.lan>
References: <Pine.LNX.4.44L0.1305301247370.1137-100000@iolanthe.rowland.org> <2033252.LiVeuYIhnT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The "runtime idle" helper routine, rpm_idle(), currently ignores
return values from .runtime_idle() callbacks executed by it.
However, it turns out that many subsystems use
pm_generic_runtime_idle() which checks the return value of the
driver's callback and executes pm_runtime_suspend() for the device
unless that value is not 0.  If that logic is moved to rpm_idle()
instead, pm_generic_runtime_idle() can be dropped and its users
will not need any .runtime_idle() callbacks any more.

Moreover, the PCI, SCSI, and SATA subsystems' .runtime_idle()
routines, pci_pm_runtime_idle(), scsi_runtime_idle(), and
ata_port_runtime_idle(), respectively, as well as a few drivers'
ones may be simplified if rpm_idle() calls rpm_suspend() after 0 has
been returned by the .runtime_idle() callback executed by it.

To reduce overall code bloat, make the changes described above.

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Kevin Hilman <khilman@linaro.org>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 Documentation/power/runtime_pm.txt |    5 -----
 arch/arm/mach-omap2/omap_device.c  |    7 +------
 drivers/acpi/device_pm.c           |    1 -
 drivers/amba/bus.c                 |    2 +-
 drivers/ata/libata-core.c          |    2 +-
 drivers/base/platform.c            |    1 -
 drivers/base/power/domain.c        |    1 -
 drivers/base/power/generic_ops.c   |   23 -----------------------
 drivers/base/power/runtime.c       |   12 +++++-------
 drivers/dma/intel_mid_dma.c        |    2 +-
 drivers/gpio/gpio-langwell.c       |    6 +-----
 drivers/i2c/i2c-core.c             |    2 +-
 drivers/mfd/ab8500-gpadc.c         |    8 +-------
 drivers/mmc/core/bus.c             |    2 +-
 drivers/mmc/core/sdio_bus.c        |    2 +-
 drivers/pci/pci-driver.c           |   14 +++++---------
 drivers/scsi/scsi_pm.c             |   11 +++--------
 drivers/sh/pm_runtime.c            |    2 +-
 drivers/spi/spi.c                  |    2 +-
 drivers/tty/serial/mfd.c           |    9 ++-------
 drivers/usb/core/driver.c          |    3 ++-
 drivers/usb/core/port.c            |    1 -
 include/linux/pm_runtime.h         |    2 --
 23 files changed, 28 insertions(+), 92 deletions(-)

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
Index: linux-pm/drivers/usb/core/driver.c
===================================================================
--- linux-pm.orig/drivers/usb/core/driver.c
+++ linux-pm/drivers/usb/core/driver.c
@@ -1765,7 +1765,8 @@ int usb_runtime_idle(struct device *dev)
 	 */
 	if (autosuspend_check(udev) == 0)
 		pm_runtime_autosuspend(dev);
-	return 0;
+	/* Tell the core not to suspend it, though. */
+	return -EBUSY;
 }
 
 int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable)
Index: linux-pm/drivers/pci/pci-driver.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-driver.c
+++ linux-pm/drivers/pci/pci-driver.c
@@ -1050,26 +1050,22 @@ static int pci_pm_runtime_idle(struct de
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+	int ret = 0;
 
 	/*
 	 * If pci_dev->driver is not set (unbound), the device should
 	 * always remain in D0 regardless of the runtime PM status
 	 */
 	if (!pci_dev->driver)
-		goto out;
+		return 0;
 
 	if (!pm)
 		return -ENOSYS;
 
-	if (pm->runtime_idle) {
-		int ret = pm->runtime_idle(dev);
-		if (ret)
-			return ret;
-	}
+	if (pm->runtime_idle)
+		ret = pm->runtime_idle(dev);
 
-out:
-	pm_runtime_suspend(dev);
-	return 0;
+	return ret;
 }
 
 #else /* !CONFIG_PM_RUNTIME */
Index: linux-pm/drivers/ata/libata-core.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-core.c
+++ linux-pm/drivers/ata/libata-core.c
@@ -5430,7 +5430,7 @@ static int ata_port_runtime_idle(struct
 				return -EBUSY;
 	}
 
-	return pm_runtime_suspend(dev);
+	return 0;
 }
 
 static int ata_port_runtime_suspend(struct device *dev)
Index: linux-pm/drivers/dma/intel_mid_dma.c
===================================================================
--- linux-pm.orig/drivers/dma/intel_mid_dma.c
+++ linux-pm/drivers/dma/intel_mid_dma.c
@@ -1405,7 +1405,7 @@ static int dma_runtime_idle(struct devic
 			return -EAGAIN;
 	}
 
-	return pm_schedule_suspend(dev, 0);
+	return 0;
 }
 
 /******************************************************************************
Index: linux-pm/drivers/gpio/gpio-langwell.c
===================================================================
--- linux-pm.orig/drivers/gpio/gpio-langwell.c
+++ linux-pm/drivers/gpio/gpio-langwell.c
@@ -305,11 +305,7 @@ static const struct irq_domain_ops lnw_g
 
 static int lnw_gpio_runtime_idle(struct device *dev)
 {
-	int err = pm_schedule_suspend(dev, 500);
-
-	if (!err)
-		return 0;
-
+	pm_schedule_suspend(dev, 500);
 	return -EBUSY;
 }
 
Index: linux-pm/drivers/mfd/ab8500-gpadc.c
===================================================================
--- linux-pm.orig/drivers/mfd/ab8500-gpadc.c
+++ linux-pm/drivers/mfd/ab8500-gpadc.c
@@ -886,12 +886,6 @@ static int ab8500_gpadc_runtime_resume(s
 	return ret;
 }
 
-static int ab8500_gpadc_runtime_idle(struct device *dev)
-{
-	pm_runtime_suspend(dev);
-	return 0;
-}
-
 static int ab8500_gpadc_suspend(struct device *dev)
 {
 	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
@@ -1039,7 +1033,7 @@ static int ab8500_gpadc_remove(struct pl
 static const struct dev_pm_ops ab8500_gpadc_pm_ops = {
 	SET_RUNTIME_PM_OPS(ab8500_gpadc_runtime_suspend,
 			   ab8500_gpadc_runtime_resume,
-			   ab8500_gpadc_runtime_idle)
+			   NULL)
 	SET_SYSTEM_SLEEP_PM_OPS(ab8500_gpadc_suspend,
 				ab8500_gpadc_resume)
 
Index: linux-pm/drivers/mmc/core/bus.c
===================================================================
--- linux-pm.orig/drivers/mmc/core/bus.c
+++ linux-pm/drivers/mmc/core/bus.c
@@ -164,7 +164,7 @@ static int mmc_runtime_resume(struct dev
 
 static int mmc_runtime_idle(struct device *dev)
 {
-	return pm_runtime_suspend(dev);
+	return 0;
 }
 
 #endif /* !CONFIG_PM_RUNTIME */
Index: linux-pm/drivers/scsi/scsi_pm.c
===================================================================
--- linux-pm.orig/drivers/scsi/scsi_pm.c
+++ linux-pm/drivers/scsi/scsi_pm.c
@@ -229,8 +229,6 @@ static int scsi_runtime_resume(struct de
 
 static int scsi_runtime_idle(struct device *dev)
 {
-	int err;
-
 	dev_dbg(dev, "scsi_runtime_idle\n");
 
 	/* Insert hooks here for targets, hosts, and transport classes */
@@ -240,14 +238,11 @@ static int scsi_runtime_idle(struct devi
 
 		if (sdev->request_queue->dev) {
 			pm_runtime_mark_last_busy(dev);
-			err = pm_runtime_autosuspend(dev);
-		} else {
-			err = pm_runtime_suspend(dev);
+			pm_runtime_autosuspend(dev);
+			return -EBUSY;
 		}
-	} else {
-		err = pm_runtime_suspend(dev);
 	}
-	return err;
+	return 0;
 }
 
 int scsi_autopm_get_device(struct scsi_device *sdev)
Index: linux-pm/drivers/sh/pm_runtime.c
===================================================================
--- linux-pm.orig/drivers/sh/pm_runtime.c
+++ linux-pm/drivers/sh/pm_runtime.c
@@ -25,7 +25,7 @@
 static int default_platform_runtime_idle(struct device *dev)
 {
 	/* suspend synchronously to disable clocks immediately */
-	return pm_runtime_suspend(dev);
+	return 0;
 }
 
 static struct dev_pm_domain default_pm_domain = {
Index: linux-pm/drivers/tty/serial/mfd.c
===================================================================
--- linux-pm.orig/drivers/tty/serial/mfd.c
+++ linux-pm/drivers/tty/serial/mfd.c
@@ -1248,13 +1248,8 @@ static int serial_hsu_resume(struct pci_
 #ifdef CONFIG_PM_RUNTIME
 static int serial_hsu_runtime_idle(struct device *dev)
 {
-	int err;
-
-	err = pm_schedule_suspend(dev, 500);
-	if (err)
-		return -EBUSY;
-
-	return 0;
+	pm_schedule_suspend(dev, 500);
+	return -EBUSY;
 }
 
 static int serial_hsu_runtime_suspend(struct device *dev)

