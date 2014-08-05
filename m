Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaHEOXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:23:35 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:43830 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaHEOXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:23:34 -0400
Date: Tue, 5 Aug 2014 15:23:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140805142324.GA10136@lee--X1>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EAFAFF1@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jul 2014, Gupta, Pekon wrote:
> >From: Brian Norris [mailto:computersforpeace@gmail.com]
> >On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:

[...]

> >> +/*
> >> + * NANDi Interrupts (shared by Hamming and BCH controllers)
> >> + */
> >> +static irqreturn_t nandi_irq_handler(int irq, void *dev)
> >> +{
> >> +	struct nandi_controller *nandi = dev;
> >> +	unsigned int status;
> >> +
> >> +	status = readl(nandi->base + NANDBCH_INT_STA);
> >> +
> >> +	if (status & NANDBCH_INT_SEQNODESOVER) {
> >> +		/* BCH */
> >> +		writel(NANDBCH_INT_CLR_SEQNODESOVER,
> >> +		       nandi->base + NANDBCH_INT_CLR);
> >> +		complete(&nandi->seq_completed);
> >> +	}
> >> +	if (status & NAND_INT_RBN) {
> >> +		/* Hamming */
> >> +		writel(NAND_INT_CLR_RBN, nandi->base + NANDHAM_INT_CLR);
> >> +		complete(&nandi->rbn_completed);
> >> +	}
> >> +
> >> +	return IRQ_HANDLED;
> 
> Did you miss following comments ?
> [RFC 05/47] mtd: nand: stm_nand_bch: IRQ support for ST's BCH NAND Controller driver
> http://lists.infradead.org/pipermail/linux-mtd/2014-March/052916.html
> 
> Shouldn't IRQ_NONE be returned if no valid irq_status was found ?

I don't recall seeing these comments, so yes, I think they were
missed.  Will fix.

> >> +/*
> >> + * BCH Operations
> >> + */
> >> +static inline void bch_load_prog_cpu(struct nandi_controller *nandi,
> >> +				     struct bch_prog *prog)
> >> +{
> >> +	uint32_t *src = (uint32_t *)prog;
> >> +	uint32_t *dst = (uint32_t *)(nandi->base + NANDBCH_ADDRESS_REG_1);
> >> +	int i;
> >> +
> >> +	for (i = 0; i < 16; i++) {
> >> +		/* Skip registers marked as "reserved" */
> >> +		if (i != 11 && i != 14)
> 
> Using macros for 11, 14, and 16 would make it more readable.

I think with the comment there, it's perfectly clear what's happening.

> >> +			writel(*src, dst);
> >> +		dst++;
> >> +		src++;
> >> +	}
> >> +}
> >> +
> >> +static void bch_wait_seq(struct nandi_controller *nandi)
> >> +{
> >> +	int ret;
> >> +
> >> +	ret = wait_for_completion_timeout(&nandi->seq_completed, HZ/2);
> 
> Are you sure you want to use same timeout value for all operations
> like ERASE, READ, WRITE ? because
> (1) There is wide variance between:
> - BLOCK_ERASE:  max(tBER) = 10ms) for MT29F4G08 Micron NAND
> - PAGE_ERASE: max(tPROG) = 600usec for same Micron part.
> 
> (2) The value of HZ varies across kernel versions and hardware platforms.
> 
> I suggest you pass the timeout value in call to bch_wait_seq().
> And this timeout value should be like 2x of typical value of which you found
> during ONFI parsing, or from DT

How do you obtain these timings?  I don't see tBER or tPROG being used
anywhere in MTD.

[...]

> >> +{
> >> +	uint8_t *b = data;
> >> +	int zeros = 0;
> >> +	int i;
> >> +
> >> +	for (i = 0; i < page_size; i++) {
> >> +		zeros += hweight8(~*b++);
> Are you sure you want to use hweight8 ?
> hweight32 or something should give better performance, plz check.
> because this piece of code (check_xx_bitflips) sometimes becomes
> bottle neck for READ path.

I'm not sure, no.  If I change it, how will I know if it's still doing
the correct thing or otherwise?

[...]

> >> +	/* Load last page of block */
> >> +	offs = (loff_t)block << chip->phys_erase_shift;
> >> +	offs += mtd->erasesize - mtd->writesize;
> >> +	if (bch_read_page(nandi, offs, buf) < 0) {
> 
> *Important*: You shouldn't call internal functions directly here..
> Instead use chip->_read() OR mtd-read() that will:
> - keep this code independent of ECC modes added in your driver in future.
> - implicitly handle updating mtd->ecc_stat (like ecc_failed, bits_corrected).
> - implicitly take care of address alignments checks and offset calculations.
> 
> <Same applies to other places where you have directly used bch_read_page())

Yourself and Brian seem to disagree on this point.  Which is correct?

> >> +	/* Is block already considered bad? (will also catch invalid offsets) */
> >> +	ret = mtd_block_isbad(mtd, offs);
> >
> >You're violating some of the layering here; the low-level driver
> >probably shouldn't be calling the high-level mtd_*() APIs. On a similar
> >note, I'm not 100% confident that the nand_base/nand_bbt separation is
> >written cleanly enough for easy maintenance of your nand_base + ST BBT
> >code in parallel. I might need a second look at that, and I think
> >modularizing your BBT code to a separate file could help ease this a
> >little.

... here is the converse argument.

[...]

> >Are you actually looking for driver data, not platform data? (e.g.,
> >dev_set_drvdata() / platform_get_drvdata()) The two are a little
> >different, but your usage sounds like this more of a driver-private
> >description.

On closer inspection it appears that drvdata was already in use.  I've
not encompassed the NANDi information and the old pdata into one ddata
container.

[...]

> Sorry, this review got delayed from my part..
> But I hope I have covered most of the review in this and earlier responses.
> if you are able to clean most of these then should be ready for 3.17+.

It's a bit late for v3.17 now, but let's see what we can do about
getting it in for v3.18.  Fingers crossed!

> Please re-send the next version in similar squashed format, as its easy for review.
> And once Brian is okay, may be then you can re-send individual patches.

Right.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
