Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3HADoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 23:44:02 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39318 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab3HADoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 23:44:00 -0400
Message-ID: <51F9D94D.5060702@ti.com>
Date: Wed, 31 Jul 2013 22:43:09 -0500
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

Sorry, just forgot to respond to "not taking care of missing any events
while doing so". Can you clarify this? DMA engine driver is taking care
of missed events.

Also- missing of events doesn't result in feedback to the peripheral.
Peripheral sends even to DMA controller, event is missed. Peripheral
doesn't know anything about what happened and is waiting for transfer
from the DMA controller.

Thanks,

-Joel

