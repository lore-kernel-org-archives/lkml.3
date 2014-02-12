Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaBLJwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 04:52:00 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:14089 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaBLJv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 04:51:57 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-46-52fb443b68b4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH] mfd: 88pm800: Fix I2C device resource leak if probe fails
Date: Wed, 12 Feb 2014 10:51:41 +0100
Message-id: <1392198701-20547-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t/xK7rWLr+DDGZtUbB4/cLQ4v7Xo4wW
	l3fNYbM43c1qsWDjI0YHVo871/awecw7GejRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGfvv
	vGMt2Mpe8f3df+YGxtlsXYycHBICJhJ/3/dD2WISF+6tB7K5OIQEljJKnNu6nRnC6WOS2PNi
	HStIFZuAscTm5UvAOkQEsiR+TFvNAmIzC3hKvPv7kB3EFhbwkui8+gUsziKgKrHn/iomEJtX
	wF1i+pI9QL0cQNsUJOZMspnAyL2AkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkgAfN3B
	uPSY1SFGAQ5GJR5eBs9fQUKsiWXFlbmHGCU4mJVEePVPAIV4UxIrq1KL8uOLSnNSiw8xMnFw
	SjUwpt2umfpnQ6JH3Ido9gfsucxSer18X2ccU1N2vXxHOnLO5wmu5zn3u775VHT/tvD5sqOP
	fGQbppUq+LwOiPkg1CJfEWT4JSJ/6W6W9QLPJp5MMNT5smbLOvNDpl4pE/dn6/zKublbZYLG
	cXs38fvsbMUz2LLOyx+rXdRyu/HAv/jSWN/kZ4vKlViKMxINtZiLihMBGKzbpt4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During probe the driver allocates two dummy I2C devices for subchips in
function pm800_pages_init(). Additionally this function allocates
regmaps for these subchips. If any of these steps fail then these dummy
I2C devices are not freed and resources leak.

On pm800_pages_init() fail the driver must call pm800_pages_exit() to
unregister dummy I2C devices.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: stable@vger.kernel.org
---
 drivers/mfd/88pm800.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 7dca1e640970..28627c1ff9da 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -586,8 +586,8 @@ static int pm800_probe(struct i2c_client *client,
 	return 0;
 
 err_device_init:
-	pm800_pages_exit(chip);
 err_page_init:
+	pm800_pages_exit(chip);
 err_subchip_alloc:
 	pm80x_deinit();
 out_init:
-- 
1.7.9.5

