Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab3EWNGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 09:06:39 -0400
Received: from smtp-out-099.synserver.de ([212.40.185.99]:1167 "EHLO
	smtp-out-096.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758245Ab3EWNGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 09:06:37 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18738
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] regmap: Make regmap-mmio usable from different contexts
Date: Thu, 23 May 2013 15:06:16 +0200
Message-Id: <1369314377-22873-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1369314377-22873-1-git-send-email-lars@metafoo.de>
References: <1369314377-22873-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for locking.
Which means in order to avoid race conditions the lock always needs to be taken
from the same context. In practice at least one of the calls to the regmap API
happens from sleepable context, which means all calls to the regmap API have to
be made from sleepable context. This not only prevents us from using regmap-mmio
from interrupt context but also from other sections where IRQs are disabled.
E.g. if interrupts are disabled because a interrupt safe spinlock is locked.
Not being able to use regmap from different contexts limits the number of
usecases for regmap-mmio quite a bit.

This patch updates the adds a flags parameter to the regmap lock and unlock
callbacks and uses spin_lock_irqsave() and spin_unlock_restore() for the mmio
case. This allows us to use regmap-mmio from different contexts.

For the non-mmio case where regmap uses a mutex for locking the flags parameter
will be ignored and it is still only possible to use regmap API from sleepable
context.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---

E.g. the Tegra ASoC drivers should suffer from this since the ALSA trigger
callback is called with interrupts off.

---
 drivers/base/regmap/regcache-rbtree.c |  5 +--
 drivers/base/regmap/regcache.c        | 33 ++++++++++++--------
 drivers/base/regmap/regmap.c          | 57 ++++++++++++++++++++---------------
 drivers/mfd/sta2x11-mfd.c             |  6 ++--
 drivers/staging/imx-drm/imx-tve.c     |  4 +--
 include/linux/regmap.h                |  4 +--
 6 files changed, 64 insertions(+), 45 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 69b443f..d424f71 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -142,8 +142,9 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	int nodes = 0;
 	int registers = 0;
 	int this_registers, average;
+	unsigned long flags;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	mem_size = sizeof(*rbtree_ctx);
 	mem_size += BITS_TO_LONGS(map->cache_present_nbits) * sizeof(long);
@@ -170,7 +171,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	seq_printf(s, "%d nodes, %d registers, average %d registers, used %zu bytes\n",
 		   nodes, registers, average, mem_size);
 
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return 0;
 }
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 4bfa219..8497cd1 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -267,10 +267,11 @@ int regcache_sync(struct regmap *map)
 	unsigned int i;
 	const char *name;
 	unsigned int bypass;
