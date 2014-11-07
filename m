Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaKGEWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:22:31 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41975 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbaKGEWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:22:30 -0500
Message-ID: <545C4904.1010402@wwwdotorg.org>
Date: Thu, 06 Nov 2014 21:22:28 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Noralf Tronnes <notro@tronnes.org>,
        Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org, lee@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com> <545BCDBE.9020200@tronnes.org>
In-Reply-To: <545BCDBE.9020200@tronnes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 12:36 PM, Noralf Tronnes wrote:
> Den 06.11.2014 00:45, skrev Matthias Klein:
>> The model B and B+ differ in the GPIO lines for ACT and PWR leds, and the
>> I2S interface.
>>
>> Signed-off-by: Matthias Klein <matthias.klein@linux.com>
>> ---
>> Changes in v2:
>> - move the common parts between the B and B+ model into the new
>> bcm2835-rpi.dtsi file
>>
>> - add the I2S signals to the B+ file which fix the problem that USB is
>> not working
>>    with the current bcm2835-rpi-b.dts file on the B+.
>> ---
> <snip>
>> +&gpio {
>> +    pinctrl-names = "default";
>> +
>> +    gpioout: gpioout {
>> +        brcm,pins = <6>;
>> +        brcm,function = <1>; /* GPIO out */
>> +    };
>> +
>> +    alt0: alt0 {
>> +        brcm,pins = <0 1 2 3 4 5 7 8 9 10 11 14 15 40 45>;
>> +        brcm,function = <4>; /* alt0 */
>> +    };
>> +
>> +    alt3: alt3 {
>> +        brcm,pins = <48 49 50 51 52 53>;
>> +        brcm,function = <7>; /* alt3 */
>> +    };
>> +};
>
> AFAIK these pins will always be configured regardless of whether they
> are used by a driver or not.

Yes.

> Could we do something like this for SPI and I2C, configuring only when
> needed?
...
> &spi {
>     pinctrl-names = "default";
>     pinctrl-0 = <&spi_pins>;
> };

It's certainly possible, but I don't really see any advantage. I'd much
rather see the pinmux set up correctly all in one go as early as possible.

>> +&i2c0 {
>> +    status = "okay";
>> +    clock-frequency = <100000>;
>> +};
>> +
>> +&i2c1 {
>> +    status = "okay";
>> +    clock-frequency = <100000>;
>> +};
>> +
>
> Should the I2C busses be enabled by default?

Yes, I think so. Whichever I2C controllers are actually connected to
something (even bare pins on an IO connector) should be enabled by the
DT, so that they're available for use.

> On Raspian, i2c is disabled
> by blacklisting the module (/etc/modprobe.d/raspi-blacklist.conf).
> At least i2c0 should be left disabled due to the HAT EEPROM and camera.
> The bus number has also changed with revisions:
> http://www.raspberrypi.org/forums/viewtopic.php?p=603950#p603950

It sounds like for I2C-0 on the B+ should use the i2c-mux-pinctrl.c to
switch the bus between the two destinations as required, although we'd
have to confirm with Broadcom or the RPi Foundation that that would work
with this SoC.

There's certainly no reason to believe that the kernel wouldn't want to
read the HAT EEPROM. After all, it has to identify what's connected there.
