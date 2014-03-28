Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaC1GeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:34:04 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:34576
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbaC1GeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:34:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I936eI1432Id799hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh1155h)
Message-ID: <533517C1.8080208@freescale.com>
Date: Fri, 28 Mar 2014 14:33:37 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinod Koul <vkoul@infradead.org>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <scottwood@freescale.com>,
        <LeoLi@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] DMA: Freescale: use spin_lock_bh instead of spin_lock_irqsave
References: <1389851246-8564-1-git-send-email-hongbo.zhang@freescale.com>	 <1389851246-8564-7-git-send-email-hongbo.zhang@freescale.com> <1395817294.6569.2.camel@vkoul-udesk3>
In-Reply-To: <1395817294.6569.2.camel@vkoul-udesk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03/26/2014 03:01 PM, Vinod Koul wrote:
> On Thu, 2014-01-16 at 13:47 +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> The usage of spin_lock_irqsave() is a stronger locking mechanism than is
>> required throughout the driver. The minimum locking required should be used
>> instead. Interrupts will be turned off and context will be saved, it is
>> unnecessary to use irqsave.
>>
>> This patch changes all instances of spin_lock_irqsave() to spin_lock_bh(). All
>> manipulation of protected fields is done using tasklet context or weaker, which
>> makes spin_lock_bh() the correct choice.
>>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
>> ---
>>   drivers/dma/fsldma.c |   25 ++++++++++---------------
>>   1 file changed, 10 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>> index bbace54..437794e 100644
>> --- a/drivers/dma/fsldma.c
>> +++ b/drivers/dma/fsldma.c
>> @@ -396,10 +396,9 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>>   	struct fsldma_chan *chan = to_fsl_chan(tx->chan);
>>   	struct fsl_desc_sw *desc = tx_to_fsl_desc(tx);
>>   	struct fsl_desc_sw *child;
>> -	unsigned long flags;
>>   	dma_cookie_t cookie = -EINVAL;
>>   
>> -	spin_lock_irqsave(&chan->desc_lock, flags);
>> +	spin_lock_bh(&chan->desc_lock);
>>   
>>   	/*
>>   	 * assign cookies to all of the software descriptors
>> @@ -412,7 +411,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>>   	/* put this transaction onto the tail of the pending queue */
>>   	append_ld_queue(chan, desc);
>>   
>> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
>> +	spin_unlock_bh(&chan->desc_lock);
>>   
>>   	return cookie;
>>   }
>> @@ -731,15 +730,14 @@ static void fsldma_free_desc_list_reverse(struct fsldma_chan *chan,
>>   static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
>>   {
>>   	struct fsldma_chan *chan = to_fsl_chan(dchan);
>> -	unsigned long flags;
>>   
>>   	chan_dbg(chan, "free all channel resources\n");
>> -	spin_lock_irqsave(&chan->desc_lock, flags);
>> +	spin_lock_bh(&chan->desc_lock);
>>   	fsldma_cleanup_descriptors(chan);
>>   	fsldma_free_desc_list(chan, &chan->ld_pending);
>>   	fsldma_free_desc_list(chan, &chan->ld_running);
>>   	fsldma_free_desc_list(chan, &chan->ld_completed);
>> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
>> +	spin_unlock_bh(&chan->desc_lock);
>>   
>>   	dma_pool_destroy(chan->desc_pool);
>>   	chan->desc_pool = NULL;
>> @@ -958,7 +956,6 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>>   {
>>   	struct dma_slave_config *config;
>>   	struct fsldma_chan *chan;
>> -	unsigned long flags;
>>   	int size;
>>   
>>   	if (!dchan)
>> @@ -968,7 +965,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>>   
>>   	switch (cmd) {
>>   	case DMA_TERMINATE_ALL:
>> -		spin_lock_irqsave(&chan->desc_lock, flags);
>> +		spin_lock_bh(&chan->desc_lock);
>>   
>>   		/* Halt the DMA engine */
>>   		dma_halt(chan);
>> @@ -979,7 +976,7 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>>   		fsldma_free_desc_list(chan, &chan->ld_completed);
>>   		chan->idle = true;
>>   
>> -		spin_unlock_irqrestore(&chan->desc_lock, flags);
>> +		spin_unlock_bh(&chan->desc_lock);
>>   		return 0;
>>   
>>   	case DMA_SLAVE_CONFIG:
>> @@ -1021,11 +1018,10 @@ static int fsl_dma_device_control(struct dma_chan *dchan,
>>   static void fsl_dma_memcpy_issue_pending(struct dma_chan *dchan)
>>   {
>>   	struct fsldma_chan *chan = to_fsl_chan(dchan);
>> -	unsigned long flags;
>>   
>> -	spin_lock_irqsave(&chan->desc_lock, flags);
>> +	spin_lock_bh(&chan->desc_lock);
>>   	fsl_chan_xfer_ld_queue(chan);
>> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
>> +	spin_unlock_bh(&chan->desc_lock);
>>   }
>>   
>>   /**
>> @@ -1124,11 +1120,10 @@ static irqreturn_t fsldma_chan_irq(int irq, void *data)
>>   static void dma_do_tasklet(unsigned long data)
>>   {
>>   	struct fsldma_chan *chan = (struct fsldma_chan *)data;
>> -	unsigned long flags;
>>   
>>   	chan_dbg(chan, "tasklet entry\n");
>>   
>> -	spin_lock_irqsave(&chan->desc_lock, flags);
>> +	spin_lock_bh(&chan->desc_lock);
> okay here is the problem :(
>
> You moved to _bh variant. So if you grab the lock in rest of the code
> and irq gets triggered then here we will be spinning to grab the lock.
> So effectively you made right locking solution into deadlock situation!

If the rest code grabs lock by spin_lock_bh(), and if irq raised, the 
tasklet could not be executed because it has been disabled by the _bh 
variant function.
Right?

>>   
>>   	/* the hardware is now idle and ready for more */
>>   	chan->idle = true;
>> @@ -1136,7 +1131,7 @@ static void dma_do_tasklet(unsigned long data)
>>   	/* Run all cleanup for descriptors which have been completed */
>>   	fsldma_cleanup_descriptors(chan);
>>   
>> -	spin_unlock_irqrestore(&chan->desc_lock, flags);
>> +	spin_unlock_bh(&chan->desc_lock);
>>   
>>   	chan_dbg(chan, "tasklet exit\n");
>>   }
>



