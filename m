Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbbAPOkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 09:40:33 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48500 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbbAPOkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 09:40:23 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-de-54b922d4a9e7
From: Paul Osmialowski <p.osmialowsk@samsung.com>
To: Wolfram Sang <wsa@the-dreams.de>, Jonathan Corbet <corbet@lwn.net>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene@kernel.org>, linux-i2c@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Paul Osmialowski <p.osmialowsk@samsung.com>
Subject: [RFC 2/3] regmap: Use the enhancement of i2c API to address circular
 dependency problem
Date: Fri, 16 Jan 2015 15:39:53 +0100
Message-id: <1421419194-1849-2-git-send-email-p.osmialowsk@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
References: <1421419194-1849-1-git-send-email-p.osmialowsk@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupiluLIzCtJLcpLzFFi42I5/e/4Zd0rSjtDDA7N4rCY+vAJm8WTA+2M
	Fs2L17NZ9D9+zWyxsG0Ji0XH3y+MFpd3zWGzmHF+H5PFhDcHmC1WnpjF7MDlsWlVJ5vH/rlr
	2D0W901m9ejbsorR4+SpJywenzfJBbBFcdmkpOZklqUW6dslcGXM2XySreBpQcXppd2sDYwf
	I7sYOTkkBEwk7nx8wAxhi0lcuLeerYuRi0NIYCmjxIbja9hBEkICvUwSe57zg9hsAoYSN/8f
	ZgQpEhHYwSTx8N5hNpAEs4C+RFP/U7BJwgJJEu//NYHFWQRUJQ4tuM8KYvMKuEusbXrDDrFN
	TuLksclgcU4BD4mlZ38zQyxzl3j+uJttAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5
	mxgh4fdlB+PiY1aHGAU4GJV4eGds2REixJpYVlyZe4hRgoNZSYQ3Q2BniBBvSmJlVWpRfnxR
	aU5q8SFGJg5OqQbG5dun/u/jtsxhm5huc6dO6JGbkEBA/T2x6CW/VA/9nHOzx/TDG6dO1XXm
	M3be65iquLiUcTLLhKbfadc5TzS4rbVffDyjfaVwhkJI5Gq5zMcdaZqnjtrd2MF51caq4O13
	hvqoTd3OMff/7Jqk/UZIcPlZCdme3GUnl9+efGIW67E0gSCD8z5tSizFGYmGWsxFxYkAZ/mY
	9h0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses the enhancement of i2c API in order to address following problem
caused by circular lock dependency:

