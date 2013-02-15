Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936029Ab3BONF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:05:27 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58545 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161738Ab3BOM5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:37 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: [PATCH 08/35] mfd: ab8500-debug: Function to save all ABB registers to mem
Date: Fri, 15 Feb 2013 12:56:39 +0000
Message-Id: <1360933026-30325-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dump function that stores all readable ABB registers to a memory
areas where they can be accessed from dump file.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   50 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 18ff86b..250b77b 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -600,6 +600,56 @@ void ab8500_dump_all_banks(struct device *dev)
 	}
 }
 
+/* Space for 500 registers. */
+#define DUMP_MAX_REGS 700
+struct ab8500_register_dump
+{
+	u8 bank;
+	u8 reg;
+	u8 value;
+	int ret;
+} ab8500_complete_register_dump[DUMP_MAX_REGS];
+
+extern int prcmu_abb_read(u8 slave, u8 reg, u8 *value, u8 size);
+
+/* This shall only be called upon kernel panic! */
+void ab8500_dump_all_banks_to_mem(void)
+{
+	int i, r = 0;
+	u8 bank;
+
+	pr_info("Saving all ABB registers at \"ab8500_complete_register_dump\" "
+		"for crash analyze.\n");
+
+	for (bank = 1; bank < AB8500_NUM_BANKS; bank++) {
+		for (i = 0; i < debug_ranges[bank].num_ranges; i++) {
+			u8 reg;
+
+			for (reg = debug_ranges[bank].range[i].first;
+			     reg <= debug_ranges[bank].range[i].last;
+			     reg++) {
+				u8 value;
+				int err;
+
+				err = prcmu_abb_read(bank, reg, &value, 1);
+
+				ab8500_complete_register_dump[r].ret = err;
+				ab8500_complete_register_dump[r].bank = bank;
+				ab8500_complete_register_dump[r].reg = reg;
+				ab8500_complete_register_dump[r].value = value;
+
+				r++;
+
+				if (r >= DUMP_MAX_REGS) {
+					pr_err("%s: too many register to dump!\n",
+						__func__);
+					return;
+				}
+			}
+		}
+	}
+}
+
 static int ab8500_all_banks_open(struct inode *inode, struct file *file)
 {
 	struct seq_file *s;
-- 
1.7.10.4

