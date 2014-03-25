Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaCYMxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:53:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47182 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752600AbaCYMxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:53:50 -0400
Date: Tue, 25 Mar 2014 09:53:29 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, computersforpeace@gmail.com, dwmw2@infradead.org
Subject: Re: [RFC 35/47] mtd: nand: stm_nand_bch: dump bad blocks
Message-ID: <20140325125329.GC665@arch.cereza>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-36-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395735604-26706-36-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 25, Lee Jones wrote:
> Inform the user of any known bad blocks during initialisation.
> Conversely, if there aren't any known bad blocks, let the user know
> the good news.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/nand/stm_nand_bch.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
> index 6698b1f..abbb4d9 100644
> --- a/drivers/mtd/nand/stm_nand_bch.c
> +++ b/drivers/mtd/nand/stm_nand_bch.c
> @@ -1060,6 +1060,28 @@ static int bch_load_bbt(struct nandi_controller *nandi,
>  	return 0;
>  }
>  
> +static void nandi_dump_bad_blocks(struct nandi_controller *nandi)
> +{
> +	int bad_count = 0;
> +	uint32_t block;
> +	uint8_t *bbt = nandi->info.bbt_info.bbt;
> +	uint8_t mark;
> +
> +	pr_info("BBT:\n");
> +	for (block = 0; block < nandi->blocks_per_device; block++) {
> +		mark = bbt_get_block_mark(bbt, block);
> +		if (mark != BBT_MARK_GOOD) {
> +			pr_info("\t\tBlock 0x%08x [%05u] marked bad [%s]\n",
> +				block << nandi->block_shift, block,
> +				(mark == BBT_MARK_BAD_FACTORY) ?
> +				"Factory" : "Wear");
> +			bad_count++;
> +		}
> +	}
> +	if (bad_count == 0)
> +		pr_info("\t\tNo bad blocks listed in BBT\n");
> +}
> +
>  /*
>   * Initialisation
>   */
> @@ -1849,6 +1871,8 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
>  			return err;
>  	}
>  
> +	nandi_dump_bad_blocks(nandi);
> +

Hm... this looks suspicious. Are you sure you need this?

The NAND BBT code prints the bad blocks at initialization-time. If that's
not the case for you, perhaps we should be fixing that in the BBT code,
rather than at a driver's level.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
