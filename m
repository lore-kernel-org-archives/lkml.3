Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3JRKNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 06:13:16 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:48339 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985Ab3JRKNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 06:13:10 -0400
MIME-Version: 1.0
In-Reply-To: <20131018172053.70cf2c2b@notabene.brown>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
 <1380971830-21492-4-git-send-email-afenkart@gmail.com> <20131018172053.70cf2c2b@notabene.brown>
From: Javier Martinez Canillas <martinez.javier@gmail.com>
Date: Fri, 18 Oct 2013 12:12:48 +0200
Message-ID: <CAAwP0s1vNcRrekDbJOdm5vzk3VEWRm-5g8c9s+6KPczFj7LBsA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO
 interrupt on AM335x
To: NeilBrown <neilb@suse.de>
Cc: Andreas Fenkart <afenkart@gmail.com>, Chris Ball <cjb@laptop.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Balaji T K <balajitk@ti.com>,
        zonque@gmail.com,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mmc@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 8:20 AM, NeilBrown <neilb@suse.de> wrote:
> On Sat,  5 Oct 2013 13:17:09 +0200 Andreas Fenkart <afenkart@gmail.com> wrote:
>
>> The am335x can't detect pending cirq in PM runtime suspend.
>> This patch reconfigures dat1 as a GPIO before going to suspend.
>> SDIO interrupts are detected with the GPIO, while in runtime
>> suspend, standard detection of the module block otherwise.
>>
>> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
>>
>> diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
>> index 1136e6b..146f3ad 100644
>> --- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
>> +++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
>> @@ -21,8 +21,11 @@ ti,non-removable: non-removable slot (like eMMC)
>>  ti,needs-special-reset: Requires a special softreset sequence
>>  ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
>>  ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
>> -SDIO irq while in suspend. Fallback to polling. Affected chips are
>> -am335x,
>> +SDIO irq while in suspend. The workaround is to reconfigure the dat1 line as a
>> +GPIO upon suspend. Beyond this option and the GPIO config, you also need to set
>> +named pinctrl states "default", "active" and "idle ", see example below.  The
>> +MMC driver will then then toggle between default and idle during the runtime
>> +Affected chips are am335x,
>>
>>                              ------
>>                              | PRCM |
>> @@ -49,3 +52,24 @@ Example:
>>               vmmc-supply = <&vmmc>; /* phandle to regulator node */
>>               ti,non-removable;
>>       };
>> +
>> +[am335x with with gpio for sdio irq]
>> +
>> +     mmc1_cirq_pin: pinmux_cirq_pin {
>> +             pinctrl-single,pins = <
>> +                     0x0f8 0x3f      /* MMC0_DAT1 as GPIO2_28 */
>> +             >;
>> +     };
>> +
>> +     mmc1: mmc@48060000 {
>> +             ti,non-removable;
>> +             bus-width = <4>;
>> +             vmmc-supply = <&ldo2_reg>;
>> +             vmmc_aux-supply = <&vmmc>;
>> +             ti,quirk-swakeup-missing;
>> +             pinctrl-names = "default", "active", "idle";
>> +             pinctrl-0 = <&mmc1_pins>;
>> +             pinctrl-1 = <&mmc1_pins>;
>> +             pinctrl-2 = <&mmc1_cirq_pin>;
>> +             ti,cirq-gpio = <&gpio3 28 0>;
>> +     };
>
>
> hi,
>  I've been trying to get SD irq to work on my  OMAP3 DM3730.
> I seems to need the magic to catch interrupts while FCLK is off, as
> the only way I can get it to work at the moment is to keep FCLK on.
>
> I discovered your patch and tried it out, but it doesn't seem to work for me.
>
> I have a Libertas WIFI chip attached to the second mmc (which is sometimes
> called mmc1, and sometimes mmc2 - very confusing!).

Hi Neil,

I have a DM3730 board with the same setup, Libertas (Marvell SD8686)
wifi + bt chip attached to mmc2.

I was going to try to add support for this to the DTS but it would be
great if I can use your as a reference.

Would you be so kind to share your DTS?

Thanks a lot and best regards,
Javier

> I added:
>         mmc2_cirq_pin: pinmux_cirq_pin {
>                 pinctrl-single,pins = <
>                         0x012e (PIN_INPUT_PULLUP | MUX_MODE4)   /* MMC2_DAT1 as GPIO5_5 */
>                 >;
>         };
>
> and
>
> &mmc2 {
>         ti,quirk-swakeup-missing;
>         pinctrl-names = "default", "active", "idle";
>         pinctrl-0 = <&mmc2_pins>;
>         pinctrl-1 = <&mmc2_pins>;
>         pinctrl-2 = <&mmc2_cirq_pin>;
>         ti,cirq-gpio = <&gpio5 5 0>; /* GPIO133 = 128+5 */
> };
>
> to my dts file but it doesn't make any apparent difference.
>
> Any idea what I might be doing wrong?
> (the base kernel I am applying patches to is from 8th Oct,
>  commit 0e7a3ed04f0cd4311096d691888f88569310ee6c)
>
> BTW,
>  - with the default polling, I get about 1Mb/sec with iperf
>  - with sd-irq enabled and FCLK kept on the whole time, I get 4Mb/sec
>  - with sd-irq enable, FCLK kept on, and the 5ms polling also
>    running, I get over 5Mb/sec!
> Still much less than the 40Mb/sec that I would like to get...
>
> Thanks,
> NeilBrown
