Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968212AbaLLOjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:39:31 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:49167 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030250AbaLLOiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:38:23 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v6 3/5] hwmon: ina2xx: don't accept shunt values greater than the calibration factor
Date: Fri, 12 Dec 2014 15:37:53 +0100
Message-Id: <1418395075-16850-4-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418395075-16850-1-git-send-email-bgolaszewski@baylibre.com>
References: <1418395075-16850-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shunt resistance values greater than the chip's calibration factor make no
sense since the actual value written to the register equals:

	<calibration factor> / <shunt>

Bail-out from ina2xx_probe() if the configured value is greater than the
calibration factor.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 24fce2a..12f0e12 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -299,7 +299,8 @@ static int ina2xx_probe(struct i2c_client *client,
 	data->config = &ina2xx_config[data->kind];
 	data->client = client;
 
-	if (data->rshunt <= 0)
+	if (data->rshunt <= 0 ||
+	    data->rshunt > data->config->calibration_factor)
 		return -ENODEV;
 
 	ret = ina2xx_init(data);
-- 
2.1.3

