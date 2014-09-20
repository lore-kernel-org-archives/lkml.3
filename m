Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaITEqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 00:46:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45142 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaITEqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 00:46:16 -0400
Date: Fri, 19 Sep 2014 21:46:07 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mtd: nand: support ONFI timings mode retrieval for
 non-ONFI NANDs
Message-ID: <20140920044607.GE8127@brian-ubuntu>
References: <1406539012-16320-1-git-send-email-boris.brezillon@free-electrons.com>
 <1406539012-16320-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406539012-16320-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since you were asking about this series, I have a comment:

On Mon, Jul 28, 2014 at 11:16:51AM +0200, Boris BREZILLON wrote:
> Add an onfi_timing_mode_ds field to nand_chip and nand_flash_dev in order
> to support NAND timings definition for non-ONFI NAND.
> 
> NAND that support better timings mode than the default one (timings mode 0)
> have to define a new entry in the nand_ids table.
> 
> The timings mode should be deduced from timings description from the
> datasheet and the ONFI specification
> (www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf, chapter 4.15
> "Timing Parameters").
> You should choose the closest mode that fit the timings requirements of
> your NAND chip.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/mtd/nand/nand_base.c | 1 +
>  include/linux/mtd/nand.h     | 7 +++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index d8cdf06..c952c21 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -3576,6 +3576,7 @@ static bool find_full_id_nand(struct mtd_info *mtd, struct nand_chip *chip,
>  		chip->options |= type->options;
>  		chip->ecc_strength_ds = NAND_ECC_STRENGTH(type);
>  		chip->ecc_step_ds = NAND_ECC_STEP(type);
> +		chip->onfi_timing_mode_ds = type->onfi_timing_mode_ds;
>  
>  		*busw = type->options & NAND_BUSWIDTH_16;
>  
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index 3083c53..435c005 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -587,6 +587,7 @@ struct nand_buffers {
>   * @ecc_step_ds:	[INTERN] ECC step required by the @ecc_strength_ds,
>   *                      also from the datasheet. It is the recommended ECC step
>   *			size, if known; if unknown, set to zero.
> + * @onfi_timing_mode_ds:[INTERN] ONFI timing mode deduced from datasheet.

Might want at least one space between '[INTERN]' and 'ONFI'?

>   * @numchips:		[INTERN] number of physical chips
>   * @chipsize:		[INTERN] the size of one chip for multichip arrays
>   * @pagemask:		[INTERN] page number mask = number of (pages / chip) - 1
> @@ -671,6 +672,7 @@ struct nand_chip {
>  	uint8_t bits_per_cell;
>  	uint16_t ecc_strength_ds;
>  	uint16_t ecc_step_ds;
> +	int onfi_timing_mode_ds;

I'm not sure if we'll just want a field specific to non-ONFI chips,
faking an ONFI timing mode; can we make this into a more generally
useful field, that represents something consistent across all NAND
types? I was thinking a "highest mode supported", but that actually
isn't great, since for true ONFI modes (except mode 0) require a SET
FEATURES command to change to a higher mode.

Maybe just something like onfi_timing_mode_default, which we could then
use as mode 0 for ONFI chips.

Ideally, we could centralize as much of this as possible, so that a NAND
driver only has to know the mechanics of "how do I translate an ONFI
mode to a timing configuration for my NAND controller," instead of any
details of how to choose from one of many supported ONFI modes. i.e., it
could implement something like the following hook:

	int (*set_timing_mode)(struct nand_sdr_timings *timing);

But anyway, that's out of the scope of this series, and it may be harder
than I make it sound. I just wanted to throw that out there.

>  	int badblockpos;
>  	int badblockbits;
>  
> @@ -772,6 +774,10 @@ struct nand_chip {
>   *               @ecc_step_ds in nand_chip{}, also from the datasheet.
>   *               For example, the "4bit ECC for each 512Byte" can be set with
>   *               NAND_ECC_INFO(4, 512).
> + * @onfi_timing_mode_ds: the ONFI timing mode supported by this NAND chip. This
> + *                       should be deduced from timings described in the
> + *                       datasheet.
> + *
>   */
>  struct nand_flash_dev {
>  	char *name;
> @@ -792,6 +798,7 @@ struct nand_flash_dev {
>  		uint16_t strength_ds;
>  		uint16_t step_ds;
>  	} ecc;
> +	int onfi_timing_mode_ds;
>  };
>  
>  /**

Brian
