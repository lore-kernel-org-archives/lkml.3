Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaEAAhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:37:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54147 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaEAAg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:36:59 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
CC: Tony Lindgren <tony@atomide.com>, Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv5 RFC 11/15] hwspinlock/core: add support for reserved locks
Date: Wed, 30 Apr 2014 19:34:32 -0500
Message-ID: <1398904476-26200-12-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398904476-26200-1-git-send-email-s-anna@ti.com>
References: <1398904476-26200-1-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HwSpinlock core allows requesting either a specific lock or an
available normal lock. The specific locks are usually reserved during
board init time, while the normal available locks are intended to be
assigned at runtime.

The HwSpinlock core has been enhanced to:
  1. allow the platform implementations to register a set of 'reserved'
     locks
  2. restrict the anonymous hwspin_lock_request() API to allocate only
     from non-reserved locks
  3. limit these reserved locks to be allocated only using the
     _request_specific() API variants.

The existing platform implementations have also been updated to adjust
for the change of the registration API.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/hwspinlock/hwspinlock_core.c     | 20 ++++++++++++++++----
 drivers/hwspinlock/hwspinlock_internal.h |  3 +++
 drivers/hwspinlock/omap_hwspinlock.c     |  4 ++--
 drivers/hwspinlock/u8500_hsem.c          |  3 ++-
 include/linux/hwspinlock.h               | 10 +++++++---
 5 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
index c2063bc..e05cea8 100644
--- a/drivers/hwspinlock/hwspinlock_core.c
+++ b/drivers/hwspinlock/hwspinlock_core.c
@@ -432,6 +432,8 @@ static int hwspinlock_device_add(struct hwspinlock_device *bank)
  * @ops: hwspinlock handlers for this device
  * @base_id: id of the first hardware spinlock in this bank
  * @num_locks: number of hwspinlocks provided by this device
+ * @num_reserved_locks: number of reserved hwspinlocks starting from @base_id
+ *			on this device
  *
  * This function should be called from the underlying platform-specific
  * implementation, to register a new hwspinlock device instance.
@@ -441,13 +443,15 @@ static int hwspinlock_device_add(struct hwspinlock_device *bank)
  * Returns 0 on success, or an appropriate error code on failure
  */
 int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
