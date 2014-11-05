Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaKEW3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:29:21 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:64850 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaKEW3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:29:18 -0500
Date: Wed, 5 Nov 2014 14:29:13 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>, Josh Wu <Josh.wu@atmel.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Mark Brown <broonie@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Herve Codina <Herve.CODINA@celad.com>, Bo Shen <voice.shen@atmel.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Huang Shijie <shijie8@gmail.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH 2/2] mtd: mxc_nand: use __iowrite32_copy for 32 bit copy
Message-ID: <20141105222913.GX23619@ld-irv-0074>
References: <1413821173-18347-1-git-send-email-vinod.koul@intel.com>
 <1413821173-18347-2-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413821173-18347-2-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 09:36:13PM +0530, Vinod Koul wrote:
> The driver was also using own method to do 32bit copy, turns out
> we have a kernel API so use that instead
> 
> Signed-off-by: Vinod Koul <vinod.koul@intel.com>
> ---
>  drivers/mtd/nand/mxc_nand.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
> index dba262b..3794cd7 100644
> --- a/drivers/mtd/nand/mxc_nand.c
> +++ b/drivers/mtd/nand/mxc_nand.c
> @@ -280,14 +280,10 @@ static void memcpy32_fromio(void *trg, const void __iomem  *src, size_t size)
>  		*t++ = __raw_readl(s++);
>  }
>  
> -static void memcpy32_toio(void __iomem *trg, const void *src, int size)
> +static inline void memcpy32_toio(void __iomem *trg, const void *src, int size)
>  {
> -	int i;
> -	u32 __iomem *t = trg;
> -	const u32 *s = src;
> -
> -	for (i = 0; i < (size >> 2); i++)
> -		__raw_writel(*s++, t++);
> +	/* __iowrite32_copy use 32bit size values so divide by 4 */
> +	__iowrite32_copy(trg, src, size/4);

Fixed up the spacing around the division, and pushed to l2-mtd.git.

>  }
>  
>  static int check_int_v3(struct mxc_nand_host *host)

Brian
