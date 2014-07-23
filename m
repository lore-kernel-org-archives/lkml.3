Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbaGWU2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:28:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51572 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932997AbaGWU2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:28:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] PCI / PM: Make PCIe PME interrupts wake up from "freeze" sleep state
Date: Wed, 23 Jul 2014 22:46:26 +0200
Message-ID: <12684812.i3F8JrYCl0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The "freeze" sleep state, also known as suspend-to-idle, is entered
without taking nonboot CPUs offline, right after devices have been
suspended.  It works by waiting for at least one wakeup source object
to become "active" as a result of handling a hardware interrupt.

Of course, interrupts supposed to be able to wake up the system from
suspend-to-idle cannot be disabled by suspend_device_irqs() and their
interrupt handlers must be able to cope with interrupts coming after
all devices have been suspended.  In that case, they only need to
call __pm_wakeup_event() for a single wakeup source object without
trying to access hardware (that will be resumed later as part of
the subsequent system resume).

Make PCIe PME interrupts work this way.

Register an additional wakeup source object for each PCIe PME
service device.  That object will be used to generate wakeups from
suspend-to-idle.

Add IRQF_NO_SUSPEND to PME interrupt flags.  This will make
suspend_device_irqs() to ignore PME interrupts, but that's OK,
because the PME interrupt handler is suspend-aware anyway and
can cope with interrupts coming during system suspend-resume.

For each PCIe port with PME service during the "prepare" phase of
system suspend walk the bus below it and see if any devices on that
bus are configured for wakeup.  If so, mark the port as one that can
be used for system wakeup signaling and handle it differenty going
forward.

Namely, while suspending its PME service, do not disable the PME
interrupt, but only set a "suspended" flag for the PME service to
make the interrupt handler behave in a special way, which is to call
__pm_wakeup_event() with the service's wakeup source object as the
first argument whenever the interrupt is triggered.

The "suspended" flag is cleared while resuming the PME service and
the "wakeup" flag is cleared at the "complete" stage of system
resume.

This change allows Wake-on-LAN to be used for wakeup from
suspend-to-idle on my MSI Wind tesbed netbook.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pcie/pme.c          |   95 ++++++++++++++++++++++++++++++++++------
 drivers/pci/pcie/portdrv.h      |    2 
 drivers/pci/pcie/portdrv_core.c |   45 ++++++++++++++++++
 drivers/pci/pcie/portdrv_pci.c  |    2 
 include/linux/pcieport_if.h     |    2 
 5 files changed, 132 insertions(+), 14 deletions(-)

Index: linux-pm/drivers/pci/pcie/pme.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/pme.c
+++ linux-pm/drivers/pci/pcie/pme.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/pcieport_if.h>
 #include <linux/pm_runtime.h>
+#include <linux/pm_wakeup.h>
 
 #include "../pci.h"
 #include "portdrv.h"
@@ -45,7 +46,9 @@ struct pcie_pme_service_data {
 	spinlock_t lock;
 	struct pcie_device *srv;
 	struct work_struct work;
-	bool noirq; /* Don't enable the PME interrupt used by this service. */
+	struct wakeup_source *ws;
+	bool suspended; /* The PME service has been suspended. */
+	bool wakeup; /* The PME interrupt is used for system wakeup. */
 };
 
 /**
@@ -223,7 +226,7 @@ static void pcie_pme_work_fn(struct work
 	spin_lock_irq(&data->lock);
 
 	for (;;) {
-		if (data->noirq)
+		if (data->suspended && !data->wakeup)
 			break;
 
 		pcie_capability_read_dword(port, PCI_EXP_RTSTA, &rtsta);
@@ -234,6 +237,11 @@ static void pcie_pme_work_fn(struct work
 			 */
 			pcie_clear_root_pme_status(port);
 
+			if (data->wakeup && data->suspended) {
+				__pm_wakeup_event(data->ws, 0);
+				break;
+			}
+
 			spin_unlock_irq(&data->lock);
 			pcie_pme_handle_request(port, rtsta & 0xffff);
 			spin_lock_irq(&data->lock);
@@ -250,7 +258,7 @@ static void pcie_pme_work_fn(struct work
 		spin_lock_irq(&data->lock);
 	}
 
-	if (!data->noirq)
+	if (!data->suspended || data->wakeup)
 		pcie_pme_interrupt_enable(port, true);
 
 	spin_unlock_irq(&data->lock);