-> #1 (prepare_lock){+.+.+.}:
[    2.730502]        [<c0061e50>] __lock_acquire+0x3c0/0x8a4
[    2.735970]        [<c0062868>] lock_acquire+0x6c/0x8c
[    2.741090]        [<c04a2724>] mutex_lock_nested+0x68/0x464
[    2.746733]        [<c0395e84>] clk_prepare_lock+0x40/0xe8
[    2.752201]        [<c0397698>] clk_unprepare+0x18/0x28
[    2.757409]        [<c034cbb0>] s3c24xx_i2c_xfer+0xc8/0x124
[    2.762964]        [<c03457e0>] __i2c_transfer+0x74/0x8c
[    2.768259]        [<c0347234>] i2c_transfer+0x78/0xec
[    2.773380]        [<c02a177c>] regmap_i2c_read+0x48/0x64
[    2.778761]        [<c029d5c0>] _regmap_raw_read+0xa8/0xfc
[    2.784230]        [<c029d920>] _regmap_bus_read+0x28/0x48
[    2.789699]        [<c029ce00>] _regmap_read+0x74/0xdc
[    2.794819]        [<c029d0ec>] _regmap_update_bits+0x24/0x70
[    2.800549]        [<c029e348>] regmap_update_bits+0x40/0x5c
[    2.806190]        [<c024c3c4>] _regulator_do_disable+0x68/0x7c
[    2.812093]        [<c024f4d8>] _regulator_disable+0x90/0x12c
[    2.817822]        [<c024f5a8>] regulator_disable+0x34/0x60
[    2.823377]        [<c0363070>] mmc_regulator_set_ocr+0x74/0xdc
[    2.829279]        [<c03783e8>] sdhci_set_power+0x38/0x20c
[    2.834748]        [<c0379c10>] sdhci_do_set_ios+0x180/0x450
[    2.840389]        [<c0379f00>] sdhci_set_ios+0x20/0x2c
[    2.845597]        [<c0364978>] mmc_set_initial_state+0x5c/0xbc
[    2.851500]        [<c0364f48>] mmc_power_off+0x2c/0x60
[    2.856708]        [<c0365c00>] mmc_rescan+0x268/0x27c
[    2.861829]        [<c003a128>] process_one_work+0x18c/0x3f8
[    2.867471]        [<c003a400>] worker_thread+0x38/0x2f8
[    2.872766]        [<c003f66c>] kthread+0xe4/0x104
[    2.877540]        [<c000f0a8>] ret_from_fork+0x14/0x2c
[    2.882749]
-> #0 (&map->mutex){+.+...}:
[    2.886828]        [<c0061224>] validate_chain.isra.25+0x3bc/0x548
[    2.892990]        [<c0061e50>] __lock_acquire+0x3c0/0x8a4
[    2.898459]        [<c0062868>] lock_acquire+0x6c/0x8c
[    2.903580]        [<c04a2724>] mutex_lock_nested+0x68/0x464
[    2.909222]        [<c029ce9c>] regmap_read+0x34/0x5c
[    2.914257]        [<c039a994>] max_gen_clk_is_prepared+0x1c/0x38
[    2.920333]        [<c0396ec4>] clk_unprepare_unused_subtree+0x64/0x98
[    2.926842]        [<c0396f78>] clk_disable_unused+0x80/0xd8
[    2.932484]        [<c00089d0>] do_one_initcall+0xac/0x1f0
[    2.937953]        [<c068bd44>] do_basic_setup+0x90/0xc8
[    2.943248]        [<c068be00>] kernel_init_freeable+0x84/0x120
[    2.949150]        [<c0491248>] kernel_init+0x8/0xec
[    2.954097]        [<c000f0a8>] ret_from_fork+0x14/0x2c
[    2.959307]
[    2.959307] other info that might help us debug this:
[    2.959307]
[    2.967293]  Possible unsafe locking scenario:
[    2.967293]
[    2.973194]        CPU0                    CPU1
[    2.977708]        ----                    ----
[    2.982221]   lock(prepare_lock);
[    2.985520]                                lock(&map->mutex);
[    2.991248]                                lock(prepare_lock);
[    2.997063]   lock(&map->mutex);
[    3.000276]
[    3.000276]  *** DEADLOCK ***

Apparently regulator and clock try to acquire lock which is protecting the
same regmap. Communication over i2c requires clock to be started. Both things
require access to the same regmap in order to complete.
To solve this, i2c clock should be started before attempting operation on
regulator (which requires locked regmap).
Exposing preparation and unpreparation stage of i2c transfer serves this
purpose.
Proposed changes in regmap and regmap-i2c make use of exposed i2c transfer
preparation and unpreparation stages.
Note that this change does not require modifications in other places.

