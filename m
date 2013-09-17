Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3IQCLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 22:11:12 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:42197
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437Ab3IQCLL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 22:11:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(zzc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz8dhz1de098h1de097h8275bhz2dh2a8h839h941hd25he5bhf0ah1269h1288h12a5h12a9h12bdh12e1h1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
Message-ID: <5237BAA9.6000606@freescale.com>
Date: Tue, 17 Sep 2013 10:12:57 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: nand: fix memory leak in ONFI extended parameter
 page
References: <1379381512-2007-1-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1379381512-2007-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年09月17日 09:31, Brian Norris 写道:
> This fixes a memory leak in the ONFI support code for detecting the
> required ECC levels from this commit:
>
>   commit 6dcbe0cdd83fb5f77be4f44c9e06c535281c375a
>   Author: Huang Shijie <b32955@freescale.com>
>   Date:   Wed May 22 10:28:27 2013 +0800
>
>       mtd: get the ECC info from the Extended Parameter Page
>
> In the success case, we never freed the 'ep' buffer.
>
> Also, this fixes an oversight in the same commit where we (harmlessly)
> freed the NULL pointer.
>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> Cc: Huang Shijie <b32955@freescale.com>
> ---
> David, if there are no objections, can you send this to Linus for 3.12?
>
> If this doesn't make it into 3.12, then it will be -stable material.
>
>  drivers/mtd/nand/nand_base.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index d4578a1..00022b4 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -2869,10 +2869,8 @@ static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
>  
>  	len = le16_to_cpu(p->ext_param_page_length) * 16;
>  	ep = kmalloc(len, GFP_KERNEL);
> -	if (!ep) {
> -		ret = -ENOMEM;
> -		goto ext_out;
> -	}
> +	if (!ep)
> +		return -ENOMEM;
>  
>  	/* Send our own NAND_CMD_PARAM. */
>  	chip->cmdfunc(mtd, NAND_CMD_PARAM, 0, -1);
> @@ -2920,7 +2918,7 @@ static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
>  	}
>  
>  	pr_info("ONFI extended param page detected.\n");
> -	return 0;
> +	ret = 0;
>  
>  ext_out:
>  	kfree(ep);
good catch!

Acked-by: Huang Shijie <b32955@freescale.com>

