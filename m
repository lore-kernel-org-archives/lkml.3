Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3EPPvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:23 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45083 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3EPPvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:18 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2, part3 01/11] PCI: introduce bus lock and state machine to serialize PCI hotplug operations
Date: Thu, 16 May 2013 23:50:49 +0800
Message-Id: <1368719459-24800-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are multiple ways to trigger concurrent PCI hotplug operations for
a specific PCI bus, but we have no way to serialize those PCI hotplug
operations yet and thus it may break the PCI hotplug logic. This patch
introduces a lock mechanism and a state machine for PCI bus to serialize
PCI hotplug operations.

The state machine is as below:
        _________________________________________________________________
       |                                                                 v
INITIALIZED->REGISTERED->STARTED->STOPPING->STOPPED->REMOVING->REMOVED->DESTOYED
                  |_____________________________________^

 INITIALIZED:	the bus structure has just been allocated
 REGISTERED:	the device for the bus has been registered into the
		device tree
 STARTED:	PCI devices under the bus has been started
 STOPPING:	start to stop devices on the bus
 STOPPED:	child PCI devices under the bus has been stopped
 REMOVING:	start to remove the PCI bus
 REMOVED:	the bus has been removed from the PCI tree
 DESTROYED:	memory for the bus has been freed, just for debug

The interfaces to manage PCI bus state are:
static inline int pci_bus_get_state(const struct pci_bus *bus);
extern void pci_bus_change_state(struct pci_bus *bus, int new_state,
				 int old_state, bool unlock);

And another three interfaces for PCI bus lock:
extern int pci_bus_lock(struct pci_bus *bus, int states, bool recursive);
extern int pci_bus_lock_timeout(struct pci_bus *bus, int states,
				bool recursive, long timeout);
extern void pci_bus_unlock(struct pci_bus *bus, bool recursive);

The locking rules are simple:
1) The bus must be locked when changing state of child devices.
2) The bus must be locked when changing state of itself.

A typical usage looks like:
if (pci_bus_lock(bus, PCI_BUS_STATE_STARTED, true) == 0) {
	do_pci_hotplug();
	pci_bus_unlock(bus, true);
}

Note:
The PCI_BUS_LOCK config option is a temporary solution to avoid breaking
bisects, it will be removed when all architectures have been enhanced to
support the new PCI bus state and lock mechanism.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/Kconfig |   3 +
 drivers/pci/bus.c   | 251 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h |  47 ++++++++++
 3 files changed, 301 insertions(+)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 6d51aa6..92e69bd 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -119,3 +119,6 @@ config PCI_IOAPIC
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
 	select NLS
+
+config PCI_BUS_LOCK
+	def_bool n
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index f7e1f76..b232775 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -15,9 +15,12 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 
 #include "pci.h"
 