-		const struct hwspinlock_ops *ops, int base_id, int num_locks)
+		const struct hwspinlock_ops *ops, int base_id, int num_locks,
+		int num_reserved_locks)
 {
 	struct hwspinlock *hwlock;
 	int ret = 0, i;
 
 	if (!bank || !ops || !dev || !num_locks || !ops->trylock ||
-	    !ops->unlock || (dev->of_node && !ops->of_xlate)) {
+	    !ops->unlock || (dev->of_node && !ops->of_xlate) ||
+	    (num_locks < num_reserved_locks)) {
 		pr_err("invalid parameters\n");
 		return -EINVAL;
 	}
@@ -456,6 +460,7 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 	bank->ops = ops;
 	bank->base_id = base_id;
 	bank->num_locks = num_locks;
+	bank->num_reserved_locks = num_reserved_locks;
 
 	mutex_lock(&hwspinlock_tree_lock);
 	ret = hwspinlock_device_add(bank);
@@ -468,7 +473,8 @@ int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
 
 		spin_lock_init(&hwlock->lock);
 		hwlock->bank = bank;
-		hwlock->type = HWSPINLOCK_UNUSED;
+		hwlock->type = (i < num_reserved_locks ?
+				HWSPINLOCK_RESERVED : HWSPINLOCK_UNUSED);
 
 		ret = hwspin_lock_register_single(hwlock, base_id + i);
 		if (ret)
@@ -651,7 +657,13 @@ struct hwspinlock *hwspin_lock_request_specific(unsigned int id)
 	/* sanity check (this shouldn't happen) */
 	WARN_ON(hwlock_to_id(hwlock) != id);
 
-	/* make sure this hwspinlock is unused */
+	if (hwlock->type != HWSPINLOCK_RESERVED) {
+		pr_warn("hwspinlock %u is not a reserved lock\n", id);
+		hwlock = NULL;
+		goto out;
+	}
+
+	/* make sure this hwspinlock is an unused reserved lock */
 	ret = radix_tree_tag_get(&hwspinlock_tree, id, hwlock->type);
 	if (ret == 0) {
 		pr_warn("hwspinlock %u is already in use\n", id);
diff --git a/drivers/hwspinlock/hwspinlock_internal.h b/drivers/hwspinlock/hwspinlock_internal.h
index 1be32ca..570e876 100644
--- a/drivers/hwspinlock/hwspinlock_internal.h
+++ b/drivers/hwspinlock/hwspinlock_internal.h
@@ -64,6 +64,8 @@ struct hwspinlock {
  * @ops: platform-specific hwspinlock handlers
  * @base_id: id index of the first lock in this device
  * @num_locks: number of locks in this device
+ * @num_reserved_locks: number of reserved locks in this device starting
+ *			from @base_id
  * @lock: dynamically allocated array of 'struct hwspinlock'
  */
 struct hwspinlock_device {
@@ -72,6 +74,7 @@ struct hwspinlock_device {
 	const struct hwspinlock_ops *ops;
 	int base_id;
 	int num_locks;
+	int num_reserved_locks;
 	struct hwspinlock lock[0];
 };
 
diff --git a/drivers/hwspinlock/omap_hwspinlock.c b/drivers/hwspinlock/omap_hwspinlock.c
index 7764291..1d0c78e 100644
--- a/drivers/hwspinlock/omap_hwspinlock.c
+++ b/drivers/hwspinlock/omap_hwspinlock.c
@@ -88,7 +88,7 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *io_base;
 	int num_locks, i, ret;
-	int base_id = 0;
+	int base_id = 0, reserved_locks = 0;
 
 	if (!node)
 		return -ENODEV;
@@ -144,7 +144,7 @@ static int omap_hwspinlock_probe(struct platform_device *pdev)
 		hwlock->priv = io_base + LOCK_BASE_OFFSET + sizeof(u32) * i;
 
 	ret = hwspin_lock_register(bank, &pdev->dev, &omap_hwspinlock_ops,
-						base_id, num_locks);
+					base_id, num_locks, reserved_locks);
 	if (ret)
 		goto reg_fail;
 
diff --git a/drivers/hwspinlock/u8500_hsem.c b/drivers/hwspinlock/u8500_hsem.c
index 401c33b..2b4f001 100644
--- a/drivers/hwspinlock/u8500_hsem.c
+++ b/drivers/hwspinlock/u8500_hsem.c
@@ -134,7 +134,8 @@ static int u8500_hsem_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	ret = hwspin_lock_register(bank, &pdev->dev, &u8500_hwspinlock_ops,
-						pdata->base_id, num_locks);
+					pdata->base_id, num_locks,
+					pdata->num_reserved_locks);
 	if (ret)
 		goto reg_fail;
 
diff --git a/include/linux/hwspinlock.h b/include/linux/hwspinlock.h
index 4857728..d120035 100644
--- a/include/linux/hwspinlock.h
+++ b/include/linux/hwspinlock.h
@@ -35,6 +35,7 @@ struct hwspinlock_ops;
 /**
  * struct hwspinlock_pdata - platform data for hwspinlock drivers
  * @base_id: base id for this hwspinlock device
+ * @num_reserved_locks: number of reserved locks starting from @base_id
  *
  * hwspinlock devices provide system-wide hardware locks that are used
  * by remote processors that have no other way to achieve synchronization.
@@ -53,11 +54,13 @@ struct hwspinlock_ops;
  *
  * This platform data structure should be used to provide the base id
  * for each device (which is trivially 0 when only a single hwspinlock
- * device exists). It can be shared between different platforms, hence
- * its location.
+ * device exists). It should also be used to provide the number of reserved
+ * locks for non-DT based devices. It can be shared between different
+ * platforms, hence its location.
  */
 struct hwspinlock_pdata {
 	int base_id;
+	int num_reserved_locks;
 };
 
 #if defined(CONFIG_HWSPINLOCK) || defined(CONFIG_HWSPINLOCK_MODULE)
@@ -67,7 +70,8 @@ int of_hwspin_lock_simple_xlate(struct hwspinlock_device *bank,
 int of_hwspin_lock_get_base_id(struct device_node *dn);
 int of_hwspin_lock_get_num_locks(struct device_node *dn);
 int hwspin_lock_register(struct hwspinlock_device *bank, struct device *dev,
-		const struct hwspinlock_ops *ops, int base_id, int num_locks);
+		const struct hwspinlock_ops *ops, int base_id, int num_locks,
+		int num_reserved_locks);
 int hwspin_lock_unregister(struct hwspinlock_device *bank);
 struct hwspinlock *hwspin_lock_request(void);
 struct hwspinlock *hwspin_lock_request_specific(unsigned int id);
-- 
1.9.2

