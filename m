Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab3I0HuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 03:50:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54065 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab3I0HuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 03:50:06 -0400
Message-ID: <5245387E.7080000@ti.com>
Date: Fri, 27 Sep 2013 13:19:18 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Olof Johansson <olof@lixom.net>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>,
        Pantel Antoniou <panto@antoniou-consulting.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH v3] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1380232546-821-1-git-send-email-joelf@ti.com> <CAOesGMgELbnuu8PM7Ah2xKo2H5rzgAN3w0g6wA7aVFsjuds-8g@mail.gmail.com> <5244D142.1090307@ti.com>
In-Reply-To: <5244D142.1090307@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/27/2013 5:58 AM, Joel Fernandes wrote:
> On 09/26/2013 06:13 PM, Olof Johansson wrote:
>> On Thu, Sep 26, 2013 at 2:55 PM, Joel Fernandes <joelf@ti.com> wrote:
>>> HWMOD removal for MMC is breaking edma_start as the events are being manually
>>> triggered due to unused channel list not being clear.
>>>
>>> The above issue is fixed by reading the "dmas" property from the DT node if it
>>> exists and clearing the bits in the unused channel list if the dma controller
>>> used by any device is EDMA. For this purpose we use the of_* helpers to parse
>>> the arguments in the dmas phandle list.
>>>
>>> Also introduced is a minor clean up of a checkpatch error in old code.
>>>
>>> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
>>> Reported-by: Balaji T K <balajitk@ti.com>
>>> Cc: Sekhar Nori <nsekhar@ti.com>
>>> Cc: Tony Lindgren <tony@atomide.com>
>>> Cc: Olof Johansson <olof@lixom.net>
>>> Cc: Nishanth Menon <nm@ti.com>
>>> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
>>> Cc: Jason Kridner <jkridner@beagleboard.org>
>>> Cc: Koen Kooi <koen@dominion.thruhere.net>
>>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>>> ---
>>> Just resending this patch after discussing with Sekhar and Olof.
>>
>> Actually, the patch you talked to me about was v3 of this. It seems
>> that you have reposted v6 but labelled it v3. This is very confusing.
> 
> Sorry about this. :-( This is indeed v6.
> 
>>> AM335x is being booted by many users such as the beaglebone community. DT is
>>> the only boot method available for all these users.  EDMA is required for the
>>> operation for many common peripherals in AM335x SoC such as McASP, MMC and
>>> Crypto.
>>>
>>> Although EDMA DT nodes are going in only for 3.13, in reality the kernel has
>>> been used for more than a year with EDMA code and out of tree EDMA DTS patches.
>>> Hence though the DT nodes are still not in mainline, this patch can be still be
>>> considered a critical fix as such and it would be great if it could be included
>>> in 3.12-rc release. Thanks.
>>
>> This is really the root of this problem. If you sit on code out of
>> tree for a year, and something breaks that we couldn't even have
>> detected since we didn't have the out-of-tree pieces. We'll help you
>> the first few times (such as now) but we will eventually stop caring.
> 
> When I started looking at EDMA in June, I noticed that a lot had already been
> merged. EDMA DMA Engine driver itself was merged last year, no worries there.
> but the long pending list of fixes to be made to the driver had to written and
> rewritten multiple times which took a long time.
> 
> Due to this, the EDMA device tree entries could not be merged in fear that doing
> so would cause problems such as MMC/SD corruption etc.
> 
>> If I was in a worse mood, then I'd just say that since your users
>> already has to have out-of-tree code to even use this functionality,
>> they could just add this fix on top of that stack of patches. But I'm
>> in a slightly better mood than that and I'll pick it up this time. :)
> 
> Thank you! :)
> 
>>> More details about why this broke an existing feature folks were using:
>>> Previously the DMA resources for platform devices were being populated through
>>> HWMOD, however with the recent clean ups with HWMOD, this data has been moved
>>> to Device tree. The EDMA code though is not aware of this so it fails to fetch
>>> the DMA resources correctly which it needs to prepare the unused channel list
>>> (basically doesn't properly clear the channels that are in use, in the unused
>>> list).
>>
>> So that we can learn for next time: What should we (as in us
>> maintainers and you TI) have done differently to avoid this?
> 
> I think a little on both sides can be improved.
> 
> For TI, a bit more work toward explaining patches better in change logs so that
> maintainers understand and are willing to help to get the code upstream would
> help. A lot of improvement to internal policies have been made for developing on
> upstream, and that's certainly a good thing but there's still more room for
> improvement.
> 
> For maintainers,  EDMA code would have been kept breathing all these months
> (atleast 8 months) if those temporary fixes mentioned above would have been
> merged into the kernel instead of not applied. With those fixes in place, dts
> could have been enabled and EDMA would be fully working all these months. This
> would have certainly made things a lot easier. Rewriting stuff the right way is
> OK but if it is a _lot_ of effort, then to keep things alive, merging stuff "for
> now" specially if they are one-liners could be made acceptable.

Joel, can you give a link to the "one-liner" "temporary fix" that was
was not merged? I am unable to put it in context.

Thanks,
Sekhar
