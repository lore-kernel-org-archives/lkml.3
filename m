Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3EQRgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 13:36:52 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:40477 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab3EQRgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 13:36:51 -0400
Message-ID: <51966AA7.7050007@gmail.com>
Date: Fri, 17 May 2013 23:06:39 +0530
From: Vikram Narayanan <vikram186@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Huang Shijie <b32955@freescale.com>
CC: dwmw2@infradead.org, dedekind1@gmail.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 05/10] mtd: get the ECC info from the Extended Parameter
 Page
References: <1368760654-28754-1-git-send-email-b32955@freescale.com> <1368760654-28754-6-git-send-email-b32955@freescale.com>
In-Reply-To: <1368760654-28754-6-git-send-email-b32955@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Huang,

On 5/17/2013 8:47 AM, Huang Shijie wrote:
> Since the ONFI 2.1, the onfi spec adds the Extended Parameter Page
> to store the ECC info.
>
<snip>
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index b63b731..0b1162a 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -2835,6 +2835,71 @@ static u16 onfi_crc16(u16 crc, u8 const *p, size_t len)
>   	return crc;
>   }
>
> +/* Parse the Extended Parameter Page. */
> +static int nand_flash_detect_ext_param_page(struct mtd_info *mtd,
> +		struct nand_chip *chip, struct nand_onfi_params *p)
> +{
<snip>
> +
> +	/* Read out the Extended Parameter Page. */
> +	chip->read_buf(mtd, (uint8_t *)ep, len);
> +	if ((onfi_crc16(ONFI_CRC_BASE, ((uint8_t *)ep) + 2, len - 2)
> +		!= le16_to_cpu(ep->crc)) || strncmp(ep->sig, "EPPS", 4)) {

 From section 5.7.2.2.
///Byte 2-5: Extended parameter page signature
This field contains the extended parameter page signature. When two or 
more bytes of the signature are valid, then it denotes that a valid copy 
of the extended parameter page is present///

But here you are doing a strict check. What if the first two bytes are 
valid? Or did I misunderstood something?
If not, I'd prefer to take the strncmp to a separate 'if' so, that you 
can do the comparison in the way specified in the ONFI spec.

> +		pr_debug("fail in the CRC.\n");

Also, this is the error for Signature failure as well. Please move the 
signature comparison to a new if to give better error messages.

> +		ret = -EINVAL;
> +		goto ext_out;
> +	}

Regards,
Vikram
