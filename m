Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbbANU66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:58:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:34878 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbbANU6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:58:53 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Bjorn Andersson <bjorn@kryo.se>, Josh Cartwright <joshc@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCH v7 3/4] hwspinlock/core: add common OF helpers
Date: Wed, 14 Jan 2015 14:58:20 -0600
Message-ID: <1421269101-51105-4-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421269101-51105-1-git-send-email-s-anna@ti.com>
References: <1421269101-51105-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new OF helper functions for platform
implementations and one new API to use/request locks from a
hwspinlock device instantiated through a device-tree blob.

1. The of_hwspin_lock_get_num_locks() is a common OF helper
   function to read the 'hwlock-num-locks' property.
2. The of_hwspin_lock_get_base_id() is a common OF helper
   function to read the 'hwlock-base-id' property.
3. The of_hwspin_lock_get_id() API can be used by hwspinlock
   clients to get the id for a specific lock using the phandle
   + args specifier, so that it can be requested using the
   available hwspin_lock_request_specific() API.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
v7:
- Moved of_hwspin_lock_get_base_id() and of_hwspin_lock_get_num_locks
  into hwspinlock_internal.h
- Simplified of_hwspin_lock_get_id(), removed deferred probing and
  args specifier validation
- updated comments and documentation

 Documentation/hwspinlock.txt             | 25 ++++++++++++
 drivers/hwspinlock/hwspinlock_core.c     | 65 ++++++++++++++++++++++++++++++++
 drivers/hwspinlock/hwspinlock_internal.h | 47 +++++++++++++++++++++++
 include/linux/hwspinlock.h               |  7 ++++
 4 files changed, 144 insertions(+)

diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
index 62f7d4ea6e26..a29bb47e4637 100644
--- a/Documentation/hwspinlock.txt
+++ b/Documentation/hwspinlock.txt
@@ -48,6 +48,16 @@ independent, drivers.
      ids for predefined purposes.
      Should be called from a process context (might sleep).
 
+  int of_hwspin_lock_get_id(struct device_node *np, int index);
+   - retrieve the global lock id for an OF phandle-based specific lock.
+     This function provides a means for DT users of a hwspinlock module
+     to get the global lock id of a specific hwspinlock, so that it can
+     be requested using the normal hwspin_lock_request_specific() API.
+     The function returns a lock id number on success, or other error
+     values. The function does not perform any validation of the args
+     specifier lock values, this burden is placed on the user.
+     Should be called from a process context (might sleep).
+
   int hwspin_lock_free(struct hwspinlock *hwlock);
    - free a previously-assigned hwspinlock; returns 0 on success, or an
      appropriate error code on failure (e.g. -EINVAL if the hwspinlock
@@ -243,6 +253,21 @@ int hwspinlock_example2(void)
      Returns the address of hwspinlock on success, or NULL on error (e.g.
      if the hwspinlock is still in use).
 
+  int of_hwspin_lock_get_num_locks(struct device_node *dn);
+   - is a common OF helper function that can be used by some underlying
+     vendor-specific implementations. This can be used by implementations
+     that require and define the number of locks supported within a hwspinlock
+     bank as a device tree node property. This function should be called by
+     needed implementations before registering a hwspinlock device with the
+     hwspinlock core.
+
+  int of_hwspin_lock_get_base_id(struct device_node *dn);
+   - is a common OF helper function that can be used by the underlying
+     vendor-specific implementations. This function should be called by
+     implementations to retrieve the base index for a block of locks present
+     within a hwspinlock device for registering that device with the
+     hwspinlock core.
+
 5. Important structs
 
 struct hwspinlock_device is a device which usually contains a bank
diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index 461a0d739d75..8f107bc34281 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -27,6 +27,7 @@
 #include <linux/hwspinlock.h>
 #include <linux/pm_runtime.h>
 #include <linux/mutex.h>
+#include <linux/of.h>
 
 #include "hwspinlock_internal.h"
 
@@ -257,6 +258,70 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 }
 EXPORT_SYMBOL_GPL(__hwspin_unlock);
 
