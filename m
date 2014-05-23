Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaEWKq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:46:58 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58108 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaEWKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:46:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 3/3] crypto: Add Allwinner Security System crypto accelerator
Date: Fri, 23 May 2014 12:46:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <7774492.yVryDeoI4M@wuerfel> <537E3E2F.7000407@gmail.com>
In-Reply-To: <537E3E2F.7000407@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201405231246.10365.arnd@arndb.de>
X-Provags-ID: V02:K0:s5LIW40EOCfi4NxntD9HFlcqyLC5DDaq5Ki1CJYSd2z
 31dSK7Kj6MlfeFrqQo6Ln00O3Y29k1VPgadV/BfGgB+jROwof/
 q/S3P9R5bGBJuxfc+40zCOmoUjWLHLG3j6gGcwotZm/DWZevnl
 J8L5gQg27u+U/06kMOFawF7MarwD21qnMbn11EEh9oy/SVTYU3
 Tjg2DbYxFLrJwiCRiBAuD39jFfirj7AEUZGdcx4ONmK+IUsQgj
 193JgBEBTsiMFfmqGAA/BcFu6rVklNHZv3L273+0vQEXHtCBC/
 OJ+Hlxbwj62ruv7kIROIois+J3vdRqGZCKfFNYyOnK669L563F
 TxmSKwLIWP6B2rpkT3co=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014, Corentin LABBE wrote:
> Le 22/05/2014 17:28, Arnd Bergmann a écrit :
> > On Thursday 22 May 2014 17:09:56 LABBE Corentin wrote:
> >> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > 
> > My feeling is that this should either be one driver that provides
> > all five algorithms unconditionally, or five drivers that are each
> > separate loadable modules and based on top of a common module
> > that only exports functions but has no active logic itself
> 
> I agree for the split.
> It was my first intention but I feared to add too many files.
> So I propose to split in 6, sunxi-ss-hash.c, sunxi-ss-des.c, sunxi-ss-aes.c, sunxi-ss-rng.c, sunxi-ss-common.c and sunxi-ss.h
> Does can I add a sunxi-ss directory in drivers/crypto ?

Yes, I think a subdirectory would be best.


> >> +	/* If we have more than one SG, we cannot use kmap_atomic since
> >> +	 * we hold the mapping too long*/
> >> +	src_addr = kmap(sg_page(in_sg)) + in_sg->offset;
> >> +	if (src_addr == NULL) {
> >> +		dev_err(ss_ctx->dev, "KMAP error for src SG\n");
> >> +		return -1;
> >> +	}
> >> +	dst_addr = kmap(sg_page(out_sg)) + out_sg->offset;
> >> +	if (dst_addr == NULL) {
> >> +		kunmap(src_addr);
> >> +		dev_err(ss_ctx->dev, "KMAP error for dst SG\n");
> >> +		return -1;
> >> +	}
> >> +	src32 = (u32 *)src_addr;
> >> +	dst32 = (u32 *)dst_addr;
> >> +	ileft = nbytes / 4;
> >> +	oleft = nbytes / 4;
> >> +	sgileft = in_sg->length / 4;
> >> +	sgoleft = out_sg->length / 4;
> >> +	do {
> >> +		tmp = readl_relaxed(ss_ctx->base + SUNXI_SS_FCSR);
> >> +		rx_cnt = SS_RXFIFO_SPACES(tmp);
> >> +		tx_cnt = SS_TXFIFO_SPACES(tmp);
> >> +		todo = min3(rx_cnt, ileft, sgileft);
> >> +		if (todo > 0) {
> >> +			ileft -= todo;
> >> +			sgileft -= todo;
> >> +		}
> >> +		while (todo > 0) {
> >> +			writel_relaxed(*src32++, ss_ctx->base + SS_RXFIFO);
> >> +			todo--;
> >> +		}
> > 
> > I wonder if this is meant to be used in combination with a dma engine
> > rather than accessed with writel/readl.
> 
> You could do both, but the dmaengine driver is under development.
> When it will be ready, I will add DMA support.
> But my intention is to keep both mode, since poll mode is better than DMA for small request.

Ok, I see.

> > How does the original driver do it?
> 
> There are no original driver, this driver is the first for the Security System.

Ah, I thought there was one in the allwinner BSP kernel.

	Arnd
