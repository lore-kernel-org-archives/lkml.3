Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaB0LrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 06:47:24 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.152]:28439 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752126AbaB0LrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 06:47:21 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-4.tower-178.messagelabs.com!1393501634!24817953!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402271146.s1RBkCGg004925@swsrvapps-02.lan>
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Date: Thu, 27 Feb 2014 11:28:56 +0000
Subject: [RFC V1] drivers/base/regmap: Implementation for
 regmap_multi_reg_write
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the implementation of regmap_multi_reg_write()

It replaces the first definition, which just defined the API.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140224

The API definition of regmap_multi_reg_write()
has been in the kernel mainline since v3.13

This patch suggests an implementation that works for DA9052
family of PMIC chips from Dialog Semiconductor.

I believe this implementation will work in the presense of
register ranges because the algorithm will chop the set of
(reg,val) changes each time the page changes.

Please feel free to comment on this implementation, in particular:

a) should an async operation be allowed? easy in the case where
   all the changes are in the same page - but if the operation
   is broken due to changes over several pages not so easy.
b) the user supplied set (array of struct reg_default) of changes
   has the register address modified when the target page alters.
   Would it be better not to do an in-situ change, but rather to
   alloc a new array of struct reg_default?


 drivers/base/regmap/regmap.c |  212 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 201 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 2b4e72f..90f3d57 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1442,6 +1442,7 @@ int regmap_field_write(struct regmap_field *field, unsigned int val)
 }
 EXPORT_SYMBOL_GPL(regmap_field_write);
 
