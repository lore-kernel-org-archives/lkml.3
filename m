Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbaCCLaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:30:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53157 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbaCCLae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:30:34 -0500
Message-ID: <531467D3.2030307@ti.com>
Date: Mon, 3 Mar 2014 13:30:27 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: twl6040: Select i2c fast mode as default with
 regmap patch
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com> <1393509410-1640-2-git-send-email-peter.ujfalusi@ti.com> <530F4A84.9070906@ti.com> <530F4CA5.6030502@ti.com> <530F5323.1020305@ti.com> <53103D34.8050101@ti.com> <53108F90.7070608@ti.com> <53109C92.10104@ti.com> <5310A61C.5000105@ti.com>
In-Reply-To: <5310A61C.5000105@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 05:07 PM, Nishanth Menon wrote:
> On 02/28/2014 08:26 AM, Peter Ujfalusi wrote:
>> On 02/28/2014 03:30 PM, Nishanth Menon wrote:
>>> TWL6030 can do 3.3MHz by default and there are no speed registers to
>>> configure.
>>
>> According to the datasheet the speed of twl6030 is limited to 2.4MHz. I have
>> not seen registers or pins to select the speed. As the documentation puts
>> this: High-speed mode (limited to 2.4Mbit/s maximum)
> 
> Aye, you are correct, the latest data sheet does show this - i made
> the mistake of opening an older spec doc :(..

As a note: I tried first with 3.4MHz bus speed (who reads documentation?)
twl6030 was working fine as far as I can tell. But the TRM is really
expressing that 2.4MHz is the limit for twl6030.

> I do however suggest that you put one of those i2c analyser on the
> rail to see what is happening. else, we'd be doing a lot of guessing here.

If I would have access to one...


>> If I have fast mode configured to the controller, I can still communicate with
>> twl6040 even if it is set to normal mode.
> 
>>
>> I still think that this patch is safe for now. We could try to figure out how
>> to increase the i2c speed on the bus for twl6030 and twl6040. This has to be
>> done in the same series.
> 
> ?? you mean set i2c bus speed to full speed on PandaBoard? it is
> already full speed[1]!

No, I was thinking of Fast+ or HighSpeed but I have doubts that it can be done.

>> Now after several boots:
>> It seams if I set the i2c to 2.4MHz and I can not communicate with twl6040
>> right after cold power on.
>> So if the i2c bus is already set to 2.4GHz I can not set the twl6040 ACCCTL
>> register. But the content of ACCCTL register seams to be preserved between
>> reboots and this is why I saw that the 2.4MHz bus speed might be even possible.
> 
> This observation is the key.
> 
> Are you power cycling the regulators for TWL6040 as part of your
> shutdown handler?

When the mfd driver is removed, yes powers are asked to be turned off but in
reality at least vio is always on in all of the boards I have seen.

> Did you read the ACCTL register after a reboot to
> see if the register contents are still the same as before?

Yes I did. after reboot the ACCCTL register is the same in u-boot as I set
previously, before the reboot.
Disconnect power + Power the board the ACCCTL is as it has been specified in
the datasheet.

> Based on this observation, I suggest switching [1] to 100KHz.

After several power cycle, reboot, cold boot etc. I think we can leave the i2c
speed at 400KHz and configure the twl6040 to Fast mode as the first thing when
the driver probes or the chip is powering on (regmap patch functionality).
I have not seen a single case when this failed on me and the the 4x bandwidth
does matter for twl6030 IMHO.

> 
> [1]
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/omap4-panda-common.dtsi#n291
> 


-- 
Péter
