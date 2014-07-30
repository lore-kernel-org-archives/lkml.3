Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbaG3Vgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:36:36 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:55587 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751343AbaG3Vgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:36:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: [PATCH 2/3] PCI / PM: Make PCIe PME interrupts wake up from "freeze" sleep state
Date: Wed, 30 Jul 2014 23:51:48 +0200
Message-ID: <3811630.J9Hv4pUoN5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <8151374.tpuvaHv3nd@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <3042738.6Ohp3GcNCj@vostro.rjw.lan> <8151374.tpuvaHv3nd@vostro.rjw.lan>
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

During system suspend, while suspending the PME service for given
port, walk the bus below that port and see if any devices on that
bus are configured for wakeup.  If so, do not disable the PME
interrupt, but call enable_device_irq_wake() for it, set a "suspend
level" variable for the service to "wakeup" and make the interrupt
handler behave in a special way, which is to call __pm_wakeup_event()
with the service's wakeup source object as the first argument and
switch the "suspend level" over to "noirq" when the interrupt is
triggered.

The "suspend level" is cleared and disable_device_irq_wake() is
called for the PME interrupt while resuming the PME service.

This change allows Wake-on-LAN to be used for wakeup from
suspend-to-idle on my MSI Wind tesbed netbook.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pcie/pme.c |   74 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 63 insertions(+), 11 deletions(-)

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
@@ -41,11 +42,18 @@ static int __init pcie_pme_setup(char *s
 }
 __setup("pcie_pme=", pcie_pme_setup);
 
+enum pme_suspend_level {
+	PME_SUSPEND_NONE = 0,
+	PME_SUSPEND_WAKEUP,
+	PME_SUSPEND_NOIRQ,
+};
+
 struct pcie_pme_service_data {
 	spinlock_t lock;
 	struct pcie_device *srv;
 	struct work_struct work;
-	bool noirq; /* Don't enable the PME interrupt used by this service. */
+	struct wakeup_source *ws;
+	enum pme_suspend_level suspend_level;
 };
 
 /**
@@ -223,7 +231,7 @@ static void pcie_pme_work_fn(struct work
 	spin_lock_irq(&data->lock);
 
 	for (;;) {
-		if (data->noirq)
+		if (data->suspend_level == PME_SUSPEND_NOIRQ)
 			break;
 
 		pcie_capability_read_dword(port, PCI_EXP_RTSTA, &rtsta);
@@ -234,6 +242,12 @@ static void pcie_pme_work_fn(struct work
 			 */
 			pcie_clear_root_pme_status(port);
 
+			if (data->suspend_level == PME_SUSPEND_WAKEUP) {
+				__pm_wakeup_event(data->ws, 0);
+				data->suspend_level = PME_SUSPEND_NOIRQ;
+				break;
+			}
+
 			spin_unlock_irq(&data->lock);
 			pcie_pme_handle_request(port, rtsta & 0xffff);
 			spin_lock_irq(&data->lock);
@@ -250,7 +264,7 @@ static void pcie_pme_work_fn(struct work
 		spin_lock_irq(&data->lock);
 	}
 
-	if (!data->noirq)
+	if (data->suspend_level != PME_SUSPEND_NOIRQ)
 		pcie_pme_interrupt_enable(port, true);
 
 	spin_unlock_irq(&data->lock);
@@ -360,6 +374,7 @@ static int pcie_pme_probe(struct pcie_de
 	if (ret) {
 		kfree(data);
 	} else {
+		data->ws = wakeup_source_register(dev_name(&srv->device));
 		pcie_pme_mark_devices(port);
 		pcie_pme_interrupt_enable(port, true);
 	}
@@ -367,6 +382,21 @@ static int pcie_pme_probe(struct pcie_de
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
 /**
  * pcie_pme_suspend - Suspend PCIe PME service device.
  * @srv: PCIe service device to suspend.
@@ -375,11 +405,26 @@ static int pcie_pme_suspend(struct pcie_
 {
 	struct pcie_pme_service_data *data = get_service_data(srv);
 	struct pci_dev *port = srv->port;
+	bool wakeup;
 
+	if (device_may_wakeup(&port->dev)) {
+		wakeup = true;
+	} else {
+		down_read(&pci_bus_sem);
+		wakeup = pcie_pme_check_wakeup(port->subordinate);
+		up_read(&pci_bus_sem);
+	}
 	spin_lock_irq(&data->lock);
-	pcie_pme_interrupt_enable(port, false);
-	pcie_clear_root_pme_status(port);
-	data->noirq = true;
+	if (wakeup) {
+		enable_device_irq_wake(srv->irq, srv);
+		data->suspend_level = PME_SUSPEND_WAKEUP;
+	} else {
+		struct pci_dev *port = srv->port;
+
+		pcie_pme_interrupt_enable(port, false);
+		pcie_clear_root_pme_status(port);
+		data->suspend_level = PME_SUSPEND_NOIRQ;
+	}
 	spin_unlock_irq(&data->lock);
 
 	synchronize_irq(srv->irq);
@@ -394,12 +439,16 @@ static int pcie_pme_suspend(struct pcie_
 static int pcie_pme_resume(struct pcie_device *srv)
 {
 	struct pcie_pme_service_data *data = get_service_data(srv);
-	struct pci_dev *port = srv->port;
 
 	spin_lock_irq(&data->lock);
-	data->noirq = false;
-	pcie_clear_root_pme_status(port);
-	pcie_pme_interrupt_enable(port, true);
+	if (data->suspend_level == PME_SUSPEND_NOIRQ) {
+		struct pci_dev *port = srv->port;
+
+		pcie_clear_root_pme_status(port);
+		pcie_pme_interrupt_enable(port, true);
+	}
+	disable_device_irq_wake(srv->irq, srv);
+	data->suspend_level = PME_SUSPEND_NONE;
 	spin_unlock_irq(&data->lock);
 
 	return 0;
@@ -411,9 +460,12 @@ static int pcie_pme_resume(struct pcie_d
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

