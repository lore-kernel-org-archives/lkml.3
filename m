Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaAFUdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 15:33:46 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:40683 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaAFUdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 15:33:44 -0500
Message-ID: <52CB1323.6080200@codeaurora.org>
Date: Mon, 06 Jan 2014 12:33:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/7] mfd: pm8921: Migrate to irqdomains
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org> <1387831563-13535-4-git-send-email-sboyd@codeaurora.org> <20140106155350.GI30156@lee--X1>
In-Reply-To: <20140106155350.GI30156@lee--X1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/14 07:53, Lee Jones wrote:
>
>> @@ -56,8 +56,7 @@
>>  struct pm_irq_chip {
>>  	struct device		*dev;
>>  	spinlock_t		pm_irq_lock;
>> -	unsigned int		devirq;
>> -	unsigned int		irq_base;
>> +	struct irq_domain	*domain;
> It's probably best to explicitly specify 'irqdomain' here in order to
> eliminate any possibility of ambiguity.

Ok. Renamed.

>
>>  	unsigned int		num_irqs;
>>  	unsigned int		num_blocks;
>>  	unsigned int		num_masters;
>> @@ -138,7 +137,7 @@ static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
>>  	for (i = 0; i < 8; i++) {
>>  		if (bits & (1 << i)) {
>>  			pmirq = block * 8 + i;
>> -			irq = pmirq + chip->irq_base;
>> +			irq = irq_find_mapping(chip->domain, pmirq);
> Going by this patch only, it appears you're calling irq_find_mapping()
> before you've called irq_create_mapping(). This won't work, so unless
> you've called the latter in a previous patch, you should ensure that
> you do so.
>

Interrupts seem to work. I think that's because the mapping is created
when the consumer drivers call request_irq().

>From what I can tell, if we call irq_find_mapping() and there is no
mapping associated with it then we have a spurious irq. If that happens
we'll call handle_generic_irq() with 0 and that will cause
handle_bad_irq() to be called and a debug message to be logged. That
seems like a good outcome.

>> -	master = block / 8;
> What was the point in this anyway? Was it completely superfluous?

I think it was just copy/paste without thinking if the variables are
actually used.

>
>> +static int pm8xxx_irq_init(struct platform_device *pdev, unsigned int irq)
>> +{
>> +	struct pm_irq_chip  *chip;
>> +	unsigned int nirqs = 256;
> No magic numbers please.

Done.

>
>> +	chip = devm_kzalloc(&pdev->dev, sizeof(*chip) + sizeof(u8) * nirqs,
>> +			    GFP_KERNEL);
> What does the sizeof(u8) add here?
>

This was just keeping the same code that was already there. I will do
sizeof(chip->config[0]) instead which is more future proof if that array
changes type later on.

>
>> +	return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
>> +}
> Can't you use the MFD core instead?
>

Are you suggesting using mfd_add_devices()? At first glance it looks
like that would require an array of mfd_cell structures that do nothing
besides match compatible strings in the DT. Using of_platform_populate()
achieves the same goal and doesn't require an array of mfd_cell
structures for each different pm8xxx chip that comes along, meaning
simpler code.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

