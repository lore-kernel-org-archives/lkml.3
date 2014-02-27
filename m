Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaB0N5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:57:14 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36832 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaB0N5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:57:02 -0500
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/3] mfd: twl6040: Move register patching earlier in probe
Date: Thu, 27 Feb 2014 15:56:49 +0200
Message-ID: <1393509410-1640-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com>
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we patch the ACCCTL register as the first thing when the
driver loads, thus configuring I2C fast mode and i2c access for dual access
registers.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/mfd/twl6040.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index 2c308750f40f..693d547db1de 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -665,6 +665,10 @@ static int twl6040_probe(struct i2c_client *client,
 	mutex_init(&twl6040->mutex);
 	init_completion(&twl6040->ready);
 
+	regmap_register_patch(twl6040->regmap, twl6040_patch,
+			      ARRAY_SIZE(twl6040_patch));
+
+
 	twl6040->rev = twl6040_reg_read(twl6040, TWL6040_REG_ASICREV);
 	if (twl6040->rev < 0) {
 		dev_err(&client->dev, "Failed to read revision register: %d\n",
@@ -712,10 +716,6 @@ static int twl6040_probe(struct i2c_client *client,
 		goto readyirq_err;
 	}
 
-	/* dual-access registers controlled by I2C only */
-	regmap_register_patch(twl6040->regmap, twl6040_patch,
-			      ARRAY_SIZE(twl6040_patch));
-
 	/*
 	 * The main functionality of twl6040 to provide audio on OMAP4+ systems.
 	 * We can add the ASoC codec child whenever this driver has been loaded.
-- 
1.9.0

