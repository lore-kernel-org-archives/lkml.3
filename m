Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbaEMKF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:05:58 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60786 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760061AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 041/182] mfd: max8998: Fix possible NULL pointer dereference on i2c_new_dummy error
Date: Tue, 13 May 2014 11:26:33 +0200
Message-Id: <6a435811f7836674fc15380ede736c490055e99b.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ed26f87b9f71693a1d1ee85f5e6209601505080f upstream.

During probe the driver allocates dummy I2C device for RTC with i2c_new_dummy() but it does not check the return value of this call.

In case of error (i2c_new_device(): memory allocation failure or I2C
address cannot be used) this function returns NULL which is later used
by i2c_unregister_device().

If i2c_new_dummy() fails for RTC device, fail also the probe for
main MFD driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/max8998.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index fe6332dcabee..25e131a0840a 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -215,6 +215,10 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	mutex_init(&max8998->iolock);
 
 	max8998->rtc = i2c_new_dummy(i2c->adapter, RTC_I2C_ADDR);
+	if (!max8998->rtc) {
+		dev_err(&i2c->dev, "Failed to allocate I2C device for RTC\n");
+		return -ENODEV;
+	}
 	i2c_set_clientdata(max8998->rtc, max8998);
 
 	max8998_irq_init(max8998);
-- 
1.9.3

