Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3JJLBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:01:10 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.165]:24156 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab3JJLBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:01:08 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Oct 2013 07:01:07 EDT
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-9.tower-38.messagelabs.com!1381402433!601121!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201310101053.r9AArpal039552@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Thu, 10 Oct 2013 11:50:23 +0100
Subject: [PATCH V1] new API regmap_multi_write()
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New API regmap_multi_write() to support a single I2C transfer consisting
of writes to multiple non-sequential registers for those I2C clients that
implement the alternative non-standard MULTIWRITE block write mode.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
This patch is relative to linux-mainline repository tag v3.12-rc4

The Dialog DA9052 family of multifunction power management devices implement
an alternative non-standard I2C MULTIWRITE block write mode that appears on
the I2C bus looking like a normal block write A1-D1-D2-D3-..-Dn, but in fact
the I2C client decodes the bytes as A1-D1-A2-D2-A3-D3-..-An-Dn, where both
the data and addresses are 8 bits wide.

The reason for this unusual mode is to ensure that the set of registers are
recieved atomically, and is crutial in a multi-I2C-master system where the
application processor (a modem chip for example) competes for the I2C bus.

This patch only adds functionality, it does not alter any existing regmap API.

The new API works in the degenerative case of a single register write as well.
 drivers/base/regmap/regmap.c |  144 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |    2 +
 2 files changed, 146 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7d689a1..d47b00d 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1439,6 +1439,150 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
+int _regmap_raw_multi_write(struct regmap *map, size_t reg_count,
+			    unsigned int *reg, const void *val)
+{
+	u8 *u8;
+	void *buf;
+	int ret;
+	size_t len;
+	int i;
+	size_t unit_len;
+	int val_bytes = map->format.val_bytes;
+
+	WARN_ON(!map->bus);
+
+	/* Check for unwritable registers before we start */
+	if (map->writeable_reg)
+		for (i = 0; i < reg_count; i++)
+			if (!map->writeable_reg(map->dev,
+						reg[i]))
+				return -EINVAL;
+
+	if (!map->cache_bypass && map->format.parse_val) {
+		unsigned int ival;
+		for (i = 0; i < reg_count; i++) {
+			ival = map->format.parse_val(val + (i * val_bytes));
+			ret = regcache_write(map, reg[i], ival);
+			if (ret) {
+				dev_err(map->dev,
+					"Error in caching of register: %x ret: %d\n",
+					reg[i], ret);
+				return ret;
+			}
+		}
+		if (map->cache_only) {
+			map->cache_dirty = true;
+			return 0;
+		}
+	}
+
+	trace_regmap_hw_write_start(map->dev, reg[0], reg_count);
+
+	/* Because a multi-write has an array of registers and an array
+	 * of values a gather_write will not work and in the simple case
+	 * of a single register write the client driver should not be
+	 * using this API anyway. So we have to linearise by hand.
+	 */
+	unit_len = map->format.reg_bytes + map->format.pad_bytes + val_bytes;
+
+	len = reg_count * unit_len;
+	buf = kzalloc(len, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+	u8 = buf;
+
+	for (i = 0; i < reg_count; i++) {
+
+		map->format.format_reg(u8, reg[i], map->reg_shift);
+		*u8 |= map->write_flag_mask;
+		u8 += map->format.reg_bytes + map->format.pad_bytes;
+
+		memcpy(u8, val + (i * val_bytes), val_bytes);
+		u8 += val_bytes;
+	}
+
+	ret = map->bus->write(map->bus_context, buf, len);
+
+	kfree(buf);
+
+	trace_regmap_hw_write_done(map->dev, reg[0], reg_count);
+
+	return ret;
+}
+
+/*
+ * regmap_multi_write(): Write multiple non sequential registers to the device
+ *
+ * @map: Register map to write to
+ * @reg: Array of registers to be written, all on the same page
+ * @val: Block of data to be written, in native register size for device
+ * @reg_count: Number of registers to write
+ *
+ * This function is intended to be used for writing a large block of data
+ * atomically to the device in single transfer for those I2C client devices
+ * that implement this alternative block write mode.
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_multi_write(struct regmap *map, unsigned int *reg, const void *val,
+		     size_t reg_count)
+{
+	int ret = 0, i;
+	size_t val_bytes = map->format.val_bytes;
+	void *wval;
+
+	if (!map->bus)
+		return -EINVAL;
+	if (!map->format.parse_inplace)
+		return -EINVAL;
+
+	map->lock(map->lock_arg);
+
+	/* No formatting is require if val_byte is 1 */
+	if (val_bytes == 1) {
+		wval = (void *)val;
+	} else {
+		wval = kmemdup(val, reg_count * val_bytes, GFP_KERNEL);
+		if (!wval) {
+			ret = -ENOMEM;
+			dev_err(map->dev, "Error in memory allocation\n");
+			goto out;
+		}
+		for (i = 0; i < reg_count * val_bytes; i += val_bytes)
+			map->format.parse_inplace(wval + i);
+	}
+	/*
+	 * Some devices do not support multi write, for
+	 * them we have a series of single write operations.
+	 */
+	if (map->use_single_rw) {
+		for (i = 0; i < reg_count; i++) {
+			ret = _regmap_raw_write(map,
+						reg[i],
+						val + (i * val_bytes),
+						val_bytes,
+						false);
+			if (ret != 0)
+				return ret;
+		}
+	} else {
+		ret = _regmap_raw_multi_write(map,
+					      reg_count,
+					      reg,
+					      wval);
+	}
+
+	if (val_bytes != 1)
+		kfree(wval);
+
+out:
+	map->unlock(map->lock_arg);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_multi_write);
+
 /**
  * regmap_raw_write_async(): Write raw values to one or more registers
  *                           asynchronously
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a10380b..f9c16db 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -378,6 +378,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
 int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 			size_t val_count);
+int regmap_multi_write(struct regmap *map, unsigned int *reg, const void *val,
+			size_t reg_count);
 int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 			   const void *val, size_t val_len);
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
-- 
end-of-patch for new API regmap_multi_write() V1

