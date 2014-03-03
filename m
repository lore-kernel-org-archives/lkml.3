Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaCCTwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:52:04 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49908 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893AbaCCTv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:51:57 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Thomas Gleixner <tglx@linutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V3 4/5] mfd: palmas: support IRQ inversion at the board level
Date: Mon,  3 Mar 2014 12:51:39 -0700
Message-Id: <1393876300-3061-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
References: <1393876300-3061-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Implement the new DT property ti,irq-externally-inverted, and add an
equivalent platform data field to match. This allows the driver to
correctly automatically configure the IRQ output polarity when the board
or SoC contains an inverter between the Palmas IRQ output and IRQ
controller input.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v3:
* Use an IRQD flag to represent the data, rather than a custom DT property.
v2:
* Split V1's patch 1/2 into separate patches 1/3 and 2/3.
---
 drivers/mfd/palmas.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index d280d789e55a..3281d4103e9d 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -292,7 +292,8 @@ static int palmas_set_pdata_irq_flag(struct i2c_client *i2c,
 		return -EINVAL;
 	}
 
-	pdata->irq_flags = irqd_get_trigger_type(irq_data);
+	pdata->irq_flags = irqd_get_trigger_type(irq_data) |
+			   irqd_get_src_dst_inverted(irq_data);
 	dev_info(&i2c->dev, "Irq flag is 0x%08x\n", pdata->irq_flags);
 	return 0;
 }
@@ -447,6 +448,8 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 		reg = PALMAS_POLARITY_CTRL_INT_POLARITY;
 	else
 		reg = 0;
+	if (pdata->irq_flags & IRQ_SRC_DST_INVERTED)
+		reg ^= PALMAS_POLARITY_CTRL_INT_POLARITY;
 	ret = palmas_update_bits(palmas, PALMAS_PU_PD_OD_BASE,
 			PALMAS_POLARITY_CTRL, PALMAS_POLARITY_CTRL_INT_POLARITY,
 			reg);
-- 
1.8.1.5

