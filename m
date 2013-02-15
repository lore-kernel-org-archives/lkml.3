Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161887Ab3BOM60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:58:26 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49960 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161328Ab3BOM6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:58:15 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 27/35] mfd: ab8500-debugfs: Dump sim registers
Date: Fri, 15 Feb 2013 12:56:58 +0000
Message-Id: <1360933026-30325-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch allows to dump the SIM registers from debugfs. It will
temporary change the config to allow APE side to read the SIM registers.
Note that this read can cause problem on modem side since the modem
can't read these registers while the operation is ongoing.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   78 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 7173406..a301f10 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1243,6 +1243,79 @@ static int ab8500_hwreg_open(struct inode *inode, struct file *file)
 	return single_open(file, ab8500_hwreg_print, inode->i_private);
 }
 
+#define AB8500_SUPPLY_CONTROL_CONFIG_1 0x01
+#define AB8500_SUPPLY_CONTROL_REG 0x00
+#define AB8500_FIRST_SIM_REG 0x80
+#define AB8500_LAST_SIM_REG 0x8B
+#define AB8505_LAST_SIM_REG 0x8C
+
+static int ab8500_print_modem_registers(struct seq_file *s, void *p)
+{
+	struct device *dev = s->private;
+	struct ab8500 *ab8500;
+	int err;
+	u8 value;
+	u8 orig_value;
+	u32 bank = AB8500_REGU_CTRL2;
+	u32 last_sim_reg = AB8500_LAST_SIM_REG;
+	u32 reg;
+
+	ab8500 = dev_get_drvdata(dev->parent);
+	dev_warn(dev, "WARNING! This operation can interfer with modem side\n"
+		"and should only be done with care\n");
+
+	err = abx500_get_register_interruptible(dev,
+		AB8500_REGU_CTRL1, AB8500_SUPPLY_CONTROL_REG, &orig_value);
+	if (err < 0) {
+		dev_err(dev, "ab->read fail %d\n", err);
+		return err;
+	}
+	/* Config 1 will allow APE side to read SIM registers */
+	err = abx500_set_register_interruptible(dev,
+		AB8500_REGU_CTRL1, AB8500_SUPPLY_CONTROL_REG,
+		AB8500_SUPPLY_CONTROL_CONFIG_1);
+	if (err < 0) {
+		dev_err(dev, "ab->write fail %d\n", err);
+		return err;
+	}
+
+	seq_printf(s, " bank 0x%02X:\n", bank);
+
+	if (is_ab9540(ab8500) || is_ab8505(ab8500))
+		last_sim_reg = AB8505_LAST_SIM_REG;
+
+	for (reg = AB8500_FIRST_SIM_REG; reg <= last_sim_reg; reg++) {
+		err = abx500_get_register_interruptible(dev,
+			bank, reg, &value);
+		if (err < 0) {
+			dev_err(dev, "ab->read fail %d\n", err);
+			return err;
+		}
+		err = seq_printf(s, "  [0x%02X/0x%02X]: 0x%02X\n",
+			bank, reg, value);
+	}
+	err = abx500_set_register_interruptible(dev,
+		AB8500_REGU_CTRL1, AB8500_SUPPLY_CONTROL_REG, orig_value);
+	if (err < 0) {
+		dev_err(dev, "ab->write fail %d\n", err);
+		return err;
+	}
+	return 0;
+}
+
+static int ab8500_modem_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ab8500_print_modem_registers, inode->i_private);
+}
+
+static const struct file_operations ab8500_modem_fops = {
+	.open = ab8500_modem_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static int ab8500_gpadc_bat_ctrl_print(struct seq_file *s, void *p)
 {
 	int bat_ctrl_raw;
@@ -2569,6 +2642,11 @@ static int ab8500_debug_probe(struct platform_device *plf)
 	if (!file)
 		goto err;
 
+	file = debugfs_create_file("all-modem-registers", (S_IRUGO | S_IWUGO),
+	    ab8500_dir, &plf->dev, &ab8500_modem_fops);
+	if (!file)
+		goto err;
+
 	file = debugfs_create_file("bat_ctrl", (S_IRUGO | S_IWUSR),
 	    ab8500_gpadc_dir, &plf->dev, &ab8500_gpadc_bat_ctrl_fops);
 	if (!file)
-- 
1.7.10.4

