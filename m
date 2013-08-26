Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3HZQwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:52:53 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36240 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3HZQwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:52:51 -0400
Message-ID: <521B87C0.1090507@ti.com>
Date: Mon, 26 Aug 2013 11:52:16 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v2] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1377287613-16491-1-git-send-email-joelf@ti.com> <521B3212.3050405@ti.com>
In-Reply-To: <521B3212.3050405@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 05:46 AM, Sekhar Nori wrote:
> On Saturday 24 August 2013 01:23 AM, Joel Fernandes wrote:
>> HWMOD removal for MMC and Crypto is breaking edma_start as the events are
>> being manually triggered due to unused channel list not being clear. Atleast
>> breakage has been seen on these peripherals, but it is expected Audio (McASP)
>> maybe breaking too.
>>
>> This patch fixes the issue, by reading the "dmas" property from the DT node if
>> it exists and clearing the bits in the unused channel list so that these channels
>> are not manually triggered.
>>
>> v2 changes:
>> Reduced indendation by returning from if block.
> 
> Is this a v2 or v3 since you already sent a v2 about a month back?

No, there aren't any changes since v2, I just resubmitted the same patch.

>>
>> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
>> Reported-by: Balaji T K <balajitk@ti.com>
>> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>> Note:
>> Patch should go in for -rc cycle as it fixes existing crypto drivers.
> 
> We agreed the patch is not needed in -rc cycle since there are no
> current EDMA users in DT-boot?

There is now, crypto and EDMA DT patches are being merged in.

>>
>>  arch/arm/common/edma.c | 22 +++++++++++++++++++---
>>  1 file changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
>> index 39ad030..3867e7e 100644
>> --- a/arch/arm/common/edma.c
>> +++ b/arch/arm/common/edma.c
>> @@ -560,14 +560,30 @@ static int reserve_contiguous_slots(int ctlr, unsigned int id,
>>  static int prepare_unused_channel_list(struct device *dev, void *data)
>>  {
>>  	struct platform_device *pdev = to_platform_device(dev);
>> -	int i, ctlr;
>> +	int i = 0, ctlr;
>> +	u32 dma_chan;
>> +	const __be32 *dma_chan_p;
>> +	struct property *prop;
>> +
>> +	if (dev->of_node) {
>> +		of_property_for_each_u32(dev->of_node, "dmas", prop,
>> +					 dma_chan_p, dma_chan) {
>> +			if (i++ & 1) {
>> +				ctlr = EDMA_CTLR(dma_chan);
>> +				clear_bit(EDMA_CHAN_SLOT(dma_chan),
>> +					  edma_cc[ctlr]->edma_unused);
>> +			}
> 
> I thought we agreed to do this differently using
> of_property_count_strings() and of_parse_phandle_with_args(). I seemed
> to have missed any discussion on why this cannot be done (if such a
> discussion took place on the list).

I kind of missed that particular review comment after reading [1]. Because I
thought only change left was the indentation. Let me work on that comment and
resubmit as v3.

Regards,

-Joel

