Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3IFTPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:15:31 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:54131
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750889Ab3IFTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:15:30 -0400
Message-ID: <522A29CF.2090001@newflow.co.uk>
Date: Fri, 06 Sep 2013 20:15:27 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Tony Lindgren <tony@atomide.com>,
        Matt Porter <matt@ohporter.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Russell King <linux@arm.linux.org.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v2] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1377287613-16491-1-git-send-email-joelf@ti.com> <522A2943.4060502@newflow.co.uk>
In-Reply-To: <522A2943.4060502@newflow.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/13 20:13, Mark Jackson wrote:
> On 23/08/13 20:53, Joel Fernandes wrote:
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
>>
>> Reviewed-by: Sekhar Nori <nsekhar@ti.com>
>> Reported-by: Balaji T K <balajitk@ti.com>
>> Cc: Pantel Antoniou <panto@antoniou-consulting.com>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>> Note:
>> Patch should go in for -rc cycle as it fixes existing crypto drivers.
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
>> +		}
>> +		return;
> 
> This should return something here, otherwise we get:-
> 
> arch/arm/common/edma.c: In function 'prepare_unused_channel_list':
> arch/arm/common/edma.c:577:3: warning: 'return' with no value, in function returning non-void [-Wreturn-type]

Other than that I can confirm it fixes the issue for me ...

Tested-by: Mark Jackson <mpfj@newflow.co.uk>