+
 /**
  * regmap_field_update_bits():	Perform a read/modify/write cycle
  *                              on the register field
@@ -1591,26 +1592,206 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
+static int _switch_register_page(struct regmap *map, unsigned int  win_page,
+					struct regmap_range_node *range)
+{
+	int ret;
+	bool page_chg;
+	void *orig_work_buf = map->work_buf;
+	unsigned int swp;
+
+	map->work_buf = map->selector_work_buf;
+
+	swp = win_page << range->selector_shift;
+	ret = _regmap_update_bits(map,
+				range->selector_reg,
+				range->selector_mask,
+				swp, &page_chg);
+
+	map->work_buf = orig_work_buf;
+
+	return ret;
+}
+/*
+ * _regmap_raw_multi_reg_write()
+ *
+ * the (register,newvalue) pairs in regs have not been formatted, but
+ * they are all in the same page and have been changed to being page
+ * relative. The page register has been written if that was neccessary.
+ */
+static int _regmap_raw_multi_reg_write(struct regmap *map,
+					struct reg_default *regs,
+					size_t num_regs)
+{
+	int ret;
+	void *buf;
+	int i;
+	u8 *u8;
+	size_t val_bytes = map->format.val_bytes;
+	size_t reg_bytes = map->format.reg_bytes;
+	size_t pad_bytes = map->format.pad_bytes;
+	size_t pair_size = reg_bytes + pad_bytes + val_bytes;
+	size_t len = pair_size * num_regs;
+
+	buf = kzalloc(len , GFP_KERNEL);
+
+	if (!buf)
+		return -ENOMEM;
+
+	/* We have to linearise by hand. */
+
+	u8 = buf;
+
+	for (i = 0; i < num_regs; i++) {
+		int reg = regs[i].reg;
+		int val = regs[i].def;
+		trace_regmap_hw_write_start(map->dev, reg, 1);
+		map->format.format_reg(u8, reg, map->reg_shift);
+		u8 += reg_bytes + pad_bytes;
+		map->format.format_val(u8, val, 0);
+		u8 += val_bytes;
+	}
+	u8 = buf;
+	*u8 |= map->write_flag_mask;
+
+	ret = map->bus->write(map->bus_context, buf, len);
+
+	kfree(buf);
+
+	for (i = 0; i < num_regs; i++) {
+		int reg = regs[i].reg;
+		trace_regmap_hw_write_done(map->dev, reg, 1);
+	}
+	return ret;
+}
+
+static int _regmap_multi_reg_write(struct regmap *map,
+				struct reg_default *regs,
+				size_t num_regs)
+{
+	int i, n;
+	int ret;
+	struct reg_default *base;
+	bool switched;
+	unsigned int this_page;
+
+	if (!map->format.parse_inplace)
+		return -EINVAL;
+
+	if (map->writeable_reg)
+		for (i = 0; i < num_regs; i++)
+			if (!map->writeable_reg(map->dev, regs[i].reg))
+				return -EINVAL;
+
+	if (!map->cache_bypass) {
+		for (i = 0; i < num_regs; i++) {
+			unsigned int val = regs[i].def;
+			unsigned int reg = regs[i].reg;
+			ret = regcache_write(map, reg, val);
+			if (ret) {
+				dev_err(map->dev,
+				"Error in caching of register: %x ret: %d\n",
+								reg, ret);
+				return ret;
+			}
+		}
+		if (map->cache_only) {
+			map->cache_dirty = true;
+			return 0;
+		}
+	}
+
+	WARN_ON(!map->bus);
+
+	/*
+	 * the set of registers are not neccessarily in order, but
+	 * since the order of write must be preserved this algorithm
+	 * chops the set each time the page changes
+	 */
+	for (i = 0, n = 0, switched = false, base = regs; i < num_regs;
+								i++, n++) {
+		unsigned int reg = regs[i].reg;
+		struct regmap_range_node *range;
+
+		range = _regmap_range_lookup(map, reg);
+		if (range) {
+			unsigned int win_page = (reg - range->range_min)
+						/ range->window_len;
+			unsigned int win_offset = (reg - range->range_min)
+						% range->window_len;
+			int rel = range->window_start + win_offset;
+			regs[i].reg = rel;
+
+			if (rel == range->selector_reg) {
+				this_page = (regs[i].def & range->selector_mask)
+						 >> range->selector_shift;
+				switched = true;
+			} else if (switched) {
+				if (win_page != this_page) {
+					ret = _regmap_raw_multi_reg_write(map,
+								base, n);
+					if (ret != 0)
+						return ret;
+					base += n;
+					n = 0;
+					ret = _switch_register_page(map,
+							win_page, range);
+					if (ret != 0)
+						return ret;
+					this_page = win_page;
+				}
+			} else {
+				switched = true;
+
+				if (n > 0) {
+					ret = _regmap_raw_multi_reg_write(map,
+								 base, n);
+					if (ret != 0)
+						return ret;
+					base += n;
+					n = 0;
+				}
+				ret = _switch_register_page(map, win_page,
+								range);
+				if (ret != 0)
+					return ret;
+				this_page = win_page;
+			}
+		}
+	}
+	if (n > 0)
+		return _regmap_raw_multi_reg_write(map, base, n);
+	return 0;
+}
+
 /*
  * regmap_multi_reg_write(): Write multiple registers to the device
  *
- * where the set of register are supplied in any order
+ * where the set of register,value pairs are supplied in any order,
+ * possibly not all in a single range.
  *
  * @map: Register map to write to
  * @regs: Array of structures containing register,value to be written
  * @num_regs: Number of registers to write
  *
- * This function is intended to be used for writing a large block of data
- * atomically to the device in single transfer for those I2C client devices
- * that implement this alternative block write mode.
+ * The 'normal' block write mode will send ultimately send data on the
+ * target bus as R,V1,V2,V3,..,Vn where successively higer registers are
+ * addressed. However, this alternative block multi write mode will send
+ * the data as R1,V1,R2,V2,..,Rn,Vn on the target bus. The target device
+ * must of course support the mode.
  *
- * A value of zero will be returned on success, a negative errno will
- * be returned in error cases.
+ * A value of zero will be returned on success, a negative errno will be
+ * returned in error cases.
  */
 int regmap_multi_reg_write(struct regmap *map, struct reg_default *regs,
 				int num_regs)
+
 {
-	int ret = 0, i;
+	int i;
+	int ret = 0;
+
+	if (!map->bus)
+		return -EINVAL;
 
 	for (i = 0; i < num_regs; i++) {
 		int reg = regs[i].reg;
@@ -1620,11 +1801,20 @@ int regmap_multi_reg_write(struct regmap *map, struct reg_default *regs,
 
 	map->lock(map->lock_arg);
 
-	for (i = 0; i < num_regs; i++) {
-		ret = _regmap_write(map, regs[i].reg, regs[i].def);
-		if (ret != 0)
-			goto out;
+	/*
+	 * Some devices do not support multi write, for
+	 * them we have a series of single write operations.
+	 */
+	if (map->use_single_rw) {
+		for (i = 0; i < num_regs; i++) {
+			ret = _regmap_write(map, regs[i].reg, regs[i].def);
+			if (ret != 0)
+				goto out;
+		}
+	} else {
+		ret = _regmap_multi_reg_write(map, regs, num_regs);
 	}
+
 out:
 	map->unlock(map->lock_arg);
 
-- 
end-of-rfc 1/1 for drivers/base/regmap: Implementation for regmap_multi_reg_write V1

