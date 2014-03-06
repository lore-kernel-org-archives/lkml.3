Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbaCFJd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:33:29 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30558 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCFJdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:33:25 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-23-531840e29200
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Beomho Seo <beomho.seo@samsung.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] iio: cm36651: Fix i2c client leak and possible NULL pointer
 dereference
Date: Thu, 06 Mar 2014 10:33:10 +0100
Message-id: <1394098390-11213-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJMWRmVeSWpSXmKPExsVy+t/xa7qPHCSCDR590bI4/Wkbu8WDplVM
	Fq9fGFosmTyf1WLekXcsFpd3zWFzYPPYtKqTzWPJm0OsHn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJUx415UQY9ARVP7M8YGxju8XYycHBICJhI3L79mg7DFJC7cWw9kc3EICSxllJjz/xoz
	hNPHJPHmxRkWkCo2AWOJzcuXgHWICCRJ3HpymRHEZhaok5jz6AsTiC0sECVxb9sRdhCbRUBV
	Yuu896xdjBwcvALuEp0r+EBMCQEFiTmTbCYwci9gZFjFKJpamlxQnJSea6hXnJhbXJqXrpec
	n7uJERIKX3YwLj5mdYhRgINRiYd3g594sBBrYllxZe4hRgkOZiUR3i2GEsFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGJff6L8zS6uAQd3s+G7b5qKotXlZbkIWNjtaL6dNfpZQnH+DN728gDNJ
	+sd8+SMiBYKKB//v+pbUWcXj01rw4P+0pDkBinvyd1Q0qXjlnlt4yoDtaFCSu5GPHdP6VRNC
	pea5zJy76q9WYMnd2xU5u1msLRUE+Y9suyJZbyn6x6lizpnLyo6+SizFGYmGWsxFxYkAQw6m
	+eMBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates dummy I2C devices (i2c_new_dummy())
but they aren't unregistered during driver remove or probe failure.

Additionally driver does not check the return value of i2c_new_dummy().
In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later
dereferenced by i2c_smbus_{read,write}_data() functions.

Fix issues by properly checking for i2c_new_dummy() return value and
unregistering I2C devices on driver remove or probe failure.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/iio/light/cm36651.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
index a45e07492db3..e7e9a597159f 100644
--- a/drivers/iio/light/cm36651.c
+++ b/drivers/iio/light/cm36651.c
@@ -653,6 +653,11 @@ static int cm36651_probe(struct i2c_client *client,
 	cm36651->ps_client = i2c_new_dummy(client->adapter,
 						     CM36651_I2C_ADDR_PS);
 	cm36651->ara_client = i2c_new_dummy(client->adapter, CM36651_ARA);
+	if (!cm36651->ps_client || !cm36651->ara_client) {
+		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
+		ret = -ENODEV;
+		goto error_i2c_unregister;
+	}
 	mutex_init(&cm36651->lock);
 	indio_dev->dev.parent = &client->dev;
 	indio_dev->channels = cm36651_channels;
@@ -687,6 +692,11 @@ error_free_irq:
 	free_irq(client->irq, indio_dev);
 error_disable_reg:
 	regulator_disable(cm36651->vled_reg);
+error_i2c_unregister:
+	if (cm36651->ps_client)
+		i2c_unregister_device(cm36651->ps_client);
+	if (cm36651->ara_client)
+		i2c_unregister_device(cm36651->ara_client);
 	return ret;
 }
 
@@ -698,6 +708,8 @@ static int cm36651_remove(struct i2c_client *client)
 	iio_device_unregister(indio_dev);
 	regulator_disable(cm36651->vled_reg);
 	free_irq(client->irq, indio_dev);
+	i2c_unregister_device(cm36651->ps_client);
+	i2c_unregister_device(cm36651->ara_client);
 
 	return 0;
 }
-- 
1.7.9.5

