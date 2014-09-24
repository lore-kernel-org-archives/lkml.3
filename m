Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaIXFoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:44:54 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:57017 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbaIXFox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:44:53 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Message-ID: <542259CA.5080002@smartplayin.com>
Date: Wed, 24 Sep 2014 11:12:34 +0530
From: Kiran Padwal <kiran.padwal@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: cppi41: Switch to using managed resource in probe
References: <1411476646-16902-1-git-send-email-kiran.padwal@smartplayin.com> <20140923154035.GP24663@intel.com>
In-Reply-To: <20140923154035.GP24663@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 09:10 PM, Vinod Koul wrote:
> On Tue, Sep 23, 2014 at 06:20:46PM +0530, Kiran Padwal wrote:
>> This change uses managed resource APIs to allocate resources such as,
>> mem, irq in order to simplify the driver unload or failure cases.
>>
>> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
>> ---
>>  drivers/dma/cppi41.c |   15 ++++-----------
>>  1 file changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
>> index 5921ce3..d3700fb 100644
>> --- a/drivers/dma/cppi41.c
>> +++ b/drivers/dma/cppi41.c
>> @@ -938,7 +938,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>>  	if (!glue_info)
>>  		return -EINVAL;
>>  
>> -	cdd = kzalloc(sizeof(*cdd), GFP_KERNEL);
>> +	cdd = devm_kzalloc(&pdev->dev, sizeof(*cdd), GFP_KERNEL);
>>  	if (!cdd)
>>  		return -ENOMEM;
>>  
>> @@ -959,10 +959,8 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>>  	cdd->qmgr_mem = of_iomap(dev->of_node, 3);
>>  
>>  	if (!cdd->usbss_mem || !cdd->ctrl_mem || !cdd->sched_mem ||
>> -			!cdd->qmgr_mem) {
>> -		ret = -ENXIO;
>> -		goto err_remap;
>> -	}
>> +			!cdd->qmgr_mem)
>> +		return -ENXIO;
>>  
>>  	pm_runtime_enable(dev);
>>  	ret = pm_runtime_get_sync(dev);
>> @@ -989,7 +987,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>>  
>>  	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
>>  
>> -	ret = request_irq(irq, glue_info->isr, IRQF_SHARED,
>> +	ret = devm_request_irq(&pdev->dev, irq, glue_info->isr, IRQF_SHARED,
>>  			dev_name(dev), cdd);
>>  	if (ret)
>>  		goto err_irq;
>> @@ -1009,7 +1007,6 @@ static int cppi41_dma_probe(struct platform_device *pdev)
>>  err_of:
>>  	dma_async_device_unregister(&cdd->ddev);
>>  err_dma_reg:
>> -	free_irq(irq, cdd);
>>  err_irq:
>>  	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
>>  	cleanup_chans(cdd);
>> @@ -1023,8 +1020,6 @@ err_get_sync:
>>  	iounmap(cdd->ctrl_mem);
>>  	iounmap(cdd->sched_mem);
>>  	iounmap(cdd->qmgr_mem);
>> -err_remap:
>> -	kfree(cdd);
>>  	return ret;
>>  }
>>  
>> @@ -1036,7 +1031,6 @@ static int cppi41_dma_remove(struct platform_device *pdev)
>>  	dma_async_device_unregister(&cdd->ddev);
>>  
>>  	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
>> -	free_irq(cdd->irq, cdd);
> pls use devm_free_irq() explicitly here, other wise your controller is active and able
> to send interrupts and driver object is getting removed. It is the role of
> driver to quiesce device before releasing
> 

Thanks, I will take care of that and resend the patch.



