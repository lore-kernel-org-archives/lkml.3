Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaDKIO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:14:57 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52735
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755761AbaDKIOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:14:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(z579ehzbb2dI98dI9371I936eIe0eah1432Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
Message-ID: <5347A46B.30206@freescale.com>
Date: Fri, 11 Apr 2014 16:14:35 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <scottwood@freescale.com>,
        <leo.li@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/8] DMA: Freescale: add fsl_dma_free_descriptor()
 to reduce code duplication
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com>	 <1397113805-24171-5-git-send-email-hongbo.zhang@freescale.com> <1397129361.11914.96.camel@smile.fi.intel.com>
In-Reply-To: <1397129361.11914.96.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/10/2014 07:29 PM, Andy Shevchenko wrote:
> On Thu, 2014-04-10 at 15:10 +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> There are several places where descriptors are freed using identical code.
>> This patch puts this code into a function to reduce code duplication.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
>> ---
>>   drivers/dma/fsldma.c |   30 ++++++++++++++++++------------
>>   1 file changed, 18 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>> index b71cc04..b5a0ffa 100644
>> --- a/drivers/dma/fsldma.c
>> +++ b/drivers/dma/fsldma.c
>> @@ -418,6 +418,19 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>>   }
>>   
>>   /**
>> + * fsl_dma_free_descriptor - Free descriptor from channel's DMA pool.
>> + * @chan : Freescale DMA channel
>> + * @desc: descriptor to be freed
>> + */
>> +static void fsl_dma_free_descriptor(struct fsldma_chan *chan,
>> +		struct fsl_desc_sw *desc)
>> +{
>> +	list_del(&desc->node);
>> +	chan_dbg(chan, "LD %p free\n", desc);
>> +	dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
>> +}
>> +
>> +/**
>>    * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.
>>    * @chan : Freescale DMA channel
>>    *
>> @@ -489,11 +502,8 @@ static void fsldma_free_desc_list(struct fsldma_chan *chan,
>>   {
>>   	struct fsl_desc_sw *desc, *_desc;
>>   
>> -	list_for_each_entry_safe(desc, _desc, list, node) {
>> -		list_del(&desc->node);
>> -		chan_dbg(chan, "LD %p free\n", desc);
>> -		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
>> -	}
>> +	list_for_each_entry_safe(desc, _desc, list, node)
>> +		fsl_dma_free_descriptor(chan, desc);
>>   }
>>   
>>   static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
>> @@ -501,11 +511,8 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
>>   {
>>   	struct fsl_desc_sw *desc, *_desc;
>>   
>> -	list_for_each_entry_safe_reverse(desc, _desc, list, node) {
>> -		list_del(&desc->node);
>> -		chan_dbg(chan, "LD %p free\n", desc);
>> -		dma_pool_free(chan->desc_pool, desc, desc->async_tx.phys);
>> -	}
>> +	list_for_each_entry_safe_reverse(desc, _desc, list, node)
>> +		fsl_dma_free_descriptor(chan, desc);
>>   }
>>   
>>   /**
>> @@ -819,8 +826,7 @@ static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
>>   	dma_run_dependencies(txd);
>>   
>>   	dma_descriptor_unmap(txd);
>> -	chan_dbg(chan, "LD %p free\n", desc);
>> -	dma_pool_free(chan->desc_pool, desc, txd->phys);
>> +	fsl_dma_free_descriptor(chan, desc);
> Here is no list_del() call since it's been called in dma_do_tasklet().
> What will be the result of double list_del() against the same node?

Not clear with your point.
This patch is only introducing a common fsl_dma_free_descriptor() to 
reduce code duplication. And later in the patch 6/8 the 
fsldma_cleanup_descriptor() is replaced by fsldma_cleanup_descriptorS().

>>   }
>>   
>>   /**
>



