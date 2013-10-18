Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab3JRHak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:30:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59171 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab3JRHai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:30:38 -0400
Message-ID: <5260E374.6050804@ti.com>
Date: Fri, 18 Oct 2013 12:59:56 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Andreas Fenkart <afenkart@gmail.com>, Chris Ball <cjb@laptop.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        <zonque@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO interrupt
 on AM335x
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com> <1380971830-21492-4-git-send-email-afenkart@gmail.com> <20131018172053.70cf2c2b@notabene.brown>
In-Reply-To: <20131018172053.70cf2c2b@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 October 2013 11:50 AM, NeilBrown wrote:
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
>>   ti,needs-special-reset: Requires a special softreset sequence
>>   ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
>>   ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
>> -SDIO irq while in suspend. Fallback to polling. Affected chips are
>> -am335x,
>> +SDIO irq while in suspend. The workaround is to reconfigure the dat1 line as a
>> +GPIO upon suspend. Beyond this option and the GPIO config, you also need to set
>> +named pinctrl states "default", "active" and "idle ", see example below.  The
>> +MMC driver will then then toggle between default and idle during the runtime
>> +Affected chips are am335x,
>>
>>                               ------
>>                               | PRCM |
>> @@ -49,3 +52,24 @@ Example:
>>   		vmmc-supply = <&vmmc>; /* phandle to regulator node */
>>   		ti,non-removable;
>>   	};
>> +
>> +[am335x with with gpio for sdio irq]
>> +
>> +	mmc1_cirq_pin: pinmux_cirq_pin {
>> +		pinctrl-single,pins = <
>> +			0x0f8 0x3f	/* MMC0_DAT1 as GPIO2_28 */
>> +		>;
>> +	};
>> +
>> +	mmc1: mmc@48060000 {
>> +		ti,non-removable;
>> +		bus-width = <4>;
>> +		vmmc-supply = <&ldo2_reg>;
>> +		vmmc_aux-supply = <&vmmc>;
>> +	        ti,quirk-swakeup-missing;
>> +		pinctrl-names = "default", "active", "idle";
>> +		pinctrl-0 = <&mmc1_pins>;
>> +		pinctrl-1 = <&mmc1_pins>;
>> +		pinctrl-2 = <&mmc1_cirq_pin>;
>> +		ti,cirq-gpio = <&gpio3 28 0>;
>> +	};
>
>
> hi,
>   I've been trying to get SD irq to work on my  OMAP3 DM3730.
> I seems to need the magic to catch interrupts while FCLK is off, as
> the only way I can get it to work at the moment is to keep FCLK on.
>
> I discovered your patch and tried it out, but it doesn't seem to work for me.
>
> I have a Libertas WIFI chip attached to the second mmc (which is sometimes
> called mmc1, and sometimes mmc2 - very confusing!).
> I added:
> 	mmc2_cirq_pin: pinmux_cirq_pin {
> 		pinctrl-single,pins = <
> 			0x012e (PIN_INPUT_PULLUP | MUX_MODE4)	/* MMC2_DAT1 as GPIO5_5 */
> 		>;
> 	};
>
> and
>
> &mmc2 {
> 	ti,quirk-swakeup-missing;
> 	pinctrl-names = "default", "active", "idle";
> 	pinctrl-0 = <&mmc2_pins>;
> 	pinctrl-1 = <&mmc2_pins>;
> 	pinctrl-2 = <&mmc2_cirq_pin>;
> 	ti,cirq-gpio = <&gpio5 5 0>; /* GPIO133 = 128+5 */
> };
>
> to my dts file but it doesn't make any apparent difference.
>
> Any idea what I might be doing wrong?
> (the base kernel I am applying patches to is from 8th Oct,
>   commit 0e7a3ed04f0cd4311096d691888f88569310ee6c)
>
> BTW,
>   - with the default polling, I get about 1Mb/sec with iperf
>   - with sd-irq enabled and FCLK kept on the whole time, I get 4Mb/sec
>   - with sd-irq enable, FCLK kept on, and the 5ms polling also
>     running, I get over 5Mb/sec!
> Still much less than the 40Mb/sec that I would like to get...
>
(removing svenkatr@ti.com)

Hi,

Can you check if you have bus-width property set ?
	bus-width = <4>;

Thanks and Regards,
Balaji T K

> Thanks,
> NeilBrown
>

