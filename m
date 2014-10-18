Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaJRGks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 02:40:48 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:41258 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaJRGkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 02:40:45 -0400
X-IronPort-AV: E=Sophos;i="5.04,744,1406617200"; 
   d="scan'208";a="48527357"
Message-ID: <54420B6A.9050206@broadcom.com>
Date: Fri, 17 Oct 2014 23:40:42 -0700
From: Scott Branden <sbranden@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "Peter Griffin" <peter.griffin@linaro.org>,
        Chris Ball <chris@printf.net>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>, <linux-rpi-kernel@lists.infradead.org>,
        Ray Jui <rjui@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH 1/1] mmc: sdhci-bcm2835: added quirk and removed udelay
 in write ops
References: <Scott Branden <sbranden@broadcom.com> <1413391385-4061-1-git-send-email-sbranden@broadcom.com> <5441D25E.5020007@wwwdotorg.org>
In-Reply-To: <5441D25E.5020007@wwwdotorg.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Great review - thanks.

On 14-10-17 07:37 PM, Stephen Warren wrote:
> On 10/15/2014 10:43 AM, Scott Branden wrote:
>> Added quirk SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 present in controller.
>> Removed udelay in write ops by using shadow registers for 16 bit
>> accesses to 32-bit registers (where necessary).
>> Optimized 32-bit operations when doing 8/16 register accesses.
>
> That's 2 or 3 unrelated changes. They'd be better as separate patches,
> so that any issues that arise can be bisected down to the smaller changes.
OK - I will split into smaller patches to bisect and understand better.
>
>> diff --git a/drivers/mmc/host/sdhci-bcm2835.c b/drivers/mmc/host/sdhci-bcm2835.c
>
>>   /*
>>    * The Arasan has a bugette whereby it may lose the content of successive
>> + * writes to the same register that are within two SD-card clock cycles of
>> + * each other (a clock domain crossing problem).  Problem does not happen with
>                                                      ^ The?
> See right >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ^
>
>> + * data.
>
> Blank line to separate the paragraphs here, to be consistent with the
> other paragraph break below?
I'll clean up the comment some more.
>
>> + * This wouldn't be a problem with the code except that we can only write the
>> + * controller with 32-bit writes.  So two different 16-bit registers in the
>> + * written back to back creates the problem.
>>    *
>> + * In reality, this only happens when a SDHCI_BLOCK_SIZE and SDHCI_BLOCK_COUNT
>> + * are written followed by SDHCI_TRANSFER_MODE and SDHCI_COMMAND.
>
> That seems like a rather risky assertion. Even if it's perfectly true
> with the MMC core code right now, does the MMC core document a guarantee
> that this will always be true? Even if we optimize the WAR for the issue
> as you've done, I think we should still have code that validates that
> the same register is never written back-to-back to detect this likely
> very hard-to-debug problem.
You're right - nothing in life is guaranteed.  We had test code for 
this.  I'll add a config option (default on) that verifies back to back 
writes do not occur.
>
>> + * The BLOCK_SIZE and BLOCK_COUNT are meaningless until a command issued so
>> + * the work around can be further optimized. We can keep shadow values of
>> + * BLOCK_SIZE, BLOCK_COUNT, and TRANSFER_MODE until a COMMAND is issued.
>> + * Then, write the BLOCK_SIZE+BLOCK_COUNT in a single 32-bit write followed
>> + * by the TRANSFER+COMMAND in another 32-bit write.
>>    */
>
> After this patch, the entire WAR for this issue is contained within
> bcm2835_sdhci_writew(). It might be a good idea to move the comment next
> to that function so it's more at hand to explain the code that's there.
> Or at least add a comment to that function the to mention the location
> of the explanation for the complex code.
ok, I'll clean up the comment a little more too.
>
>>   static inline u32 bcm2835_sdhci_readl(struct sdhci_host *host, int reg)
>>   {
>>   	u32 val = readl(host->ioaddr + reg);
>> @@ -71,76 +57,83 @@ static inline u32 bcm2835_sdhci_readl(struct sdhci_host *host, int reg)
>>   	return val;
>>   }
>>
>> -static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
>> -{
> ... (entire function deleted)
>> -}
>
> This patch could be a lot smaller if it didn't re-order the functions at
> the same time. It makes the patch harder to understand. If you must
> re-order the functions, perhaps make that a separate patch that does
> nothing else, so that the actual code changes are easier to see?
ok
>
>>   static u16 bcm2835_sdhci_readw(struct sdhci_host *host, int reg)
>>   {
>> -	u32 val = bcm2835_sdhci_readl(host, (reg & ~3));
>> -	u32 word_num = (reg >> 1) & 1;
>> -	u32 word_shift = word_num * 16;
>> -	u32 word = (val >> word_shift) & 0xffff;
>> -
>> +	u32 val = bcm2835_sdhci_readl(host->ioaddr, (reg & ~3));
>
> The change from host to host->ioaddr ends up passing the wrong value to
> bcm2835_sdhci_readl(). This causes the kernel to crash during boot.
I see that now.  Will fix - unfortunately I ported from an existing 
driver that doesn't need the bcm2835_shdci_readl function.
>
> The compiler doesn't warn about this because host->ioaddr is void, so
> can be automatically converted to struct sdhci_host *.
>
>> +	u16 word = val >> (reg << 3 & 0x18) & 0xffff;
>>   	return word;
>>   }
>
> To be honest, I think the existing code is a bit clearer, since it uses
> variables with names to explain all the intermediate values. Assuming
> the compiler is competent (which admittedly I haven't checked) I would
> expect the same code to be generated either way, or at least something
> pretty similar. Did you measure the benefit of the optimization?
By optimize I meant use the same bit calculation instead of doing 
different calculations for the same operation.  I'll create a macro to 
make it clearer to see.
>
>> +static void bcm2835_sdhci_writew(struct sdhci_host *host, u16 val, int reg)
>>   {
>> +	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
>> +	struct bcm2835_sdhci_host *bcm2835_host = pltfm_host->priv;
>> +	u32 word_shift = reg << 3 & 0x18;
>> +	u32 mask = 0xffff << word_shift;
>> +	u32 oldval;
>> +	u32 newval;
>> +
>> +	if (reg == SDHCI_COMMAND) {
>> +		if (bcm2835_host->shadow_blk != 0) {
>> +			writel(bcm2835_host->shadow_blk,
>> +			       host->ioaddr + SDHCI_BLOCK_SIZE);
>> +			bcm2835_host->shadow_blk = 0;
>> +		}
>
> Is it absolutely guaranteed that there's never a need to write 0 to that
> register? I can see that no data transfer command is likely to transfer
> 0 blocks. I assume no other type of command uses that register as a
> parameter?
Correct.
>

