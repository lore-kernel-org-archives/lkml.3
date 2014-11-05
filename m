Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaKEGzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:55:12 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:8137 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaKEGzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:55:09 -0500
X-IronPort-AV: E=Sophos;i="5.07,317,1413270000"; 
   d="scan'208";a="50131801"
Message-ID: <5459C9C8.9070800@broadcom.com>
Date: Tue, 4 Nov 2014 22:55:04 -0800
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "Peter Griffin" <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>, "Piotr Krol" <pietrushnic@gmail.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCHv2 3/5] mmc: shdci-bcm2835: add efficient back-to-back
 write workaround
References: <Scott Branden <sbranden@broadcom.com> <1414651017-3545-1-git-send-email-sbranden@broadcom.com> <1414651017-3545-4-git-send-email-sbranden@broadcom.com> <5459AE2C.2050401@wwwdotorg.org>
In-Reply-To: <5459AE2C.2050401@wwwdotorg.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-11-04 08:57 PM, Stephen Warren wrote:
> On 10/30/2014 12:36 AM, Scott Branden wrote:
>> The bcm2835 has clock domain issues when back to back writes to certain
>> registers are written.  The existing driver works around this issue with
>> udelay.  A more efficient method is to store the 8 and 16 bit writes
>> to the registers affected and then write them as 32 bits at the appropriate
>> time.
>
>> diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
>
>>   static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
>>   {
>>   	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>> -	struct bcm2835_sdhci *bcm2835_host = pltfm_host->priv;
>> -	u32 oldval = (reg == SDHCI_COMMAND) ? bcm2835_host->shadow :
>> -		bcm2835_sdhci_readl(host, reg & ~3);
>> +	struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;
>
> Is that type change for bcm2835_host really correct?
Yes - at the top of the patch the structure has been expanded and named 
appropriately.

-struct bcm2835_sdhci {
-	u32 shadow;
+struct bcm2835_sdhci_host {
+	u32 shadow_cmd;
+	u32 shadow_blk;
  };
>
>> +	} else {
>> +		/* Read reg, all other registers are not shadowed */
>> +		oldval = readl(host->ioaddr + (reg & ~3));
>
> Is there any reason to use readl() directly here rather than calling
> bcm2835_readl()? ...
Yes, bcm2835_readl does not need to be called in read-modify-write and 
shadow register situations and just adds overhead.  All that needs to be 
called is readl.  bcm2835_readl has some existing ugly code in it to 
modify the capabilities register on a read function.  This info never 
needs to be for write as you can't overwrite the capabilities register. 
  I hope to get rid of the capabilities hack in a future patch as this 
should never have been acceptable in upstreamed code to begin with.  The 
capabilities override should have been passed in through a device tree 
entry.
>
>>   static void bcm2835_sdhci_writeb(struct sdhci_host *host, u8 val, int reg)
>>   {
>> -	u32 oldval = bcm2835_sdhci_readl(host, reg & ~3);
>> +	u32 oldval = readl(host->ioaddr + (reg & ~3));
>
> ... and here in particular, since this seems like an unrelated change?
Same situation with bcm2835_readl above.  No need to call in 
read-modify-write situations.
>
>>   static int bcm2835_sdhci_probe(struct platform_device *pdev)
>>   {
>>   	struct sdhci_host *host;
>> -	struct bcm2835_sdhci *bcm2835_host;
>> +	struct bcm2835_sdhci_host *bcm2835_host;
>
> Is that type change for bcm2835_host really correct?
>
yes - structure renamed above
