Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaKGRMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:12:07 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:61122 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKGRMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:12:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAE8Q9tBDxq9W=Vh0LRCRNR+Dj+5PrWyzK+GBdMDM=1kq84mFTA@mail.gmail.com>
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com>
	<545BCDBE.9020200@tronnes.org>
	<545C4904.1010402@wwwdotorg.org>
	<545CF15A.1050601@tronnes.org>
	<CAE8Q9tBDxq9W=Vh0LRCRNR+Dj+5PrWyzK+GBdMDM=1kq84mFTA@mail.gmail.com>
Date: Fri, 7 Nov 2014 17:12:03 +0000
X-Google-Sender-Auth: 5F49DNqaDDCBDr34OQZxLeNj790
Message-ID: <CAE8Q9tC7jowebEF3OgRu+qHemV7v_d3o6ZbCPQMbL8_7LR4Ewg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model B+
From: Gordon Hollingworth <gordon@holliweb.co.uk>
To: Noralf Tronnes <notro@tronnes.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Matthias Klein <matthias.klein@linux.com>,
        "linux-rpi-kernel@lists.infradead.org" 
	<linux-rpi-kernel@lists.infradead.org>,
        lee@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resend: HTML less...

On 7 November 2014 17:07, Gordon Hollingworth <gordon@holliweb.co.uk> wrote:
>
>
> On 7 November 2014 16:20, Noralf Tronnes <notro@tronnes.org> wrote:
>>
>> Den 07.11.2014 05:22, skrev Stephen Warren:
>>>
>>> On 11/06/2014 12:36 PM, Noralf Tronnes wrote:
>>>>
>>>> Den 06.11.2014 00:45, skrev Matthias Klein:
>>>>>
>>>>> The model B and B+ differ in the GPIO lines for ACT and PWR leds, and
>>>>> the
>>>>> I2S interface.
>>>>>
>>>>> Signed-off-by: Matthias Klein <matthias.klein@linux.com>
>>>>> ---
>>>>> Changes in v2:
>>>>> - move the common parts between the B and B+ model into the new
>>>>> bcm2835-rpi.dtsi file
>>>>>
>>>>> - add the I2S signals to the B+ file which fix the problem that USB is
>>>>> not working
>>>>>     with the current bcm2835-rpi-b.dts file on the B+.
>>>>> ---
>>>>
>>>> <snip>
>>>>>
>>>>> +&gpio {
>>>>> +    pinctrl-names = "default";
>>>>> +
>>>>> +    gpioout: gpioout {
>>>>> +        brcm,pins = <6>;
>>>>> +        brcm,function = <1>; /* GPIO out */
>>>>> +    };
>>>>> +
>>>>> +    alt0: alt0 {
>>>>> +        brcm,pins = <0 1 2 3 4 5 7 8 9 10 11 14 15 40 45>;
>>>>> +        brcm,function = <4>; /* alt0 */
>>>>> +    };
>>>>> +
>>>>> +    alt3: alt3 {
>>>>> +        brcm,pins = <48 49 50 51 52 53>;
>>>>> +        brcm,function = <7>; /* alt3 */
>>>>> +    };
>>>>> +};
>>>>
>>>> AFAIK these pins will always be configured regardless of whether they
>>>> are used by a driver or not.
>>>
>>> Yes.
>>>
>>>> Could we do something like this for SPI and I2C, configuring only when
>>>> needed?
>>>
>>> ...
>>>>
>>>> &spi {
>>>>      pinctrl-names = "default";
>>>>      pinctrl-0 = <&spi_pins>;
>>>> };
>>>
>>> It's certainly possible, but I don't really see any advantage. I'd much
>>> rather see the pinmux set up correctly all in one go as early as
>>> possible.
>>>
>>>>> +&i2c0 {
>>>>> +    status = "okay";
>>>>> +    clock-frequency = <100000>;
>>>>> +};
>>>>> +
>>>>> +&i2c1 {
>>>>> +    status = "okay";
>>>>> +    clock-frequency = <100000>;
>>>>> +};
>>>>> +
>>>>
>>>> Should the I2C busses be enabled by default?
>>>
>>> Yes, I think so. Whichever I2C controllers are actually connected to
>>> something (even bare pins on an IO connector) should be enabled by the
>>> DT, so that they're available for use.
>>
>> What makes i2c so special that it should be enabled by default?
>> SPI is not enabled and not 1wire, i2s, lirc either, they must be
>> explicitly
>> enabled. The problem I see, is that this is a newbie platform, and having
>> pins driven increases the chance of shorting something.
>> And it's quite easy to enable these devices with fdtput.
>>
>>>> On Raspian, i2c is disabled
>>>> by blacklisting the module (/etc/modprobe.d/raspi-blacklist.conf).
>>>> At least i2c0 should be left disabled due to the HAT EEPROM and camera.
>>>> The bus number has also changed with revisions:
>>>> http://www.raspberrypi.org/forums/viewtopic.php?p=603950#p603950
>>>
>>> It sounds like for I2C-0 on the B+ should use the i2c-mux-pinctrl.c to
>>> switch the bus between the two destinations as required, although we'd
>>> have to confirm with Broadcom or the RPi Foundation that that would work
>>> with this SoC.
>>>
>>> There's certainly no reason to believe that the kernel wouldn't want to
>>> read the HAT EEPROM. After all, it has to identify what's connected
>>> there.
>>
>> This will happen solely in the firmware. The firmware reads the eeprom,
>> and if it contains a DT fragment, it is merged with the dtb before handing
>> it over to the kernel. As far as I know, this hasn't been implemented yet.
>>
>> I asked if we couldn't use u-boot as the boot loader, but I was turned
>> down.
>> Personally I'm not happy about putting a lot stuff in a closed firmware,
>> especially on a platform dedicated to getting kids into programming.
>>
>> From the HAT specification:
>> GPIO pins ID_SC and ID_SD (GPIO0 and GPIO1) are reserved for use solely
>> for board detection / identification. The only allowed connections to
>> the ID_ pins are an ID EEPROM plus 3.9K pull up resistors. Do not connect
>> anything else to these pins!
>>
>> Ref:
>> https://github.com/raspberrypi/hats/blob/master/designguide.md#gpio-requirements
>>
>> I asked in the forum if I could use an app for writing to the eeprom to
>> change things like display rotation in the DT fragment, but was told that
>> this
>> was a no-no. i2c0 is also used together with the camera port, which is
>> then
>> controlled by the firmware.
>
>
> The idea with the HAT specification is to provide a mechanism for hardware
> developers to add their drivers and configuration in such a way as to avoid
> 'special' kernel builds for particular bits of hardware (this was a problem
> with a number of DAC add on boards for the Pi)
>
> There is software in the Raspberry Pi github to edit the EEPROM if you
> really want to (which would allow you to do that) but this isn't really the
> point for normal users and shouldn't be encouraged (just in case they break
> the information in the EEPROM).
>
>>
>>
>> When talking about firmware, there's also a /boot/dt-blob.bin used for
>> configuring pins and clocks.
>>
>> https://github.com/raspberrypi/documentation/blob/master/configuration/pin-configuration.md
>> This is the source of that file:
>> https://github.com/raspberrypi/documentation/blob/master/configuration/images/dt-blob.dts
>> I haven't studied this, so I don't know how/if it affects our work here.
>>
>
> The dt-blob.bin is a device tree blob that is specifically used to configure
> the binary blob initial gpio settings, if you look at the documentation
> you'll see the standard default dt-blob.bin  In there are a number of
> different nodes specifically for the videocore blob, firstly they set up the
> gpio alternate settings and pin defaults and also assign pin numbers to pin
> functions for the binary blob, such as the HDMI_ATTACHED (hdmi hotplug
> gpio), obviously this pin is fixed on the B, B+, A but are programmable for
> the compute module...  This allows hardware designers a little freedom when
> assigning pins which is very important when developing new hardware.
>
> It does in some way effect you because in the long run, the two files are
> going to contain similar data (i.e. the initial state of the GPIOs and the
> alternate settings) and of course it's just bad design having to reproduce
> the same data in two places!
>
>>
>>
>> _______________________________________________
>> linux-rpi-kernel mailing list
>> linux-rpi-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-rpi-kernel
>
>
