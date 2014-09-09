Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaIISJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:09:18 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64709 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaIISJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:09:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Cc: robh+dt@kernel.org, riku.voipio@iki.fi, cooloney@gmail.com,
        rpurdie@rpsys.net, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [PATCH] leds: Add DT support for leds-pca9532
Date: Tue, 09 Sep 2014 20:08:53 +0200
Message-ID: <17734612.3IvPuVrruO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410269280-8761-1-git-send-email-stigge@antcom.de>
References: <1410269280-8761-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:BC+J36fk34vi1A/dbeztBj4Bc4oo5KeGfqyP1FP6+XS
 busGmz+kV+nGWC0e4uQWTey9js3yZoKS25SgISo4kvrYER6GGB
 TLjAJ9BnBZyN16IQtVrqHmHCveUc6p8EFRBU6rS5dB9NnPm8SK
 Kl/P/2xiTEz6aSEZ3RZkA9WHgiWtSJfjS3kr40AHAnRb+V91X0
 gJOznQ7smkeTUHOM80zO5E3v1UWk2N0O72UOhpZ7rnaRrMGGVP
 DbphCmGTuHGNCEWfmK2+PUNkniq8CUz27zra941STzMnh7CBSD
 mUghFCvFV4lc0ni0o7FNRixGbs+zD9gTBRN+OKuJk161NyZdNN
 O7ZYefjrM5r0Lk9mc+hI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 September 2014 15:28:00 Roland Stigge wrote:
> +#ifdef CONFIG_OF
> +static struct pca9532_platform_data *pca9532_parse_dt(struct device *dev)
> +{
...
> +
>  static int pca9532_probe(struct i2c_client *client,
>         const struct i2c_device_id *id)
>  {
> @@ -449,6 +489,11 @@ static int pca9532_probe(struct i2c_clie
>         struct pca9532_platform_data *pca9532_pdata =
>                         dev_get_platdata(&client->dev);
>  
> +#ifdef CONFIG_OF
> +       if (!pca9532_pdata && client->dev.of_node)
> +               pca9532_pdata = pca9532_parse_dt(&client->dev);
> +#endif
> +

It would be better to remove the two #ifdef statements and instead
do this in C language as

	if (IS_ENABLED(CONFIG_OF) && !pca9532_pdata && client->dev.of_node)
		pca9532_pdata = pca9532_parse_dt(&client->dev);

This gives you extra compile-time coverage when CONFIG_OF is not
enabled.

I would probably also remove the !pca9532_pdata check there, since
we rarely do auxdata for new devices these days, but that is a separate
matter, and the check does not hurt.

> +       if (!of_property_read_u32_array(np, "nxp,pwm", &pwm[0], 2)) {
> +               for (i = 0; i < 2; i++)
> +                       pca9532_pdata->pwm[i] = pwm[i];
> +       }

Is this a full PWM controller? If it is, it would be better to also
provide a #pwm-cells property and register the device with the PWM
subsystem to allow arbitrary users.

If the PWM is only really usable for LED, it's probably enough to
leave this used by the LED subsystem.

	Arnd