@@ -356,10 +364,12 @@ static int pcie_pme_probe(struct pcie_de
 	pcie_pme_interrupt_enable(port, false);
 	pcie_clear_root_pme_status(port);
 
-	ret = request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED, "PCIe PME", srv);
+	ret = request_irq(srv->irq, pcie_pme_irq, IRQF_SHARED | IRQF_NO_SUSPEND,
+			  "PCIe PME", srv);
 	if (ret) {
 		kfree(data);
 	} else {
+		data->ws = wakeup_source_register(dev_name(&srv->device));
 		pcie_pme_mark_devices(port);
 		pcie_pme_interrupt_enable(port, true);
 	}
@@ -367,6 +377,43 @@ static int pcie_pme_probe(struct pcie_de
 	return ret;
 }
 
+static bool pcie_pme_check_wakeup(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	if (!bus)
+		return false;
+
+	list_for_each_entry(dev, &bus->devices, bus_list)
+		if (device_may_wakeup(&dev->dev)
+		    || pcie_pme_check_wakeup(dev->subordinate))
+			return true;
+
+	return false;
+}
+
+/**
+ * pcie_pme_prepare - Prepare system PM transition for PCIe PME service device.
+ * @srv - PCIe service device to handle.
+ *
+ * Check if any devices below the port are configured for wakeup.  If so, set
+ * the service's wakeup flag.
+ */
+static int pcie_pme_prepare(struct pcie_device *srv)
+{
+	struct pcie_pme_service_data *data = get_service_data(srv);
+	struct pci_dev *port = srv->port;
+
+	if (device_may_wakeup(&port->dev)) {
+		data->wakeup = true;
+	} else {
+		down_read(&pci_bus_sem);
+		data->wakeup = pcie_pme_check_wakeup(port->subordinate);
+		up_read(&pci_bus_sem);
+	}
+	return 0;
+}
+
 /**
  * pcie_pme_suspend - Suspend PCIe PME service device.
  * @srv: PCIe service device to suspend.
@@ -374,12 +421,15 @@ static int pcie_pme_probe(struct pcie_de
 static int pcie_pme_suspend(struct pcie_device *srv)
 {
 	struct pcie_pme_service_data *data = get_service_data(srv);
-	struct pci_dev *port = srv->port;
 
 	spin_lock_irq(&data->lock);
-	pcie_pme_interrupt_enable(port, false);
-	pcie_clear_root_pme_status(port);
-	data->noirq = true;
+	if (!data->wakeup) {
+		struct pci_dev *port = srv->port;
+
+		pcie_pme_interrupt_enable(port, false);
+		pcie_clear_root_pme_status(port);
+	}
+	data->suspended = true;
 	spin_unlock_irq(&data->lock);
 
 	synchronize_irq(srv->irq);
@@ -394,26 +444,43 @@ static int pcie_pme_suspend(struct pcie_
 static int pcie_pme_resume(struct pcie_device *srv)
 {
 	struct pcie_pme_service_data *data = get_service_data(srv);
-	struct pci_dev *port = srv->port;
 
 	spin_lock_irq(&data->lock);
-	data->noirq = false;
-	pcie_clear_root_pme_status(port);
-	pcie_pme_interrupt_enable(port, true);
+	data->suspended = false;
+	if (!data->wakeup) {
+		struct pci_dev *port = srv->port;
+
+		pcie_clear_root_pme_status(port);
+		pcie_pme_interrupt_enable(port, true);
+	}
 	spin_unlock_irq(&data->lock);
 
 	return 0;
 }
 
 /**
+ * pcie_pme_resume - Complete system PM transition for PCIe PME service device.
+ * @srv - PCIe service device to handle.
+ */
+static void pcie_pme_complete(struct pcie_device *srv)
+{
+	struct pcie_pme_service_data *data = get_service_data(srv);
+
+	data->wakeup = false;
+}
+
+/**
  * pcie_pme_remove - Prepare PCIe PME service device for removal.
  * @srv - PCIe service device to remove.
  */
 static void pcie_pme_remove(struct pcie_device *srv)
 {
+	struct pcie_pme_service_data *data = get_service_data(srv);
+
 	pcie_pme_suspend(srv);
 	free_irq(srv->irq, srv);
-	kfree(get_service_data(srv));
+	wakeup_source_unregister(data->ws);
+	kfree(data);
 }
 
 static struct pcie_port_service_driver pcie_pme_driver = {
@@ -422,8 +489,10 @@ static struct pcie_port_service_driver p
 	.service	= PCIE_PORT_SERVICE_PME,
 
 	.probe		= pcie_pme_probe,
+	.prepare	= pcie_pme_prepare,
 	.suspend	= pcie_pme_suspend,
 	.resume		= pcie_pme_resume,
+	.complete	= pcie_pme_complete,
 	.remove		= pcie_pme_remove,
 };
 
