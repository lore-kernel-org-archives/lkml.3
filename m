Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbaDKHmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:42:46 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:24579
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbaDKHmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:42:43 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI9371I936eI1432Id799hdbb0izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz8275ch1d7338h1de098h17326ah8275bh1de097h186068hz2dh2a8h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26b9h26d3h1155h)
Message-ID: <53479CE0.1030009@freescale.com>
Date: Fri, 11 Apr 2014 15:42:24 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: <vkoul@infradead.org>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <scottwood@freescale.com>,
        <leo.li@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/8] DMA: Freescale: add suspend resume functions for
 DMA driver
References: <1397113805-24171-1-git-send-email-hongbo.zhang@freescale.com>	 <1397113805-24171-9-git-send-email-hongbo.zhang@freescale.com> <1397131557.11914.113.camel@smile.fi.intel.com>
In-Reply-To: <1397131557.11914.113.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/10/2014 08:05 PM, Andy Shevchenko wrote:
> On Thu, 2014-04-10 at 15:10 +0800, hongbo.zhang@freescale.com wrote:
>> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>>
>> This patch adds suspend resume functions for Freescale DMA driver.
>> .prepare callback is used to stop further descriptors from being added into the
>> pending queue, and also issue pending queues into execution if there is any.
>> .suspend callback makes sure all the pending jobs are cleaned up and all the
>> channels are idle, and save the mode registers.
>> .resume callback re-initializes the channels by restore the mode registers.
> Like we discussed with Vinod [1] the DMA controller drivers should go to
> suspend after users and come back before them.
>
> After you reconsider this point the patch logic might be modified a lot.

Looked through that discussions, I really had thought such problem for a 
while.

For the dma-controller and dma-user, we don't know which .suspend 
callback is executed firstly, so the idea would be: which ever is called 
earlier, the dma-controller driver suspend function should be as  robust 
as possible.

It is better the dma-user .suspend callback is called earlier, some 
clean-ups should be done here such as stop dma request, but we cannot 
make sure every dma-user has a .suspend callback, some dma-users don't 
pay attention to or even don't care the suspend at all for some reason.

So even the suspend_late is used, we cannot assume every dma-user's 
activity is cleaned up neatly, dma-controller driver should be robust to 
handle this gracefully, that was my design target.

In the prepare() function, clean up the pending queue and stop receive 
new coming request, and in the suspend() function I do some register 
saving works. I don't think my code needs to be modified much, a 
possible change according to Vinod's idea would be:
use .suspend instead of my current .prepare
use . suspend_late instead of my current .suspend
e.g. postpone all my functions to be executed later, this method works 
and seems better for client/low-level module drivers.

The reason I didn't use the above functions was that I had read this 
Documentation/power/devices.txt, search the definitions of prepare, 
suspend, suspend_late and suspend_noirq, I think my usage complies with 
that definitions strictly, I can do the modification above if the 
maintainer like and if nobody says I break this law.

> (Moreover, you abuse your own position to use only setters/getters to
> access to the DMAc registers)

My shame, I will update it.
(reason is the setters/getters patch isn't merged into our internal 
tree, but this suspend patch has been done. I am trying to sync our 
internal kernel and the community now)

