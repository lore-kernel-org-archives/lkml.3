Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaEBPmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43850 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaEBPmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:07 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 075/151] mfd: 88pm800: Fix I2C device resource leak if probe fails
Date: Fri,  2 May 2014 08:37:43 -0700
Message-Id: <1399045139-4531-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/88pm800.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index a65447d..da1ef32 100644
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
1.9.1

