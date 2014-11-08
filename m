Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaKHGML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 01:12:11 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60985 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaKHGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 01:12:10 -0500
Message-ID: <545DB437.7080409@wwwdotorg.org>
Date: Fri, 07 Nov 2014 23:12:07 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Noralf Tronnes <notro@tronnes.org>
CC: Matthias Klein <matthias.klein@linux.com>,
        linux-rpi-kernel@lists.infradead.org, lee@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com> <545BCDBE.9020200@tronnes.org> <545C4904.1010402@wwwdotorg.org> <545CF15A.1050601@tronnes.org>
In-Reply-To: <545CF15A.1050601@tronnes.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 09:20 AM, Noralf Tronnes wrote:
> Den 07.11.2014 05:22, skrev Stephen Warren:
>> On 11/06/2014 12:36 PM, Noralf Tronnes wrote:
>>> Den 06.11.2014 00:45, skrev Matthias Klein:
>>>> The model B and B+ differ in the GPIO lines for ACT and PWR leds,
>>>> and the
>>>> I2S interface.
...
>>>> +&i2c0 {
>>>> +    status = "okay";
>>>> +    clock-frequency = <100000>;
>>>> +};
>>>> +
>>>> +&i2c1 {
>>>> +    status = "okay";
>>>> +    clock-frequency = <100000>;
>>>> +};
>>>> +
>>>
>>> Should the I2C busses be enabled by default?
>>
>> Yes, I think so. Whichever I2C controllers are actually connected to
>> something (even bare pins on an IO connector) should be enabled by the
>> DT, so that they're available for use.
>
> What makes i2c so special that it should be enabled by default?

I2C itself as a bus requires no configuration. If all you represent in
DT is an enabled controller, it's quite possible for SW to then go and
use the I2C bus in SW. Thus bus can be scanned to detect devices. The
user can instruct SW what address to communicate with and how. Etc.

> SPI is not enabled

SPI devices require extra configuration; the chip-select must be
configured for each device. It doesn't make sense to enable the SPI bus
without actually defining which devices are attached to it.

> and not 1wire, i2s, lirc either, they must be explicitly
> enabled.

I don't think there is a 1-wire controller on the RPi? There's certainly
no pin on the expansion header (at least in A/B/B-rev2) that's labeled
in a way that indicates 1-wire is the "default" purpose.

I2S typically requires other things to be set up to be useful, e.g.
communication with a (typically I2C-based) CODEC to configure it before
it'll accept I2S data.

lirc is more of a SW concept.

> The problem I see, is that this is a newbie platform, and having
> pins driven increases the chance of shorting something.

In the case of I2C at least, the pins are always pulled high by the I2C
pull-ups. Admittedly that's a weak drive. Either way though, you simply
need to take care when hooking things up. There's simply no way for SW
to make it completely fool-proof.

> And it's quite easy to enable these devices with fdtput.

DT include files might be better, or DT overlays.

>>> On Raspian, i2c is disabled
>>> by blacklisting the module (/etc/modprobe.d/raspi-blacklist.conf).
>>> At least i2c0 should be left disabled due to the HAT EEPROM and camera.
>>> The bus number has also changed with revisions:
>>> http://www.raspberrypi.org/forums/viewtopic.php?p=603950#p603950
>>
>> It sounds like for I2C-0 on the B+ should use the i2c-mux-pinctrl.c to
>> switch the bus between the two destinations as required, although we'd
>> have to confirm with Broadcom or the RPi Foundation that that would work
>> with this SoC.
>>
>> There's certainly no reason to believe that the kernel wouldn't want to
>> read the HAT EEPROM. After all, it has to identify what's connected
>> there.
>
> This will happen solely in the firmware.

Oh, given your comments below, does the firmware completely own I2C-0
both when it's used for EEPROM ID *and* when driving the camera module?
I had assumed all control of the camera module would be performed via
drivers in the Linux kernel, and hence I2C-0 would be driven by the
Linux kernel I2C driver. If this isn't the case, we should indeed make
sure that the kernel DTs don't touch the pinmux for the camera I2C port
at all. It'd also be quite disappointing, since it would make it
essentially impossible for anyone outside the RPi Foundation to connect
a different camera module that required different programming over I2C.

> The firmware reads the eeprom,
> and if it contains a DT fragment, it is merged with the dtb before handing
> it over to the kernel. As far as I know, this hasn't been implemented yet.

Hmm. It sounds like it'd be much better if the EEPROM contained a board
ID, and the board ID was passed into the kernel, which then used the
(recently merged upstream) DT overlays feature to load the overlay DT
once that kernel boots. IIUC this would also allow unloading and
reloading the overlay DT during development of the DT overlay.

> I asked if we couldn't use u-boot as the boot loader, but I was turned
> down.

I assume you mean in the official SD card images? Nothing is stopping
anyone from using it; I use it without issue for example.

> Personally I'm not happy about putting a lot stuff in a closed firmware,
> especially on a platform dedicated to getting kids into programming.

Indeed.

> From the HAT specification:
> GPIO pins ID_SC and ID_SD (GPIO0 and GPIO1) are reserved for use solely
> for board detection / identification. The only allowed connections to
> the ID_ pins are an ID EEPROM plus 3.9K pull up resistors. Do not connect
> anything else to these pins!
> 
> Ref:
> https://github.com/raspberrypi/hats/blob/master/designguide.md#gpio-requirements
> 
> I asked in the forum if I could use an app for writing to the eeprom to
> change things like display rotation in the DT fragment, but was told
> that this
> was a no-no. i2c0 is also used together with the camera port, which is then
> controlled by the firmware.

Oh, I see. See what I said about I2C-0 above.

> When talking about firmware, there's also a /boot/dt-blob.bin used for
> configuring pins and clocks.
> https://github.com/raspberrypi/documentation/blob/master/configuration/pin-configuration.md
> 
> This is the source of that file:
> https://github.com/raspberrypi/documentation/blob/master/configuration/images/dt-blob.dts
> 
> I haven't studied this, so I don't know how/if it affects our work here.

Hmm. DT blobs for firmware:-(
