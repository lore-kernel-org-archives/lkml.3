Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbaIVQWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:22:42 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:65535 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373AbaIVQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:22:40 -0400
MIME-Version: 1.0
In-Reply-To: <7192455.FveG5nGWsJ@xq-nb>
References: <1411370675-27866-1-git-send-email-zyw@rock-chips.com>
	<7192455.FveG5nGWsJ@xq-nb>
Date: Mon, 22 Sep 2014 09:22:39 -0700
X-Google-Sender-Auth: X9tvMLywQl1WlSrBluCLjAV9N_g
Message-ID: <CAD=FV=VUoK8SDng6O4-VVq8UZf88b3bSe-hQMht3R2nmYXqMFQ@mail.gmail.com>
Subject: Re: [PATCH] i2c-rk3x: move setup to the earlier subsys initcall
From: Doug Anderson <dianders@chromium.org>
To: Max Schwarz <max.schwarz@online.de>
Cc: Chris Zhong <zyw@rock-chips.com>, linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>, Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max,

On Mon, Sep 22, 2014 at 9:05 AM, Max Schwarz <max.schwarz@online.de> wrote:
> Hi Chris,
>
> Am Montag, 22. September 2014, 15:24:35 schrieb Chris Zhong:
>> Some device using this bus, such as regulators, they should register
>> as early as possible, so the I2C bus master needs to be loaded early.
>> Therefore initialize via subsys_initcall() is better.
>
> You could also use probe deferral in the regulator driver to wait until the
> bus is ready. I don't know if you're already doing it, just wanted to point
> that out.

In general you are correct.  You can get by with lots of probe
deferrals.  I don't personally know of any case where things are
broken with the current code, but it's really nice to avoid the
deferrals if possible.

Given that this is a core SoC i2c bus and is used for _a lot_ of
external connectivity (including for connecting to the primary
regulator on most boards), bumping up the priority in the init order
makes a lot of sense to me.

This also matches the i2c busses of most other major SoCs.  A selected
few examples:

i2c-gpio.c:subsys_initcall(i2c_gpio_init);
i2c-omap.c:subsys_initcall(omap_i2c_init_driver);
i2c-s3c2410.c:subsys_initcall(i2c_adap_s3c_init);
i2c-tegra.c:subsys_initcall(tegra_i2c_init_driver);


> That said, this change will make the boot faster in any case by avoiding
> unnecessary deferrals, so I'm for it if you fix the minor issue below.

Yes, I'm for it too.  It's important to note that this fix is not
something required for correctness (as far as I know) but just an
optimization.


>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>>
>> ---
>>
>>  drivers/i2c/busses/i2c-rk3x.c |   13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
>> index e637c32..5b91901 100644
>> --- a/drivers/i2c/busses/i2c-rk3x.c
>> +++ b/drivers/i2c/busses/i2c-rk3x.c
>> @@ -760,7 +760,18 @@ static struct platform_driver rk3x_i2c_driver = {
>>       },
>>  };
>>
>> -module_platform_driver(rk3x_i2c_driver);
>> +static int __init rk3x_i2c_init_driver(void)
>> +{
>> +     return platform_driver_register(&rk3x_i2c_driver);
>> +}
>> +
>> +static void __exit rk3x_i2c_exit_driver(void)
>> +{
>> +     platform_driver_unregister(&rk3x_i2c_driver);
>> +}
>> +
>> +subsys_initcall(rk3x_i2c_init_driver);
>> +module_exit(rk3x_i2c_exit_driver);
>
> This means that the driver cannot be used as a loadable module any more,
> right?
>
> In that case, you should probably turn the tristate option in Kconfig into a
> bool.

Actually, no.  If this driver is switched to a loadable module then it
will dumb itself down to a module initcall.  ...so there's no reason
for a Kconfig option.

Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
