Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaJFFHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 01:07:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45002 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaJFFHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 01:07:34 -0400
Date: Sun, 5 Oct 2014 22:07:31 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH 7/9] mtd: nand: stm_nand_bch: adding BBT header
Message-ID: <20141006050731.GG3248@norris-Latitude-E6410>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
 <1409143344-22458-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409143344-22458-8-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, Aug 27, 2014 at 01:42:22PM +0100, Lee Jones wrote:
> This header will be used firstly by the BCH main driver, then the
> Bad Block Table (BBT) code which will be added immediately after.
> Doing it this way provides the cleanest method of keeping the
> patch-set bisectable.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  include/linux/mtd/stm_nand_bbt.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 include/linux/mtd/stm_nand_bbt.h
> 
> diff --git a/include/linux/mtd/stm_nand_bbt.h b/include/linux/mtd/stm_nand_bbt.h
> new file mode 100644
> index 0000000..bcb33b2
> --- /dev/null
> +++ b/include/linux/mtd/stm_nand_bbt.h
> @@ -0,0 +1,17 @@
> +#include <linux/mtd/stm_nand.h>
> +
> +/* BCH ECC sizes */
> +static int bch_ecc_sizes[] = {
> +	[BCH_18BIT_ECC] = 32,
> +	[BCH_30BIT_ECC] = 54,
> +	[BCH_NO_ECC] = 0,
> +};
> +
> +#if defined(CONFIG_MTD_NAND_STM_BCH_BBT)
> +extern void nandi_dump_bad_blocks(struct nandi_controller *nandi);
> +extern int bch_scan_bbt(struct mtd_info *mtd);
> +extern int bch_block_isbad(struct mtd_info *mtd, loff_t offs, int getchip);
> +extern int bch_block_markbad(struct mtd_info *mtd, loff_t offs);
> +#else
> +inline void nandi_dump_bad_blocks(struct nandi_controller *nandi) {}

This line induces the following failure when everything is built as a
module:

  drivers/mtd/nand/stm_nand_bbt.c:579:6: error: redefinition of 'nandi_dump_bad_blocks'
  include/linux/mtd/stm_nand_bbt.h:16:84: note: previous definition of 'nandi_dump_bad_blocks' was here

This highlights the fact that:
(1) This should be 'static inline', not just 'inline'
(2) Your code is not modularized properly. You can't build
    stm_nand_bbt.o and stm_nand_bch.o as kernel modules properly, since
    #if defined() isn't true when CONFIG_MTD_NAND_STM_BCH_BBT=m
(3) You're building 3 separate modules for your STM NAND code, where 2
    might suffice (one for NAND support and one for BBT).

Ezequiel has been running through some of the same build problems with
the OMAP NAND + ELM (ECC) driver recently. You might check the recent
MTD archives for this. Or you might just restrict your driver to being
built-in (non-module) if you can't fix this for now.

> +#endif

Brian
