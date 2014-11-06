Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaKFEs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:48:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58225 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKFEsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:48:53 -0500
Message-ID: <545AFDB1.80008@wwwdotorg.org>
Date: Wed, 05 Nov 2014 21:48:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Scott Branden <sbranden@broadcom.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Peter Griffin <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>, Piotr Krol <pietrushnic@gmail.com>
CC: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, linux-rpi-kernel@lists.infradead.org,
        Ray Jui <rjui@broadcom.com>, bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCHv2 3/5] mmc: shdci-bcm2835: add efficient back-to-back
 write workaround
References: <Scott Branden <sbranden@broadcom.com> <1414651017-3545-1-git-send-email-sbranden@broadcom.com> <1414651017-3545-4-git-send-email-sbranden@broadcom.com> <5459AE2C.2050401@wwwdotorg.org> <5459C9C8.9070800@broadcom.com>
In-Reply-To: <5459C9C8.9070800@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2014 11:55 PM, Scott Branden wrote:
> On 14-11-04 08:57 PM, Stephen Warren wrote:
>> On 10/30/2014 12:36 AM, Scott Branden wrote:
>>> The bcm2835 has clock domain issues when back to back writes to certain
>>> registers are written.  The existing driver works around this issue with
>>> udelay.  A more efficient method is to store the 8 and 16 bit writes
>>> to the registers affected and then write them as 32 bits at the
>>> appropriate
>>> time.
>>
>>> diff --git a/drivers/mmc/host/sdhci-bcm2835.c
>>> b/drivers/mmc/host/sdhci-bcm2835.c
>>
>>>   static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val,
>>> int reg)
>>>   {
>>>       struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>>> -    struct bcm2835_sdhci *bcm2835_host = pltfm_host->priv;
>>> -    u32 oldval = (reg == SDHCI_COMMAND) ? bcm2835_host->shadow :
>>> -        bcm2835_sdhci_readl(host, reg & ~3);
>>> +    struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;
>>
>> Is that type change for bcm2835_host really correct?
>
> Yes - at the top of the patch the structure has been expanded and named
> appropriately.
> 
> -struct bcm2835_sdhci {
> -    u32 shadow;
> +struct bcm2835_sdhci_host {
> +    u32 shadow_cmd;
> +    u32 shadow_blk;
>  };

Ah yes, sorry for missing that.

>>> +    } else {
>>> +        /* Read reg, all other registers are not shadowed */
>>> +        oldval = readl(host->ioaddr + (reg & ~3));
>>
>> Is there any reason to use readl() directly here rather than calling
>> bcm2835_readl()? ...
>
> Yes, bcm2835_readl does not need to be called in read-modify-write and
> shadow register situations and just adds overhead.  All that needs to be
> called is readl.  bcm2835_readl has some existing ugly code in it to
> modify the capabilities register on a read function.  This info never
> needs to be for write as you can't overwrite the capabilities register.

To be honest, it seems better to do all the read/write through
consistent functions. One advantage of bcm2835_readl() is that it
consistently adds on the base address internally so you don't have to
write it out every time manually. Still, the code ought to work fine
after this change, so I guess it's OK.

> I hope to get rid of the capabilities hack in a future patch as this
> should never have been acceptable in upstreamed code to begin with.  The
> capabilities override should have been passed in through a device tree
> entry.

It's a pretty common technique with precedent. I certainly don't agree
that it should be configured by DT. Arguably, DT makes sense to describe
board-to-board variations, but there's almost zero point putting data
into DT that is SoC description rather than board description; just put
it into the driver to avoid continually parsing the same data over and
over from DT just to get back to the same data that could have been
encoded into the driver. If the data varies between similar controllers,
an of_match table can easily be used to parameterize it based on
compatible value.
