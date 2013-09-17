Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668Ab3IQFju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 01:39:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44118 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420Ab3IQFjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 01:39:37 -0400
Message-ID: <5237EAF3.70505@ti.com>
Date: Tue, 17 Sep 2013 00:38:59 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>, Jyri Sarah <jsarha@ti.com>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1378839171-14455-1-git-send-email-joelf@ti.com> <5231903F.7080301@ti.com> <5233B471.40603@ti.com> <5236F00B.5040605@ti.com> <5237314D.7080102@ti.com> <5237E3C3.8050602@ti.com>
In-Reply-To: <5237E3C3.8050602@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2013 12:08 AM, Sekhar Nori wrote:
[..]
>>> I still cannot find any users of edma in the device tree sources either
>>> in linux-next or linus/master. Why cannot this wait until v3.13?
>>
>> I understand this affects only DT users of EDMA. But I get so many private
>> reports of breakage due to this patch not being there that I think it will save
>> everyone a lot of pain, specially folks creating integration trees to have this
>> patch available by default.
> 
> Well, I do agree that the current DT support for EDMA is incomplete
> without this patch even if there are no in-kernel users of it. I will
> try sending this for the next -rc if we get to the final version in time
> and after that its upto the upstreams to take it.

Ok, except for the one minor nit below my last scissor patch is good to go.

>>>> +
>>>> +			ctlr = EDMA_CTLR(dma_spec.args[0]);
>>>> +			clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]),
>>>> +				  edma_cc[ctlr]->edma_unused);
>>>
>>> We don't support the second controller when using DT and the controller
>>> number is not really encoded in the argument to edma phandle. So just
>>> simplify this to:
>>>
>>> 	clear_bit(EDMA_CHAN_SLOT(dma_spec.args[0]), 	
>>> 		  edma_cc[0]->edma_unused);
>>
>> I think let's not make that assumption just incase in the future we support more
>> than one EDMA controller for DT-based boot. Is that ok?
> 
> We don't write future proof code in that _hope_ that it will get used
> someday.  In fact this will confuse the reader into wondering if support
> for second channel controller is present or not as the code will send

Nope I don't agree with this at all.. EDMA CC ctrl will not be hardcoded. We
need to write future-proof code to make sure sudden regressions don't pop up
when say a second EDMA CC is introduced.. further edma_cc[ctrl] pattern is used
all through out the code so what you're asking to do doesn't make much sense in
this context. There's no reason to break out of this pattern. It actually will
confuse the reader more.

Second controller can be present in future. I don't want to come back to change
the code when we introduce more than 1 CC which is possible in the future.

> mixed messages. In short, we aim for consistency with situation today,
> not tomorrow.

What you're asking to do infact breaks consistency with the rest of the code.

> 
> Besides, I can bet that when second CC support does get added, it is
> very unlikely that the CC number is get encoded into channel number when
> using DT.

Even if it is not encoded, the data structure for edma_cc is an array and what
you're asking is to hardcode the controller number to 0 always. No way I'm going
to hard code controller number to a single value.

Different topic but anyway why wouldn't ctrl number be encoded in the channel?
That's clean, and saves variables and extra structures. Better use of the
integer bitmap making up the Ctrl and channel number of small ranges.

Regards,

-Joel