Index: linux-pm/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-pm/drivers/pci/pcie/portdrv_core.c
@@ -413,6 +413,27 @@ error_disable:
 }
 
 #ifdef CONFIG_PM
+static int prepare_iter(struct device *dev, void *data)
+{
+	struct pcie_port_service_driver *service_driver;
+
+	if ((dev->bus == &pcie_port_bus_type) && dev->driver) {
+		service_driver = to_service_driver(dev->driver);
+		if (service_driver->prepare)
+			service_driver->prepare(to_pcie_device(dev));
+	}
+	return 0;
+}
+
+/**
+ * pcie_port_device_prepare - prepare PCIe port services for system suspend
+ * @dev: PCI Express port to handle
+ */
+int pcie_port_device_prepare(struct device *dev)
+{
+	return device_for_each_child(dev, NULL, prepare_iter);
+}
+
 static int suspend_iter(struct device *dev, void *data)
 {
 	struct pcie_port_service_driver *service_driver;
@@ -448,13 +469,35 @@ static int resume_iter(struct device *de
 }
 
 /**
- * pcie_port_device_suspend - resume port services associated with a PCIe port
+ * pcie_port_device_resume - resume port services associated with a PCIe port
  * @dev: PCI Express port to handle
  */
 int pcie_port_device_resume(struct device *dev)
 {
 	return device_for_each_child(dev, NULL, resume_iter);
 }
+
+static int complete_iter(struct device *dev, void *data)
+{
+	struct pcie_port_service_driver *service_driver;
+
+	if ((dev->bus == &pcie_port_bus_type) && dev->driver) {
+		service_driver = to_service_driver(dev->driver);
+		if (service_driver->complete)
+			service_driver->complete(to_pcie_device(dev));
+	}
+	return 0;
+}
+
+/**
+ * pcie_port_device_complete - complete system resume for PCIe port services
+ * @dev: PCI Express port to handle
+ */
+void pcie_port_device_complete(struct device *dev)
+{
+	device_for_each_child(dev, NULL, complete_iter);
+}
+
 #endif /* PM */
 
 static int remove_iter(struct device *dev, void *data)
Index: linux-pm/drivers/pci/pcie/portdrv.h
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv.h
+++ linux-pm/drivers/pci/pcie/portdrv.h
@@ -23,8 +23,10 @@
 extern struct bus_type pcie_port_bus_type;
 int pcie_port_device_register(struct pci_dev *dev);
 #ifdef CONFIG_PM
+int pcie_port_device_prepare(struct device *dev);
 int pcie_port_device_suspend(struct device *dev);
 int pcie_port_device_resume(struct device *dev);
+void pcie_port_device_complete(struct device *dev);
 #endif
 void pcie_port_device_remove(struct pci_dev *dev);
 int __must_check pcie_port_bus_register(void);
Index: linux-pm/drivers/pci/pcie/portdrv_pci.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/portdrv_pci.c
+++ linux-pm/drivers/pci/pcie/portdrv_pci.c
@@ -165,6 +165,8 @@ static int pcie_port_runtime_idle(struct
 #endif
 
 static const struct dev_pm_ops pcie_portdrv_pm_ops = {
+	.prepare	= pcie_port_device_prepare,
+	.complete	= pcie_port_device_complete,
 	.suspend	= pcie_port_device_suspend,
 	.resume		= pcie_port_device_resume,
 	.freeze		= pcie_port_device_suspend,
Index: linux-pm/include/linux/pcieport_if.h
===================================================================
--- linux-pm.orig/include/linux/pcieport_if.h
+++ linux-pm/include/linux/pcieport_if.h
@@ -45,8 +45,10 @@ struct pcie_port_service_driver {
 	const char *name;
 	int (*probe) (struct pcie_device *dev);
 	void (*remove) (struct pcie_device *dev);
+	int (*prepare) (struct pcie_device *dev);
 	int (*suspend) (struct pcie_device *dev);
 	int (*resume) (struct pcie_device *dev);
+	void (*complete) (struct pcie_device *dev);
 
 	/* Service Error Recovery Handler */
 	const struct pci_error_handlers *err_handler;

