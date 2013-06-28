Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab3F1IGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:06:30 -0400
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:53965 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754719Ab3F1IGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:06:18 -0400
Message-ID: <51CD43F4.2000601@overkiz.com>
Date: Fri, 28 Jun 2013 10:06:12 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Chris Ball <cjb@laptop.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: [PATCH v2 2/4] mmc: atmel-mci: prepare clk before calling enable
References: <1372147702-4074-1-git-send-email-b.brezillon@overkiz.com> <1372147891-4296-1-git-send-email-b.brezillon@overkiz.com> <51CD3EE4.90902@atmel.com>
In-Reply-To: <51CD3EE4.90902@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4923560293934856300
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrledtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrledtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/2013 09:44, Nicolas Ferre wrote:
> On 25/06/2013 10:11, Boris BREZILLON :
>> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
>> avoid common clk framework warnings.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>
> It seems that you forgot the Acked-by line from Ludovic.
>
> One comment...
>
>> ---
>>   drivers/mmc/host/atmel-mci.c |   27 ++++++++++++++++++---------
>>   1 file changed, 18 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>> index e75774f..631c4cf 100644
>> --- a/drivers/mmc/host/atmel-mci.c
>> +++ b/drivers/mmc/host/atmel-mci.c
>> @@ -380,6 +380,8 @@ static int atmci_regs_show(struct seq_file *s, 
>> void *v)
>>   {
>>       struct atmel_mci    *host = s->private;
>>       u32            *buf;
>> +    int            ret = 0;
>> +
>>
>>       buf = kmalloc(ATMCI_REGS_SIZE, GFP_KERNEL);
>>       if (!buf)
>> @@ -391,9 +393,13 @@ static int atmci_regs_show(struct seq_file *s, 
>> void *v)
>>        * consistent.
>>        */
>>       spin_lock_bh(&host->lock);
>> -    clk_enable(host->mck);
>> +    ret = clk_prepare_enable(host->mck);
>
> Do you think that it is needed here? I do not think it can be called 
> before the probe() function and I do not know if the result can change 
> depending on when clk_prepare_enable() is called...
Same as for other patches: it should not fail if this function is called 
after probe,
because the prepare and enable process already succeed once.

But I think this is better to keep the check wherever we can reflect the 
error to the caller:
the code will be more robust to clk framework or at91 clk implementation 
changes.

I know I told you this kind of check could be removed from dma driver, 
so this is a bit inconsistent.

It's up to you, tell me if you want me to remove this part.


>
>> +    if (ret) {
>> +        spin_unlock_bh(&host->lock);
>> +        goto out;
>> +    }
>>       memcpy_fromio(buf, host->regs, ATMCI_REGS_SIZE);
>> -    clk_disable(host->mck);
>> +    clk_disable_unprepare(host->mck);
>>       spin_unlock_bh(&host->lock);
>>
>>       seq_printf(s, "MR:\t0x%08x%s%s ",
>> @@ -444,9 +450,10 @@ static int atmci_regs_show(struct seq_file *s, 
>> void *v)
>>                   val & ATMCI_CFG_LSYNC ? " LSYNC" : "");
>>       }
>>
>> +out:
>>       kfree(buf);
>>
>> -    return 0;
>> +    return ret;
>>   }
>>
>>   static int atmci_regs_open(struct inode *inode, struct file *file)
>> @@ -1281,7 +1288,7 @@ static void atmci_set_ios(struct mmc_host *mmc, 
>> struct mmc_ios *ios)
>>
>>           spin_lock_bh(&host->lock);
>>           if (!host->mode_reg) {
>> -            clk_enable(host->mck);
>> +            clk_prepare_enable(host->mck);
>>               atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
>>               atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIEN);
>>               if (host->caps.has_cfg_reg)
>> @@ -1361,7 +1368,7 @@ static void atmci_set_ios(struct mmc_host *mmc, 
>> struct mmc_ios *ios)
>>               atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIDIS);
>>               if (host->mode_reg) {
>>                   atmci_readl(host, ATMCI_MR);
>> -                clk_disable(host->mck);
>> +                clk_disable_unprepare(host->mck);
>>               }
>>               host->mode_reg = 0;
>>           }
>> @@ -2379,10 +2386,12 @@ static int __init atmci_probe(struct 
>> platform_device *pdev)
>>       if (!host->regs)
>>           goto err_ioremap;
>>
>> -    clk_enable(host->mck);
>> +    ret = clk_prepare_enable(host->mck);
>> +    if (ret)
>> +        goto err_request_irq;
>>       atmci_writel(host, ATMCI_CR, ATMCI_CR_SWRST);
>>       host->bus_hz = clk_get_rate(host->mck);
>> -    clk_disable(host->mck);
>> +    clk_disable_unprepare(host->mck);
>>
>>       host->mapbase = regs->start;
>>
>> @@ -2487,11 +2496,11 @@ static int __exit atmci_remove(struct 
>> platform_device *pdev)
>>               atmci_cleanup_slot(host->slot[i], i);
>>       }
>>
>> -    clk_enable(host->mck);
>> +    clk_prepare_enable(host->mck);
>>       atmci_writel(host, ATMCI_IDR, ~0UL);
>>       atmci_writel(host, ATMCI_CR, ATMCI_CR_MCIDIS);
>>       atmci_readl(host, ATMCI_SR);
>> -    clk_disable(host->mck);
>> +    clk_disable_unprepare(host->mck);
>>
>>       if (host->dma.chan)
>>           dma_release_channel(host->dma.chan);
>>
>
>

