Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaJBMwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:52:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36093 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaJBMwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:52:05 -0400
Message-ID: <542D4A51.9060907@ti.com>
Date: Thu, 2 Oct 2014 15:51:29 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <michal.vokac@comap.cz>, <sojkam1@fel.cvut.cz>,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH v2 2/2] mtd: nand: omap: Synchronize access to the ECC
 engine
References: <1412252173-20454-1-git-send-email-lisovy@merica.cz> <1412252173-20454-2-git-send-email-lisovy@merica.cz>
In-Reply-To: <1412252173-20454-2-git-send-email-lisovy@merica.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 03:16 PM, Rostislav Lisovy wrote:
> The AM335x Technical Reference Manual (spruh73j.pdf) says
> "Because the ECC engine includes only one accumulation context,
> it can be allocated to only one chip-select at a time ... "
> (7.1.3.3.12.3). Since the commit 97a288ba2cfa ("ARM: omap2+:
> gpmc-nand: Use dynamic platform_device_alloc()") gpmc-nand
> driver supports multiple NAND flash devices connected to
> the single controller. Use mutexes to restrict access
> to the ECC engine for single read/write operation at a time.
> 
> Tested with custom AM335x board using 2x NAND flash chips.
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> ---
> Changes since v1:
> * Since not all the read/write operations are performed by the
>   omap_read(write)_page_bch() functions use the locks directly on
>   those places that configure the ECC engine (take the lock) and
>   read the result from the ECC engine (release the lock).
>   This approach should cover read/write operations with all
>   possible ECC modes. (Roger Quadros)
> 

Don't you think this approach is racy?

IMHO the lock must be held across the entire page operation
i.e.
hold ecc lock
ecc.hwctl
chip->read/write_buf
ecc.calculate
ecc.correct
release ecc lock

else we risk simultaneous NAND operations on multiple chips
stomping on each other in between the entire sequence.

Then on further investigation isn't nand_get_device() already doing the same
thing as you are attempting here?

The chip->controller->lock is meant for serializing NAND controller access.

so instead of adding a new lock in the omap2 nand driver we need to ensure that
we are maintaining the same nand_hw_control (controller) structure across multiple NAND chips.

Let's move this controller structure out of omap_nand_info and keep it global to the driver
and make sure every NAND instance uses it.

cheers,
-roger

> 
>  drivers/mtd/nand/omap2.c | 28 +++++++++++++++++++++++++---
>  1 file changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index f0dcdb6..898cb44 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/mutex.h>
>  
>  #include <linux/mtd/nand_bch.h>
>  #include <linux/platform_data/elm.h>
> @@ -144,6 +145,12 @@ static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
>  	0xac, 0x6b, 0xff, 0x99, 0x7b};
>  static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
>  
> +/*
> + * Because the ECC engine includes only one accumulation context,
> + * it can be allocated to only one chip-select at a time
> + */
> +static DEFINE_MUTEX(omap_eccengine_lock);
> +
>  struct omap_nand_info {
>  	struct nand_hw_control		controller;
>  	struct omap_nand_platform_data	*pdata;
> @@ -926,10 +933,13 @@ static int omap_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
>  	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
>  							mtd);
>  	u32 val;
> +	int ret = 0;
>  
>  	val = readl(info->reg.gpmc_ecc_config);
> -	if (((val >> ECC_CONFIG_CS_SHIFT) & CS_MASK) != info->gpmc_cs)
> -		return -EINVAL;
> +	if (((val >> ECC_CONFIG_CS_SHIFT) & CS_MASK) != info->gpmc_cs) {
> +		ret = -EINVAL;
> +		goto leave;
> +	}
>  
>  	/* read ecc result */
>  	val = readl(info->reg.gpmc_ecc1_result);
> @@ -938,7 +948,10 @@ static int omap_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
>  	/* P2048o, P1024o, P512o, P256o, P2048e, P1024e, P512e, P256e */
>  	*ecc_code++ = ((val >> 8) & 0x0f) | ((val >> 20) & 0xf0);
>  
> -	return 0;
> +leave:
> +	/* Release the ECC engine */
> +	mutex_unlock(&omap_eccengine_lock);
> +	return ret;
>  }
>  
>  /**
> @@ -954,6 +967,9 @@ static void omap_enable_hwecc(struct mtd_info *mtd, int mode)
>  	unsigned int dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
>  	u32 val;
>  
> +	/* ECC Engine is shared among multiple NAND devices */
> +	mutex_lock(&omap_eccengine_lock);
> +
>  	/* clear ecc and enable bits */
>  	val = ECCCLEAR | ECC1;
>  	writel(val, info->reg.gpmc_ecc_control);
> @@ -1132,6 +1148,9 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
>  		return;
>  	}
>  
> +	/* ECC Engine is shared among multiple NAND devices */
> +	mutex_lock(&omap_eccengine_lock);
> +
>  	writel(ECC1, info->reg.gpmc_ecc_control);
>  
>  	/* Configure ecc size for BCH */
> @@ -1252,6 +1271,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
>  			ecc_code[25] = ((val >>  0) & 0xFF);
>  			break;
>  		default:
> +			mutex_unlock(&omap_eccengine_lock);
>  			return -EINVAL;
>  		}
>  
> @@ -1280,12 +1300,14 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
>  		case OMAP_ECC_BCH16_CODE_HW:
>  			break;
>  		default:
> +			mutex_unlock(&omap_eccengine_lock);
>  			return -EINVAL;
>  		}
>  
>  	ecc_calc += eccbytes;
>  	}
>  
> +	mutex_unlock(&omap_eccengine_lock);
>  	return 0;
>  }
>  
> 

