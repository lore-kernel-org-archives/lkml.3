Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3HAEkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 00:40:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:41731 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab3HAEkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 00:40:35 -0400
Message-ID: <51F9E688.7010608@ti.com>
Date: Wed, 31 Jul 2013 23:39:36 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: <joelf@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 4/9] dma: edma: Find missed events and issue them
References: <1375104595-16018-1-git-send-email-joelf@ti.com> <1375104595-16018-5-git-send-email-joelf@ti.com> <51F7659E.3040302@ti.com> <51F89763.1010102@ti.com> <51F8D667.2040406@ti.com> <51F9C793.2000001@ti.com>
In-Reply-To: <51F9C793.2000001@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 09:27 PM, Joel Fernandes wrote:
> On 07/31/2013 04:18 AM, Sekhar Nori wrote:
>> On Wednesday 31 July 2013 10:19 AM, Joel Fernandes wrote:
>>> Hi Sekhar,
>>>
>>> On 07/30/2013 02:05 AM, Sekhar Nori wrote:
>>>> On Monday 29 July 2013 06:59 PM, Joel Fernandes wrote:
>>>>> In an effort to move to using Scatter gather lists of any size with
>>>>> EDMA as discussed at [1] instead of placing limitations on the driver,
>>>>> we work through the limitations of the EDMAC hardware to find missed
>>>>> events and issue them.
>>>>>
>>>>> The sequence of events that require this are:
>>>>>
>>>>> For the scenario where MAX slots for an EDMA channel is 3:
>>>>>
>>>>> SG1 -> SG2 -> SG3 -> SG4 -> SG5 -> SG6 -> Null
>>>>>
>>>>> The above SG list will have to be DMA'd in 2 sets:
>>>>>
>>>>> (1) SG1 -> SG2 -> SG3 -> Null
>>>>> (2) SG4 -> SG5 -> SG6 -> Null
>>>>>
>>>>> After (1) is succesfully transferred, the events from the MMC controller
>>>>> donot stop coming and are missed by the time we have setup the transfer
>>>>> for (2). So here, we catch the events missed as an error condition and
>>>>> issue them manually.
>>>>
>>>> Are you sure there wont be any effect of these missed events on the
>>>> peripheral side. For example, wont McASP get into an underrun condition
>>>> when it encounters a null PaRAM set? Even UART has to transmit to a
>>>
>>> But it will not encounter null PaRAM set because McASP uses contiguous
>>> buffers for transfer which are not scattered across physical memory.
>>> This can be accomplished with an SG of size 1. For such SGs, this patch
>>> series leaves it linked Dummy and does not link to Null set. Null set is
>>> only used for SG lists that are > MAX_NR_SG in size such as those
>>> created for example by MMC and Crypto.
>>>
>>>> particular baud so I guess it cannot wait like the way MMC/SD can.
>>>
>>> Existing driver have to wait anyway if they hit MAX SG limit today. If
>>> they don't want to wait, they would have allocated a contiguous block of
>>> memory and DMA that in one stretch so they don't lose any events, and in
>>> such cases we are not linking to Null.
>>
>> As long as DMA driver can advertize its MAX SG limit, peripherals can
>> always work around that by limiting the number of sync events they
>> generate so as to not having any of the events getting missed. With this
>> series, I am worried that EDMA drivers is advertizing that it can handle
>> any length SG list while not taking care of missing any events while
>> doing so. This will break the assumptions that driver writers make.
> 
> This is already being done by some other DMA engine drivers ;). We can
> advertise more than we can handle at a time, that's the basis of this
> whole idea.
> 
> I understand what you're saying but events are not something that have
> be serviced immediately, they can be queued etc and the actually
> transfer from the DMA controller can be delayed. As long as we don't
> miss the event we are fine which my series takes care off.
> 
> So far I have tested this series on following modules in various
> configurations and have seen no issues:
> - Crypto AES
> - MMC/SD
> - SPI (128x160 display)
> 
>>>> Also, wont this lead to under-utilization of the peripheral bandwith?
>>>> Meaning, MMC/SD is ready with data but cannot transfer because the DMA
>>>> is waiting to be set-up.
>>>
>>> But it is waiting anyway even today. Currently based on MAX segs, MMC
>>> driver/subsystem will make SG list of size max_segs. Between these
>>> sessions of creating such smaller SG-lists, if for some reason the MMC
>>> controller is sending events, these will be lost anyway.
>>
>> But if MMC/SD driver knows how many events it should generate if it
>> knows the MAX SG limit. So there should not be any missed events in
>> current code. And I am not claiming that your solution is making matters
>> worse. But its not making it much better as well.
> 
> This is not true for crypto, the events are not deasserted and crypto
> continues to send events. This is what led to the "don't trigger in
> Null" patch where I'm setting the missed flag to avoid recursion.
> 
>>> This can be used only for buffers that are contiguous in memory, not
>>> those that are scattered across memory.
>>
>> I was hinting at using the linking facility of EDMA to achieve this.
>> Each PaRAM set has full 32-bit source and destination pointers so I see
>> no reason why non-contiguous case cannot be handled.
>>
>> Lets say you need to transfer SG[0..6] on channel C. Now, PaRAM sets are
>> typically 4 times the number of channels. In this case we use one DMA
>> PaRAM set and two Link PaRAM sets per channel. P0 is the DMA PaRAM set
>> and P1 and P2 are the Link sets.
>>
>> Initial setup:
>>
>> SG0 -> SG1 -> SG2 -> SG3 -> SG4 -> SG5 -> SG6 -> NULL
>>  ^      ^      ^
>>  |      |      |
>> P0  -> P1  -> P2  -> NULL
>>
>> P[0..2].TCINTEN = 1, so get an interrupt after each SG element
>> completion. On each completion interrupt, hardware automatically copies
>> the linked PaRAM set into the DMA PaRAM set so after SG0 is transferred
>> out, the state of hardware is:
>>
>> SG1  -> SG2 -> SG3 -> SG3 -> SG6 -> NULL
>>  ^       ^
>>  |       |
>> P0,1    P2  -> NULL
>>  |       ^
>>  |       |
>>  ---------
>>
>> SG1 transfer has already started by the time the TC interrupt is
>> handled. As you can see P1 is now redundant and ready to be recycled. So
>> in the interrupt handler, software recycles P1. Thus:
>>
>> SG1 -> SG2 -> SG3 -> SG4 -> SG5 -> SG6 -> NULL
>>  ^      ^      ^
>>  |      |      |
>> P0  -> P2  -> P1  -> NULL
>>
>> Now, on next interrupt, P2 gets copied and thus can get recycled.
>> Hardware state:
>>
>> SG2  -> SG3 -> SG4 -> SG5 -> SG6 -> NULL
>>  ^       ^
>>  |       |
>> P0,2    P1  -> NULL
>>  |       ^
>>  |       |
>>  ---------
>>
>> As part of TC completion interrupt handling:
>>
>> SG2 -> SG3 -> SG4 -> SG5 -> SG6 -> NULL
>>  ^      ^      ^
>>  |      |      |
>> P0  -> P1  -> P2  -> NULL
>>
>> This goes on until the SG list in exhausted. If you use more PaRAM sets,
>> interrupt handler gets more time to recycle the PaRAM set. At no point
>> we touch P0 as it is always under active transfer. Thus the peripheral
>> is always kept busy.
>>
>> Do you see any reason why such a mechanism cannot be implemented?
> 
> This is possible and looks like another way to do it, but there are 2
> problems I can see with it.
> 
> 1. Its inefficient because of too many interrupts:
> 
> Imagine case where we have an SG list of size 30 and MAX_NR_SG size is
> 10. This method will trigger 30 interrupts always, where as with my
> patch series, you'd get only 3 interrupts. If you increase MAX_SG_NR ,
> you'd get even fewer interrupts.
> 
> 2. If the interrupt handler for some reason doesn't complete or get
> service in time, we will end up DMA'ing incorrect data as events
> wouldn't stop coming in even if interrupt is not yet handled (in your
> example linked sets P1 or P2 would be old ones being repeated). Where as
> with my method, we are not doing any DMA once we finish the current
> MAX_NR_SG set even if events continue to come.
> 

Actually on second thought, 1. can be tackled by having a list of PaRAM
set instead of just 1 set for P1, and another list in P2. And ping-pong
between the P1 and P2 sets only interrupting in between to setup one or
the other. However 2. is still a concern.

Still, what you're asking for is a rewrite of quite a bit of the driver
which I feel is unnecessary at this point as my patch series is
alternate method that's been tested and  working.

The only point of concern I think you have with the series is how will
peripherals react if their events are not handled right away. I am
certain that the peripheral doesn't go into an error condition state
because it doesn't know that its event was missed and it'd be just
waiting. I haven't dealt with EDMA queuing but wouldn't this kind of
wait be happening even with such queues. Another note is, the waiting is
happening even in today's state of the driver where we limit by
MAX_NR_SG. Probably not the same kind of wait as this series (like send
event and wait), but peripheral just not doing anything.

Let me know if you had a specific case of a peripheral where this could
be a problem and I'll be happy to test it. Thanks.

Regards,

-Joel

