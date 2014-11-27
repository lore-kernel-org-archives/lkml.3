Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172AbaK0WYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:24:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57572 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750801AbaK0WX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:23:58 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        USB development list <linux-usb@vger.kernel.org>
Subject: [PATCH] USB / PM: Drop CONFIG_PM_RUNTIME from the USB core
Date: Thu, 27 Nov 2014 23:45:15 +0100
Message-ID: <1736553.sGOphfkJmV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
selected) PM_RUNTIME is always set if PM is set, so quite a few
#ifdef blocks depending on CONFIG_PM_RUNTIME may now be changed to
depend on CONFIG_PM (or even dropped in some cases).

Replace CONFIG_PM_RUNTIME with CONFIG_PM in the USB core code.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/usb/core/driver.c     |    6 +-----
 drivers/usb/core/hcd-pci.c    |   11 -----------
 drivers/usb/core/hcd.c        |   10 +++-------
 drivers/usb/core/hub.c        |    6 +++---
 drivers/usb/core/port.c       |    4 ++--
 drivers/usb/core/sysfs.c      |   13 ++++---------
 drivers/usb/core/usb.c        |    4 +---
 drivers/usb/core/usb.h        |   23 +++++++++--------------
 drivers/usb/host/ehci-pci.c   |    2 +-
 drivers/usb/host/sl811-hcd.c  |    5 ++---
 drivers/usb/host/u132-hcd.c   |    3 +--
 drivers/usb/host/xhci-hub.c   |    2 +-
 drivers/usb/host/xhci.c       |   29 ++++++++++++-----------------
 drivers/usb/phy/phy-msm-usb.c |    2 +-
 14 files changed, 41 insertions(+), 79 deletions(-)

Index: linux-pm/drivers/usb/core/sysfs.c
===================================================================
--- linux-pm.orig/drivers/usb/core/sysfs.c
+++ linux-pm/drivers/usb/core/sysfs.c
@@ -334,14 +334,6 @@ static void remove_persist_attributes(st
 			&dev_attr_persist.attr,
 			power_group_name);
 }
-#else
-
-#define add_persist_attributes(dev)	0
-#define remove_persist_attributes(dev)	do {} while (0)
-
-#endif	/* CONFIG_PM */
-
-#ifdef	CONFIG_PM_RUNTIME
 
 static ssize_t connected_duration_show(struct device *dev,
 				       struct device_attribute *attr, char *buf)
