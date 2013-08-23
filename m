Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3HWQSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:18:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44882 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab3HWQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:18:04 -0400
Message-ID: <52178B0B.7090303@ti.com>
Date: Fri, 23 Aug 2013 21:47:15 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benoit Cousson <bcousson@baylibre.com>
CC: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>, <mark.rutland@arm.com>,
        <a.zummo@towertech.it>,
        <davinci-linux-open-source@linux.davincidsp.com>, <khilman@linaro.org>,
        <rtc-linux@googlegroups.com>, <devicetree@vger.kernel.org>,
        <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <rob.herring@calxeda.com>, <sudhakar.raj@ti.com>, <rob@landley.net>,
        <grant.likely@linaro.org>, <akpm@linux-foundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 1/2] rtc: omap: update of_device_id to reflect latest
 ip revisions
References: <1376653017-21935-1-git-send-email-gururaja.hebbar@ti.com> <1376653017-21935-2-git-send-email-gururaja.hebbar@ti.com> <520E341D.4080206@baylibre.com> <520E482A.1070504@ti.com> <520E5444.1000700@baylibre.com> <52172264.3070000@ti.com> <52177B6C.2080406@baylibre.com>
In-Reply-To: <52177B6C.2080406@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2013 8:40 PM, Benoit Cousson wrote:

>>> There is no assumption about the lost of functionality by using the
>>> generic version of the driver. How the user is supposed to know the
>>> amount of functionality he will lose, and if this is acceptable to
>>> him.
>>
>> I suppose the generic driver would return some error code like
>> -ENOTSUP for the functionality it cannot provide.
> 
> Well, I guess it depends of the added functionality add how far the IP
> version is forward compatible with the old driver. If the new IP version
> is just improving the performance by adding a DMA mode instead of the
> PIO, then the driver API can remain the same.
> But if you add a new functionality that will require an extended API,
> there is no way you can report such error. Except if the API itself is
> done with a good forward compatibility support.
> 
> And if the new functionality is mandatory to make the new system
> operational, returning an error might just make the system not working
> at all.

If the driver cannot work at all, then yes, I would not claim
compatibility. At least a subset of functionality should work.

> 
>> Why
>> would someone write a driver supporting “fsl,mpc8641-uart” if 100% of
>> its hardware features are also supported by “ns16550" driver?
> 
> That's still doable, if you want to reduce the size of a big generic
> driver into a smaller specific driver. The point is that the compatible

Thats plausible. Although I have to admit I have never seen a new driver
being written just because another existing driver is bloated.

> value does not have any assumption about the driver that will handle it.

Right. Its all driven by hardware changes.

> 
> The other issue is that we are supposed to always use the latest SoC
> version even if the IP is 100% the same. Like
> 
> omap5-timer {
>     compatible = "omap5-timer", "omap4-timer";
> }
> 
> So how are you suppose to differentiate the same IP, and a compatible IP???
> 
> That's what I don't like in that compatible string definition. You do
> not necessarily know the amount of compatibility you are talking about.

That's correct. The strings themselves tell very little how much OMAP5
timer works when compatible = "omap4-timer" is passed. Some known
limitations can perhaps be documented in binding definition.

>> that it is today. Thing is, you can never know if the IP needs any
>> additional handling even after reading the spec. We keep discovering
>> new features/quirks. So, when writing <new-soc>.dtsi its safer to
>> always use
>>
>> compatible = "ti,<new-soc>-rtc", "ti,<compatible-soc>-rtc";
>>
>> even though _today_ you may not have code that specifically handles
>> "ti,<new-soc>-rtc".
> 
> Well, we can do that, but honestly, I do not see the need. You can
> always update the dts later. Why would we add hundreds more compatible
> strings just in case few devices will need special handling. That's
> overkill.
> If was maybe easy and harmless in the good old PPC time when the DTS
> files were relatively small, but the ARM DTS files are much bigger.
> 
> In the name of the Keep It Simple Principle, I would just avoid adding
> something just because it might be useful in 5 % of the cases.

It certainly seems overkill today. If and when the .dts[i] files are
maintained as a separate project it will become painful to keep kernel
and .dtb in sync. This will then become important, as bootloader
independence today is.

>>>> Otherwise they get plain RTC functionality - but at least they
>>>> get something instead of no RTC.
>>>
>>> Because you assume that this feature is not important and thus you
>>> can use the plain RTC, but what if someone is buying that HW
>>> because of this new feature. Without that feature his system will
>>> just not work properly.
>>
>> Right, but thats not a problem DT can solve. He/she needs to hassle
>> TI for updated drivers. But there could be 10 other customers who are
>> just okay with plain RTC. So till the time driver is updated to use
>> ti,am3352-rtc", are you saying no one should be able to use the RTC
>> on the SoC at all even though 90% features are available?
> 
> Again, if it will not prevent the system to work properly, then it is
> fine. But let's assume that without the wakeup RTC functionality, you
> just cannot wakeup from suspend an am3352 board. Then you end up with a
> non functional system for the PM point of view.

Correct, but this is because of lack of kernel support for a feature.
Not because of the way compatible is written.

> Someone who is not aware that the compatible RTC is not supporting that
> feature might spend some time figuring out why he cannot wakeup from
> suspend on a RTC alarm.

Right. DT/compatible does not make this problem better or worse. Even
using platform device model, you would still end up with a partially
working system.

>>> Saying that this is compatible whereas you lost functionality is
>>> lying to the customer for my point of view.
>>
>> If 100% functionality is required for compatibility then I am afraid
>> there is nothing like "compatibility". There are just different
>> isolated versions.
> 
> I guess you are right.
> 
> Bottom-line, I'm really disappointed but that lack of accuracy in the
> compatible string, but I guess, it was done for what you guys are doing.
> And maybe, it is something that should just be well documented in the
> bindings to avoid confusing the users.

Okay. Can you please see if you can take 2/2 for v3.12? It can be taken
independently of 1/2 (which I guess akpm will pick up).

Thanks,
Sekhar
