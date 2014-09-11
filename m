Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaIKO3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:29:53 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65363 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaIKO3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:29:52 -0400
Date: Thu, 11 Sep 2014 22:29:32 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <b32955@freescale.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140911142930.GB2543@localhost.localdomain>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:55:39AM +0200, Boris BREZILLON wrote:
 +static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
> +				  struct nand_chip *chip, uint8_t *buf,
> +				  int oob_required, int page)
> +{
> +	struct gpmi_nand_data *this = chip->priv;
> +	struct bch_geometry *nfc_geo = &this->bch_geometry;
> +	int eccsize = nfc_geo->ecc_chunk_size;
> +	int eccbytes = DIV_ROUND_UP(nfc_geo->ecc_strength * nfc_geo->gf_len,
> +				    8);

In actually, the ECC can be _NOT_ bytes aligned.
you should not round up to byte.

it's hard to implement this hook.

thanks
Huang Shijie
	
> +	uint8_t *oob = chip->oob_poi;
> +	int step;
> +	int column = 0;
> +	uint8_t *orig_buf = buf;
> +
> +	chip->read_buf(mtd, oob, nfc_geo->metadata_size);
> +	oob += nfc_geo->metadata_size;
> +
> +	column += nfc_geo->metadata_size;
> +	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
> +		chip->read_buf(mtd, buf, eccsize);
> +		buf += eccsize;
> +		column += eccsize;
> +		chip->read_buf(mtd, oob, eccbytes);
> +		oob += eccbytes;
> +		column += eccbytes;
> +	}
> +
> +	if (column < mtd->writesize + mtd->oobsize)
> +		chip->read_buf(mtd, oob,
> +			       mtd->writesize + mtd->oobsize - column);
> +
> +	block_mark_swapping(this, orig_buf, chip->oob_poi);
> +
> +	return 0;
> +}
