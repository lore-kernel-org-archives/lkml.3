Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3BDVzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 16:55:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40803 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab3BDVzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 16:55:03 -0500
Message-ID: <51102E25.8040107@ti.com>
Date: Mon, 4 Feb 2013 16:54:45 -0500
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>, <balbi@ti.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Lindgren <tony@atomide.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, "Nair, Sandeep" <sandeep_n@ti.com>,
        Chris Ball <cjb@laptop.org>, Matt Porter <mporter@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to arm/common
References: <510C2A47.1090607@mvista.com> <20130201205600.GA31762@arwen.pp.htv.fi> <20130201213003.GW2637@n2100.arm.linux.org.uk> <20130204154153.GA18237@arwen.pp.htv.fi> <510FF1A6.403@mvista.com> <20130204164712.GB4269@arwen.pp.htv.fi> <510FF5C9.3030600@mvista.com> <20130204170216.GC4269@arwen.pp.htv.fi> <51100A72.6030909@ti.com> <CACRpkdZihnp3_Df==QRWxQupgi7W_YXZxc-MxkusVH6J+Vx56A@mail.gmail.com> <20130204203358.GX4720@opensource.wolfsonmicro.com> <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com>
In-Reply-To: <CACRpkdbPyZt8=pLhz-5qcaSSAk6VBn61dPTNp6teU9HksBwN2w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2013 04:11 PM, Linus Walleij wrote:
> On Mon, Feb 4, 2013 at 9:33 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Mon, Feb 04, 2013 at 09:29:46PM +0100, Linus Walleij wrote:
>>> On Mon, Feb 4, 2013 at 8:22 PM, Cyril Chemparathy <cyril@ti.com> wrote:
>>
>>>> Based on our experience with fitting multiple subsystems on top of this
>>>> DMA-Engine driver, I must say that the DMA-Engine interface has proven
>>>> to be a less than ideal fit for the network driver use case.
>>
>>>> The first problem is that the DMA-Engine interface expects to "push"
>>>> completed traffic up into the upper layer as a part of its callback.
>>>> This doesn't fit cleanly with NAPI, which expects to "pull" completed
>>>> traffic from below in the NAPI poll.  We've somehow kludged together a
>>>> solution around this, but it isn't very elegant.
>>
>>> I cannot understand the actual technical problem from the above
>>> paragraphs though. dmaengine doesn't have a concept of pushing
>>> nor polling, it basically copies streams of words from A to B, where
>>> A/B can be a device or a buffer, nothing else.
>>
>>> The thing you're looking for sounds more like an adapter on top
>>> of dmaengine, which can surely be constructed, some
>>> drivers/dma/dmaengine-napi.c or whatever.
>>
>> Broadly speaking what NAPI wants is to never get any callbacks from the
>> hardware (or DMAs).  It wants to wake up periodically, take a look at
>> what packets have been read by the hardware and process them.  The goal
>> is to have the DMAs sitting and running without disturbing the processor
>> at all after the first packet has been handled.
>
> OK we should definately be able to encompass that in dmaengine
> quite easily.
>
> So I think the above concerns are moot. The callback we can
> set on cookies is entirely optional, and it's even implemented by
> each DMA engine, and some may not even support it but *require*
> polling, and then it won't even be implemented by the driver.
>
> Which probably stems from the original design of the dmaengine
> API, which was for TCP networking acceleration, mainly.
>
> Cyril, just stack up the cookies and take a sweep over them to see
> which ones are baked when the NAPI poll comes in -> problem
> solved.
>

You're assuming that cookies complete in order.  That is not necessarily 
true.

Thanks
-- Cyril.
