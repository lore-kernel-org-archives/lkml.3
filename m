Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab3IZNL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:11:27 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3754 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3IZNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:11:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Sep 2013 06:07:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 4/4] mfd: palmas: fix resource leak of i2c_dummy devices
Date: Thu, 26 Sep 2013 19:03:51 +0530
Message-ID: <1380202431-4868-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
References: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas device supports multiple i2c device address and the client
for these addressed are created in the driver as i2c_new_dummy().

The new devices are not getting released in error or removal path and
so it is causing resource leak.

Add the unregister of these newly created dummy devices to avoid resource
leaks.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/palmas.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 6aab016..ae91478 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -422,7 +422,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 				dev_err(palmas->dev,
 					"can't attach client %d\n", i);
 				ret = -ENOMEM;
-				goto err;
+				goto err_i2c;
 			}
 			palmas->i2c_clients[i]->dev.of_node = of_node_get(node);
 		}
@@ -433,7 +433,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 			dev_err(palmas->dev,
 				"Failed to allocate regmap %d, err: %d\n",
 				i, ret);
-			goto err;
+			goto err_i2c;
 		}
 	}
 
@@ -452,7 +452,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 			reg);
 	if (ret < 0) {
 		dev_err(palmas->dev, "POLARITY_CTRL updat failed: %d\n", ret);
-		goto err;
+		goto err_i2c;
 	}
 
 	/* Change IRQ into clear on read mode for efficiency */
@@ -466,7 +466,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 			IRQF_ONESHOT | pdata->irq_flags, 0, &palmas_irq_chip,
 			&palmas->irq_data);
 	if (ret < 0)
-		goto err;
+		goto err_i2c;
 
 no_irq:
 	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PU_PD_OD_BASE);
@@ -552,7 +552,6 @@ no_irq:
 		} else if (pdata->pm_off && !pm_power_off) {
 			palmas_dev = palmas;
 			pm_power_off = palmas_power_off;
-			return ret;
 		}
 	}
 
@@ -560,16 +559,26 @@ no_irq:
 
 err_irq:
 	regmap_del_irq_chip(palmas->irq, palmas->irq_data);
-err:
+err_i2c:
+	for (i = 1; i < PALMAS_NUM_CLIENTS; i++) {
+		if (palmas->i2c_clients[i])
+			i2c_unregister_device(palmas->i2c_clients[i]);
+	}
 	return ret;
 }
 
 static int palmas_i2c_remove(struct i2c_client *i2c)
 {
 	struct palmas *palmas = i2c_get_clientdata(i2c);
+	int i;
 
 	regmap_del_irq_chip(palmas->irq, palmas->irq_data);
 
+	for (i = 1; i < PALMAS_NUM_CLIENTS; i++) {
+		if (palmas->i2c_clients[i])
+			i2c_unregister_device(palmas->i2c_clients[i]);
+	}
+
 	if (palmas == palmas_dev) {
 		pm_power_off = NULL;
 		palmas_dev = NULL;
-- 
1.7.1.1

