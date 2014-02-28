Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaB1PHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:07:15 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42131 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaB1PHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:07:12 -0500
Message-ID: <5310A61C.5000105@ti.com>
Date: Fri, 28 Feb 2014 09:07:08 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, Lee Jones <lee.jones@linaro.org>
CC: <florian.vaussard@epfl.ch>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/3] mfd: twl6040: Select i2c fast mode as default with
 regmap patch
References: <1393509410-1640-1-git-send-email-peter.ujfalusi@ti.com> <1393509410-1640-2-git-send-email-peter.ujfalusi@ti.com> <530F4A84.9070906@ti.com> <530F4CA5.6030502@ti.com> <530F5323.1020305@ti.com> <53103D34.8050101@ti.com> <53108F90.7070608@ti.com> <53109C92.10104@ti.com>
In-Reply-To: <53109C92.10104@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 08:26 AM, Peter Ujfalusi wrote:
> On 02/28/2014 03:30 PM, Nishanth Menon wrote:
>> TWL6030 can do 3.3MHz by default and there are no speed registers to
>> configure.
> 
> According to the datasheet the speed of twl6030 is limited to 2.4MHz. I have
> not seen registers or pins to select the speed. As the documentation puts
> this: High-speed mode (limited to 2.4Mbit/s maximum)

Aye, you are correct, the latest data sheet does show this - i made
the mistake of opening an older spec doc :(..

>>> Also you could have more devices on the bus, wired for 3.4MHz. In that case we
>>> would need to make sure that the first access happens with 100KHz to twl6040
>>> to select 3.4MHz mode, switch the controller speed and allow the communication
>>> to other chips. It is another question how the 3.4MHz clients will interpret
>>> the 100KHz communication on the bus, I guess it is ignored by them.
>> As far as the i2c spec 2.1 says:
>> "Fast-mode devices are downward-compatible and can communicate with
>> Standard-mode devices in a 0 to 100 kbit/s I2C-bus system"
>> ...
>> "Hs-mode devices can transfer information at bit rates of up to 3.4
>> Mbit/s, yet they remain fully downward compatible with Fast- or
>> Standard-mode (F/S-mode) devices for bi-directional communication in a
>> mixed-speed bus system."
>>
>> So, they are backward compatible.
> 
> I just tried it on PandaBoard to set the i2c speed to 24MHz. If I do not touch
> the twl6040 ACCCTL register's i2cmode I can not access to twl6040 later on.
> However if I select the high-speed mode as the first write everything is fine
> afterwards.
> Hrm, it is possible that I can write with high-speed to twl6040 but the
> twl6040 is sending back the data in normal-mode?

I doubt it would do that as it would be a violation of i2c high speed
specification.

> So in theory if I have the ACCCTL write as a first I2C access towards twl6040
> we might be safe if the bus is in high-speed mode?

I think you did catch the real behavior in the email below.

I do however suggest that you put one of those i2c analyser on the
rail to see what is happening. else, we'd be doing a lot of guessing here.

> 
> If I have fast mode configured to the controller, I can still communicate with
> twl6040 even if it is set to normal mode.

> 
> I still think that this patch is safe for now. We could try to figure out how
> to increase the i2c speed on the bus for twl6030 and twl6040. This has to be
> done in the same series.

?? you mean set i2c bus speed to full speed on PandaBoard? it is
already full speed[1]!

> 
> Now after several boots:
> It seams if I set the i2c to 2.4MHz and I can not communicate with twl6040
> right after cold power on.
> So if the i2c bus is already set to 2.4GHz I can not set the twl6040 ACCCTL
> register. But the content of ACCCTL register seams to be preserved between
> reboots and this is why I saw that the 2.4MHz bus speed might be even possible.

This observation is the key.

Are you power cycling the regulators for TWL6040 as part of your
shutdown handler? Did you read the ACCTL register after a reboot to
see if the register contents are still the same as before?

Based on this observation, I suggest switching [1] to 100KHz.

[1]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/omap4-panda-common.dtsi#n291

-- 
Regards,
Nishanth Menon
