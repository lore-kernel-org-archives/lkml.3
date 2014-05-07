Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaEGUBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:01:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaEGUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:01:08 -0400
Date: Wed, 7 May 2014 13:01:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: Re: [RESEND] [PATCH V1 2/2] rtc: da9063: RTC driver
Message-Id: <20140507130106.409f65f673317710104d7681@linux-foundation.org>
In-Reply-To: <3cca26c6dedcfd95df75d44e10a27447350c6e35.1399465372.git.stwiss.opensource@diasemi.com>
References: <cover.1399465372.git.stwiss.opensource@diasemi.com>
	<3cca26c6dedcfd95df75d44e10a27447350c6e35.1399465372.git.stwiss.opensource@diasemi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 13:22:52 +0100 "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:

> Add the RTC driver for DA9063.

A few minor things:

>
> ...
>
> +static int da9063_rtc_stop_alarm(struct device *dev)
> +{
> +	struct da9063_rtc *rtc = dev_get_drvdata(dev);
> +	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
> +				  DA9063_ALARM_ON, 0);
> +}
> +
> +static int da9063_rtc_start_alarm(struct device *dev)
> +{
> +	struct da9063_rtc *rtc = dev_get_drvdata(dev);
> +	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
> +				  DA9063_ALARM_ON, DA9063_ALARM_ON);
> +}

It's conventional to put a newline between end-of-locals and
start-of-code.  My version of checkpatch warns about this and soon
everyone's will.

> +static int da9063_rtc_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	struct da9063_rtc *rtc = dev_get_drvdata(dev);
> +	unsigned long tm_secs;
> +	unsigned long al_secs;
> +	u8 data[RTC_DATA_LEN];
> +	int ret;
> +
> +	ret = regmap_bulk_read(rtc->hw->regmap, DA9063_REG_COUNT_S,
> +			       data, RTC_DATA_LEN);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to read RTC time data: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (!(data[RTC_SEC] & DA9063_RTC_READ)) {
> +		dev_dbg(dev, "RTC not yet ready to be read by the host\n");
> +		return -EINVAL;
> +	}
> +
> +	da9063_data_to_tm(data, tm);
> +
> +	(void)rtc_tm_to_time(tm, &tm_secs);
> +	(void)rtc_tm_to_time(&rtc->alarm_time, &al_secs);

The void casts are a bit useful - they tell the reader that the author
deliberately chose to ignore the return value.  But kernel code
generally doesn't do this trick.


> +	/* handle the rtc synchronisation delay */
> +	if (rtc->rtc_sync == true && al_secs - tm_secs == 1)
> +		(void)memcpy((void *)tm, (const void *)&rtc->alarm_time,
> +			     sizeof(struct rtc_time));

And all three casts here are unneeded.

And they're actually a bit harmful.  If rtc->alarm_time has type `int'
then we really want the warning, but this cast will suppress it.

> +	else
> +		rtc->rtc_sync = false;
> +
> +	return rtc_valid_tm(tm);
> +}


So how does this look?

--- a/drivers/rtc/rtc-da9063.c~rtc-da9063-rtc-driver-fix
+++ a/drivers/rtc/rtc-da9063.c
@@ -82,6 +82,7 @@ static void da9063_tm_to_data(struct rtc
 static int da9063_rtc_stop_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+
 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
 				  DA9063_ALARM_ON, 0);
 }
@@ -89,6 +90,7 @@ static int da9063_rtc_stop_alarm(struct
 static int da9063_rtc_start_alarm(struct device *dev)
 {
 	struct da9063_rtc *rtc = dev_get_drvdata(dev);
+
 	return regmap_update_bits(rtc->hw->regmap, DA9063_REG_ALARM_Y,
 				  DA9063_ALARM_ON, DA9063_ALARM_ON);
 }
@@ -115,13 +117,12 @@ static int da9063_rtc_read_time(struct d
 
 	da9063_data_to_tm(data, tm);
 
-	(void)rtc_tm_to_time(tm, &tm_secs);
-	(void)rtc_tm_to_time(&rtc->alarm_time, &al_secs);
+	rtc_tm_to_time(tm, &tm_secs);
+	rtc_tm_to_time(&rtc->alarm_time, &al_secs);
 
 	/* handle the rtc synchronisation delay */
 	if (rtc->rtc_sync == true && al_secs - tm_secs == 1)
-		(void)memcpy((void *)tm, (const void *)&rtc->alarm_time,
-			     sizeof(struct rtc_time));
+		memcpy(tm, &rtc->alarm_time, sizeof(struct rtc_time));
 	else
 		rtc->rtc_sync = false;
 
_

