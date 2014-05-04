Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaEDQir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:38:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbaEDPlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Beomho Seo <beomho.seo@samsung.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.14 068/158] iio: cm36651: Fix i2c client leak and possible NULL pointer dereference
Date: Sun,  4 May 2014 11:39:37 -0400
Message-Id: <20140504154039.163788886@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/cm36651.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/cm36651.c
+++ b/drivers/iio/light/cm36651.c
@@ -652,7 +652,19 @@ static int cm36651_probe(struct i2c_clie
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
@@ -664,7 +676,7 @@ static int cm36651_probe(struct i2c_clie
 	ret = cm36651_setup_reg(cm36651);
 	if (ret) {
 		dev_err(&client->dev, "%s: register setup failed\n", __func__);
-		goto error_disable_reg;
+		goto error_i2c_unregister_ara;
 	}
 
 	ret = request_threaded_irq(client->irq, NULL, cm36651_irq_handler,
@@ -672,7 +684,7 @@ static int cm36651_probe(struct i2c_clie
 							"cm36651", indio_dev);
 	if (ret) {
 		dev_err(&client->dev, "%s: request irq failed\n", __func__);
-		goto error_disable_reg;
+		goto error_i2c_unregister_ara;
 	}
 
 	ret = iio_device_register(indio_dev);
@@ -685,6 +697,10 @@ static int cm36651_probe(struct i2c_clie
 
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+error_i2c_unregister_ara:
+	i2c_unregister_device(cm36651->ara_client);
+error_i2c_unregister_ps:
+	i2c_unregister_device(cm36651->ps_client);
 error_disable_reg:
 	regulator_disable(cm36651->vled_reg);
 	return ret;
@@ -698,6 +714,8 @@ static int cm36651_remove(struct i2c_cli
 	iio_device_unregister(indio_dev);
 	regulator_disable(cm36651->vled_reg);
 	free_irq(client->irq, indio_dev);
+	i2c_unregister_device(cm36651->ps_client);
+	i2c_unregister_device(cm36651->ara_client);
 
 	return 0;
 }