+	unsigned long flags;
 
 	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 	/* Remember the initial bypass state */
 	bypass = map->cache_bypass;
 	dev_dbg(map->dev, "Syncing %s cache\n",
@@ -306,7 +307,7 @@ out:
 	trace_regcache_sync(map->dev, name, "stop");
 	/* Restore the bypass state */
 	map->cache_bypass = bypass;
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -330,10 +331,11 @@ int regcache_sync_region(struct regmap *map, unsigned int min,
 	int ret = 0;
 	const char *name;
 	unsigned int bypass;
+	unsigned long flags;
 
 	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	/* Remember the initial bypass state */
 	bypass = map->cache_bypass;
@@ -352,7 +354,7 @@ out:
 	trace_regcache_sync(map->dev, name, "stop region");
 	/* Restore the bypass state */
 	map->cache_bypass = bypass;
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -372,13 +374,14 @@ EXPORT_SYMBOL_GPL(regcache_sync_region);
 int regcache_drop_region(struct regmap *map, unsigned int min,
 			 unsigned int max)
 {
+	unsigned long flags;
 	unsigned int reg;
 	int ret = 0;
 
 	if (!map->cache_present && !(map->cache_ops && map->cache_ops->drop))
 		return -EINVAL;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	trace_regcache_drop_region(map->dev, min, max);
 
@@ -389,7 +392,7 @@ int regcache_drop_region(struct regmap *map, unsigned int min,
 	if (map->cache_ops && map->cache_ops->drop)
 		ret = map->cache_ops->drop(map, min, max);
 
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -409,11 +412,13 @@ EXPORT_SYMBOL_GPL(regcache_drop_region);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
-	map->lock(map->lock_arg);
+	unsigned long flags;
+
+	map->lock(map->lock_arg, &flags);
 	WARN_ON(map->cache_bypass && enable);
 	map->cache_only = enable;
 	trace_regmap_cache_only(map->dev, enable);
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
@@ -428,9 +433,11 @@ EXPORT_SYMBOL_GPL(regcache_cache_only);
  */
 void regcache_mark_dirty(struct regmap *map)
 {
-	map->lock(map->lock_arg);
+	unsigned long flags;
+
+	map->lock(map->lock_arg, &flags);
 	map->cache_dirty = true;
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 }
 EXPORT_SYMBOL_GPL(regcache_mark_dirty);
 
@@ -447,11 +454,13 @@ EXPORT_SYMBOL_GPL(regcache_mark_dirty);
  */
 void regcache_cache_bypass(struct regmap *map, bool enable)
 {
-	map->lock(map->lock_arg);
+	unsigned long flags;
+
+	map->lock(map->lock_arg, &flags);
 	WARN_ON(map->cache_only && enable);
 	map->cache_bypass = enable;
 	trace_regmap_cache_bypass(map->dev, enable);
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 307f5a1..8369e2c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -287,28 +287,28 @@ static unsigned int regmap_parse_32_native(const void *buf)
 	return *(u32 *)buf;
 }
 
-static void regmap_lock_mutex(void *__map)
+static void regmap_lock_mutex(void *__map, unsigned long *flags)
 {
 	struct regmap *map = __map;
 	mutex_lock(&map->mutex);
 }
 
-static void regmap_unlock_mutex(void *__map)
+static void regmap_unlock_mutex(void *__map, unsigned long *flags)
 {
 	struct regmap *map = __map;
 	mutex_unlock(&map->mutex);
 }
 
-static void regmap_lock_spinlock(void *__map)
+static void regmap_lock_spinlock(void *__map, unsigned long *flags)
 {
 	struct regmap *map = __map;
-	spin_lock(&map->spinlock);
+	spin_lock_irqsave(&map->spinlock, *flags);
 }
 
-static void regmap_unlock_spinlock(void *__map)
+static void regmap_unlock_spinlock(void *__map, unsigned long *flags)
 {
 	struct regmap *map = __map;
-	spin_unlock(&map->spinlock);
+	spin_unlock_irqrestore(&map->spinlock, *flags);
 }
 
 static void dev_get_regmap_release(struct device *dev, void *res)
@@ -1198,16 +1198,17 @@ int _regmap_write(struct regmap *map, unsigned int reg,
  */
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 {
+	unsigned long flags;
 	int ret;
 
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	ret = _regmap_write(map, reg, val);
 
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -1232,6 +1233,7 @@ EXPORT_SYMBOL_GPL(regmap_write);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len)
 {
+	unsigned long flags;
 	int ret;
 
 	if (!regmap_can_raw_write(map))
@@ -1239,11 +1241,11 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	ret = _regmap_raw_write(map, reg, val, val_len, false);
 
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -1266,6 +1268,7 @@ EXPORT_SYMBOL_GPL(regmap_raw_write);
 int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		     size_t val_count)
 {
+	unsigned long flags;
 	int ret = 0, i;
 	size_t val_bytes = map->format.val_bytes;
 	void *wval;
@@ -1277,7 +1280,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	/* No formatting is require if val_byte is 1 */
 	if (val_bytes == 1) {
@@ -1314,7 +1317,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		kfree(wval);
 
 out:
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
@@ -1344,6 +1347,7 @@ EXPORT_SYMBOL_GPL(regmap_bulk_write);
 int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 			   const void *val, size_t val_len)
 {
+	unsigned long flags;
 	int ret;
 
 	if (val_len % map->format.val_bytes)
@@ -1351,11 +1355,11 @@ int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	ret = _regmap_raw_write(map, reg, val, val_len, true);
 
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -1462,16 +1466,17 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
  */
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 {
+	unsigned long flags;
 	int ret;
 
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	ret = _regmap_read(map, reg, val);
 
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -1493,6 +1498,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 {
 	size_t val_bytes = map->format.val_bytes;
 	size_t val_count = val_len / val_bytes;
+	unsigned long flags;
 	unsigned int v;
 	int ret, i;
 
@@ -1503,7 +1509,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	if (regmap_volatile_range(map, reg, val_count) || map->cache_bypass ||
 	    map->cache_type == REGCACHE_NONE) {
@@ -1525,7 +1531,7 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	}
 
  out:
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -1631,12 +1637,13 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
+	unsigned long flags;
 	bool change;
 	int ret;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 	ret = _regmap_update_bits(map, reg, mask, val, &change);
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
@@ -1658,11 +1665,12 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change)
 {
+	unsigned long flags;
 	int ret;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 	ret = _regmap_update_bits(map, reg, mask, val, change);
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
@@ -1752,6 +1760,7 @@ EXPORT_SYMBOL_GPL(regmap_async_complete);
 int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 			  int num_regs)
 {
+	unsigned long flags;
 	int i, ret;
 	bool bypass;
 
@@ -1759,7 +1768,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 	if (map->patch)
 		return -EBUSY;
 
-	map->lock(map->lock_arg);
+	map->lock(map->lock_arg, &flags);
 
 	bypass = map->cache_bypass;
 
@@ -1787,7 +1796,7 @@ int regmap_register_patch(struct regmap *map, const struct reg_default *regs,
 out:
 	map->cache_bypass = bypass;
 
-	map->unlock(map->lock_arg);
+	map->unlock(map->lock_arg, &flags);
 
 	return ret;
 }
diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index d70a3430..2fe1d36 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -154,20 +154,20 @@ EXPORT_SYMBOL(sta2x11_mfd_get_regs_data);
  * Special sta2x11-mfd regmap lock/unlock functions
  */
 
-static void sta2x11_regmap_lock(void *__lock)
+static void sta2x11_regmap_lock(void *__lock, unsigned long *flags)
 {
 	spinlock_t *lock = __lock;
 	spin_lock(lock);
 }
 
-static void sta2x11_regmap_unlock(void *__lock)
+static void sta2x11_regmap_unlock(void *__lock, unsigned long *flags)
 {
 	spinlock_t *lock = __lock;
 	spin_unlock(lock);
 }
 
 /* OTP (one time programmable registers do not require locking */
-static void sta2x11_regmap_nolock(void *__lock)
+static void sta2x11_regmap_nolock(void *__lock, unsigned long *flags)
 {
 }
 
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index ac16344..455aad2 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -131,13 +131,13 @@ struct imx_tve {
 	int hsync_pin;
 };
 
-static void tve_lock(void *__tve)
+static void tve_lock(void *__tve, unsigned long *flags)
 {
 	struct imx_tve *tve = __tve;
 	spin_lock(&tve->lock);
 }
 
-static void tve_unlock(void *__tve)
+static void tve_unlock(void *__tve, unsigned long *flags)
 {
 	struct imx_tve *tve = __tve;
 	spin_unlock(&tve->lock);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index d6f3221..377a589 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -85,8 +85,8 @@ struct regmap_access_table {
 	unsigned int n_no_ranges;
 };
 
-typedef void (*regmap_lock)(void *);
-typedef void (*regmap_unlock)(void *);
+typedef void (*regmap_lock)(void *, unsigned long *flags);
+typedef void (*regmap_unlock)(void *, unsigned long *flags);
 
 /**
  * Configuration for the register map of a device.
-- 
1.8.0

