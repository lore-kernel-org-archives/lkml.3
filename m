Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaHEPLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 11:11:01 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60436 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753099AbaHEPK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 11:10:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: [PATCH 5/5] PCI / PM: Make PCIe PME interrupts wake up from suspend-to-idle
Date: Tue, 05 Aug 2014 17:28:55 +0200
Message-ID: <2711098.sybS8dER1z@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3321219.itH23ZEDt4@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <3855585.ek3PTQLkmN@vostro.rjw.lan> <3321219.itH23ZEDt4@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

To make PCIe PME interrupts wake up the system from suspend to idle,
make the PME driver use enable_irq_wake() on the IRQ during system
suspend (if there are any wakeup devices below the given PCIe port)
without disabling PME interrupts.  This way, an interrupt will still
trigger if a wakeup event happens and the system will be woken up (or
system suspend in progress will be aborted) by means of the new
mechanics introduced previously.

This change allows Wake-on-LAN to be used for wakeup from
suspend-to-idle on my MSI Wind tesbed netbook.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pcie/pme.c |   61 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 51 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/pci/pcie/pme.c
===================================================================
--- linux-pm.orig/drivers/pci/pcie/pme.c
+++ linux-pm/drivers/pci/pcie/pme.c
@@ -41,11 +41,17 @@ static int __init pcie_pme_setup(char *s
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
+	enum pme_suspend_level suspend_level;
 };
 
 /**
@@ -223,7 +229,7 @@ static void pcie_pme_work_fn(struct work
 	spin_lock_irq(&data->lock);
 
 	for (;;) {
-		if (data->noirq)
+		if (data->suspend_level != PME_SUSPEND_NONE)
 			break;
 
 		pcie_capability_read_dword(port, PCI_EXP_RTSTA, &rtsta);
@@ -250,7 +256,7 @@ static void pcie_pme_work_fn(struct work
 		spin_lock_irq(&data->lock);
 	}
 
-	if (!data->noirq)
+	if (data->suspend_level == PME_SUSPEND_NONE)
 		pcie_pme_interrupt_enable(port, true);
 
 	spin_unlock_irq(&data->lock);
@@ -367,6 +373,21 @@ static int pcie_pme_probe(struct pcie_de
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
@@ -375,11 +396,26 @@ static int pcie_pme_suspend(struct pcie_
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
+		enable_irq_wake(srv->irq);
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
@@ -394,12 +430,17 @@ static int pcie_pme_suspend(struct pcie_
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
+	} else {
+		disable_irq_wake(srv->irq);
+	}
+	data->suspend_level = PME_SUSPEND_NONE;
 	spin_unlock_irq(&data->lock);
 
 	return 0;

