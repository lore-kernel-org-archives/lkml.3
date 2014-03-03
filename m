Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaCCRL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 12:11:57 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.139]:37832 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602AbaCCRL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 12:11:56 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-6.tower-179.messagelabs.com!1393866712!29731908!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201403031711.s23HBmjF024145@swsrvapps-02.lan>
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Date: Mon, 3 Mar 2014 17:02:51 +0000
Subject: [RFC V2] drivers/base/regmap: Implementation for
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

This patch is relative to linux-next repository tag next-20140228

The API definition of regmap_multi_reg_write()
has been in the kernel mainline since v3.13

This patch suggests an implementation that works for DA9052
family of PMIC chips from Dialog Semiconductor.

This implementation will work in the presense of register ranges
because the algorithm will chop the set of (reg,val) changes each
time the page changes. This part of the algorithm will be need
for other Dialog PMIC that both need to use the Multi Register
Write mode and use paged registers.

The big difference between this attempt and V1 is that the
set of (reg,val) changes are now treated as 'const ...' and
the simplest option of doing a pre pass to catch possible
register changes to page relative is done so that in-situ
changes can be made to an kalloc'ed copy.

A minor change is moving knowledge of the range structure
from _regmap_range_multi_paged_reg_write() to a new static
function _regmap_register_page(). Specifically the function
_regmap_select_page() will send an I2C command if the register
is in a new page, whereas the algorothm needs to know in advance
when the page is going to change so that the fragment of multi
register writes can be sent out to the I2C device.

Please feel free to comment on this implementation. This patch
has only had limited testing with a DA9053 chip so the real
attempt to submit into the MainLine will come later giving any
reviewer ample time to make constructive comments.


 drivers/base/regmap/regmap.c |  175 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 159 insertions(+), 16 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0e5c833..c17a2e1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1591,41 +1591,184 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
+/*
+ * _regmap_raw_multi_reg_write()
+ *
+ * the (register,newvalue) pairs in regs have not been formatted, but
+ * they are all in the same page and have been changed to being page
+ * relative. The page register has been written if that was neccessary.
+ */
+static int _regmap_raw_multi_reg_write(struct regmap *map,
+				       const struct reg_default *regs,
+				       size_t num_regs)
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
+	buf = kzalloc(len, GFP_KERNEL);
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
+static unsigned int _regmap_register_page(struct regmap *map,
+					  unsigned int reg,
+					  struct regmap_range_node *range)
+{
+	unsigned int win_page = (reg - range->range_min) / range->window_len;
+
+	return win_page;
+}
+
+static int _regmap_range_multi_paged_reg_write(struct regmap *map,
+					       struct reg_default *regs,
+					       size_t num_regs)
+{
+	int ret;
+	int i, n;
+	struct reg_default *base;
+	unsigned int this_page;
+	/*
+	 * the set of registers are not neccessarily in order, but
+	 * since the order of write must be preserved this algorithm
+	 * chops the set each time the page changes
+	 */
+	base = regs;
+	for (i = 0, n = 0; i < num_regs; i++, n++) {
+		unsigned int reg = regs[i].reg;
+		struct regmap_range_node *range;
+
+		range = _regmap_range_lookup(map, reg);
+		if (range) {
+			unsigned int win_page = _regmap_register_page(map,
+								      reg,
+								      range);
+
+			if (i == 0)
+				this_page = win_page;
+			if (win_page != this_page) {
+				this_page = win_page;
+				ret = _regmap_raw_multi_reg_write(map, base, n);
+				if (ret != 0)
+					return ret;
+				base += n;
+				n = 0;
+			}
+			ret = _regmap_select_page(map, &base[n].reg, range, 1);
+			if (ret != 0)
+				return ret;
+		}
+	}
+	if (n > 0)
+		return _regmap_raw_multi_reg_write(map, base, n);
+	return 0;
+}
+
 static int _regmap_multi_reg_write(struct regmap *map,
 				   const struct reg_default *regs,
-				   int num_regs)
+				   size_t num_regs)
 {
-	int i, ret;
+	int i;
+	int ret;
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
 
 	for (i = 0; i < num_regs; i++) {
-		if (regs[i].reg % map->reg_stride)
-			return -EINVAL;
-		ret = _regmap_write(map, regs[i].reg, regs[i].def);
-		if (ret != 0) {
-			dev_err(map->dev, "Failed to write %x = %x: %d\n",
-				regs[i].reg, regs[i].def, ret);
+		unsigned int reg = regs[i].reg;
+		struct regmap_range_node *range;
+		range = _regmap_range_lookup(map, reg);
+		if (range) {
+			size_t len = sizeof(struct reg_default)*num_regs;
+			struct reg_default *base = kmemdup(regs, len,
+							   GFP_KERNEL);
+			if (!base)
+				return -ENOMEM;
+			ret = _regmap_range_multi_paged_reg_write(map, base,
+								  num_regs);
+			kfree(base);
+
 			return ret;
 		}
 	}
-
-	return 0;
+	return _regmap_raw_multi_reg_write(map, regs, num_regs);
 }
 
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
 int regmap_multi_reg_write(struct regmap *map, const struct reg_default *regs,
 			   int num_regs)
-- 
end-of-rfc 1/1 for drivers/base/regmap: Implementation for regmap_multi_reg_write V2