+/**
+ * of_hwspin_lock_simple_xlate - translate hwlock_spec to return a lock id
+ * @bank: the hwspinlock device bank
+ * @hwlock_spec: hwlock specifier as found in the device tree
+ *
+ * This is a simple translation function, suitable for hwspinlock platform
+ * drivers that only has a lock specifier length of 1.
+ *
+ * Returns a relative index of the lock within a specified bank on success,
+ * or -EINVAL on invalid specifier cell count.
+ */
+static inline int
+of_hwspin_lock_simple_xlate(const struct of_phandle_args *hwlock_spec)
+{
+	if (WARN_ON(hwlock_spec->args_count != 1))
+		return -EINVAL;
+
+	return hwlock_spec->args[0];
+}
+
+/**
+ * of_hwspin_lock_get_id() - get lock id for an OF phandle-based specific lock
+ * @np: device node from which to request the specific hwlock
+ * @index: index of the hwlock in the list of values
+ *
+ * This function provides a means for DT users of the hwspinlock module to
+ * get the global lock id of a specific hwspinlock using the phandle of the
+ * hwspinlock device, so that it can be requested using the normal
+ * hwspin_lock_request_specific() API.
+ *
+ * Returns the global lock id number on success, -EINVAL on invalid args
+ * specifier count or an appropriate error as returned from the OF parsing
+ * logic.
+ */
+int of_hwspin_lock_get_id(struct device_node *np, int index)
+{
+	struct of_phandle_args args;
+	int id, base_id;
+	int ret;
+
+	ret = of_parse_phandle_with_args(np, "hwlocks", "#hwlock-cells", index,
+					 &args);
+	if (ret)
+		return ret;
+
+	id = of_hwspin_lock_simple_xlate(&args);
+	if (id < 0) {
+		ret = id;
+		goto out;
+	}
+
+	base_id = of_hwspin_lock_get_base_id(args.np);
+	if (base_id < 0) {
+		ret = base_id;
+		goto out;
+	}
+	id += base_id;
+
+out:
+	of_node_put(args.np);
+	return ret ? ret : id;
+}
+EXPORT_SYMBOL_GPL(of_hwspin_lock_get_id);
+
 static int hwspin_lock_register_single(struct hwspinlock *hwlock, int id)
 {
 	struct hwspinlock *tmp;
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index d26f78b8f214..7c8b148761f0 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -20,6 +20,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/device.h>
+#include <linux/of.h>
 
 struct hwspinlock_device;
 
@@ -74,4 +75,50 @@ static inline int hwlock_to_id(struct hwspinlock *hwlock)
 	return hwlock->bank->base_id + local_id;
 }
 
+/**
+ * of_hwspin_lock_get_base_id() - OF helper to retrieve base id
+ * @dn: device node pointer
+ *
+ * This is an OF helper function that can be called by the underlying
+ * platform-specific implementations, to retrieve the base id for the
+ * set of locks present within a hwspinlock device instance.
+ *
+ * Returns the base id value on success, or an appropriate error code
+ * as returned by the OF layer
+ */
+static inline int of_hwspin_lock_get_base_id(struct device_node *dn)
+{
+	unsigned int val;
+	int ret;
+
+	ret = of_property_read_u32(dn, "hwlock-base-id", &val);
+	return ret ? ret : val;
+}
+
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
+ * Returns a positive number of locks on success, -ENODEV on a value
+ * of zero locks or an appropriate error code as returned by the OF layer
+ */
+static inline int of_hwspin_lock_get_num_locks(struct device_node *dn)
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
+
 #endif /* __HWSPINLOCK_HWSPINLOCK_H */
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index 3343298e40e8..859d673d98c8 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -26,6 +26,7 @@
 #define HWLOCK_IRQ	0x02	/* Disable interrupts, don't save state */
 
 struct device;
+struct device_node;
 struct hwspinlock;
 struct hwspinlock_device;
 struct hwspinlock_ops;
@@ -66,6 +67,7 @@ int hwspin_lock_unregister(struct hwspinlock_device *bank);
 struct hwspinlock *hwspin_lock_request(void);
 struct hwspinlock *hwspin_lock_request_specific(unsigned int id);
 int hwspin_lock_free(struct hwspinlock *hwlock);
+int of_hwspin_lock_get_id(struct device_node *np, int index);
 int hwspin_lock_get_id(struct hwspinlock *hwlock);
 int __hwspin_lock_timeout(struct hwspinlock *, unsigned int, int,
 							unsigned long *);
@@ -120,6 +122,11 @@ void __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
 {
 }
 
+static inline int of_hwspin_lock_get_id(struct device_node *np, int index)
+{
+	return 0;
+}
+
 static inline int hwspin_lock_get_id(struct hwspinlock *hwlock)
 {
 	return 0;
-- 
2.2.1

