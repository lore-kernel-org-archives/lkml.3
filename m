Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaJTM3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:29:23 -0400
Received: from down.free-electrons.com ([37.187.137.238]:49291 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751273AbaJTM3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:29:20 -0400
Date: Mon, 20 Oct 2014 14:29:15 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Yassin Jaffer <yassinjaffer@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v6 1/2] mtd: nand: add sunxi NAND flash controller
 support
Message-ID: <20141020142915.5bebeb2c@bbrezillon>
In-Reply-To: <5444F9AF.5000104@gmail.com>
References: <1413805520-14947-1-git-send-email-boris.brezillon@free-electrons.com>
	<1413805520-14947-2-git-send-email-boris.brezillon@free-electrons.com>
	<5444F9AF.5000104@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Varka,

On Mon, 20 Oct 2014 17:31:51 +0530
Varka Bhadram <varkabhadram@gmail.com> wrote:

> On 10/20/2014 05:15 PM, Boris Brezillon wrote:
> > Add support for the sunxi NAND Flash Controller (NFC).
> >
> (...)
> 
> > +
> > +static int sunxi_nfc_dev_ready(struct mtd_info *mtd)
> > +{
> > +	struct nand_chip *nand = mtd->priv;
> > +	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
> > +	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
> > +	struct sunxi_nand_rb *rb;
> > +	unsigned long timeo = (sunxi_nand->nand.state == FL_ERASING ? 400 : 20);
> > +	int ret;
> > +
> > +	if (sunxi_nand->selected < 0)
> > +		return 0;
> > +
> > +	rb = &sunxi_nand->sels[sunxi_nand->selected].rb;
> > +
> > +	switch (rb->type) {
> > +	case RB_NATIVE:
> > +		ret = !!(readl(nfc->regs + NFC_REG_ST) &
> > +			 (NFC_RB_STATE0 << rb->info.nativeid));
> > +		if (ret)
> > +			break;
> > +
> > +		sunxi_nfc_wait_int(nfc, NFC_RB_B2R, timeo);
> > +		ret = !!(readl(nfc->regs + NFC_REG_ST) &
> > +			 (NFC_RB_STATE0 << rb->info.nativeid));
> > +		break;
> > +	case RB_GPIO:
> > +		ret = gpio_get_value(rb->info.gpio);
> > +		break;
> > +	case RB_NONE:
> > +	default:
> > +		ret = 0;
> > +		pr_err("cannot check R/B NAND status!");
> 
> Missed terminating  new line...  :-)

I'll fix that.

> 
> > +		break;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +
> 
> (...)
> 
> > +static struct platform_driver sunxi_nfc_driver = {
> > +	.driver = {
> > +		.name = "sunxi_nand",
> > +		.owner = THIS_MODULE,
> 
> This field updated by module_platform_driver()..

Yep, I'll remove this line.

Thanks for your review.

Best Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
