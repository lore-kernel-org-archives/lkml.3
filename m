Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbaIVQW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:22:27 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:50975 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751070AbaIVQWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:22:25 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <54204CBB.5000603@smartplayin.com>
Date: Mon, 22 Sep 2014 21:52:19 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: atmel-mci: Switch to using managed resource
 in probe
References: <1411195951-10630-1-git-send-email-pramod.gurav@smartplayin.com> <20140922154540.GS22877@ldesroches-Latitude-E6320>
In-Reply-To: <20140922154540.GS22877@ldesroches-Latitude-E6320>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22-09-2014 09:15 PM, Ludovic Desroches wrote:
> Hi Pramod,
> 
> Thanks for taking care of device managed resources conversion. My only
> concern is about using devm_request_irq. There are several discussions
> about races which can occur when using it.
> 
> Keeping request_irq and free_irq the time it takes to solve this issue
> is probably better.
Oh, Thanks for letting me know this. I will resend this patch keeping
request_irq and free_irq in driver.

> 
> Regards
> 
> Ludovic
> 
> On Sat, Sep 20, 2014 at 12:22:30PM +0530, Pramod Gurav wrote:
>> This change uses managed resource APIs to allocate resources such as,
>> clk, gpio, irq in order to simplify the driver unload or failure cases.
>> Hence does away with release statements of the same resorces in error
>> lables and remove function.
>>
>> Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
>> Cc: Chris Ball <chris@printf.net>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Cc: linux-mmc@vger.kernel.org
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>> ---
>>  drivers/mmc/host/atmel-mci.c | 57 ++++++++++++++++----------------------------
>>  1 file changed, 20 insertions(+), 37 deletions(-)
>>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index bb585d9..21a222c 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/gpio.h>
>>  #include <linux/init.h>
>>  #include <linux/interrupt.h>
>> +#include <linux/io.h>
>>  #include <linux/ioport.h>
>>  #include <linux/module.h>
>>  #include <linux/of.h>
>> @@ -2195,7 +2196,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>>  	/* Assume card is present initially */
>>  	set_bit(ATMCI_CARD_PRESENT, &slot->flags);
>>  	if (gpio_is_valid(slot->detect_pin)) {
>> -		if (gpio_request(slot->detect_pin, "mmc_detect")) {
>> +		if (devm_gpio_request(&host->pdev->dev, slot->detect_pin,
>> +				      "mmc_detect")) {
>>  			dev_dbg(&mmc->class_dev, "no detect pin available\n");
>>  			slot->detect_pin = -EBUSY;
>>  		} else if (gpio_get_value(slot->detect_pin) ^
>> @@ -2208,7 +2210,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>>  		mmc->caps |= MMC_CAP_NEEDS_POLL;
>>  
>>  	if (gpio_is_valid(slot->wp_pin)) {
>> -		if (gpio_request(slot->wp_pin, "mmc_wp")) {
>> +		if (devm_gpio_request(&host->pdev->dev, slot->wp_pin,
>> +				      "mmc_wp")) {
>>  			dev_dbg(&mmc->class_dev, "no WP pin available\n");
>>  			slot->wp_pin = -EBUSY;
>>  		}
>> @@ -2224,7 +2227,8 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>>  		setup_timer(&slot->detect_timer, atmci_detect_change,
>>  				(unsigned long)slot);
>>  
>> -		ret = request_irq(gpio_to_irq(slot->detect_pin),
>> +		ret = devm_request_irq(&host->pdev->dev,
>> +				gpio_to_irq(slot->detect_pin),
>>  				atmci_detect_interrupt,
>>  				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>>  				"mmc-detect", slot);
>> @@ -2232,7 +2236,6 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>>  			dev_dbg(&mmc->class_dev,
>>  				"could not request IRQ %d for detect pin\n",
>>  				gpio_to_irq(slot->detect_pin));
>> -			gpio_free(slot->detect_pin);
>>  			slot->detect_pin = -EBUSY;
>>  		}
>>  	}
>> @@ -2252,15 +2255,8 @@ static void __exit atmci_cleanup_slot(struct atmel_mci_slot *slot,
>>  
>>  	mmc_remove_host(slot->mmc);
>>  
>> -	if (gpio_is_valid(slot->detect_pin)) {
>> -		int pin = slot->detect_pin;
>> -
>> -		free_irq(gpio_to_irq(pin), slot);
>> +	if (gpio_is_valid(slot->detect_pin))
>>  		del_timer_sync(&slot->detect_timer);
>> -		gpio_free(pin);
>> -	}
>> -	if (gpio_is_valid(slot->wp_pin))
>> -		gpio_free(slot->wp_pin);
>>  
>>  	slot->host->slot[id] = NULL;
>>  	mmc_free_host(slot->mmc);
>> @@ -2395,7 +2391,7 @@ static int __init atmci_probe(struct platform_device *pdev)
>>  	if (irq < 0)
>>  		return irq;
>>  
>> -	host = kzalloc(sizeof(struct atmel_mci), GFP_KERNEL);
>> +	host = devm_kzalloc(&pdev->dev, sizeof(*host), GFP_KERNEL);
>>  	if (!host)
>>  		return -ENOMEM;
>>  
>> @@ -2403,20 +2399,18 @@ static int __init atmci_probe(struct platform_device *pdev)
>>  	spin_lock_init(&host->lock);
>>  	INIT_LIST_HEAD(&host->queue);
>>  
>> -	host->mck = clk_get(&pdev->dev, "mci_clk");
>> -	if (IS_ERR(host->mck)) {
>> -		ret = PTR_ERR(host->mck);
>> -		goto err_clk_get;
>> -	}
>> +	host->mck = devm_clk_get(&pdev->dev, "mci_clk");
>> +	if (IS_ERR(host->mck))
>> +		return PTR_ERR(host->mck);
>>  
>> -	ret = -ENOMEM;
>> -	host->regs = ioremap(regs->start, resource_size(regs));
>> +	host->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
>>  	if (!host->regs)
>> -		goto err_ioremap;
>> +		return -ENOMEM;
>>  
>>  	ret = clk_prepare_enable(host->mck);
>>  	if (ret)
>> -		goto err_request_irq;
>> +		return ret;
>> +
>>  	atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
>>  	host->bus_hz = clk_get_rate(host->mck);
>>  	clk_disable_unprepare(host->mck);
>> @@ -2425,9 +2419,10 @@ static int __init atmci_probe(struct platform_device *pdev)
>>  
>>  	tasklet_init(&host->tasklet, atmci_tasklet_func, (unsigned long)host);
>>  
>> -	ret = request_irq(irq, atmci_interrupt, 0, dev_name(&pdev->dev), host);
>> +	ret = devm_request_irq(&pdev->dev, irq, atmci_interrupt, 0,
>> +			       dev_name(&pdev->dev), host);
>>  	if (ret)
>> -		goto err_request_irq;
>> +		return ret;
>>  
>>  	/* Get MCI capabilities and set operations according to it */
>>  	atmci_get_cap(host);
>> @@ -2498,13 +2493,7 @@ static int __init atmci_probe(struct platform_device *pdev)
>>  err_init_slot:
>>  	if (host->dma.chan)
>>  		dma_release_channel(host->dma.chan);
>> -	free_irq(irq, host);
>> -err_request_irq:
>> -	iounmap(host->regs);
>> -err_ioremap:
>> -	clk_put(host->mck);
>> -err_clk_get:
>> -	kfree(host);
>> +
>>  	return ret;
>>  }
>>  
>> @@ -2531,12 +2520,6 @@ static int __exit atmci_remove(struct platform_device *pdev)
>>  	if (host->dma.chan)
>>  		dma_release_channel(host->dma.chan);
>>  
>> -	free_irq(platform_get_irq(pdev, 0), host);
>> -	iounmap(host->regs);
>> -
>> -	clk_put(host->mck);
>> -	kfree(host);
>> -
>>  	return 0;
>>  }
>>  
>> -- 
>> 1.8.3.2
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
