Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaEAAfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:35:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51353 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbaEAAfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:35:47 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 04/15] hwspinlock/core: add common OF helpers
Date: Wed, 30 Apr 2014 19:34:25 -0500
Message-ID: <1398904476-26200-5-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds three new OF helper functions to use/request
locks from a hwspinlock device instantiated through a
device-tree blob.

1. The of_hwspin_lock_get_num_locks() is a common helper
   function to read the common 'hwlock-num-locks' property.
2. The of_hwspin_lock_simple_xlate() is a simple default
   translator function for hwspinlock provider implementations
   that use a single cell number for requesting a specific lock
   (relatively indexed) within a hwlock bank.
3. The of_hwspin_lock_request_specific() API can be used by
   hwspinlock clients to request a specific lock using the
   phandle + args specifier. This function relies on the
   implementation providing back a relative hwlock id within
   the bank from the args specifier.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 Documentation/hwspinlock.txt             |  34 ++++++++++-
 drivers/hwspinlock/hwspinlock_core.c     | 100 ++++++++++++++++++++++++++++++-
 drivers/hwspinlock/hwspinlock_internal.h |   4 ++
 include/linux/hwspinlock.h               |  22 ++++++-
 4 files changed, 155 insertions(+), 5 deletions(-)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index 640ae47..903d477 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -48,6 +48,15 @@ independent, drivers.
      ids for predefined purposes.
      Should be called from a process context (might sleep).
 
+  struct hwspinlock *of_hwspin_lock_request_specific(
+		struct device_node *np,	const char *propname, int index);
+   - assign a specific hwspinlock id and return its address, or NULL
+     if that hwspinlock is already in use. This function is the OF
+     equivalent of hwspin_lock_request_specific() function, and provides
+     a means for users of the hwspinlock module to request a specific
+     hwspinlock using the phandle of the hwspinlock device.
+     Should be called from a process context (might sleep).
+
   int hwspin_lock_free(struct hwspinlock *hwlock);
    - free a previously-assigned hwspinlock; returns 0 on success, or an
      appropriate error code on failure (e.g. -EINVAL if the hwspinlock
@@ -243,6 +252,23 @@ int hwspinlock_example2(void)
      Returns the address of hwspinlock on success, or NULL on error (e.g.
      if the hwspinlock is still in use).
 
+  int of_hwspin_lock_simple_xlate(struct hwspinlock_device *bank,
+				  const struct of_phandle_args *hwlock_spec);
+   - is a simple default OF translate helper function that can be plugged in
+     as the underlying vendor-specific implementation's of_xlate ops function.
+     This can be used by implementations that use a single integer argument in
+     the DT node argument specifier, that indicates the hwlock index number.
+     Returns a hwlock index within a bank, or appropriate error code on
+     failure.
+
+  int of_hwspin_lock_get_num_locks(struct device_node *dn);
+   - is a common OF helper function that can be used by some underlying
+     vendor-specific implementations. This can be used by implementations
+     that require and define the number of locks supported within a hwspinlock
+     bank as a device tree node property. This function should be called by
+     needed implementations before registering a hwspinlock device with the
+     core.
+
 5. Important structs
 
 struct hwspinlock_device is a device which usually contains a bank
@@ -288,12 +314,14 @@ initialized by the hwspinlock core itself.
 
 6. Implementation callbacks
 
-There are three possible callbacks defined in 'struct hwspinlock_ops':
+There are four possible callbacks defined in 'struct hwspinlock_ops':
 
 struct hwspinlock_ops {
 	int (*trylock)(struct hwspinlock *lock);
 	void (*unlock)(struct hwspinlock *lock);
 	void (*relax)(struct hwspinlock *lock);
+	int (*of_xlate)(struct hwspinlock_device *bank,
+			const struct of_phandle_args *hwlock_spec);
 };
 
 The first two callbacks are mandatory:
@@ -307,3 +335,7 @@ may _not_ sleep.
 The ->relax() callback is optional. It is called by hwspinlock core while
 spinning on a lock, and can be used by the underlying implementation to force
 a delay between two successive invocations of ->trylock(). It may _not_ sleep.
+
+The ->of_xlate() callback is mandatory to support requesting hwlocks through
+device-tree nodes. It is called by hwspinlock core to retrieve the relative
+lock index within a bank from the underlying implementation.
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 48f7866..3966c0c 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -27,6 +27,7 @@
 #include <linux/hwspinlock.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 
 #include "hwspinlock_internal.h"
 
@@ -262,6 +263,33 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 }
 EXPORT_SYMBOL_GPL(__hwspin_unlock);
 