+static DECLARE_WAIT_QUEUE_HEAD(pci_bus_state_wait_queue);
+
 void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 			     resource_size_t offset)
 {
@@ -297,6 +300,254 @@ void pci_bus_put(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_bus_put);
 
+/**
+ * pci_bus_change_state - Change state of @bus from @old_state to @new_state
+ * @bus: the PCI bus to change state
+ * @old_state: old state of @bus
+ * @new_state: new state for @bus
+ * @unlock: unlock @bus if true
+ *
+ * Change state of @bus from @old_state to @new_state, and unlock @bus
+ * if @unlock is true.
+ * Note:
+ * - @new_state must be bigger than @old_state
+ * - must be called with @bus locked.
+ */
+void pci_bus_change_state(struct pci_bus *bus, int old_state, int new_state,
+			  bool unlock)
+{
+	int t;
+
+	BUG_ON(!pci_bus_is_locked(bus));
+	BUG_ON(new_state < old_state || pci_bus_get_state(bus) != old_state ||
+	       (new_state & ~PCI_BUS_STATE_MASK));
+
+	old_state |= PCI_BUS_STATE_LOCK;
+	if (!unlock)
+		new_state |= PCI_BUS_STATE_LOCK;
+
+	do {
+		t = atomic_read(&bus->state);
+		t &= ~(PCI_BUS_STATE_MASK | PCI_BUS_STATE_LOCK);
+	} while (atomic_cmpxchg(&bus->state, t | old_state, t | new_state)
+		 != (t | old_state));
+
+	wake_up_all(&pci_bus_state_wait_queue);
+}
+
+/* Wait for bus to reach one of the specified states. */
+static bool pci_bus_wait_for_states(struct pci_bus *bus, int states)
+{
+	int t = atomic_read(&bus->state);
+
+	/* Bus state is bigger than any of the specified states. */
+	if ((t & PCI_BUS_STATE_MASK) > states)
+		return true;
+
+	/* Bus is in one of the specified states and unlocked. */
+	if ((t & states) && !(t & PCI_BUS_STATE_LOCK))
+		return true;
+
+	return false;
+}
+
+static int pci_bus_lock_one(struct pci_bus *bus, int states, long *to)
+{
+	int t;
+
+	BUG_ON(states & ~PCI_BUS_STATE_MASK);
+	do {
+		do {
+			if (*to <= 0)
+				return -ETIMEDOUT;
+			*to = wait_event_timeout(pci_bus_state_wait_queue,
+				pci_bus_wait_for_states(bus, states), *to);
+			t = atomic_read(&bus->state);
+			if (((t & PCI_BUS_STATE_MASK) > states))
+				return -EBUSY;
+		} while (!(t & states));
+
+		t &= ~PCI_BUS_STATE_LOCK;
+	} while (atomic_cmpxchg(&bus->state, t , t | PCI_BUS_STATE_LOCK) != t);
+
+	return 0;
+}
+
+static int ___pci_bus_lock(struct pci_bus *bus, int states, bool recursive,
+			   long *to, struct pci_bus **marker)
+{
+	int ret;
+	struct pci_bus *child;
+
+	ret = pci_bus_lock_one(bus, states, to);
+	if (ret < 0) {
+		*marker = bus;
+	} else if (recursive) {
+		list_for_each_entry(child, &bus->children, node) {
+			ret = ___pci_bus_lock(child, states, recursive,
+					      to, marker);
+			if (ret < 0)
+				break;
+		}
+	}
+
+	return ret;
+}
+
+static int __pci_bus_unlock(struct pci_bus *bus, bool recursive,
+			    struct pci_bus *mark)
+{
+	int t, ret = 0;
+	struct pci_bus *child;
+
+	if (unlikely(bus == mark))
+		return 1;
+
+	if (recursive)
+		list_for_each_entry(child, &bus->children, node) {
+			ret = __pci_bus_unlock(child, recursive, mark);
+			if (ret)
+				break;
+		}
+
+	BUG_ON(!pci_bus_is_locked(bus));
+	do {
+		t = atomic_read(&bus->state);
+	} while (atomic_cmpxchg(&bus->state, t, t & ~PCI_BUS_STATE_LOCK) != t);
+
+	return ret;
+}
+
+static int __pci_bus_lock(struct pci_bus *bus, int states, bool recursive,
+			  long *to)
+{
+	int ret;
+	struct pci_bus *mark = NULL;
+
+	ret = ___pci_bus_lock(bus, states, recursive, to, &mark);
+	if (ret < 0) {
+		__pci_bus_unlock(bus, recursive, mark);
+		wake_up_all(&pci_bus_state_wait_queue);
+	}
+
+	return ret;
+}
+
+/**
+ * pci_bus_lock - wait for @bus to reach one of the specified states
+ *		  and then lock it.
+ * @bus: the PCI bus to lock
+ * @states: specified states to wait for
+ * @recursive: lock all the subtree if true
+ *
+ * Wait for @bus to reach one of the states specified by @states and then
+ * lock it. Resursively lock all the subtree if @recursive is true.
+ *
+ * Return values:
+ * - 0 on success
+ * - -EBUSY if failed to lock the bus
+ */
+int pci_bus_lock(struct pci_bus *bus, int states, bool recursive)
+{
+	int ret;
+	long to;
+
+	/*
+	 * When recursively locking the sub-tree starting from @bus,
+	 * __pci_bus_lock() may return -EBUSY if some child buses are under
+	 * hot-removing, so keep retrying until success or @bus is out of
+	 * requested @states.
+	 */
+	do {
+		to = HZ / 10;
+		ret = __pci_bus_lock(bus, states, recursive, &to);
+		if (ret == 0)
+			return 0;
+
+		/*
+		 * Prevent a deadlock scenario that thread A waits for
+		 * all sysfs files to be released while holding PCI bus
+		 * locks, and Thread B tries to acquire PCI bus locks
+		 * in a sysfs handler. These checks break the deadlock
+		 * condition.
+		 */
+		if (pci_bus_get_state(bus) > states)
+			return -EBUSY;
+		if (to > 0)
+			schedule_timeout_interruptible(to);
+	} while (true);
+}
+EXPORT_SYMBOL(pci_bus_lock);
+
+/**
+ * pci_bus_lock_timeout - wait for @bus to reach one of the
+ *			  specified states and then lock it.
+ * @bus: the PCI bus to lock
+ * @states: specified states to wait for
+ * @recursive: lock all the subtree if true
+ * @timeout: maximum number of jiffies to wait
+ *
+ * Wait for @bus to reach one of the states specified by @states and then
+ * lock it. Resursively lock all the subtree if @recursive is true.
+ *
+ * Return values:
+ * - 0 on success
+ * - -ETIMEDOUT if timeouts
+ * - -EBUSY if failed to lock the bus
+ */
+int pci_bus_lock_timeout(struct pci_bus *bus, int states, bool recursive,
+			 long timeout)
+{
+	int ret;
+	long to;
+
+	if (timeout <= 0)
+		return -ETIMEDOUT;
+
+	/*
+	 * When recursively locking the sub-tree starting from @bus,
+	 * __pci_bus_lock() may return -EBUSY if some child buses are under
+	 * hot-removing, so keep retrying until success or @bus is out of
+	 * requested @states.
+	 */
+	do {
+		to = (timeout > HZ / 10) ? (HZ / 10) : timeout;
+		timeout -= to;
+		ret = __pci_bus_lock(bus, states, recursive, &to);
+		if (ret == 0)
+			return 0;
+
+		/*
+		 * Prevent a deadlock scenario that thread A waits for
+		 * all sysfs files to be released while holding PCI bus
+		 * locks, and Thread B tries to acquire PCI bus locks
+		 * in a sysfs handler. These checks break the deadlock
+		 * condition.
+		 */
+		if (pci_bus_get_state(bus) > states)
+			return -EBUSY;
+		if (to > 0)
+			schedule_timeout_interruptible(to);
+	} while (timeout > 0);
+
+	return -ETIMEDOUT;
+}
+EXPORT_SYMBOL(pci_bus_lock_timeout);
+
+/**
+ * pci_bus_unlock - unlock @bus and wake up waiters
+ * bus: PCI bus to unlock
+ * recursive: unlock subtree if recursive is true
+ *
+ * Unlock PCI bus @bus and wake up waiters. Must be called with @bus locked.
+ */
+void pci_bus_unlock(struct pci_bus *bus, bool recursive)
+{
+	__pci_bus_unlock(bus, recursive, NULL);
+	wake_up_all(&pci_bus_state_wait_queue);
+}
+EXPORT_SYMBOL(pci_bus_unlock);
+
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
 EXPORT_SYMBOL(pci_bus_add_devices);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index c88d4e6..cfe075c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -450,8 +450,55 @@ struct pci_bus {
 	struct bin_attribute	*legacy_io; /* legacy I/O for this bus */
 	struct bin_attribute	*legacy_mem; /* legacy mem */
 	unsigned int		is_added:1;
+	atomic_t		state;
 };
 
+/*
+ * PCI bus state machine:
+ *         _________________________________________________________________
+ *        |                                                                 v
+ * INITIALIZED->REGISTERED->STARTED->STOPPING->STOPPED->REMOVING->REMOVED->DESTOYED
+ *                   |_____________________________________^
+ */
+#define PCI_BUS_STATE_UNKNOWN		0x0	/* invalid state */
+#define PCI_BUS_STATE_INITIALIZED	0x1	/* bus initialized */
+#define PCI_BUS_STATE_REGISTERED	0x2	/* bus added into device tree */
+#define PCI_BUS_STATE_STARTED		0x4	/* working state */
+#define PCI_BUS_STATE_STOPPING		0x8	/* start to stop children */
+#define PCI_BUS_STATE_STOPPED		0x10	/* child devices stopped */
+#define PCI_BUS_STATE_REMOVING		0x20	/* start to remove PCI */
+#define PCI_BUS_STATE_REMOVED		0x40	/* bus removed */
+#define PCI_BUS_STATE_DESTROYED		0x80	/* used for debug only */
+#define PCI_BUS_STATE_MASK		0xFF
+
+#ifdef	CONFIG_PCI_BUS_LOCK
+#define	PCI_BUS_STATE_LOCK		0x10000	/* for pci core only */
+
+static inline bool pci_bus_is_locked(const struct pci_bus *bus)
+{
+	return !!(atomic_read(&bus->state) & PCI_BUS_STATE_LOCK);
+}
+#else /* CONFIG_PCI_BUS_LOCK */
+#define	PCI_BUS_STATE_LOCK		0x00000	/* for pci core only */
+
+static inline bool pci_bus_is_locked(const struct pci_bus *bus)
+{
+	return true;
+}
+#endif /* CONFIG_PCI_BUS_LOCK */
+
+static inline int pci_bus_get_state(const struct pci_bus *bus)
+{
+	return atomic_read(&bus->state) & PCI_BUS_STATE_MASK;
+}
+
+void pci_bus_change_state(struct pci_bus *bus, int new_state,
+			  int old_state, bool unlock);
+int pci_bus_lock(struct pci_bus *bus, int states, bool recursive);
+int pci_bus_lock_timeout(struct pci_bus *bus, int states,
+			 bool recursive, long timeout);
+void pci_bus_unlock(struct pci_bus *bus, bool recursive);
+
 #define pci_bus_b(n)	list_entry(n, struct pci_bus, node)
 #define to_pci_bus(n)	container_of(n, struct pci_bus, dev)
 #define for_each_pci_bus(b)	for (b = NULL; (b = pci_get_next_bus(b)); )
-- 
1.8.1.2

