Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932428AbaFJTxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:53:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35457 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbaFJTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 054/160] iio: cm36651: Fix i2c client leak and possible NULL pointer dereference
Date: Tue, 10 Jun 2014 12:44:54 -0700
Message-Id: <1402429600-20477-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit d0a588a57c2b0748df8307a0865a1bbbf1624c53 upstream.

During probe the driver allocates dummy I2C devices (i2c_new_dummy())
but they aren't unregistered during driver remove or probe failure.

Additionally driver does not check the return value of i2c_new_dummy().
In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later
dereferenced by i2c_smbus_{read,write}_data() functions.

Fix issues by properly checking for i2c_new_dummy() return value and
unregistering I2C devices on driver remove or probe failure.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Beomho Seo <beomho.seo@samsung.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iio/light/cm36651.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
index 0922e39..203883c 100644
--- a/drivers/iio/light/cm36651.c
+++ b/drivers/iio/light/cm36651.c
@@ -628,7 +628,19 @@ static int cm36651_probe(struct i2c_client *client,
 	cm36651->client = client;
 	cm36651->ps_client = i2c_new_dummy(client->adapter,
 						     CM36651_I2C_ADDR_PS);
+	if (!cm36651->ps_client) {
+		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
+		ret = -ENODEV;
+		goto error_disable_reg;
+	}
+
 	cm36651->ara_client = i2c_new_dummy(client->adapter, CM36651_ARA);
+	if (!cm36651->ara_client) {
+		dev_err(&client->dev, "%s: new i2c device failed\n", __func__);
+		ret = -ENODEV;
+		goto error_i2c_unregister_ps;
+	}
+
 	mutex_init(&cm36651->lock);
 	indio_dev->dev.parent = &client->dev;
 	indio_dev->channels = cm36651_channels;
@@ -640,7 +652,7 @@ static int cm36651_probe(struct i2c_client *client,
 	ret = cm36651_setup_reg(cm36651);
 	if (ret) {
 		dev_err(&client->dev, "%s: register setup failed\n", __func__);
-		goto error_disable_reg;
+		goto error_i2c_unregister_ara;
 	}
 
 	ret = request_threaded_irq(client->irq, NULL, cm36651_irq_handler,
@@ -648,7 +660,7 @@ static int cm36651_probe(struct i2c_client *client,
 							"cm36651", indio_dev);
 	if (ret) {
 		dev_err(&client->dev, "%s: request irq failed\n", __func__);
-		goto error_disable_reg;
+		goto error_i2c_unregister_ara;
 	}
 
 	ret = iio_device_register(indio_dev);
@@ -661,6 +673,10 @@ static int cm36651_probe(struct i2c_client *client,
 
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+error_i2c_unregister_ara:
+	i2c_unregister_device(cm36651->ara_client);
+error_i2c_unregister_ps:
+	i2c_unregister_device(cm36651->ps_client);
 error_disable_reg:
 	regulator_disable(cm36651->vled_reg);
 	return ret;
@@ -674,6 +690,8 @@ static int cm36651_remove(struct i2c_client *client)
 	iio_device_unregister(indio_dev);
 	regulator_disable(cm36651->vled_reg);
 	free_irq(client->irq, indio_dev);
+	i2c_unregister_device(cm36651->ps_client);
+	i2c_unregister_device(cm36651->ara_client);
 
 	return 0;
 }
-- 
1.9.1

