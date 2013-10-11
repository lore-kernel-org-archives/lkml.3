Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3JKOtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:49:50 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.120]:48345 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047Ab3JKOts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:49:48 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Oct 2013 10:49:48 EDT
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-9.tower-193.messagelabs.com!1381502580!10642736!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201310111442.r9BEgxmJ029386@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Fri, 11 Oct 2013 15:31:11 +0100
Subject: [PATCH V1] new API regmap_multi_reg_write() definition
To: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New API regmap_multi_reg_write() is defined that allows a set of reg,val
pairs to be written to a I2C client device as one block transfer from the
point of view of a single I2C master system.

A simple demonstration implementation is included that just splits the
block write request into a sequence of single register writes.

The implementation will be modified later to support those I2C clients
that implement the alternative non-standard MULTIWRITE block write mode
so to achieve a single I2C transfer that will be atomic even in multiple
I2C master systems.

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

This patch only defines an API that will, after the implementation has been
modified later, support the non-standard I2C MULTIWRITE atomic single I2C
transfer.

The API is also expected to be useful, in single I2C master systems,
for device drivers that need to patch a non-sequential set of registers
in one mutex protected go.

 drivers/base/regmap/regmap.c |   41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |    2 ++
 2 files changed, 43 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7d689a1..c42ad69 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1439,6 +1439,47 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
+/*
+ * regmap_multi_reg_write(): Write multiple registers to the device
+ *
+ * where the set of register are supplied in any order
+ *
+ * @map: Register map to write to
+ * @regs: Array of structures containing register,value to be written
+ * @num_regs: Number of registers to write
+ *
+ * This function is intended to be used for writing a large block of data
+ * atomically to the device in single transfer for those I2C client devices
+ * that implement this alternative block write mode.
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_multi_reg_write(struct regmap *map, struct reg_default *regs,
+				int num_regs)
+{
+	int ret = 0, i;
+
+	for (i = 0; i < num_regs; i++) {
+		int reg = regs[i].reg;
+		if (reg % map->reg_stride)
+			return -EINVAL;
+	}
+
+	map->lock(map->lock_arg);
+
+	for (i = 0; i < num_regs; i++) {
+		ret = _regmap_write(map, regs[i].reg, regs[i].def);
+		if (ret != 0)
+			goto out;
+	}
+out:
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_multi_reg_write);
+
 /**
  * regmap_raw_write_async(): Write raw values to one or more registers
  *                           asynchronously
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index a10380b..4b933a3 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -378,6 +378,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
 int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 			size_t val_count);
+int regmap_multi_reg_write(struct regmap *map, struct reg_default *regs,
+			int num_regs);
 int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 			   const void *val, size_t val_len);
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
-- 
end-of-patch for new API regmap_multi_reg_write() definition V1

