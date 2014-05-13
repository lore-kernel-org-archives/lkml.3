Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272AbaEMKJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:09:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60781 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760050AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 037/182] mfd: 88pm800: Fix I2C device resource leak if probe fails
Date: Tue, 13 May 2014 11:26:29 +0200
Message-Id: <0088e1efbabc2fc72fecc083aee2b0a0389c0914.1399973152.git.jslaby@suse.cz>
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

commit 141050cf3d84fc303df58796d68dc1376b0e8f67 upstream.

During probe the driver allocates two dummy I2C devices for subchips in
function pm800_pages_init(). Additionally this function allocates
regmaps for these subchips. If any of these steps fail then these dummy
I2C devices are not freed and resources leak.

On pm800_pages_init() fail the driver must call pm800_pages_exit() to
unregister dummy I2C devices.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/88pm800.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index a65447d65605..da1ef3290be5 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -571,7 +571,7 @@ static int pm800_probe(struct i2c_client *client,
 	ret = pm800_pages_init(chip);
 	if (ret) {
 		dev_err(&client->dev, "pm800_pages_init failed!\n");
-		goto err_page_init;
+		goto err_device_init;
 	}
 
 	ret = device_800_init(chip, pdata);
@@ -587,7 +587,6 @@ static int pm800_probe(struct i2c_client *client,
 
 err_device_init:
 	pm800_pages_exit(chip);
-err_page_init:
 err_subchip_alloc:
 	pm80x_deinit();
 out_init:
-- 
1.9.3