Signed-off-by: Paul Osmialowski <p.osmialowsk@samsung.com>
---
 drivers/base/regmap/internal.h   |   2 +
 drivers/base/regmap/regmap-i2c.c |  18 +++++++
 drivers/base/regmap/regmap.c     | 107 ++++++++++++++++++++++++++++++++++++++-
 include/linux/regmap.h           |   7 +++
 4 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 0da5865..fc8cbc9 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -94,6 +94,8 @@ struct regmap {
 	const struct regmap_access_table *volatile_table;
 	const struct regmap_access_table *precious_table;
 
+	int (*reg_prepare_sync_io)(void *context);
+	void (*reg_unprepare_sync_io)(void *context);
 	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
 	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
 
diff --git a/drivers/base/regmap/regmap-i2c.c b/drivers/base/regmap/regmap-i2c.c
index 053150a..09e95a6 100644
--- a/drivers/base/regmap/regmap-i2c.c
+++ b/drivers/base/regmap/regmap-i2c.c
@@ -87,6 +87,22 @@ static struct regmap_bus regmap_smbus_word = {
 	.reg_read = regmap_smbus_word_reg_read,
 };
 
+static int regmap_i2c_transfer_prepare(void *context)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	return i2c_transfer_prepare(i2c->adapter);
+}
+
+static void regmap_i2c_transfer_unprepare(void *context)
+{
+	struct device *dev = context;
+	struct i2c_client *i2c = to_i2c_client(dev);
+
+	i2c_transfer_unprepare(i2c->adapter);
+}
+
 static int regmap_i2c_write(void *context, const void *data, size_t count)
 {
 	struct device *dev = context;
@@ -165,6 +181,8 @@ static int regmap_i2c_read(void *context,
 }
 
 static struct regmap_bus regmap_i2c = {
+	.prepare_sync_io = regmap_i2c_transfer_prepare,
+	.unprepare_sync_io = regmap_i2c_transfer_unprepare,
 	.write = regmap_i2c_write,
 	.gather_write = regmap_i2c_gather_write,
 	.read = regmap_i2c_read,
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index d2f8a81..69e7d6b 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -36,6 +36,9 @@ static int _regmap_update_bits(struct regmap *map, unsigned int reg,
 			       unsigned int mask, unsigned int val,
 			       bool *change);
 
+static int regmap_bus_prepare_sync_io(void *context);
+static void regmap_bus_unprepare_sync_io(void *context);
+
 static int _regmap_bus_reg_read(void *context, unsigned int reg,
 				unsigned int *val);
 static int _regmap_bus_read(void *context, unsigned int reg,
@@ -617,6 +620,11 @@ struct regmap *regmap_init(struct device *dev,
 		map->reg_read  = _regmap_bus_read;
 	}
 
+	if (bus) {
+		map->reg_prepare_sync_io = regmap_bus_prepare_sync_io;
+		map->reg_unprepare_sync_io = regmap_bus_unprepare_sync_io;
+	}
+
 	reg_endian = regmap_get_reg_endian(bus, config);
 	val_endian = regmap_get_val_endian(dev, bus, config);
 
@@ -1440,11 +1448,48 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 map->format.val_bytes);
 }
 
+static int regmap_bus_prepare_sync_io(void *context)
+{
+	struct regmap *map = context;
+
+	if (map->bus->prepare_sync_io)
+		return map->bus->prepare_sync_io(map->bus_context);
+
+	return 0;
+}
+
+static void regmap_bus_unprepare_sync_io(void *context)
+{
+	struct regmap *map = context;
+
+	if (map->bus->unprepare_sync_io)
+		map->bus->unprepare_sync_io(map->bus_context);
+}
+
 static inline void *_regmap_map_get_context(struct regmap *map)
 {
 	return (map->bus) ? map : map->bus_context;
 }
 
+static int regmap_prepare_sync_io(struct regmap *map)
+{
+	void *context = _regmap_map_get_context(map);
+
+	if (map->reg_prepare_sync_io)
+		return map->reg_prepare_sync_io(context);
+
+	return 0;
+}
+
+static void regmap_unprepare_sync_io(struct regmap *map)
+{
+	void *context = _regmap_map_get_context(map);
+
+	if (map->reg_unprepare_sync_io)
+		map->reg_unprepare_sync_io(context);
+}
+
+
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val)
 {
@@ -1491,12 +1536,18 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 
 	ret = _regmap_write(map, reg, val);
 
 	map->unlock(map->lock_arg);
 
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_write);
@@ -1558,12 +1609,18 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 
 	ret = _regmap_raw_write(map, reg, val, val_len);
 
 	map->unlock(map->lock_arg);
 
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_raw_write);
@@ -1669,7 +1726,7 @@ EXPORT_SYMBOL_GPL(regmap_fields_update_bits);
 int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		     size_t val_count)
 {
-	int ret = 0, i;
+	int ret = 0, i, retv;
 	size_t val_bytes = map->format.val_bytes;
 
 	if (map->bus && !map->format.parse_inplace)
@@ -1682,6 +1739,9 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	 * them we have a series of single write operations.
 	 */
 	if (!map->bus || map->use_single_rw) {
+		retv = regmap_prepare_sync_io(map);
+		if (retv)
+			return retv;
 		map->lock(map->lock_arg);
 		for (i = 0; i < val_count; i++) {
 			unsigned int ival;
@@ -1713,15 +1773,21 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 		}
 out:
 		map->unlock(map->lock_arg);
+		regmap_unprepare_sync_io(map);
 	} else {
 		void *wval;
 
 		if (!val_count)
 			return -EINVAL;
 
+		retv = regmap_prepare_sync_io(map);
+		if (retv)
+			return retv;
+
 		wval = kmemdup(val, val_count * val_bytes, GFP_KERNEL);
 		if (!wval) {
 			dev_err(map->dev, "Error in memory allocation\n");
+			regmap_unprepare_sync_io(map);
 			return -ENOMEM;
 		}
 		for (i = 0; i < val_count * val_bytes; i += val_bytes)
@@ -1732,6 +1798,8 @@ out:
 		map->unlock(map->lock_arg);
 
 		kfree(wval);
+
+		regmap_unprepare_sync_io(map);
 	}
 	return ret;
 }
