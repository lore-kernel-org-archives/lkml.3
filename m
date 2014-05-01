Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaEAAfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:35:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51348 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaEAAfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:35:42 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 03/15] hwspinlock/core: maintain a list of registered hwspinlock banks
Date: Wed, 30 Apr 2014 19:34:24 -0500
Message-ID: <1398904476-26200-4-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hwspinlock_device structure is used for registering a bank of
locks with the driver core. The structure already contains the
necessary members to identify the bank of locks. The core does not
maintain the hwspinlock_devices itself, but maintains only a radix
tree for all the registered locks. A specific lock can be requested
by users using a global lock id, and any device-specific fields
can be retrieved through a reference to the hwspinlock_device in
each lock.

The global lock id, however, is not friendly to be requested for
users using the device-tree model. The device-tree representation
will typically have each of the hwspinlock devices represented as
a DT node, and a specific lock can be requested using the device's
phandle and a lock specifier. Add support to the core therefore to
maintain all the registered hwspinlock_devices, so that a device
can be looked up and a specific lock belonging to the device
requested through a phandle + args approach.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 Documentation/hwspinlock.txt             |  2 ++
 drivers/hwspinlock/hwspinlock_core.c     | 51 ++++++++++++++++++++++++++++++++
 drivers/hwspinlock/hwspinlock_internal.h |  2 ++
 3 files changed, 55 insertions(+)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index 62f7d4e..640ae47 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -251,6 +251,7 @@ implementation using the hwspin_lock_register() API.
 
 /**
  * struct hwspinlock_device - a device which usually spans numerous hwspinlocks
+ * @list: list element to link hwspinlock devices together
  * @dev: underlying device, will be used to invoke runtime PM api
  * @ops: platform-specific hwspinlock handlers
  * @base_id: id index of the first lock in this device
@@ -258,6 +259,7 @@ implementation using the hwspin_lock_register() API.
  * @lock: dynamically allocated array of 'struct hwspinlock'
  */
 struct hwspinlock_device {
+	struct list_head list;
 	struct device *dev;
 	const struct hwspinlock_ops *ops;
 	int base_id;
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 461a0d7..48f7866 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -59,6 +59,11 @@ static RADIX_TREE(hwspinlock_tree, GFP_KERNEL);
  */
 static DEFINE_MUTEX(hwspinlock_tree_lock);
 
+/*
+ * A linked list for maintaining all the registered hwspinlock devices.
+ * The list is maintained in an ordered-list of the supported locks group.
+ */
+static LIST_HEAD(hwspinlock_devices);
 
 /**
  * __hwspin_trylock() - attempt to lock a specific hwspinlock
@@ -307,6 +312,40 @@ out:
 	return hwlock;
 }
 
+/*
+ * Add a new hwspinlock device to the global list, keeping the list of
+ * devices sorted by base order.
+ *
+ * Returns 0 on success, or -EBUSY if the new device overlaps with some
+ * other device's lock space.
+ */
+static int hwspinlock_device_add(struct hwspinlock_device *bank)
+{
+	struct list_head *entry = &hwspinlock_devices;
+	struct hwspinlock_device *_bank;
+	int ret = 0;
+
+	list_for_each(entry, &hwspinlock_devices) {
+		_bank = list_entry(entry, struct hwspinlock_device, list);
+		if (_bank->base_id >= bank->base_id + bank->num_locks)
+			break;
+	}
+
+	if (entry != &hwspinlock_devices &&
+	    entry->prev != &hwspinlock_devices) {
+		_bank = list_entry(entry->prev, struct hwspinlock_device, list);
+		if (_bank->base_id + _bank->num_locks > bank->base_id) {
+			dev_err(bank->dev, "hwlock space overlap, cannot add device\n");
+			ret = -EBUSY;
+		}
+	}
+
+	if (!ret)
+		list_add_tail(&bank->list, entry);
+
+	return ret;
+}
+
 /**
  * hwspin_lock_register() - register a new hw spinlock device
  * @bank: the hwspinlock device, which usually provides numerous hw locks
@@ -339,6 +378,12 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 	bank->base_id = base_id;
 	bank->num_locks = num_locks;
 
+	mutex_lock(&hwspinlock_tree_lock);
+	ret = hwspinlock_device_add(bank);
+	mutex_unlock(&hwspinlock_tree_lock);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < num_locks; i++) {
 		hwlock = &bank->lock[i];
 
@@ -355,6 +400,9 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 reg_failed:
 	while (--i >= 0)
 		hwspin_lock_unregister_single(base_id + i);
+	mutex_lock(&hwspinlock_tree_lock);
+	list_del(&bank->list);
+	mutex_unlock(&hwspinlock_tree_lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_register);
@@ -386,6 +434,9 @@ int hwspin_lock_unregister(struct hwspinlock_device *bank)
 		WARN_ON(tmp != hwlock);
 	}
 
+	mutex_lock(&hwspinlock_tree_lock);
+	list_del(&bank->list);
+	mutex_unlock(&hwspinlock_tree_lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(hwspin_lock_unregister);
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index d26f78b..aff560c 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -53,6 +53,7 @@ struct hwspinlock {
 
 /**
  * struct hwspinlock_device - a device which usually spans numerous hwspinlocks
+ * @list: list element to link hwspinlock devices together
  * @dev: underlying device, will be used to invoke runtime PM api
  * @ops: platform-specific hwspinlock handlers
  * @base_id: id index of the first lock in this device
@@ -60,6 +61,7 @@ struct hwspinlock {
  * @lock: dynamically allocated array of 'struct hwspinlock'
  */
 struct hwspinlock_device {
+	struct list_head list;
 	struct device *dev;
 	const struct hwspinlock_ops *ops;
 	int base_id;
-- 
1.9.2

