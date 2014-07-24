Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473AbaGXPSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:18:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:57800 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759251AbaGXPSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:18:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PCI / PM: Make PCIe PME interrupts wake up from "freeze" sleep state
Date: Thu, 24 Jul 2014 17:36:28 +0200
Message-ID: <3655886.Ih7L6voqVK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140724134241.GZ6758@twins.programming.kicks-ass.net>
References: <12684812.i3F8JrYCl0@vostro.rjw.lan> <20140724134241.GZ6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 03:42:41 PM Peter Zijlstra wrote:

[...]

> 
> So with this patch on:
> 
>   http://marc.info/?l=3Dlinux-kernel&m=3D140620918218199
> 
> This will not work on my machine, because aerdrv is requesting the same
> irq.
> 
> Now I've not a f'cking clue what aerdrv is, and whether it too wants
> NO_SUSPEND on or not.
> 
> But if I make it also request NO_SUSPEND it all starts working.

OK, so can you please test the updated patch below?

Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PCI / PM: Make PCIe PME interrupts wake up from "freeze" sleep state

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
Unfortunately, that requires the AER service driver to pass
IRQF_NO_SUSPEND when requesting its IRQ which may be shared with
the PME interrupt and to make that safe, simple suspend/resume
routines need to be added to the AER driver.

During system suspend, while suspending the PME service for given
port, walk the bus below that port and see if any devices on that
bus are configured for wakeup.  If so, do not disable the PME
interrupt, but only set a "suspend level" for the service to
"wakeup" and make the interrupt handler behave in a special way,
which is to call __pm_wakeup_event() with the service's wakeup
source object as the first argument whenever the interrupt is
triggered.

The "suspend level" is cleared while resuming the PME service.

This change allows Wake-on-LAN to be used for wakeup from
suspend-to-idle on my MSI Wind tesbed netbook.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pcie/aer/aerdrv.c |   44 +++++++++++++++++++++++-
 drivers/pci/pcie/aer/aerdrv.h |    1 
 drivers/pci/pcie/pme.c        |   74 +++++++++++++++++++++++++++++++++++-------
 3 files changed, 104 insertions(+), 15 deletions(-)

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
@@ -234,6 +242,11 @@ static void pcie_pme_work_fn(struct work
 			 */
 			pcie_clear_root_pme_status(port);
 
+			if (data->suspend_level == PME_SUSPEND_WAKEUP) {
+				__pm_wakeup_event(data->ws, 0);
+				break;
+			}
+
 			spin_unlock_irq(&data->lock);
 			pcie_pme_handle_request(port, rtsta & 0xffff);
 			spin_lock_irq(&data->lock);
@@ -250,7 +263,7 @@ static void pcie_pme_work_fn(struct work
 		spin_lock_irq(&data->lock);
 	}
 
-	if (!data->noirq)
+	if (data->suspend_level != PME_SUSPEND_NOIRQ)
 		pcie_pme_interrupt_enable(port, true);
 
 	spin_unlock_irq(&data->lock);
@@ -356,10 +369,12 @@ static int pcie_pme_probe(struct pcie_de
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
@@ -375,11 +405,25 @@ static int pcie_pme_suspend(struct pcie_
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
@@ -394,12 +438,15 @@ static int pcie_pme_suspend(struct pcie_
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
+	data->suspend_level = PME_SUSPEND_NONE;
 	spin_unlock_irq(&data->lock);
 
 	return 0;
@@ -411,9 +458,12 @@ static int pcie_pme_resume(struct pcie_d
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
Index: linux-pm/drivers/pci/pcie/aer/aerdrv.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/aer/aerdrv.c
+++ linux-pm/drivers/pci/pcie/aer/aerdrv.c
@@ -43,6 +43,8 @@ MODULE_LICENSE("GPL");
 
 static int aer_probe(struct pcie_device *dev);
 static void aer_remove(struct pcie_device *dev);
+static int aer_suspend(struct pcie_device *dev);
+static int aer_resume(struct pcie_device *dev);
 static pci_ers_result_t aer_error_detected(struct pci_dev *dev,
 	enum pci_channel_state error);
 static void aer_error_resume(struct pci_dev *dev);
@@ -60,6 +62,8 @@ static struct pcie_port_service_driver a
 
 	.probe		= aer_probe,
 	.remove		= aer_remove,
+	.suspend	= aer_suspend,
+	.resume		= aer_resume,
 
 	.err_handler	= &aer_error_handlers,
 
@@ -222,9 +226,10 @@ irqreturn_t aer_irq(int irq, void *conte
 	next_prod_idx = rpc->prod_idx + 1;
 	if (next_prod_idx == AER_ERROR_SOURCES_MAX)
 		next_prod_idx = 0;
-	if (next_prod_idx == rpc->cons_idx) {
+	if (next_prod_idx == rpc->cons_idx || rpc->suspended) {
 		/*
-		 * Error Storm Condition - possibly the same error occurred.
+		 * Error Storm Condition (possibly the same error occurred) or
+		 * the service has been suspended.
 		 * Drop the error.
 		 */
 		spin_unlock_irqrestore(&rpc->e_lock, flags);
@@ -271,6 +276,38 @@ static struct aer_rpc *aer_alloc_rpc(str
 }
 
 /**
+ * aer_suspend - suspend the service
+ * @dev: pointer to the pcie_dev data structure
+ *
+ * Invoked during system suspend.
+ */
+static int aer_suspend(struct pcie_device *dev)
+{
+	struct aer_rpc *rpc = get_service_data(dev);
+
+	spin_lock_irq(&rpc->e_lock);
+	rpc->suspended = true;
+	spin_unlock_irq(&rpc->e_lock);
+	return 0;
+}
+
+/**
+ * aer_resume - resume the service
+ * @dev: pointer to the pcie_dev data structure
+ *
+ * Invoked during system resume.
+ */
+static int aer_resume(struct pcie_device *dev)
+{
+	struct aer_rpc *rpc = get_service_data(dev);
+
+	spin_lock_irq(&rpc->e_lock);
+	rpc->suspended = false;
+	spin_unlock_irq(&rpc->e_lock);
+	return 0;
+}
+
+/**
  * aer_remove - clean up resources
  * @dev: pointer to the pcie_dev data structure
  *
@@ -320,7 +357,8 @@ static int aer_probe(struct pcie_device
 	}
 
 	/* Request IRQ ISR */
-	status = request_irq(dev->irq, aer_irq, IRQF_SHARED, "aerdrv", dev);
+	status = request_irq(dev->irq, aer_irq, IRQF_SHARED | IRQF_NO_SUSPEND,
+			     "aerdrv", dev);
 	if (status) {
 		dev_printk(KERN_DEBUG, device, "request IRQ failed\n");
 		aer_remove(dev);
Index: linux-pm/drivers/pci/pcie/aer/aerdrv.h
===================================================================
--- linux-pm.orig/drivers/pci/pcie/aer/aerdrv.h
+++ linux-pm/drivers/pci/pcie/aer/aerdrv.h
@@ -73,6 +73,7 @@ struct aer_rpc {
 					 * root port hierarchy
 					 */
 	wait_queue_head_t wait_release;
+	bool suspended;
 };
 
 struct aer_broadcast_data {

