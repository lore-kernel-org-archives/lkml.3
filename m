Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaBXJvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 04:51:39 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44874 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaBXJvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 04:51:36 -0500
Message-ID: <530B1609.8030804@ti.com>
Date: Mon, 24 Feb 2014 15:21:05 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>
CC: <george.cherian@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] usb: dwc3: core: continue probing if usb phy library
 returns -ENODEV/-ENXIO
References: <1385373690-12170-1-git-send-email-kishon@ti.com> <1390299099-14764-1-git-send-email-kishon@ti.com> <20140121144725.GF30451@saruman.home> <20140127150855.GA17928@xps8300> <20140127160458.GF13268@saruman.home> <20140128153230.GA20991@xps8300> <20140128163036.GD28546@saruman.home> <20140129144659.GA22152@xps8300> <52FB42DE.4090203@ti.com> <5304A58C.2030306@ti.com> <5307459D.9080707@ti.com> <5307468E.6040304@ti.com>
In-Reply-To: <5307468E.6040304@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Friday 21 February 2014 05:59 PM, Roger Quadros wrote:
> On 02/21/2014 02:25 PM, Kishon Vijay Abraham I wrote:
>> Hi Roger,
>>
>> On Wednesday 19 February 2014 06:07 PM, Roger Quadros wrote:
>>> Hi,
>>>
>>> On 02/12/2014 11:46 AM, Kishon Vijay Abraham I wrote:
>>>> On Wednesday 29 January 2014 08:17 PM, Heikki Krogerus wrote:
>>>>> Hi,
>>>>>
>>>>> On Tue, Jan 28, 2014 at 10:30:36AM -0600, Felipe Balbi wrote:
>>>>>> On Tue, Jan 28, 2014 at 05:32:30PM +0200, Heikki Krogerus wrote:
>>>>>>> On Mon, Jan 27, 2014 at 10:05:20AM -0600, Felipe Balbi wrote:
>>>>>>> For the controller drivers the PHYs are just a resource like any
>>>>>>> other. The controller drivers can't have any responsibility of
>>>>>>> them. They should not care if PHY drivers are available for them or
>>>>>>> not, or even if the PHY framework is available or not.
>>>>>>
>>>>>> huh? If memory isn't available you don't continue probing, right ? If
>>>>>> your IORESOURCE_MEM is missing, you also don't continue probing, if your
>>>>>> IRQ line is missing, you bail too. Those are also nothing but resources
>>>>>> to the driver, what you're asking here is to treat PHY as a _different_
>>>>>> resource; which might be fine, but we need to make sure we don't
>>>>>> continue probing when a PHY is missing in a platform that certainly
>>>>>> needs a PHY.
>>>>>
>>>>> Yes, true. In my head I was comparing the PHY only to resources like
>>>>> gpios, clocks, dma channels, etc. that are often optional to the
>>>>> drivers.
>>>>>
>>>>>>>>>> But I really want to see the argument against using no-op. As far as I
>>>>>>>>>> could see, everybody needs a PHY driver one way or another, some
>>>>>>>>>> platforms just haven't sent any PHY driver upstream and have their own
>>>>>>>>>> hacked up solution to avoid using the PHY layer.
>>>>>>>>>
>>>>>>>>> Not true in our case. Platforms using Intel's SoCs and chip sets may
>>>>>>>>> or may not have controllable USB PHY. Quite often they don't. The
>>>>>>>>> Baytrails have usually ULPI PHY for USB2, but that does not mean they
>>>>>>>>> provide any vendor specific functions or any need for a driver in any
>>>>>>>>> case.
>>>>>>>>
>>>>>>>> that's different from what I heard.
>>>>>>>
>>>>>>> I don't know where you got that impression, but it's not true. The
>>>>>>> Baytrail SoCs for example don't have internal USB PHYs, which means
>>>>>>> the manufacturers using it can select what they want. So we have
>>>>>>> boards where PHY driver(s) is needed and boards where it isn't.
>>>>>>
>>>>>> alright, that explains it ;-) So you have external USB2 and USB3 PHYs ?
>>>>>> You have an external PIPE3 interface ? That's quite an achievement,
>>>>>> kudos to your HW designers. Getting timing closure on PIPE3 is a
>>>>>> difficult task.
>>>>>
>>>>> No, only the USB2 PHY is external. I'm giving you wrong information,
>>>>> I'm sorry about that. Need to concentrate on what I'm writing.
>>>>>
>>>>> <snip>
>>>>>
>>>>>>> This is really good to get. We have some projects where we are dealing
>>>>>>> with more embedded environments, like IVI, where the kernel should be
>>>>>>> stripped of everything useless. Since the PHYs are autonomous, we
>>>>>>> should be able to disable the PHY libraries/frameworks.
>>>>>>
>>>>>> hmmm, in that case it's a lot easier to treat. We can use
>>>>>> ERR_PTR(-ENXIO) as an indication that the framework is disabled, or
>>>>>> something like that.
>>>>>>
>>>>>> The difficult is really reliably supporting e.g. OMAP5 (which won't work
>>>>>> without a PHY) and your BayTrail with autonomous PHYs. What can we use
>>>>>> as an indication ?
>>>>>
>>>>> OMAP has it's own glue driver, so shouldn't it depend on the PHY
>>>>> layer?
>>>>
>>>> right, but the PHY is connected to the dwc3 core and not to the glue.
>>>>>
>>>>>> I mean, I need to know that a particular platform depends on a PHY
>>>>>> driver before I decide to return -EPROBE_DEFER or just assume the PHY
>>>>>> isn't needed ;-)
>>>>>
>>>>> I don't think dwc3 (core) should care about that. The PHY layer needs
>>>>> to tell us that. If the PHY driver that the platform depends is not
>>>>> available yet, the PHY layer returns -EPROBE_DEFER and dwc3 ends up
>>>>> returning -EPROBE_DEFER.
>>>>
>>>> I don't think the PHY layer can 'reliably' tell if PHY driver is available or
>>>> not. Consider when the phy_provider_register fails, there is no way to know if
>>>> PHY driver is available or not. There are a few cases where PHY layer returns
>>>> -EPROBE_DEFER but none of them can tell for sure that PHY driver is either
>>>> available and failed or not available at all. It would be best for us to leave
>>>> that to the platforms if we want to be sure if the platform needs a PHY or not.
>>>>
>>>
>>> Just to summarize this thread on what we need
>>
>> Thanks for summarizing.
>>>
>>> 1) dwc3 core shouldn't worry about platform specific stuff i.e. PHY needed or not.
>>> It should be as generic as possible.
>>>
>>> 2) dwc3 core should continue probe even if PHY layer is not enabled, as not all platforms need it.
>>>
>>> 3) dwc3 core should continue probe if PHY device is not available. (-ENODEV?)
>>>
>>> 4) dwc3 core should error out on any error condition if PHY device is available and caused some error,
>>> e.g. init error.
>>>
>>> 5) dwc3 core should return EPROBE_DEFER if PHY device is available but device driver is not yet loaded.
>>>
>>> 6) platform glue should do the necessary sanity checks for availability of all resources like PHY device, PHY layer, etc, before populating the dwc3 device. e.g. in OMAP5 case we could check if both usb2 and usb3 PHY
>>> nodes are available in the DT and PHY layer is enabled, from dwc3-omap.c? In J6 case we could check that at least usb2 phy node is there for the High-Speed only controller, and so on.
>>
>> The PHY is connected to the dwc3 core. So I'm not sure if we should be doing
>> checks for PHY in the glue layer.
> 
> Sorry, I didn't get you. My reasoning was that since OMAP platform has this strict requirement of requiring
> explicit PHY control in order to work, we must do the sanity checks in OMAP specific code and not in the dwc3 core code. It has nothing to do with how hardware is laid out.

What kind of sanity check do you think can be done in OMAP code? We don't use
any of the PHY API's in glue code. If we add the same PHY APIs in glue code it
will be duplication of the same code without much value besides breaking the
design guideline of the software to be modelled similar to hardware.

However in Kconfig of dwc3 glue we can add 'select GENERIC_PHY, select
PHY_OMAP_USB2, select OMAP_USB3' I guess.

Thanks
Kishon
