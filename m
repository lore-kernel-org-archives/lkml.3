Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061AbaK0PFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:05:18 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62447 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbaK0PFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:05:16 -0500
Date: Thu, 27 Nov 2014 15:05:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-spi@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/4] spi: Add new driver for STMicroelectronics' SPI
 Controller
Message-ID: <20141127150508.GI4628@x1>
References: <1417088636-11994-1-git-send-email-lee.jones@linaro.org>
 <1417088636-11994-2-git-send-email-lee.jones@linaro.org>
 <20141127125904.GV7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141127125904.GV7712@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]

> > +struct spi_st {
> > +	/* SSC SPI Controller */
> > +	struct spi_bitbang	bitbang;
> 
> Is there a good reason for using bitbang over the core transmit_one()
> interface?  The operations are basically the same but more modern and
> the functionality is more discoverable.

I don't know enough about SPI to answer that question.  I will look
into moving over to transmit_one().  Most of the design decisions in
this driver were taken back when you were probably wearing denim
jackets and supporting an afro. ;) 


> > +	} else if (spi_st->bits_per_word == 8 && !(t->len & 0x1)) {
> > +		/*
> > +		 * If transfer is even-length, and 8 bits-per-word, then
> > +		 * implement as half-length 16 bits-per-word transfer
> > +		 */
> > +		spi_st->bytes_per_word = 2;
> > +		spi_st->words_remaining = t->len/2;
> > +
> > +		/* Set SSC_CTL to 16 bits-per-word */
> > +		ctl = readl_relaxed(spi_st->base + SSC_CTL);
> > +		writel_relaxed((ctl | 0xf), spi_st->base + SSC_CTL);
> > +
> > +		readl_relaxed(spi_st->base + SSC_RBUF);
> 
> No byte swapping issues here?

I think this implementation has been pretty heavily tested.  What
should I be looking out for?

[...]

> > +	printk("LEE: %s: %s()[%d]: Probing\n", __FILE__, __func__, __LINE__);
> 
> Tsk.

School boy error!

> > +	spi_st->clk = of_clk_get_by_name(np, "ssc");
> > +	if (IS_ERR(spi_st->clk)) {
> > +		dev_err(&pdev->dev, "Unable to request clock\n");
> > +		ret = PTR_ERR(spi_st->clk);
> > +		goto free_master;
> > +	}
> 
> Why is this of_get_clk_by_name() and not just devm_clk_get()?

Probably historical and I didn't notice.

I'll look into swapping it over.

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
