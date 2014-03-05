Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbaCEQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:58:24 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50514 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755015AbaCEQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:58:21 -0500
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Josh Wu <josh.wu@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 1/3] iio: adc: at91_adc: Repair broken platform_data support
Date: Wed,  5 Mar 2014 17:57:53 +0100
Message-Id: <1394038675-15809-2-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1394038675-15809-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to use the at91_adc driver while not using device tree is ending up in a
kernel crash:

Unable to handle kernel NULL pointer dereference at virtual address 00000004
[...]
[<c01f3510>] (at91_adc_probe) from [<c0183828>] (platform_drv_probe+0x18/0x48)
[<c0183828>] (platform_drv_probe) from [<c01824a4>] (driver_probe_device+0x100/0x218)
[<c01824a4>] (driver_probe_device) from [<c0182648>] (__driver_attach+0x8c/0x90)
[<c0182648>] (__driver_attach) from [<c0180de4>] (bus_for_each_dev+0x58/0x88)
[<c0180de4>] (bus_for_each_dev) from [<c0181c7c>] (bus_add_driver+0xd4/0x1d4)
[<c0181c7c>] (bus_add_driver) from [<c0182c40>] (driver_register+0x78/0xf4)
[<c0182c40>] (driver_register) from [<c0008998>] (do_one_initcall+0xe8/0x14c)
[<c0008998>] (do_one_initcall) from [<c02f0b50>] (kernel_init_freeable+0xec/0x1b4)
[<c02f0b50>] (kernel_init_freeable) from [<c022acdc>] (kernel_init+0x8/0xe4)
[<c022acdc>] (kernel_init) from [<c0009670>] (ret_from_fork+0x14/0x24)

This is because the at91_adc_caps structure is mandatory but is not filled when
using platform_data. Correct that by using an id_table. It ensues that the
driver will not match "at91_adc" anymore but it was crashing anyway.

Fixes: c46016665fff (iio: at91: ADC start-up time calculation changed since at91sam9x5)
Cc: stable@vger.kernel.org # v3.13+

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/iio/adc/at91_adc.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
index 5b1aa027c034..bbba014c9939 100644
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -765,14 +765,17 @@ static int at91_adc_probe_pdata(struct at91_adc_state *st,
 	if (!pdata)
 		return -EINVAL;
 
+	st->caps = (struct at91_adc_caps *)
+			platform_get_device_id(pdev)->driver_data;
+
 	st->use_external = pdata->use_external_triggers;
 	st->vref_mv = pdata->vref;
 	st->channels_mask = pdata->channels_used;
-	st->num_channels = pdata->num_channels;
+	st->num_channels = st->caps->num_channels;
 	st->startup_time = pdata->startup_time;
 	st->trigger_number = pdata->trigger_number;
 	st->trigger_list = pdata->trigger_list;
-	st->registers = pdata->registers;
+	st->registers = &st->caps->registers;
 
 	return 0;
 }
@@ -1101,7 +1104,6 @@ static int at91_adc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_OF
 static struct at91_adc_caps at91sam9260_caps = {
 	.calc_startup_ticks = calc_startup_ticks_9260,
 	.num_channels = 4,
@@ -1154,11 +1156,27 @@ static const struct of_device_id at91_adc_dt_ids[] = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, at91_adc_dt_ids);
-#endif
+
+static const struct platform_device_id at91_adc_ids[] = {
+	{
+		.name = "at91sam9260-adc",
+		.driver_data = (unsigned long)&at91sam9260_caps,
+	}, {
+		.name = "at91sam9g45-adc",
+		.driver_data = (unsigned long)&at91sam9g45_caps,
+	}, {
+		.name = "at91sam9x5-adc",
+		.driver_data = (unsigned long)&at91sam9x5_caps,
+	}, {
+		/* terminator */
+	}
+};
+MODULE_DEVICE_TABLE(platform, at91_adc_ids);
 
 static struct platform_driver at91_adc_driver = {
 	.probe = at91_adc_probe,
 	.remove = at91_adc_remove,
+	.id_table = at91_adc_ids,
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .of_match_table = of_match_ptr(at91_adc_dt_ids),
-- 
1.8.3.2

