Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab3KGXqp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:46:45 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37545 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3KGXqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:46:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
References: <20131101134120.13a44225@notabene.brown> <CAK5ve-LzYLr0xuvNA3MX=pECPPfAkDFqExPpmQt8GF+9jf5uHg@mail.gmail.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 7 Nov 2013 15:46:10 -0800
Message-ID: <CAK5ve-LCD1keP+cimRcXSQwFAH6OKpU-ABBQS5LkptgANmDWsQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] LEDS: tca6502: add device-tree support for GPIO configuration.
To: NeilBrown <neilb@suse.de>
Cc: Richard Purdie <rpurdie@rpsys.net>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 7, 2013 at 3:39 PM, Bryan Wu <cooloney@gmail.com> wrote:
> On Thu, Oct 31, 2013 at 7:41 PM, NeilBrown <neilb@suse.de> wrote:
>>
>
> [PATCH 2/2] LEDS: tca6502: add device-tree support for GPIO configuration.
>
> I think it should be tca6507, right? Typo?
>

I fixed this typo and queue up this patch in my devel branch.

-Bryan

> For other parts of this patch, I'm OK for them.
>
> And just a quick scan of the leds-tca6507, I found bunch of typos in
> the comments:
>
> * An led-tca6507 device must be provided with platform data.  This data
>  * lists for each output: the name, default trigger, and whether the signal
>  * is being used as a GPiO rather than an led.  'struct led_plaform_data'
>
> Can we unify to use GPIO and gpio?
>
>  * is used for this.  If 'name' is NULL, the output isn't used.  If 'flags'
>  * is TCA6507_MAKE_CPIO, the output is a GPO.
>
> Here should be TCA6507_MAKE_GPIO and GPIO instead of GPO
>
>  * The "struct led_platform_data" can be embedded in a
>  * "struct tca6507_platform_data" which adds a 'gpio_base' for the GPiOs,
>  * and a 'setup' callback which is called once the GPiOs are available.
>
> Don't use GPiO, please.
>
> Could you please review the code again and submit a cleanup patch to
> fix those typos?
>
> Thanks,
> -Bryan
>
>
>> The 7 lines driven by the TCA6507 can either drive LEDs or act as output-only
>> GPIOs.
>>
>> To make this distinction in devicetree we use the "compatible" property.
>>
>> If the device attached to a line is "compatible" with "gpio", we treat it
>> like a GPIO.  If it is "compatible" with "led" (or if no "compatible" value
>> is set) we treat it like an LED.
>>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>>
>> diff --git a/Documentation/devicetree/bindings/leds/tca6507.txt b/Documentation/devicetree/bindings/leds/tca6507.txt
>> index 80ff3dfb1f32..d7221b84987c 100644
>> --- a/Documentation/devicetree/bindings/leds/tca6507.txt
>> +++ b/Documentation/devicetree/bindings/leds/tca6507.txt
>> @@ -2,6 +2,13 @@ LEDs connected to tca6507
>>
>>  Required properties:
>>  - compatible : should be : "ti,tca6507".
>> +- #address-cells: must be 1
>> +- #size-cells: must be 0
>> +- reg: typically 0x45.
>> +
>> +Optional properties:
>> +- gpio-controller: allows lines to be used as output-only GPIOs.
>> +- #gpio-cells: if present, must be 0.
>>
>>  Each led is represented as a sub-node of the ti,tca6507 device.
>>
>> @@ -10,6 +17,7 @@ LED sub-node properties:
>>  - reg : number of LED line (could be from 0 to 6)
>>  - linux,default-trigger : (optional)
>>     see Documentation/devicetree/bindings/leds/common.txt
>> +- compatible: either "led" (the default) or "gpio".
>>
>>  Examples:
>>
>> @@ -19,6 +27,9 @@ tca6507@45 {
>>         #size-cells = <0>;
>>         reg = <0x45>;
>>
>> +       gpio-controller;
>> +       #gpio-cells = <2>;
>> +
>>         led0: red-aux@0 {
>>                 label = "red:aux";
>>                 reg = <0x0>;
>> @@ -29,5 +40,10 @@ tca6507@45 {
>>                 reg = <0x5>;
>>                 linux,default-trigger = "default-on";
>>         };
>> +
>> +       wifi-reset@6 {
>> +               reg = <0x6>;
>> +               compatible = "gpio";
>> +       };
>>  };
>>
>> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
>> index f5063f447463..93a2b1759054 100644
>> --- a/drivers/leds/leds-tca6507.c
>> +++ b/drivers/leds/leds-tca6507.c
>> @@ -638,6 +638,9 @@ static int tca6507_probe_gpios(struct i2c_client *client,
>>         tca->gpio.direction_output = tca6507_gpio_direction_output;
>>         tca->gpio.set = tca6507_gpio_set_value;
>>         tca->gpio.dev = &client->dev;
>> +#ifdef CONFIG_OF_GPIO
>> +       tca->gpio.of_node = of_node_get(client->dev.of_node);
>> +#endif
>>         err = gpiochip_add(&tca->gpio);
>>         if (err) {
>>                 tca->gpio.ngpio = 0;
>> @@ -696,6 +699,8 @@ tca6507_led_dt_init(struct i2c_client *client)
>>                 led.default_trigger =
>>                         of_get_property(child, "linux,default-trigger", NULL);
>>                 led.flags = 0;
>> +               if (of_property_match_string(child, "compatible", "gpio") >= 0)
>> +                       led.flags |= TCA6507_MAKE_GPIO;
>>                 ret = of_property_read_u32(child, "reg", &reg);
>>                 if (ret != 0 || reg < 0 || reg >= NUM_LEDS)
>>                         continue;
>> @@ -709,6 +714,7 @@ tca6507_led_dt_init(struct i2c_client *client)
>>
>>         pdata->leds.leds = tca_leds;
>>         pdata->leds.num_leds = NUM_LEDS;
>> +       pdata->gpio_base = -1;
>>
>>         return pdata;
>>  }
