Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3J1KBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:01:46 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:1486 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3J1KBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:01:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 28 Oct 2013 02:56:49 -0700
Message-ID: <526E3605.9080002@nvidia.com>
Date: Mon, 28 Oct 2013 19:01:41 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: Any news on Runtime Interpreted Power Sequences
References: <20131025112224.6e5265e6@notabene.brown>	<526A0E71.100@nvidia.com> <20131025183345.2b963e13@notabene.brown>
In-Reply-To: <20131025183345.2b963e13@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 04:33 PM, NeilBrown wrote:
> * PGP Signed by an unknown key
>
> On Fri, 25 Oct 2013 15:23:45 +0900 Alex Courbot <acourbot@nvidia.com> wrote:
>
>> Hi Neil,
>>
>> On 10/25/2013 09:22 AM, NeilBrown wrote:
>>>    I'm wondering if there was any news on the Runtime Interpreted Power
>>> Sequences?
>>> The most recent news I can find is
>>>     https://lkml.org/lkml/2013/4/27/73
>>> where you say they might be ready for 3.11.  Clearly that didn't work
>>> (predictions being hard, especially about the future).
>>>
>>> I'm really keen to see them turning into a reality and I gather others are
>>> too. So ... can we hope?
>>
>> A prerequisite of power sequences was to merge the gpiod interface, and
>> this is finally happening. It took much longer than I wanted, sorry
>> about that.
>>
>> Logically speaking nothing should now stand in the way of a new version
>> of the power sequences. Expected maybe my own skepticism about them.
>>
>> The first version of the power seqs is mainly the result of my
>> misunderstanding of the device tree. Reconsidering it now, if we strip
>> the DT support away power seqs would just become a simplified way to
>> describe how to power a device up and down. In other words, it would be
>> another way to express what can be expressed with C code and would not
>> bring any additional flexibility that DT-described power seqs would have
>> (and I say this totally convinced now that power sequences in the device
>> tree were a bad idea).
>>
>> The advantage I could see is that using power sequences we could get rid
>> of the cumbersome and mistake-prone error checking code which is
>> basically the same for most devices. You would just need to describe
>> what you want to activate, and in which order, and the power seqs
>> framework would catch and report any error.
>>
>> I'm not sure if this is a sufficient reason to introduce another
>> framework into the kernel, but if this is deemed a good reason by more
>> experienced people then I'm ok to give it a shot. If you have other
>> motivations for this, please also state them so I can get the whole
>> picture. Maybe I just need to be a little bit more motivated about this
>> idea myself. :)
>>
>> Thanks,
>> Alex.
>
> Hmmm... I'm not encouraged that you don't see them as belonging in
> device-tree, as that is exactly where I want them.
>
> Let me explain what I'm thinking.
>
> I have two (or three) use-cases on my board ("GTA04" replacement motherboard
> for Openmoko Phone).
>
> Firstly the wifi chip is very fussy about being reset properly before being
> accessed.  However it shares the same power regulator as the bluetooth chip.
> So if the bluetooth is in use when you "ifconfig down; ifconfig up" the
> wifi, it won't get powered down, so it won't get reset, so it won't work.
>
> What I need to do is to tell the 'mmc/sdio' driver that when it wants to
> power-on the wifi, it must
>     pull a reset-gpio low
>     turn-on the regulator (which might already be on)
>     pull the reset-gpio high again
>
> I currently have that hacked into the omap-hsmmc driver but I don't think the
> code really belongs there.

