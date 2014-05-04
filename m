Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbaEDQtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:49:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35967 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaEDPl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.14 042/158] mfd: 88pm800: Fix I2C device resource leak if probe fails
Date: Sun,  4 May 2014 11:39:11 -0400
Message-Id: <20140504154035.714707215@linuxfoundation.org>
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

commit 141050cf3d84fc303df58796d68dc1376b0e8f67 upstream.

During probe the driver allocates two dummy I2C devices for subchips in
function pm800_pages_init(). Additionally this function allocates
regmaps for these subchips. If any of these steps fail then these dummy
I2C devices are not freed and resources leak.

On pm800_pages_init() fail the driver must call pm800_pages_exit() to
unregister dummy I2C devices.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/88pm800.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -571,7 +571,7 @@ static int pm800_probe(struct i2c_client
 	ret = pm800_pages_init(chip);
 	if (ret) {
 		dev_err(&client->dev, "pm800_pages_init failed!\n");
-		goto err_page_init;
+		goto err_device_init;
 	}
 
 	ret = device_800_init(chip, pdata);
@@ -587,7 +587,6 @@ static int pm800_probe(struct i2c_client
 
 err_device_init:
 	pm800_pages_exit(chip);
-err_page_init:
 err_subchip_alloc:
 	pm80x_deinit();
 out_init:


