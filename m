Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaCRIOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:14:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18444 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbaCRIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:14:01 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-2e-5328004748c4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, Beomho Seo <beomho.seo@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2] iio: cm36651: Fix i2c client leak and possible NULL pointer
 dereference
Date: Tue, 18 Mar 2014 09:13:29 +0100
Message-id: <1395130410-15865-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJMWRmVeSWpSXmKPExsVy+t/xK7ruDBrBBn/u8Vic/rSN3eJB0yom
	i9cvDC2WTJ7PajHvyDsWi8u75rA5sHlsWtXJ5rHkzSFWj74tqxg9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mro7XYqaBevOP3gF1sD4y7hLkZODgkBE4m/H/ezQNhiEhfurWfrYuTiEBJYyijx/PAl
	Jginj0mir/cqG0gVm4CxxOblS8CqRATWM0qsWvGZFSTBLGAo8fPdH/YuRg4OYYFYiSfX+EDC
	LAKqEidWrWMCsXkF3CXWP37PClIiIaAgMWeSzQRG7gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS
	9ZLzczcxQoLh6w7GpcesDjEKcDAq8fC+ZFMPFmJNLCuuzD3EKMHBrCTCu3QyUIg3JbGyKrUo
	P76oNCe1+BAjEwenVAOjZ8aLTSnZl6UWi+ZbrGK7mJfIp+6Yxrd9j6HU7KznWZ+lTd0CXVg/
	nLjJ3duou+KJZVyf052O9lffJuv/eKXI5dtmmGtY5rXnqm+ZsvU6lk097x/kyM4wsT+0LJOR
	/QXjih1bS9bzuWTJHf7B2iT7LHX+uXeLy6fwbsqZ161z8YtV5Zr/Wh+UWIozEg21mIuKEwGy
	o90q5AEAAA==
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
Acked-by: Beomho Seo <beomho.seo@samsung.com>
---
 drivers/iio/light/cm36651.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/light/cm36651.c b/drivers/iio/light/cm36651.c
index a45e07492db3..39fc67e82138 100644
--- a/drivers/iio/light/cm36651.c
+++ b/drivers/iio/light/cm36651.c
@@ -652,7 +652,19 @@ static int cm36651_probe(struct i2c_client *client,
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
@@ -664,7 +676,7 @@ static int cm36651_probe(struct i2c_client *client,
 	ret = cm36651_setup_reg(cm36651);
 	if (ret) {
 		dev_err(&client->dev, "%s: register setup failed\n", __func__);
-		goto error_disable_reg;
+		goto error_i2c_unregister_ara;
 	}
 
 	ret = request_threaded_irq(client->irq, NULL, cm36651_irq_handler,
@@ -672,7 +684,7 @@ static int cm36651_probe(struct i2c_client *client,
 							"cm36651", indio_dev);
 	if (ret) {
 		dev_err(&client->dev, "%s: request irq failed\n", __func__);
-		goto error_disable_reg;
+		goto error_i2c_unregister_ara;
 	}
 
 	ret = iio_device_register(indio_dev);
@@ -685,6 +697,10 @@ static int cm36651_probe(struct i2c_client *client,
 
 error_free_irq:
 	free_irq(client->irq, indio_dev);
+error_i2c_unregister_ara:
+	i2c_unregister_device(cm36651->ara_client);
+error_i2c_unregister_ps:
+	i2c_unregister_device(cm36651->ps_client);
 error_disable_reg:
 	regulator_disable(cm36651->vled_reg);
 	return ret;
@@ -698,6 +714,8 @@ static int cm36651_remove(struct i2c_client *client)
 	iio_device_unregister(indio_dev);
 	regulator_disable(cm36651->vled_reg);
 	free_irq(client->irq, indio_dev);
+	i2c_unregister_device(cm36651->ps_client);
+	i2c_unregister_device(cm36651->ara_client);
 
 	return 0;
 }
-- 
1.7.9.5