I'd argue that it probably belongs here, on the contrary - unless this 
power-on sequence breaks other use-cases (which I don't think it does), 
it could simply be considered a safer way to power your device on. 
Shared regulators are quite common in the kernel, so you cannot simply 
rely on them solely to power a device down and expect it to be back to 
its reset set the next time you switch the regulator on.

> I would much rather that the omap-hsmmc could be given a 'RIPS' instead
> of (or as well as) the regulator and be told to just turn that RIPS on or off.
> The RIPS would do the appropriate timed fiddling with GPIO and Regulator.
> The only place I can think of the describe the RIPS would be in device-tree.

The problem I have with this is that the power sequence of a device is 
something that should be device-specific (as opposed to board-specific), 
and thus should be handled by the device driver. If you need to come 
with a board-specific way to power a device up, this most most certainly 
means something is wrong with the device's powerup sequence to start 
with. In the current case, it definitely seems to be the issue. Is there 
any problem introduced by asserting reset on your device when you power 
it up?

> Secondly I have two devices that are behind serial ports - a GPS and the
> bluetooth.
> It makes perfect sense to tie the  power-on/off of these to the serial-port
> concept of "DTR".  The omap-serial doesn't have a physical DTR, but is can be
> configured with a GPIO to use as the DTR (it gets asserted on 'open' and
> de-asserted on 'close').
>
> I currently have a "gpio-to-regulator" converting driver plugged between the
> serial port and the blue-tooth's regulator.  When I open the serial port for
> bluetooth it asserts the gpio line which is routed through gpiolib to my
> driver which enables the appropriate regulator.  I have something similar for
> the GPS.
>
> I think the gpio-to-regulator driver is a kludge.  I would much rather tell
> the omap-serial to activate/de-activate a RIPS as the DTR action.  That RIPS
> could then control GPIO for a "real" dtr line, or control a regulator to
> support my bluetooth.

What you describe here sounds pretty much like the hotplug GPIO of e.g. 
HDMI drivers, which activates the display controller when a plug event 
occurs. I'd say that you need a similar mechanism, either at the driver 
or framework level, that powers-up the device (not a single regulator 
which might once again be shared).

Power sequences would be of little help here, since instead of having a 
gpio-to-regulator driver you would need a gpio-to-powerseq one. Instead 
of relying on power sequences for this, maybe you could leverage the 
runtime_pm framework and invoke pm_runtime_get() on your device when the 
GPIO is asserted, and pm_runtime_put() once it goes down. This could be 
done at your GPS driver level, but it might be interesting to see if 
this could not be generalized for a larger group of devices. This kind 
of 'device active when a GPIO gets high' should be rather common.

> For the GPS, power on/off is really messy.  There is a toggle connected to a
> GPIO so you need to know what the current state is before you can know how to
> "turn off".  So you need to either plug into the serial driver and watch for
> input, or use pinctrl to grab the RX pin and treat it like a GPIO.
> This is admittedly quite horrible and it makes sense to have a dedicated
> driver for it, but as the purpose of the driver would be to power
> something up or down it would be nice if the interface it presented was a
> power-up-down interface which is exactly what RIPS promised.

I'm not sure I understand all the actors involved here, but since you 
mention GPIOs powering devices up and down again, wouldn't it somehow 
fit within the runtime_pm leverage I suggested earlier? Here it seems 
like you need a "power conditions" framework more than "power sequences". :)

> I imagine a device-tree interface a bit like GPIO but with more details.
> We would have #defines for
> #define RIPS_REG_ON <0>,
> #define RIPS_REG_OFF <1>,
> #define RIPS_GPIO_ASSERT <2>,
> #define RIPS_GPIO_DEASSERT <3>,
> #define RIPS_DELAY <4>,
> #define RIPS_NATIVE_ON <5>,
> #define RIPS_NATIVE_OFF <6>,
>
> Then
>
>   rips-on = RIPS_GPIO_ASSERT  "wifi-reset",
>             RIPS_DELAY         <10>,
>             RIPS_REG_ON       "wifi",
>             RIPS_DELAY         <10>,
>             RIPS_GPIO_DEASSERT "wifi-reset";
>   wifi-reset-gpio = <&gpio1 0 GPIO_ACTIVE_HIGH>;
>   wifi-supply = <&vaux4>;
>
> would would power-on my wifi-chip.  It's probably a bit ugly, but it is
> simple and does follow an established pattern to some extent.

But this most likely belongs to your wifi driver. Maybe not every board 
embedding your wifi chip will require e.g. active regulator, but that's 
what dummy regulators are for, and using them results in much less 
complexity (and much less controversy :)) that having interpreted code 
all over the device tree.

So far I don't see any hard requirement for power seqs in your use 
cases, but feel free to challenge my arguments. I'm adding the linux-pm 
list to the discussion since I feel we might get interesting comments 
from there - especially since what you want to do does not seem so uncommon.

Alex.

