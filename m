Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3BNH1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:27:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51611 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3BNH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:27:06 -0500
Date: Thu, 14 Feb 2013 10:26:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] generic-adc-battery: forever loop in gab_remove()
Message-ID: <20130214072643.GA4690@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a forever loop calling iio_channel_release() because the
"chan < " part of the "chan < ARRAY_SIZE()" is missing.  This is in both
the error handling on probe and also in the remove function.

The other thing is that it's possible for some of the elements of the
adc_bat->channel[chan] array to be an ERR_PTR().  I've changed them to
be NULL instead.  We're still not allowed to pass NULLs to
iio_channel_release() so I've added a check.

Finally, I removed an unused "chan = ARRAY_SIZE(gab_chan_name);"
statement as a small cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 42733c4..8cb5d7f 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -263,9 +263,6 @@ static int gab_probe(struct platform_device *pdev)
 	psy->external_power_changed = gab_ext_power_changed;
 	adc_bat->pdata = pdata;
 
-	/* calculate the total number of channels */
-	chan = ARRAY_SIZE(gab_chan_name);
-
 	/*
 	 * copying the static properties and allocating extra memory for holding
 	 * the extra configurable properties received from platform data.
@@ -291,6 +288,7 @@ static int gab_probe(struct platform_device *pdev)
 							 gab_chan_name[chan]);
 		if (IS_ERR(adc_bat->channel[chan])) {
 			ret = PTR_ERR(adc_bat->channel[chan]);
+			adc_bat->channel[chan] = NULL;
 		} else {
 			/* copying properties for supported channels only */
 			memcpy(properties + sizeof(*(psy->properties)) * index,
@@ -344,8 +342,10 @@ err_gpio:
 gpio_req_fail:
 	power_supply_unregister(psy);
 err_reg_fail:
-	for (chan = 0; ARRAY_SIZE(gab_chan_name); chan++)
-		iio_channel_release(adc_bat->channel[chan]);
+	for (chan = 0; chan < ARRAY_SIZE(gab_chan_name); chan++) {
+		if (adc_bat->channel[chan])
+			iio_channel_release(adc_bat->channel[chan]);
+	}
 second_mem_fail:
 	kfree(psy->properties);
 first_mem_fail:
@@ -365,8 +365,10 @@ static int gab_remove(struct platform_device *pdev)
 		gpio_free(pdata->gpio_charge_finished);
 	}
 
-	for (chan = 0; ARRAY_SIZE(gab_chan_name); chan++)
-		iio_channel_release(adc_bat->channel[chan]);
+	for (chan = 0; chan < ARRAY_SIZE(gab_chan_name); chan++) {
+		if (adc_bat->channel[chan])
+			iio_channel_release(adc_bat->channel[chan]);
+	}
 
 	kfree(adc_bat->psy.properties);
 	cancel_delayed_work(&adc_bat->bat_work);
