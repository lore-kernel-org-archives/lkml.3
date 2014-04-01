Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaDANpm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:45:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56464 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbaDANpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:45:13 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <sameo@linux.intel.com>, <nm@ti.com>
Subject: [RESEND 3/3] mfd: twl6040: Clear the interrupt ID register before requesting IRQ
Date: Tue, 1 Apr 2014 16:45:01 +0300
Message-ID: <1396359901-32656-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396359901-32656-1-git-send-email-peter.ujfalusi@ti.com>
References: <1396359901-32656-1-git-send-email-peter.ujfalusi@ti.com>
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
index dc5c05940e96..2e6504a8e1e3 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -687,6 +687,9 @@ static int twl6040_probe(struct i2c_client *client,
 					    GPIOF_OUT_INIT_LOW, "audpwron");
 		if (ret)
 			goto gpio_err;
+
+		/* Clear any pending interrupt */
+		twl6040_reg_read(twl6040, TWL6040_REG_INTID);
 	}
 
 	ret = regmap_add_irq_chip(twl6040->regmap, twl6040->irq, IRQF_ONESHOT,
-- 
1.9.1

