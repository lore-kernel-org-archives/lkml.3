Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaBLKLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:11:25 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8585 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaBLKLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:11:21 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-76-52fb48c79254
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>, stable@vger.kernel.org
Subject: [PATCH v2] mfd: 88pm800: Fix I2C device resource leak if probe fails
Date: Wed, 12 Feb 2014 11:10:56 +0100
Message-id: <1392199856-25412-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <20140212095828.GW15081@lee--X1>
References: <20140212095828.GW15081@lee--X1>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xa7rHPX4HGUy/Lmzx+oWhxf2vRxkt
	Lu+aw2ZxupvVYsHGR4wOrB53ru1h85h3MtCjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mvb8
	38VSMJ+z4nLbNKYGxhvsXYycHBICJhI3e36xQthiEhfurWfrYuTiEBJYyijRuWINO4TTxyRx
	8OxPJpAqNgFjic3Ll7CB2CICWRI/pq1mAbGZBTwl3v19CDZVWMBX4tLiPrA4i4CqxOzr08Bs
	XgF3iS/P/jJ3MXIAbVOQmDPJBiTMKaArsengbbBWIQEdid8Xj7NMYORdwMiwilE0tTS5oDgp
	PddQrzgxt7g0L10vOT93EyMkYL7sYFx8zOoQowAHoxIPL4PnryAh1sSy4srcQ4wSHMxKIrx3
	XX4HCfGmJFZWpRblxxeV5qQWH2Jk4uCUamAsbt7+89cGH15/rxlv9lx+5HCumWP9uff1c4se
	aV1Q7X/0k9X37C+DtBfRYTL8aZEXcvd/t4pdnTePcUKYTZH92q0bhV63cSV1dpbtDrR////R
	/uo4kWb9D7USjk5SaitdyyS7Zk0XXF2iotMkMTnpw4//82Tubni4PsHn8/n7T1doiTzwWLtc
	iaU4I9FQi7moOBEAvfNML/YBAAA=
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
 drivers/mfd/88pm800.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 7dca1e640970..841717a2842c 100644
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
1.7.9.5

