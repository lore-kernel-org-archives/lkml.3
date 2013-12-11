Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab3LKCTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:19:41 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63796 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3LKCTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:19:40 -0500
Date: Tue, 10 Dec 2013 18:19:36 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 30/36] mtd: st_spi_fsm: Erase partly or as a whole a
 Serial Flash device
Message-ID: <20131211021936.GN27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-31-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-31-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:19:19PM +0000, Lee Jones wrote:
> When an erase is requested by userspace the MFD framework calls back

s/MFD/MTD/

;)

> into the driver to conduct the actual command issue. Here we provide the
> routines which do exactly that. We can choose to either do an entire chip
> erase or by sector.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/devices/st_spi_fsm.c | 118 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 117 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index 9b35e15..ecb001d 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -861,6 +923,60 @@ out1:
>  	return ret;
>  }
>  
> +/*
> + * Erase an address range on the flash chip. The address range may extend
> + * one or more erase sectors.  Return an error is there is a problem erasing.
> + */
> +static int stfsm_mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
> +{
> +	struct stfsm *fsm = dev_get_drvdata(mtd->dev.parent);
> +	u32 addr, len;
> +	int ret;
> +
> +	dev_dbg(fsm->dev, "%s at 0x%llx, len %lld\n", __func__,
> +		(long long)instr->addr, (long long)instr->len);
> +
> +	if (instr->addr + instr->len > mtd->size)
> +		return -EINVAL;

Duplicated from mtd_read(). Kill this.

> +
> +	if (instr->len & (mtd->erasesize - 1))
> +		return -EINVAL;

...

> @@ -1131,7 +1247,7 @@ static int stfsm_probe(struct platform_device *pdev)
>  
>  	fsm->mtd._read  = stfsm_mtd_read;
>  	fsm->mtd._write = stfsm_mtd_write;
> -
> +	fsm->mtd._erase = stfsm_mtd_erase;

Can you leave the blank line between assigning fsm->mtd.xxx callbacks
and the dev_err()?

>  	dev_err(&pdev->dev,
>  		"Found serial flash device: %s\n"
>  		" size = %llx (%lldMiB) erasesize = 0x%08x (%uKiB)\n",

(BTW, why is this dev_err()?? It's just information, so you want
dev_info().)

Brian
