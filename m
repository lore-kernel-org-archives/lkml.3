Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaJBHNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:13:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60541 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbaJBHNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:13:20 -0400
Message-ID: <542CFAEB.3040905@ti.com>
Date: Thu, 2 Oct 2014 10:12:43 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>, pekon <pekon@pek-sem.com>,
        Tony Lindgren <tony@atomide.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <michal.vokac@comap.cz>, <sojkam1@fel.cvut.cz>,
        Rostislav Lisovy <lisovy@merica.cz>
Subject: Re: [PATCH 2/2] mtd: nand: omap: Synchronize access to the ECC engine
References: <1412175554-19391-1-git-send-email-lisovy@merica.cz> <1412175554-19391-2-git-send-email-lisovy@merica.cz>
In-Reply-To: <1412175554-19391-2-git-send-email-lisovy@merica.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 05:59 PM, Rostislav Lisovy wrote:
> The AM335x Technical Reference Manual (spruh73j.pdf) says
> "Because the ECC engine includes only one accumulation context,
> it can be allocated to only one chip-select at a time ... "
> (7.1.3.3.12.3). Since the commit 97a288ba2cfa ("ARM: omap2+:
> gpmc-nand: Use dynamic platform_device_alloc()") gpmc-nand
> driver supports multiple NAND flash devices connected to
> the single controller. Use spinlocks to restrict access
> to the ECC engine for single read/write operation at a time.
> 
> Tested with custom AM335x board using 2x NAND flash chips.
> 
> Signed-off-by: Rostislav Lisovy <lisovy@merica.cz>
> ---
>  drivers/mtd/nand/omap2.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
> index 24d5c6a..8761a5b 100644
> --- a/drivers/mtd/nand/omap2.c
> +++ b/drivers/mtd/nand/omap2.c
> @@ -24,6 +24,7 @@
>  #include <linux/slab.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> +#include <linux/spinlock.h>
>  
>  #include <linux/mtd/nand_bch.h>
>  #include <linux/platform_data/elm.h>
> @@ -146,6 +147,7 @@ static u_char bch8_vector[] = {0xf3, 0xdb, 0x14, 0x16, 0x8b, 0xd2, 0xbe, 0xcc,
>  static u_char bch4_vector[] = {0x00, 0x6b, 0x31, 0xdd, 0x41, 0xbc, 0x10};
>  #endif
>  
> +static DEFINE_SPINLOCK(omap_eccengine_lock);
>  
>  struct omap_nand_info {
>  	struct nand_hw_control		controller;
> @@ -1518,6 +1520,7 @@ static int omap_write_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
>  	uint8_t *ecc_calc = chip->buffers->ecccalc;
>  	uint32_t *eccpos = chip->ecc.layout->eccpos;
>  
> +	spin_lock(&omap_eccengine_lock);
>  	/* Enable GPMC ecc engine */
>  	chip->ecc.hwctl(mtd, NAND_ECC_WRITE);
>  
> @@ -1526,6 +1529,7 @@ static int omap_write_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
>  
>  	/* Update ecc vector from GPMC result registers */
>  	chip->ecc.calculate(mtd, buf, &ecc_calc[0]);
> +	spin_unlock(&omap_eccengine_lock);
>  
>  	for (i = 0; i < chip->ecc.total; i++)
>  		chip->oob_poi[eccpos[i]] = ecc_calc[i];
> @@ -1561,6 +1565,7 @@ static int omap_read_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
>  	int stat;
>  	unsigned int max_bitflips = 0;
>  
> +	spin_lock(&omap_eccengine_lock);
>  	/* Enable GPMC ecc engine */
>  	chip->ecc.hwctl(mtd, NAND_ECC_READ);
>  
> @@ -1573,6 +1578,7 @@ static int omap_read_page_bch(struct mtd_info *mtd, struct nand_chip *chip,
>  
>  	/* Calculate ecc bytes */
>  	chip->ecc.calculate(mtd, buf, ecc_calc);
> +	spin_unlock(&omap_eccengine_lock);
>  
>  	memcpy(ecc_code, &chip->oob_poi[eccpos[0]], chip->ecc.total);
>  
> 
The access to the BCH/ELM engine is still not serialized for ecc->read_subpage and ecc->write_subpage() in case of
OMAP_ECC_BCH4_CODE_HW
OMAP_ECC_BCH8_CODE_HW
OMAP_ECC_BCH16_CODE_HW

What about serializing access to BCH engine for read/write_page() and read/write_subpage() in case of
OMAP_ECC_BCH4_CODE_HW_DETECTION_SW
OMAP_ECC_BCH8_CODE_HW_DETECTION_SW

and finally we should also serialize access to ECC engine for read/write_page() and read/write_subpage() in case of
OMAP_ECC_HAM1_CODE_HW

cheers,
-roger
