Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3EMFEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 01:04:38 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:35048 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3EMFEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 01:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAMPhdO9EFj1YZt3zCD6evrH+t77=hiFj46_LPSM7dGX0rku6Kw@mail.gmail.com>
References: <1367803801-17111-1-git-send-email-chao.xie@marvell.com>
	<1367803801-17111-4-git-send-email-chao.xie@marvell.com>
	<CAMPhdO9EFj1YZt3zCD6evrH+t77=hiFj46_LPSM7dGX0rku6Kw@mail.gmail.com>
Date: Mon, 13 May 2013 13:04:36 +0800
Message-ID: <CADApbehSgR7h2iHhW_QmvO0sTb3zsw6cPh0Dgcbge16PzObFvg@mail.gmail.com>
Subject: Re: [PATCH V4 3/3] pwm: pxa: add device tree support
From: Chao Xie <xiechao.mail@gmail.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +       const struct of_device_id *of_id =
>> +                       of_match_device(pxa_pwm_of_match, &pdev->dev);
>> +       unsigned int npwm;
>> +
>> +       if (!of_id)
>> +               return -ENODEV;
>> +
>> +       npwm = (unsigned int)of_id->data;
>> +       pwm->chip.npwm = (npwm & HAS_SECONDARY_PWM) ? 2 : 1;
>> +
>> +       return 0;
>> +}
>> +
>>  static int pwm_probe(struct platform_device *pdev)
>>  {
>>         const struct platform_device_id *id = platform_get_device_id(pdev);
>> @@ -144,7 +180,6 @@ static int pwm_probe(struct platform_device *pdev)
>>         pwm->chip.dev = &pdev->dev;
>>         pwm->chip.ops = &pxa_pwm_ops;
>>         pwm->chip.base = -1;
>> -       pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
>>
>>         r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>         if (r == NULL) {
>> @@ -156,6 +191,20 @@ static int pwm_probe(struct platform_device *pdev)
>>         if (IS_ERR(pwm->mmio_base))
>>                 return PTR_ERR(pwm->mmio_base);
>>
>> +       if (!id) {
>> +               if (IS_ENABLED(CONFIG_OF))
>> +                       ret = pxa_pwm_parse_data_dt(pdev, pwm);
>> +               else
>> +                       ret = -ENODEV;
>> +       } else {
>> +               pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
>> +       }
>
> ^^ braces not necessarily here, and I'm not really sure if we should check
> CONFIG_OF firstly, and leave the platform_device_id thing as a legacy
> fall back, what do you think?
>
>   if (IS_ENABLED(CONFIG_OF)) {
>      ...
>   } else {
>     const struct platform_device_id *id = platform_get_device_id(...);
>     ...
>   }
>
it has some reasons.
You ways works for
     1. PWM defined in DT configuration file and CONFIG_OF is defined
     2. CONFIG_OF is not defined.
If COFNIG_OF is defined, but PWM is not defined in device tree
configuration file. The device
can still match the driver is the id_table is matched or name is matched.
So I covered addtional situation
    1. PWM is not defined in DT configuration file but CONFIG_OF is defined.

So i keep the possiblility that event CONFIG_OF is defined, but PWM is
not defined in DT file, and we still can use old way to probe the
device.

>> +
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "failed to parse data from device id\n");
>> +               return ret;
>> +       }
>> +
>>         ret = pwmchip_add(&pwm->chip);
>>         if (ret < 0) {
>>                 dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
>> @@ -181,6 +230,7 @@ static struct platform_driver pwm_driver = {
>>         .driver         = {
>>                 .name   = "pxa25x-pwm",
>>                 .owner  = THIS_MODULE,
>> +               .of_match_table = pxa_pwm_of_match,
>>         },
>>         .probe          = pwm_probe,
>>         .remove         = pwm_remove,
>> --
>> 1.7.4.1
>>
