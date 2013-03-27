Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3C0LDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:03:22 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:46478 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3C0LDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:03:20 -0400
Message-ID: <5152D1F5.2050308@slimlogic.co.uk>
Date: Wed, 27 Mar 2013 11:03:17 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, "balbi@ti.com" <balbi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "s-guiriec@ti.com" <s-guiriec@ti.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH v3] USB: PHY: Palmas USB Transceiver Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1364203926-24488-1-git-send-email-kishon@ti.com> <51501CFB.4020905@nvidia.com> <51513A40.7080905@ti.com> <515163F6.3010400@slimlogic.co.uk> <51516695.8020808@nvidia.com> <51516A10.40704@slimlogic.co.uk> <5151CB36.1050404@wwwdotorg.org> <5151D37A.4020300@slimlogic.co.uk> <515203BC.7010003@wwwdotorg.org>
In-Reply-To: <515203BC.7010003@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/03/13 20:23, Stephen Warren wrote:
> On 03/26/2013 10:57 AM, Graeme Gregory wrote:
>> On 26/03/13 16:22, Stephen Warren wrote:
>>> On 03/26/2013 03:27 AM, Graeme Gregory wrote:
>>> ...
>>>> If we are tightly coupling as above then using platform_irq is an extra
>>>> inefficiency. You both have to populate this then parse it afterwards.
>>>> Why not just use the regmap helper? Ill admit this code is like this as
>>>> there was a period where platform irqs in DT just was not working right!
>>>>
>>>> We should really agree now if we are going for loose or tight coupling
>>>> now rather than keep switching?
>>> Yes, this is something that I think needs to be fully resolved before
>>> any more Palmas patches are discussed.
>>>
>>> So you can have the MFD components fully coupled or completely
>>> standalone. We should fully pick one or the other, not some mish-mash of
>>> the two.
>>>
>>> In practical terms, this means that:
>>>
>>> a) Tightly coupled
>>>
>>> The top-level MFD device knows exactly which child devices are present.
>>> It has an internal table to defined the set of child devices, and
>>> instantiate them. It provides them with IRQs, I2C addresses and register
>>> base addresses (or regmaps), etc. etc., using purely Palmas-internal
>>> APIs. If using device tree, the DT won't include any representation of
>>> which child devices are present, nor their I2C addresses, nor their
>>> register addresses, nor their IRQs, etc. That's all inside the driver.
>>>
>>> b) Completely decoupled.
>>>
>>> The top-level MFD device knows nothing about its children. It simply
>>> provides a bus into which they can be instantiated, and a generic IRQ
>>> controller into which they can hook.
>>>
>>> Platform data or device tree is solely used to define which children
>>> exist, which of the top-level MFD's I2C addresses is used for each
>>> child, the base register address for each child device, the IRQs used by
>>> each child device, etc.
>>>
>>>
>>> Which of those two models are different people expecting?
>>>
>>> (b) appears to be the most flexible, and since you have defined the DT
>>> bindings to contain a separate node for each MFD child device, each with
>>> its own compatible value, seems to be what you're aiming for. In this
>>> scenario, there should be no private APIs between the top-level MFD
>>> device and the children though; everything should be using standard bus
>>> APIs.
>> I was aiming towards (b) which would allow drivers for IP blocks that I
>> know are shared between multiple devices such as RTC which is shared by
>> twl6030, twl6032, tps80032, tps65910, tps65911, tps65912, tps80035,
>> tps80036 and probably many more.
>>
>> Finishing (b) implementation is currently beyond the time I have
>> available I think.
>>
>> If we choose to ignore path (b) and ignore the code duplication of half
>> a dozen RTC drivers for the same IP than the path to (a) is much quicker
>> and easier. Can just rip out a lot of the DT stuff, use mfd_add_devices.
>> Makes the binding much simpler. Means we don't have to use platform
>> resources for IRQs. Makes palmas and palmas-charger just 2 black boxes
>> which is in line with other MFDs.
>>
>> So I think I have come around to just do it the easy way and select (a)
>>
>> I shall work on the main palmas series to implement (a).
>>
>> This will obviously invalidate some comments on this patch and the main
>> series.
> Well, my question was more directed at which way we want to model the HW
> in the device tree, rather than how we want to implement the driver. The
> driver implementation style might end up being derived from the DT
> structure, but it shouldn't be the other way around.
>
> I think if people think (b) is the right way to go, we should just do
> it, and ignore any time issues; if it takes a while to get it right
> upstream, what is the issue with that?
I'm going to take a timeout now, I have to travel on an emergency
tonight and not sure when I will be back.

Graeme