+/**
+ * of_hwspin_lock_get_num_locks() - OF helper to retrieve number of locks
+ * @dn: device node pointer
+ *
+ * This is an OF helper function that can be called by the underlying
+ * platform-specific implementations, to retrieve the number of locks
+ * present within a hwspinlock device instance. The hwlock-num-locks
+ * DT property may be optional for some platforms, while mandatory for
+ * some others, so this function is typically called only by needed
+ * platform-specific implementations.
+ *
+ * Returns a positive number of locks on success, -ENODEV on generic
+ * failure or an appropriate error code as returned by the OF layer
+ */
+int of_hwspin_lock_get_num_locks(struct device_node *dn)
+{
+	unsigned int val;
+	int ret = -ENODEV;
+
+	ret = of_property_read_u32(dn, "hwlock-num-locks", &val);
+	if (!ret)
+		ret = val ? val : -ENODEV;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(of_hwspin_lock_get_num_locks);
+
 static int hwspin_lock_register_single(struct hwspinlock *hwlock, int id)
 {
 	struct hwspinlock *tmp;
@@ -312,6 +340,31 @@ out:
 	return hwlock;
 }
 
+/**
+ * of_hwspin_lock_simple_xlate - translate hwlock_spec to return a lock id
+ * @bank: the hwspinlock device bank
+ * @hwlock_spec: hwlock specifier as found in the device tree
+ *
+ * This is a simple translation function, suitable for hwspinlock platform
+ * drivers that only has a lock specifier length of 1.
+ *
+ * Returns a negative value on error, and a relative index of the lock within
+ * a specified bank on success.
+ */
+int of_hwspin_lock_simple_xlate(struct hwspinlock_device *bank,
+				const struct of_phandle_args *hwlock_spec)
+{
+	/* sanity check (these shouldn't happen) */
+	if (WARN_ON(!bank->dev->of_node))
+		return -EINVAL;
+
+	if (WARN_ON(hwlock_spec->args_count != 1))
+		return -EINVAL;
+
+	return hwlock_spec->args[0];
+}
+EXPORT_SYMBOL_GPL(of_hwspin_lock_simple_xlate);
+
 /*
  * Add a new hwspinlock device to the global list, keeping the list of
  * devices sorted by base order.
@@ -368,7 +421,7 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 	int ret = 0, i;
 
 	if (!bank || !ops || !dev || !num_locks || !ops->trylock ||
-							!ops->unlock) {
+	    !ops->unlock || (dev->of_node && !ops->of_xlate)) {
 		pr_err("invalid parameters\n");
 		return -EINVAL;
 	}
@@ -592,6 +645,51 @@ out:
 EXPORT_SYMBOL_GPL(hwspin_lock_request_specific);
 
 /**
+ * of_hwspin_lock_request_specific() - request a OF phandle-based specific lock
+ * @np: device node from which to request the specific hwlock
+ * @propname: property name containing hwlock specifier(s)
+ * @index: index of the hwlock
+ *
+ * This function is the OF equivalent of hwspin_lock_request_specific(). This
+ * function provides a means for users of the hwspinlock module to request a
+ * specific hwspinlock using the phandle of the hwspinlock device. The requested
+ * lock number is indexed relative to the hwspinlock device, unlike the
+ * hwspin_lock_request_specific() which is an absolute lock number.
+ *
+ * Returns the address of the assigned hwspinlock, or NULL on error
+ */
+struct hwspinlock *of_hwspin_lock_request_specific(struct device_node *np,
+						   const char *propname,
+						   int index)
+{
+	struct hwspinlock_device *bank;
+	struct of_phandle_args args;
+	int id;
+	int ret;
+
+	ret = of_parse_phandle_with_args(np, propname, "#hwlock-cells", index,
+					 &args);
+	if (ret)
+		return NULL;
+
+	mutex_lock(&hwspinlock_tree_lock);
+	list_for_each_entry(bank, &hwspinlock_devices, list)
+		if (bank->dev->of_node == args.np)
+			break;
+	mutex_unlock(&hwspinlock_tree_lock);
+	if (&bank->list == &hwspinlock_devices)
+		return NULL;
+
+	id = bank->ops->of_xlate(bank, &args);
+	if (id < 0 || id >= bank->num_locks)
+		return NULL;
+
+	id += bank->base_id;
+	return hwspin_lock_request_specific(id);
+}
+EXPORT_SYMBOL_GPL(of_hwspin_lock_request_specific);
+
+/**
  * hwspin_lock_free() - free a specific hwspinlock
  * @hwlock: the specific hwspinlock to free
  *
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index aff560c..5e42613 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -32,11 +32,15 @@ struct hwspinlock_device;
  * @relax:   optional, platform-specific relax handler, called by hwspinlock
  *	     core while spinning on a lock, between two successive
  *	     invocations of @trylock. may _not_ sleep.
+ * @of_xlate: platform-specific hwlock specifier translate function, to
+ *	      return the relative index of the lock within a bank
  */
 struct hwspinlock_ops {
 	int (*trylock)(struct hwspinlock *lock);
 	void (*unlock)(struct hwspinlock *lock);
 	void (*relax)(struct hwspinlock *lock);
+	int (*of_xlate)(struct hwspinlock_device *bank,
+			const struct of_phandle_args *hwlock_spec);
 };
 
 /**
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index 3343298..068e628 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -26,6 +26,8 @@
 #define HWLOCK_IRQ	0x02	/* Disable interrupts, don't save state */
 
 struct device;
+struct device_node;
+struct of_phandle_args;
 struct hwspinlock;
 struct hwspinlock_device;
 struct hwspinlock_ops;
@@ -60,11 +62,17 @@ struct hwspinlock_pdata {
 
 #if defined(CONFIG_HWSPINLOCK) || defined(CONFIG_HWSPINLOCK_MODULE)
 
+int of_hwspin_lock_simple_xlate(struct hwspinlock_device *bank,
+				const struct of_phandle_args *hwlock_spec);
+int of_hwspin_lock_get_num_locks(struct device_node *dn);
 int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 		const struct hwspinlock_ops *ops, int base_id, int num_locks);
 int hwspin_lock_unregister(struct hwspinlock_device *bank);
 struct hwspinlock *hwspin_lock_request(void);
 struct hwspinlock *hwspin_lock_request_specific(unsigned int id);
+struct hwspinlock *of_hwspin_lock_request_specific(struct device_node *np,
+						   const char *propname,
+						   int index);
 int hwspin_lock_free(struct hwspinlock *hwlock);
 int hwspin_lock_get_id(struct hwspinlock *hwlock);
 int __hwspin_lock_timeout(struct hwspinlock *, unsigned int, int,
@@ -80,9 +88,9 @@ void __hwspin_unlock(struct hwspinlock *, int, unsigned long *);
  * code path get compiled away. This way, if CONFIG_HWSPINLOCK is not
  * required on a given setup, users will still work.
  *
- * The only exception is hwspin_lock_register/hwspin_lock_unregister, with which
- * we _do_ want users to fail (no point in registering hwspinlock instances if
- * the framework is not available).
+ * The only exception is hwspin_lock_register/hwspin_lock_unregister and
+ * associated OF helpers, with which we _do_ want users to fail (no point
+ * in registering hwspinlock instances if the framework is not available).
  *
  * Note: ERR_PTR(-ENODEV) will still be considered a success for NULL-checking
  * users. Others, which care, can still check this with IS_ERR.
@@ -97,6 +105,14 @@ static inline struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 	return ERR_PTR(-ENODEV);
 }
 
+static inline
+struct hwspinlock *of_hwspin_lock_request_specific(struct device_node *np,
+						   const char *propname,
+						   int index)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline int hwspin_lock_free(struct hwspinlock *hwlock)
 {
 	return 0;
-- 
1.9.2

