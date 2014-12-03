Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaLCJzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 04:55:09 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:34184 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaLCJzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 04:55:02 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Dec 2014 10:57:10 +0100
From: Stefan Agner <stefan@agner.ch>
To: Lucas Stach <l.stach@pengutronix.de>
Cc: chris@printf.net, ulf.hansson@linaro.org, anton@enomsg.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rmk+kernel@arm.linux.org.uk, shawn.guo@linaro.org,
        b29396@freescale.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] mmc: sdhci-esdhc-imx: enable IPG clock for sdio
 interrupts
In-Reply-To: <1417598713.2419.1.camel@pengutronix.de>
References: <1417538845-10867-1-git-send-email-stefan@agner.ch>
 <1417538845-10867-2-git-send-email-stefan@agner.ch>
 <1417598713.2419.1.camel@pengutronix.de>
Message-ID: <6ff09082f3f43d4b358ec59d7ed8f216@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Dec  3 10:54:24 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 547eddd012817896758063
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-12-03 10:25, Lucas Stach wrote:
> Am Dienstag, den 02.12.2014, 17:47 +0100 schrieb Stefan Agner:
>> Enable IPG clock for sdio interrupts while runtime PM, since this
>> clock is needed for register access. The need of this clock has been
>> verified on Vybrid, but this is probably true for i.MX53 and maybe
>> others. The need for bus access during runtime suspend has been
>> introduced with be138554a792 ("mmc: sdhci: allow sdio interrupts
>> while sdhci runtime suspended").
>>
> Am I reading this wrong, or is this commit actually doing something
> different than what the commit message says?
> 
> This does _not_ enable the IPG clock during runtime PM, in fact it is
> disabling it while suspending even with SDIO ints enabled, which is
> wrong, as no SDIO interrupts will be delivered with this clock disabled.

You are completely right. What I wanted was what is written in the
commit message, but I misinterpreted the code!

=> This patch is invalid.

> One thing that seems to be wrong with the current code is that the state
> of sdhci_sdio_irq_enabled could change between a runtime suspend and
> resume, so to keep the clocks balanced the driver has to remember if it
> disabled those two clocks in the suspend path and always enable them in
> that case in the resume path.

As far as I can see, the only place where that flag changes is in
sdhci_enable_sdio_irq. But this function makes sure runtime PM is off
while changing that, so I guess it's ok....

--
Stefan

> 
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>> ---
>>  drivers/mmc/host/sdhci-esdhc-imx.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
>> index 587ee0e..b7e9ad1 100644
>> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
>> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
>> @@ -1193,10 +1193,10 @@ static int sdhci_esdhc_runtime_suspend(struct device *dev)
>>
>>  	ret = sdhci_runtime_suspend_host(host);
>>
>> -	if (!sdhci_sdio_irq_enabled(host)) {
>> +	if (!sdhci_sdio_irq_enabled(host))
>>  		clk_disable_unprepare(imx_data->clk_per);
>> -		clk_disable_unprepare(imx_data->clk_ipg);
>> -	}
>> +
>> +	clk_disable_unprepare(imx_data->clk_ipg);
>>  	clk_disable_unprepare(imx_data->clk_ahb);
>>
>>  	return ret;
>> @@ -1208,10 +1208,10 @@ static int sdhci_esdhc_runtime_resume(struct device *dev)
>>  	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>>  	struct pltfm_imx_data *imx_data = pltfm_host->priv;
>>
>> -	if (!sdhci_sdio_irq_enabled(host)) {
>> +	if (!sdhci_sdio_irq_enabled(host))
>>  		clk_prepare_enable(imx_data->clk_per);
>> -		clk_prepare_enable(imx_data->clk_ipg);
>> -	}
>> +
>> +	clk_prepare_enable(imx_data->clk_ipg);
>>  	clk_prepare_enable(imx_data->clk_ahb);
>>
>>  	return sdhci_runtime_resume_host(host);

