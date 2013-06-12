Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab3FLMIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:08:49 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:34227 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755580Ab3FLMIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:08:48 -0400
Message-ID: <51B864CB.8000100@overkiz.com>
Date: Wed, 12 Jun 2013 14:08:43 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dan Williams <djbw@fb.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [RFC PATCH 27/50] at_hdmac: prepare clk before calling enable
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com> <1370622358-19575-1-git-send-email-b.brezillon@overkiz.com> <20130612090520.GN4107@intel.com>
In-Reply-To: <20130612090520.GN4107@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7230247728176593043
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrhedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2013 11:05, Vinod Koul wrote:
> On Fri, Jun 07, 2013 at 06:25:57PM +0200, Boris BREZILLON wrote:
>> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
>> avoid common clk framework warnings.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   drivers/dma/at_hdmac.c |   12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
>> index e923cda..4772036 100644
>> --- a/drivers/dma/at_hdmac.c
>> +++ b/drivers/dma/at_hdmac.c
>> @@ -1374,7 +1374,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
>>   		err = PTR_ERR(atdma->clk);
>>   		goto err_clk;
>>   	}
>> -	clk_enable(atdma->clk);
>> +	clk_prepare_enable(atdma->clk);
> Can you add checks for return value in the driver as well
Sure. I'll add it in the next version.
>>   
>>   	/* force dma off, just in case */
>>   	at_dma_off(atdma);
>> @@ -1475,7 +1475,7 @@ err_pool_create:
>>   	platform_set_drvdata(pdev, NULL);
>>   	free_irq(platform_get_irq(pdev, 0), atdma);
>>   err_irq:
>> -	clk_disable(atdma->clk);
>> +	clk_disable_unprepare(atdma->clk);
>>   	clk_put(atdma->clk);
>>   err_clk:
>>   	iounmap(atdma->regs);
>> @@ -1512,7 +1512,7 @@ static int at_dma_remove(struct platform_device *pdev)
>>   		list_del(&chan->device_node);
>>   	}
>>   
>> -	clk_disable(atdma->clk);
>> +	clk_disable_unprepare(atdma->clk);
>>   	clk_put(atdma->clk);
>>   
>>   	iounmap(atdma->regs);
>> @@ -1531,7 +1531,7 @@ static void at_dma_shutdown(struct platform_device *pdev)
>>   	struct at_dma	*atdma = platform_get_drvdata(pdev);
>>   
>>   	at_dma_off(platform_get_drvdata(pdev));
>> -	clk_disable(atdma->clk);
>> +	clk_disable_unprepare(atdma->clk);
>>   }
>>   
>>   static int at_dma_prepare(struct device *dev)
>> @@ -1588,7 +1588,7 @@ static int at_dma_suspend_noirq(struct device *dev)
>>   
>>   	/* disable DMA controller */
>>   	at_dma_off(atdma);
>> -	clk_disable(atdma->clk);
>> +	clk_disable_unprepare(atdma->clk);
>>   	return 0;
>>   }
>>   
>> @@ -1618,7 +1618,7 @@ static int at_dma_resume_noirq(struct device *dev)
>>   	struct dma_chan *chan, *_chan;
>>   
>>   	/* bring back DMA controller */
>> -	clk_enable(atdma->clk);
>> +	clk_prepare_enable(atdma->clk);
>>   	dma_writel(atdma, EN, AT_DMA_ENABLE);
>>   
>>   	/* clear any pending interrupt */
> --
> ~Vinod