> [1] http://www.spinics.net/lists/kernel/msg1650974.html
>
>
>> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
>> ---
>>   drivers/dma/fsldma.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>   drivers/dma/fsldma.h |   16 ++++++++
>>   2 files changed, 116 insertions(+)
>>
>> diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
>> index c9bf54a..d6da222 100644
>> --- a/drivers/dma/fsldma.c
>> +++ b/drivers/dma/fsldma.c
>> @@ -400,6 +400,14 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
>>   
>>   	spin_lock_bh(&chan->desc_lock);
>>   
>> +#ifdef CONFIG_PM
>> +	if (unlikely(chan->pm_state != RUNNING)) {
>> +		chan_dbg(chan, "cannot submit due to suspend\n");
>> +		spin_unlock_bh(&chan->desc_lock);
>> +		return -1;
>> +	}
>> +#endif
>> +
>>   	/*
>>   	 * assign cookies to all of the software descriptors
>>   	 * that make up this transaction
>> @@ -1311,6 +1319,9 @@ static int fsl_dma_chan_probe(struct fsldma_device *fdev,
>>   	INIT_LIST_HEAD(&chan->ld_running);
>>   	INIT_LIST_HEAD(&chan->ld_completed);
>>   	chan->idle = true;
>> +#ifdef CONFIG_PM
>> +	chan->pm_state = RUNNING;
>> +#endif
>>   
>>   	chan->common.device = &fdev->common;
>>   	dma_cookie_init(&chan->common);
>> @@ -1450,6 +1461,92 @@ static int fsldma_of_remove(struct platform_device *op)
>>   	return 0;
>>   }
>>   
>> +#ifdef CONFIG_PM
>> +static int fsldma_prepare(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct fsldma_device *fdev = platform_get_drvdata(pdev);
>> +	struct fsldma_chan *chan;
>> +	int i;
>> +
>> +	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
>> +		chan = fdev->chan[i];
>> +		if (!chan)
>> +			continue;
>> +
>> +		spin_lock_bh(&chan->desc_lock);
>> +		chan->pm_state = SUSPENDING;
>> +		if (!list_empty(&chan->ld_pending))
>> +			fsl_chan_xfer_ld_queue(chan);
>> +		spin_unlock_bh(&chan->desc_lock);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int fsldma_suspend(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct fsldma_device *fdev = platform_get_drvdata(pdev);
>> +	struct fsldma_chan *chan;
>> +	int i;
>> +
>> +	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
>> +		chan = fdev->chan[i];
>> +		if (!chan)
>> +			continue;
>> +
>> +		spin_lock_bh(&chan->desc_lock);
>> +		if (!chan->idle)
>> +			goto out;
>> +		chan->regs_save.mr = DMA_IN(chan, &chan->regs->mr, 32);
>> +		chan->pm_state = SUSPENDED;
>> +		spin_unlock_bh(&chan->desc_lock);
>> +	}
>> +	return 0;
>> +
>> +out:
>> +	for (; i >= 0; i--) {
>> +		chan = fdev->chan[i];
>> +		if (!chan)
>> +			continue;
>> +		chan->pm_state = RUNNING;
>> +		spin_unlock_bh(&chan->desc_lock);
>> +	}
>> +	return -EBUSY;
>> +}
>> +
>> +static int fsldma_resume(struct device *dev)
>> +{
>> +	struct platform_device *pdev = to_platform_device(dev);
>> +	struct fsldma_device *fdev = platform_get_drvdata(pdev);
>> +	struct fsldma_chan *chan;
>> +	u32 mode;
>> +	int i;
>> +
>> +	for (i = 0; i < FSL_DMA_MAX_CHANS_PER_DEVICE; i++) {
>> +		chan = fdev->chan[i];
>> +		if (!chan)
>> +			continue;
>> +
>> +		spin_lock_bh(&chan->desc_lock);
>> +		mode = chan->regs_save.mr
>> +			& ~FSL_DMA_MR_CS & ~FSL_DMA_MR_CC & ~FSL_DMA_MR_CA;
>> +		DMA_OUT(chan, &chan->regs->mr, mode, 32);
>> +		chan->pm_state = RUNNING;
>> +		spin_unlock_bh(&chan->desc_lock);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct dev_pm_ops fsldma_pm_ops = {
>> +	.prepare	= fsldma_prepare,
>> +	.suspend	= fsldma_suspend,
>> +	.resume		= fsldma_resume,
>> +};
>> +#endif
>> +
>>   static const struct of_device_id fsldma_of_ids[] = {
>>   	{ .compatible = "fsl,elo3-dma", },
>>   	{ .compatible = "fsl,eloplus-dma", },
>> @@ -1462,6 +1559,9 @@ static struct platform_driver fsldma_of_driver = {
>>   		.name = "fsl-elo-dma",
>>   		.owner = THIS_MODULE,
>>   		.of_match_table = fsldma_of_ids,
>> +#ifdef CONFIG_PM
>> +		.pm = &fsldma_pm_ops,
>> +#endif
>>   	},
>>   	.probe = fsldma_of_probe,
>>   	.remove = fsldma_of_remove,
>> diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
>> index ec19517..eecaf9e 100644
>> --- a/drivers/dma/fsldma.h
>> +++ b/drivers/dma/fsldma.h
>> @@ -134,6 +134,18 @@ struct fsldma_device {
>>   #define FSL_DMA_CHAN_PAUSE_EXT	0x00001000
>>   #define FSL_DMA_CHAN_START_EXT	0x00002000
>>   
>> +#ifdef CONFIG_PM
>> +struct fsldma_chan_regs_save {
>> +	u32 mr;
>> +};
>> +
>> +enum fsldma_pm_state {
>> +	RUNNING = 0,
>> +	SUSPENDING,
>> +	SUSPENDED,
>> +};
>> +#endif
>> +
>>   struct fsldma_chan {
>>   	char name[8];			/* Channel name */
>>   	struct fsldma_chan_regs __iomem *regs;
>> @@ -161,6 +173,10 @@ struct fsldma_chan {
>>   	struct tasklet_struct tasklet;
>>   	u32 feature;
>>   	bool idle;			/* DMA controller is idle */
>> +#ifdef CONFIG_PM
>> +	struct fsldma_chan_regs_save regs_save;
>> +	enum fsldma_pm_state pm_state;
>> +#endif
>>   
>>   	void (*toggle_ext_pause)(struct fsldma_chan *fsl_chan, int enable);
>>   	void (*toggle_ext_start)(struct fsldma_chan *fsl_chan, int enable);
>