@@ -585,10 +577,13 @@ static void remove_power_attributes(stru
 
 #else
 
+#define add_persist_attributes(dev)	0
+#define remove_persist_attributes(dev)	do {} while (0)
+
 #define add_power_attributes(dev)	0
 #define remove_power_attributes(dev)	do {} while (0)
 
-#endif	/* CONFIG_PM_RUNTIME */
+#endif	/* CONFIG_PM */
 
 
 /* Descriptor fields */
Index: linux-pm/drivers/usb/core/driver.c
===================================================================
--- linux-pm.orig/drivers/usb/core/driver.c
+++ linux-pm/drivers/usb/core/driver.c
@@ -1493,10 +1493,6 @@ int usb_resume(struct device *dev, pm_me
 	return status;
 }
 
-#endif /* CONFIG_PM */
-
-#ifdef CONFIG_PM_RUNTIME
-
 /**
  * usb_enable_autosuspend - allow a USB device to be autosuspended
  * @udev: the USB device which may be autosuspended
@@ -1876,7 +1872,7 @@ int usb_set_usb2_hardware_lpm(struct usb
 	return ret;
 }
 
-#endif /* CONFIG_PM_RUNTIME */
+#endif /* CONFIG_PM */
 
 struct bus_type usb_bus_type = {
 	.name =		"usb",
Index: linux-pm/drivers/usb/core/hcd-pci.c
===================================================================
--- linux-pm.orig/drivers/usb/core/hcd-pci.c
+++ linux-pm/drivers/usb/core/hcd-pci.c
@@ -429,7 +429,6 @@ static int check_root_hub_suspended(stru
 	return 0;
 }
 
-#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
 static int suspend_common(struct device *dev, bool do_wakeup)
 {
 	struct pci_dev		*pci_dev = to_pci_dev(dev);
@@ -528,7 +527,6 @@ static int resume_common(struct device *
 	}
 	return retval;
 }
-#endif	/* SLEEP || RUNTIME */
 
 #ifdef	CONFIG_PM_SLEEP
 
@@ -607,8 +605,6 @@ static int hcd_pci_restore(struct device
 
 #endif	/* CONFIG_PM_SLEEP */
 
-#ifdef	CONFIG_PM_RUNTIME
-
 static int hcd_pci_runtime_suspend(struct device *dev)
 {
 	int	retval;
@@ -630,13 +626,6 @@ static int hcd_pci_runtime_resume(struct
 	return retval;
 }
 
-#else
-
-#define hcd_pci_runtime_suspend	NULL
-#define hcd_pci_runtime_resume	NULL
-
-#endif	/* CONFIG_PM_RUNTIME */
-
 const struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.suspend	= hcd_pci_suspend,
 	.suspend_noirq	= hcd_pci_suspend_noirq,
Index: linux-pm/drivers/usb/core/port.c
===================================================================
--- linux-pm.orig/drivers/usb/core/port.c
+++ linux-pm/drivers/usb/core/port.c
@@ -72,7 +72,7 @@ static void usb_port_device_release(stru
 	kfree(port_dev);
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int usb_port_runtime_resume(struct device *dev)
 {
 	struct usb_port *port_dev = to_usb_port(dev);
@@ -171,7 +171,7 @@ static int usb_port_runtime_suspend(stru
 #endif
 
 static const struct dev_pm_ops usb_port_pm_ops = {
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	.runtime_suspend =	usb_port_runtime_suspend,
 	.runtime_resume =	usb_port_runtime_resume,
 #endif
Index: linux-pm/drivers/usb/core/usb.c
===================================================================
--- linux-pm.orig/drivers/usb/core/usb.c
+++ linux-pm/drivers/usb/core/usb.c
@@ -49,7 +49,7 @@ const char *usbcore_name = "usbcore";
 
 static bool nousb;	/* Disable USB when built into kernel image */
 
-#ifdef	CONFIG_PM_RUNTIME
+#ifdef	CONFIG_PM
 static int usb_autosuspend_delay = 2;		/* Default delay value,
 						 * in seconds */
 module_param_named(autosuspend, usb_autosuspend_delay, int, 0644);
@@ -348,11 +348,9 @@ static const struct dev_pm_ops usb_devic
 	.thaw =		usb_dev_thaw,
 	.poweroff =	usb_dev_poweroff,
 	.restore =	usb_dev_restore,
-#ifdef CONFIG_PM_RUNTIME
 	.runtime_suspend =	usb_runtime_suspend,
 	.runtime_resume =	usb_runtime_resume,
 	.runtime_idle =		usb_runtime_idle,
-#endif
 };
 
 #endif	/* CONFIG_PM */
Index: linux-pm/drivers/usb/core/usb.h
===================================================================
--- linux-pm.orig/drivers/usb/core/usb.h
+++ linux-pm/drivers/usb/core/usb.h
@@ -75,6 +75,14 @@ extern int usb_resume_complete(struct de
 extern int usb_port_suspend(struct usb_device *dev, pm_message_t msg);
 extern int usb_port_resume(struct usb_device *dev, pm_message_t msg);
 
+extern void usb_autosuspend_device(struct usb_device *udev);
+extern int usb_autoresume_device(struct usb_device *udev);
+extern int usb_remote_wakeup(struct usb_device *dev);
+extern int usb_runtime_suspend(struct device *dev);
+extern int usb_runtime_resume(struct device *dev);
+extern int usb_runtime_idle(struct device *dev);
+extern int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable);
+
 #else
 
 static inline int usb_port_suspend(struct usb_device *udev, pm_message_t msg)
@@ -87,20 +95,6 @@ static inline int usb_port_resume(struct
 	return 0;
 }
 
-#endif
-
-#ifdef CONFIG_PM_RUNTIME
-
-extern void usb_autosuspend_device(struct usb_device *udev);
-extern int usb_autoresume_device(struct usb_device *udev);
-extern int usb_remote_wakeup(struct usb_device *dev);
-extern int usb_runtime_suspend(struct device *dev);
-extern int usb_runtime_resume(struct device *dev);
-extern int usb_runtime_idle(struct device *dev);
-extern int usb_set_usb2_hardware_lpm(struct usb_device *udev, int enable);
-
-#else
-
 #define usb_autosuspend_device(udev)		do {} while (0)
 static inline int usb_autoresume_device(struct usb_device *udev)
 {
@@ -111,6 +105,7 @@ static inline int usb_set_usb2_hardware_
 {
 	return 0;
 }
+
 #endif
 
 extern struct bus_type usb_bus_type;
Index: linux-pm/drivers/usb/core/hcd.c
===================================================================
--- linux-pm.orig/drivers/usb/core/hcd.c
+++ linux-pm/drivers/usb/core/hcd.c
@@ -2258,10 +2258,6 @@ int hcd_bus_resume(struct usb_device *rh
 	return status;
 }
 
-#endif	/* CONFIG_PM */
-
-#ifdef	CONFIG_PM_RUNTIME
-
 /* Workqueue routine for root-hub remote wakeup */
 static void hcd_resume_work(struct work_struct *work)
 {
@@ -2293,7 +2289,7 @@ void usb_hcd_resume_root_hub (struct usb
 }
 EXPORT_SYMBOL_GPL(usb_hcd_resume_root_hub);
 
-#endif	/* CONFIG_PM_RUNTIME */
+#endif	/* CONFIG_PM */
 
 /*-------------------------------------------------------------------------*/
 
@@ -2476,7 +2472,7 @@ struct usb_hcd *usb_create_shared_hcd(co
 	init_timer(&hcd->rh_timer);
 	hcd->rh_timer.function = rh_timer_func;
 	hcd->rh_timer.data = (unsigned long) hcd;
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	INIT_WORK(&hcd->wakeup_work, hcd_resume_work);
 #endif
 
@@ -2790,7 +2786,7 @@ error_create_attr_group:
 	hcd->rh_registered = 0;
 	spin_unlock_irq(&hcd_root_hub_lock);
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	cancel_work_sync(&hcd->wakeup_work);
 #endif
 	mutex_lock(&usb_bus_list_lock);
Index: linux-pm/drivers/usb/core/hub.c
===================================================================
--- linux-pm.orig/drivers/usb/core/hub.c
+++ linux-pm/drivers/usb/core/hub.c
@@ -1737,7 +1737,7 @@ static int hub_probe(struct usb_interfac
 	 * - If user has indicated to prevent autosuspend by passing
 	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
 	 */
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 	if (hdev->dev.power.autosuspend_delay >= 0)
 		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
 #endif
@@ -3449,7 +3449,7 @@ int usb_port_resume(struct usb_device *u
 	return status;
 }
 
-#ifdef	CONFIG_PM_RUNTIME
+#ifdef	CONFIG_PM
 
 int usb_remote_wakeup(struct usb_device *udev)
 {
@@ -4856,7 +4856,7 @@ static void hub_port_connect_change(stru
 			udev->state != USB_STATE_NOTATTACHED) {
 		if (portstatus & USB_PORT_STAT_ENABLE) {
 			status = 0;		/* Nothing to do */
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 		} else if (udev->state == USB_STATE_SUSPENDED &&
 				udev->persist_enabled) {
 			/* For a suspended device, treat this as a
Index: linux-pm/drivers/usb/host/u132-hcd.c
===================================================================
--- linux-pm.orig/drivers/usb/host/u132-hcd.c
+++ linux-pm/drivers/usb/host/u132-hcd.c
@@ -3144,8 +3144,7 @@ static int u132_probe(struct platform_de
 #ifdef CONFIG_PM
 /*
  * for this device there's no useful distinction between the controller
- * and its root hub, except that the root hub only gets direct PM calls
- * when CONFIG_PM_RUNTIME is enabled.
+ * and its root hub.
  */
 static int u132_suspend(struct platform_device *pdev, pm_message_t state)
 {
Index: linux-pm/drivers/usb/host/ehci-pci.c
===================================================================
--- linux-pm.orig/drivers/usb/host/ehci-pci.c
+++ linux-pm/drivers/usb/host/ehci-pci.c
@@ -305,7 +305,7 @@ static int ehci_pci_setup(struct usb_hcd
 		}
 	}
 
-#ifdef	CONFIG_PM_RUNTIME
+#ifdef	CONFIG_PM
 	if (ehci->no_selective_suspend && device_can_wakeup(&pdev->dev))
 		ehci_warn(ehci, "selective suspend/wakeup unavailable\n");
 #endif
Index: linux-pm/drivers/usb/host/sl811-hcd.c
===================================================================
--- linux-pm.orig/drivers/usb/host/sl811-hcd.c
+++ linux-pm/drivers/usb/host/sl811-hcd.c
@@ -22,7 +22,7 @@
  * and usb-storage.
  *
  * TODO:
- * - usb suspend/resume triggered by sl811 (with PM_RUNTIME)
+ * - usb suspend/resume triggered by sl811
  * - various issues noted in the code
  * - performance work; use both register banks; ...
  * - use urb->iso_frame_desc[] with ISO transfers
@@ -1752,8 +1752,7 @@ sl811h_probe(struct platform_device *dev
 #ifdef	CONFIG_PM
 
 /* for this device there's no useful distinction between the controller
- * and its root hub, except that the root hub only gets direct PM calls
- * when CONFIG_PM_RUNTIME is enabled.
+ * and its root hub.
  */
 
 static int
Index: linux-pm/drivers/usb/host/xhci-hub.c
===================================================================
--- linux-pm.orig/drivers/usb/host/xhci-hub.c
+++ linux-pm/drivers/usb/host/xhci-hub.c
@@ -1146,7 +1146,7 @@ int xhci_bus_suspend(struct usb_hcd *hcd
 			set_bit(port_index, &bus_state->bus_suspended);
 		}
 		/* USB core sets remote wake mask for USB 3.0 hubs,
-		 * including the USB 3.0 roothub, but only if CONFIG_PM_RUNTIME
+		 * including the USB 3.0 roothub, but only if CONFIG_PM
 		 * is enabled, so also enable remote wake here.
 		 */
 		if (hcd->self.root_hub->do_remote_wakeup
Index: linux-pm/drivers/usb/host/xhci.c
===================================================================
--- linux-pm.orig/drivers/usb/host/xhci.c
+++ linux-pm/drivers/usb/host/xhci.c
@@ -4024,7 +4024,7 @@ static int __maybe_unused xhci_change_ma
 	return ret;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 
 /* BESL to HIRD Encoding array for USB2 LPM */
 static int xhci_besl_encoding[16] = {125, 150, 200, 300, 400, 500, 1000, 2000,
@@ -4239,24 +4239,8 @@ int xhci_update_device(struct usb_hcd *h
 	return 0;
 }
 
-#else
-
-int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
-				struct usb_device *udev, int enable)
-{
-	return 0;
-}
-
-int xhci_update_device(struct usb_hcd *hcd, struct usb_device *udev)
-{
-	return 0;
-}
-
-#endif /* CONFIG_PM_RUNTIME */
-
 /*---------------------- USB 3.0 Link PM functions ------------------------*/
 
-#ifdef CONFIG_PM
 /* Service interval in nanoseconds = 2^(bInterval - 1) * 125us * 1000ns / 1us */
 static unsigned long long xhci_service_interval_to_ns(
 		struct usb_endpoint_descriptor *desc)
@@ -4687,6 +4671,17 @@ int xhci_disable_usb3_lpm_timeout(struct
 }
 #else /* CONFIG_PM */
 
+int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
+				struct usb_device *udev, int enable)
+{
+	return 0;
+}
+
+int xhci_update_device(struct usb_hcd *hcd, struct usb_device *udev)
+{
+	return 0;
+}
+
 int xhci_enable_usb3_lpm_timeout(struct usb_hcd *hcd,
 			struct usb_device *udev, enum usb3_link_state state)
 {
Index: linux-pm/drivers/usb/phy/phy-msm-usb.c
===================================================================
--- linux-pm.orig/drivers/usb/phy/phy-msm-usb.c
+++ linux-pm/drivers/usb/phy/phy-msm-usb.c
@@ -1761,7 +1761,7 @@ static int msm_otg_remove(struct platfor
 	return 0;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
 static int msm_otg_runtime_idle(struct device *dev)
 {
 	struct msm_otg *motg = dev_get_drvdata(dev);

