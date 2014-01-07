Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaAGIWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 03:22:42 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38047 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaAGIWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 03:22:40 -0500
Date: Tue, 7 Jan 2014 08:22:33 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/7] mfd: pm8921: Migrate to irqdomains
Message-ID: <20140107082233.GB3182@lee--X1>
References: <1387831563-13535-1-git-send-email-sboyd@codeaurora.org>
 <1387831563-13535-4-git-send-email-sboyd@codeaurora.org>
 <20140106155350.GI30156@lee--X1>
 <52CB1323.6080200@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52CB1323.6080200@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>  	unsigned int		num_irqs;
> >>  	unsigned int		num_blocks;
> >>  	unsigned int		num_masters;
> >> @@ -138,7 +137,7 @@ static int pm8xxx_irq_block_handler(struct pm_irq_chip *chip, int block)
> >>  	for (i = 0; i < 8; i++) {
> >>  		if (bits & (1 << i)) {
> >>  			pmirq = block * 8 + i;
> >> -			irq = pmirq + chip->irq_base;
> >> +			irq = irq_find_mapping(chip->domain, pmirq);
> > Going by this patch only, it appears you're calling irq_find_mapping()
> > before you've called irq_create_mapping(). This won't work, so unless
> > you've called the latter in a previous patch, you should ensure that
> > you do so.
> >
> 
> Interrupts seem to work. I think that's because the mapping is created
> when the consumer drivers call request_irq().
> 
> From what I can tell, if we call irq_find_mapping() and there is no
> mapping associated with it then we have a spurious irq. If that happens
> we'll call handle_generic_irq() with 0 and that will cause
> handle_bad_irq() to be called and a debug message to be logged. That
> seems like a good outcome.

I would try to adhere to the documentation in case we are missing
something or some of the semantics change. Please read:
Documentation/IRQ-domain.txt. Specifically, "=== irq_domain usage ==="
from line 39, which says to call irq_create_mapping() to indeed, create
the mapping.

> > What does the sizeof(u8) add here?
> >
> 
> This was just keeping the same code that was already there. I will do
> sizeof(chip->config[0]) instead which is more future proof if that array
> changes type later on.

Ah, now I see what it's doing. Perhaps brackets would be of use to
ensure readers aren't confused. I also think the sizeof() would be
helpful too, so:

        chip = devm_kzalloc(&pdev->dev, sizeof(*chip) +
                            (sizeof(chip->config[0]) * nirqs), GFP_KERNEL);

> >> +	return of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> >> +}
> > Can't you use the MFD core instead?
> >
> 
> Are you suggesting using mfd_add_devices()? At first glance it looks
> like that would require an array of mfd_cell structures that do nothing
> besides match compatible strings in the DT. Using of_platform_populate()
> achieves the same goal and doesn't require an array of mfd_cell
> structures for each different pm8xxx chip that comes along, meaning
> simpler code.

I'm inclined to agree, but playing Devil's advocate here, as a device
using the MFD subsystem it's often clearer to readers and other people
looking for examples if the MFD core functionality is used. For
instance, I now have no idea what devices the PM8xxx encompasses
without looking at the DTS file. A small cell structure is a small
price to pay for code clarity IMHO.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
