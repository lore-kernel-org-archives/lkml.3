Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaEDQMk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:12:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbaEDPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.10 24/86] mfd: 88pm860x: Fix I2C device resource leak on regmap init fail
Date: Sun,  4 May 2014 11:40:59 -0400
Message-Id: <20140504154143.677817576@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

commit a7ab1c8b261305af583ce26bb4a14f555fdaa73e upstream.

During probe the driver allocates dummy I2C device for companion chip
and then allocates a regmap for it. If regmap_init_i2c() fails then the
I2C driver (allocated with i2c_new_dummy()) is not freed and this
resource leaks.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/88pm860x-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mfd/88pm860x-core.c
+++ b/drivers/mfd/88pm860x-core.c
@@ -1190,6 +1190,7 @@ static int pm860x_probe(struct i2c_clien
 			ret = PTR_ERR(chip->regmap_companion);
 			dev_err(&chip->companion->dev,
 				"Failed to allocate register map: %d\n", ret);
+			i2c_unregister_device(chip->companion);
 			return ret;
 		}
 		i2c_set_clientdata(chip->companion, chip);


