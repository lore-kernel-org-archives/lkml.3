Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaB0N5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:57:11 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbaB0N5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:57:03 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 3/3] mfd: twl6040: Clear the interrupt ID register before requesting IRQ
Date: Thu, 27 Feb 2014 15:56:50 +0200
Message-ID: <1393509410-1640-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com>
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If for some reason the boot loader enabled the audpwron GPIO we will have
pending IRQs to be handled. This seams to break twl6040 for some reason
leading to non working i2c communication (i2c timeouts). Clearing the INTID
register after we requested the audpwron GPIO (and set it to low) will
ensure that the chip will operate normally in this case as well.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 693d547db1de..ea8acfb029df 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -688,6 +688,9 @@ static int twl6040_probe(struct i2c_client *client,
 					    GPIOF_OUT_INIT_LOW, "audpwron");
 		if (ret)
 			goto gpio_err;
+
+		/* Clear any pending interrupt */
+		twl6040_reg_read(twl6040, TWL6040_REG_INTID);
 	}
 
 	ret = regmap_add_irq_chip(twl6040->regmap, twl6040->irq, IRQF_ONESHOT,
-- 
1.9.0

