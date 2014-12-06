Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaLFCe6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:34:58 -0500
Received: from smtprelay0036.hostedemail.com ([216.40.44.36]:45000 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751016AbaLFCe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:34:57 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:981:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3873:3874:4250:4321:5007:6261:6742:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13069:13141:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: train94_2aa6dc0ae0654
X-Filterd-Recvd-Size: 3264
Message-ID: <1417833291.31745.5.camel@perches.com>
Subject: Re: [PATCH 2/5] gpio: Cygnus: add GPIO driver
From: Joe Perches <joe@perches.com>
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Date: Fri, 05 Dec 2014 18:34:51 -0800
In-Reply-To: <5482668F.1040907@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
	 <1417826408-1600-1-git-send-email-rjui@broadcom.com>
	 <1417826408-1600-3-git-send-email-rjui@broadcom.com>
	 <1417829282.31745.3.camel@perches.com> <5482668F.1040907@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 18:14 -0800, Ray Jui wrote:
> On 12/5/2014 5:28 PM, Joe Perches wrote:
> > On Fri, 2014-12-05 at 16:40 -0800, Ray Jui wrote:
> >> +static void bcm_cygnus_gpio_irq_handler(unsigned int irq,
> >> +		struct irq_desc *desc)
> >> +{
> >> +	struct bcm_cygnus_gpio *cygnus_gpio;
> >> +	struct irq_chip *chip = irq_desc_get_chip(desc);
> >> +	int i, bit;
> >> +
> >> +	chained_irq_enter(chip, desc);
> >> +
> >> +	cygnus_gpio = irq_get_handler_data(irq);
> >> +
> >> +	/* go through the entire GPIO banks and handle all interrupts */
> >> +	for (i = 0; i < cygnus_gpio->num_banks; i++) {
> >> +		unsigned long val = readl(cygnus_gpio->base +
> >> +				(i * GPIO_BANK_SIZE) +
> >> +				CYGNUS_GPIO_INT_MSTAT_OFFSET);
> >> +		if (val) {
> >
> > This if (val) and indentation isn't really necessary
> >
> 
> Note for_each_set_bit in this case iterates 32 times searching for bits 
> that are set.

No it doesn't.

#define for_each_set_bit(bit, addr, size) \
	for ((bit) = find_first_bit((addr), (size));		\
	     (bit) < (size);					\
	     (bit) = find_next_bit((addr), (size), (bit) + 1))

find_first_bit:

 * Returns the bit number of the first set bit.
 * If no bits are set, returns @size.

>  By having the if (val) check here, it can potentially save 
> some of such processing in the ISR. I agree with you that it introduces 
> one extra indent here but I think it's required.
> 
> >> +			for_each_set_bit(bit, &val, 32) {
> >
> > for_each_set_bit will effectively do the if above.
> >
> > 32 bit only code?
> > otherwise isn't this endian unsafe?
> >
> 
> Will change 'unsigned long val' to 'u32 val'.

All the bit operations only work on long *


