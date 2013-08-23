Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab3HWQ24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:28:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58293 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab3HWQ2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:28:54 -0400
Message-ID: <52178D98.8020202@ti.com>
Date: Fri, 23 Aug 2013 21:58:08 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] misc: Add crossbar driver
References: <51E83A4F.5080904@ti.com> <CACRpkdY3nQaWimTwB-Zt-8+Q_KZr8a0rpB1SUQq=AuoG4bAYnQ@mail.gmail.com> <51ED2385.60108@ti.com> <51ED5C66.1010407@ti.com> <51EFFBE1.4090505@ti.com> <51F0031B.1050307@ti.com> <51F00530.9090703@ti.com> <51F02069.3050207@ti.com> <51F0223E.4050008@ti.com> <51F0240F.3050507@ti.com> <20130813081003.GU7656@atomide.com> <520A02BA.4090805@ti.com> <CACRpkda+m82PYJsExLM6JLsLa8-bVhdvy_r_+-uKfVT2NG7Cbg@mail.gmail.com> <520D398D.9040806@ti.com> <CACRpkdYeo1y-HhftkRWgwyq8o-NVuJ978Uq+ON880LHhUxC=hg@mail.gmail.com> <520D44C5.6080205@ti.com> <CACRpkdagSHxzV3=427O9iftNxM+N=w9aPds=iDvGQPoG3H-cWw@mail.gmail.com> <5215F6F6.9060703@ti.com> <5216E966.5020902@ti.com> <5216FD0C.3090709@ti.com> <521702E2.5000102@ti.com> <521706D9.9070001@ti.com> <521719D8.7060506@ti.com> <521765DC.2000609@ti.com>
In-Reply-To: <521765DC.2000609@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2013 7:08 PM, Santosh Shilimkar wrote:
> On Friday 23 August 2013 04:14 AM, Sekhar Nori wrote:
>> On Friday 23 August 2013 12:23 PM, Sricharan R wrote:
>>> On Friday 23 August 2013 12:06 PM, Sekhar Nori wrote:
>>>> On Friday 23 August 2013 11:41 AM, Sricharan R wrote:
>>>>> Hi,
>>>>> On Friday 23 August 2013 10:17 AM, Rajendra Nayak wrote:
>>>>>> On Thursday 22 August 2013 05:03 PM, Sricharan R wrote:
>>>>>>>  maps crossbar number<->  to interrupt number and
>>>>>>>  calls request_irq(int_no, crossbar_handler,..)
>>>>>> So will this mapping happen based on some data passed from DT or
>>>>>> just based on whats available when the device does a request_irq()?
>>>>>>
>>>>>> If its based on whats available then I see an issue when you need
>>>>>> to remap something thats already mapped by default (and not used)
>>>>>> since you run out of all free ones.
>>>>> Yes, when done based on what is available then there is a
>>>>> problem when we run out of free ones because we do not
>>>>> know which one to replace. I was thinking of something like
>>>>> this,
>>>>>     1) DT would give a list of all free ones, and also if some are
>>>>>         mapped as default and not used, mark those also as free.
>>>>>
>>>>>      2) While mapping see if it has a default mapping and use it.
>>>>>           otherwise, pick from free list.   
>>>> Since the entire DT is available to you at boot time, you should be able
>>>> to find each node where interrupt-parent = <&crossbar> and then allocate
>>>> one of 0-160 GIC interrupt numbers for that node, no? Where would there
>>>> be a need for default mapping and remapping? From one the mails in the
>>>> thread the crossbar is completely flexible - any of the 320 crossbar
>>>> interrupts can be mapped to any of the 160 GIC interrupts.
>>>>
>>>> Any GIC interrupts left after this boot-time scan can be added to an
>>>> unused list for use with runtime DT fragments (when that support comes).
>>>>  
>>>> Sorry if I misunderstood, but above proposal sounds like maintaining a
>>>> separate free interrupt lines list in DT. That will quickly go out of sync.
>>>  Say, peripheral x uses crossbar 1 and specifies this in DT.
>>>  During boot crossbar 1 gets mapped int 10. So if by default
>>> some other crossbar has its interrupt mapped to 10,
>>> then it should be removed.  Instead clear all crossbar registers
>>> once and mark all as free, then  allocate only during request.
>>> Correct ?. In this the free no need to maintain any list.
>>
>> Right, so in my suggestion there is nothing like a "default mapping" and
>> entire 160 GIC interrupt number space is up for grabs. I think this will
>> be much simpler to write and maintain.
>>
>> If you really want to maintain default mapping as far as possible, you
>> can do two passes on the crossbar interrupt numbers requested. Once to
>> assign the default map - for numbers less that 160 - and then look at
>> the free GIC interrupt slots and use those for numbers greater than 160.
>>
> The whole point we are moving to domain is not have any default
> mapping(connection done) at DT level. Rather DT only specifies the
> peripherals and their cross-bar connection ID(i.e cross-bar IRQ line).
> This will be the driver input as a IRQ line from DT. The cross-bar
> driver needs to map any of the free list available on *request* only.

Right, the mapping can be done on request. That will be cleaner.

Thanks,
Sekhar
