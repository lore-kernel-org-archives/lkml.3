Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3HLE3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 00:29:36 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:43158 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3HLE3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 00:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <5208639F.8070406@ti.com>
References: <1375719297-12871-1-git-send-email-joelf@ti.com>
	<1375719297-12871-3-git-send-email-joelf@ti.com>
	<520385D3.1060408@ti.com>
	<5208639F.8070406@ti.com>
Date: Sun, 11 Aug 2013 23:29:33 -0500
Message-ID: <CAD=GYpa75vqz120O2McxTXsPCWFb+RsO+7dZ4WRNQJgb3W=E=A@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] ARM: edma: Don't clear EMR of channel in edma_stop
From: Joel Fernandes <agnel.joel@gmail.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Joel Fernandes <joelf@ti.com>, Mark Brown <broonie@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sricharan R <r.sricharan@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Lokesh Vutla <lokeshvutla@ti.com>,
        Chris Ball <cjb@laptop.org>, Arnd Bergmann <arnd@arndb.de>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Balaji TK <balajitk@ti.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <djbw@fb.com>, Olof Johansson <olof@lixom.net>,
        Benoit Cousson <benoit.cousson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 11, 2013 at 11:25 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> On 8/8/2013 5:19 PM, Sekhar Nori wrote:
>> On Monday 05 August 2013 09:44 PM, Joel Fernandes wrote:
>>> We certainly don't want error conditions to be cleared any other
>>> place but the EDMA error handler, as this will make us 'forget'
>>> about missed events we might need to know errors have occurred.
>>>
>>> This fixes a race condition where the EMR was being cleared
>>> by the transfer completion interrupt handler.
>>>
>>> Basically, what was happening was:
>>>
>>>             Missed event
>>>              |
>>>              |
>>>              V
>>> SG1-SG2-SG3-Null
>>>          \
>>>           \__TC Interrupt (Almost same time as ARM is executing
>>> TC interrupt handler, an event got missed and also forgotten
>>> by clearing the EMR).
>>>
>>> This causes the following  problems:
>>>
>>> 1.
>>> If error interrupt is also pending and TC interrupt clears the EMR
>>> by calling edma_stop as has been observed in the edma_callback function,
>>> the ARM will execute the error interrupt even though the EMR is clear.
>>> As a result, the  dma_ccerr_handler returns IRQ_NONE. If this happens
>>> enough number of times, IRQ subsystem disables the interrupt thinking
>>> its spurious which makes error handler never execute again.
>>>
>>> 2.
>>> Also even if error handler doesn't return IRQ_NONE, the removing of EMR
>>> removes the knowledge about which channel had a missed event, and thus
>>> a manual trigger on such channels cannot be performed.
>>>
>>> The EMR is ultimately being cleared by the Error interrupt handler
>>> once it is handled so we remove code that does it in edma_stop and
>>> allow it to happen there.
>>>
>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>
>> Queuing this for v3.11 fixes. While committing, I changed the headline
>> to remove capitalization and made it more readable by removing register
>> level details. The new headline is:
>>
>> ARM: edma: don't clear missed events in edma_stop()
>
> Forgot to ask, should this be tagged for stable? IOW, how serious is
> this race in current kernel (without the entire series applied)? I have
> never observed it myself - so please provide details how easy/difficult
> it is to hit this condition.

The race was uncovered by recent EDMA patch series, So this patch can
go in for next kernel release as such, I am not aware of any other DMA
user that maybe uncovering the race condition.

Thanks,

-Joel