@@ -1936,12 +2004,18 @@ int regmap_multi_reg_write(struct regmap *map, const struct reg_default *regs,
 {
 	int ret;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 
 	ret = _regmap_multi_reg_write(map, regs, num_regs);
 
 	map->unlock(map->lock_arg);
 
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_multi_reg_write);
@@ -1970,6 +2044,10 @@ int regmap_multi_reg_write_bypassed(struct regmap *map,
 	int ret;
 	bool bypass;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 
 	bypass = map->cache_bypass;
@@ -1981,6 +2059,8 @@ int regmap_multi_reg_write_bypassed(struct regmap *map,
 
 	map->unlock(map->lock_arg);
 
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_multi_reg_write_bypassed);
@@ -2148,12 +2228,18 @@ int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val)
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 
 	ret = _regmap_read(map, reg, val);
 
 	map->unlock(map->lock_arg);
 
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_read);
@@ -2184,6 +2270,10 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	if (reg % map->reg_stride)
 		return -EINVAL;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 
 	if (regmap_volatile_range(map, reg, val_count) || map->cache_bypass ||
@@ -2208,6 +2298,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
  out:
 	map->unlock(map->lock_arg);
 
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_raw_read);
@@ -2370,10 +2462,16 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 	ret = _regmap_update_bits(map, reg, mask, val, NULL);
 	map->unlock(map->lock_arg);
 
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits);
@@ -2430,9 +2528,16 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	ret = regmap_prepare_sync_io(map);
+	if (ret)
+		return ret;
+
 	map->lock(map->lock_arg);
 	ret = _regmap_update_bits(map, reg, mask, val, change);
 	map->unlock(map->lock_arg);
+
+	regmap_unprepare_sync_io(map);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 4419b99..74aace5 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -265,6 +265,8 @@ struct regmap_range_cfg {
 
 struct regmap_async;
 
+typedef int (*regmap_hw_prepare_sync_io)(void *context);
+typedef void (*regmap_hw_unprepare_sync_io)(void *context);
 typedef int (*regmap_hw_write)(void *context, const void *data,
 			       size_t count);
 typedef int (*regmap_hw_gather_write)(void *context,
@@ -291,6 +293,9 @@ typedef void (*regmap_hw_free_context)(void *context);
  *	     to perform locking. This field is ignored if custom lock/unlock
  *	     functions are used (see fields lock/unlock of
  *	     struct regmap_config).
+ * @prepare_sync_io: Prepare for read/write operation (if needed, e.g. to obtain
+ *           locks earlier).
+ * @unprepare_sync_io: Unprepare after read/write operation (if needed).
  * @write: Write operation.
  * @gather_write: Write operation with split register/value, return -ENOTSUPP
  *                if not implemented  on a given device.
@@ -311,6 +316,8 @@ typedef void (*regmap_hw_free_context)(void *context);
  */
 struct regmap_bus {
 	bool fast_io;
+	regmap_hw_prepare_sync_io prepare_sync_io;
+	regmap_hw_unprepare_sync_io unprepare_sync_io;
 	regmap_hw_write write;
 	regmap_hw_gather_write gather_write;
 	regmap_hw_async_write async_write;
-- 
1.9.1

