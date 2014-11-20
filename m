Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbaKTJIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:08:15 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39793 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756180AbaKTJIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:08:11 -0500
Date: Thu, 20 Nov 2014 01:08:07 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v4 3/4] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141120090807.GC3212@norris-Latitude-E6410>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
 <1413794777-32220-4-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413794777-32220-4-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:46:16AM +0200, Boris Brezillon wrote:
> Several MTD users (either in user or kernel space) expect a valid raw
> access support to NAND chip devices.
> This is particularly true for testing tools which are often touching the
> data stored in a NAND chip in raw mode to artificially generate errors.
> 
> The GPMI drivers do not implemenent raw access functions, and thus rely on
> default HW_ECC scheme implementation.
> The default implementation consider the data and OOB area as properly
> separated in their respective NAND section, which is not true for the GPMI
> controller.
> In this driver/controller some OOB data are stored at the beginning of the
> NAND data area (these data are called metadata in the driver), then ECC
> bytes are interleaved with data chunk (which is similar to the
> HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
> OOB data.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 128 +++++++++++++++++++++++++++++++++
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   2 +
>  2 files changed, 130 insertions(+)
> 
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> index 959cb9b..bd4dedc 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> @@ -791,6 +791,7 @@ static void gpmi_free_dma_buffer(struct gpmi_nand_data *this)
>  					this->page_buffer_phys);
>  	kfree(this->cmd_buffer);
>  	kfree(this->data_buffer_dma);
> +	kfree(this->raw_buffer);
>  
>  	this->cmd_buffer	= NULL;
>  	this->data_buffer_dma	= NULL;
> @@ -837,6 +838,9 @@ static int gpmi_alloc_dma_buffer(struct gpmi_nand_data *this)
>  	if (!this->page_buffer_virt)
>  		goto error_alloc;
>  
> +	this->raw_buffer = kzalloc(mtd->writesize + mtd->oobsize, GFP_KERNEL);
> +	if (!this->raw_buffer)
> +		goto error_alloc;
>  
>  	/* Slice up the page buffer. */
>  	this->payload_virt = this->page_buffer_virt;
> @@ -1347,6 +1351,128 @@ gpmi_ecc_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
>  	return status & NAND_STATUS_FAIL ? -EIO : 0;
>  }
>  
> +static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
> +				  struct nand_chip *chip, uint8_t *buf,
> +				  int oob_required, int page)

I think I follow what this function is doing, and gpmi-nand notes the
ECC layout elsewhere in the driver, but can you put a few comments at
above this function to describe what it's doing? Refer to existing
comments as needed. And maybe note the tricky parts inline with the
code.

> +{
> +	struct gpmi_nand_data *this = chip->priv;
> +	struct bch_geometry *nfc_geo = &this->bch_geometry;
> +	int eccsize = nfc_geo->ecc_chunk_size;
> +	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
> +	u8 *tmp_buf = this->raw_buffer;
> +	size_t src_bit_off;
> +	size_t oob_bit_off;
> +	size_t oob_byte_off;
> +	uint8_t *oob = chip->oob_poi;
> +	int step;
> +
> +	chip->read_buf(mtd, tmp_buf,
> +		       mtd->writesize + mtd->oobsize);
> +
> +	if (this->swap_block_mark) {
> +		u8 swap = tmp_buf[0];
> +
> +		tmp_buf[0] = tmp_buf[mtd->writesize];
> +		tmp_buf[mtd->writesize] = swap;
> +	}
> +
> +	if (oob_required)
> +		memcpy(oob, tmp_buf, nfc_geo->metadata_size);
> +
> +	oob_bit_off = nfc_geo->metadata_size * 8;
> +	src_bit_off = oob_bit_off;
> +
> +	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
> +		if (buf)

Can buf ever be zero here?

> +			gpmi_move_bits(buf, step * eccsize * 8,
> +				       tmp_buf, src_bit_off,
> +				       eccsize * 8);
> +		src_bit_off += eccsize * 8;
> +
> +		if (oob_required)
> +			gpmi_move_bits(oob, oob_bit_off,
> +				       tmp_buf, src_bit_off,
> +				       eccbits);
> +
> +		src_bit_off += eccbits;
> +		oob_bit_off += eccbits;
> +	}
> +
> +	if (oob_required) {
> +		if (oob_bit_off % 8)
> +			oob[oob_bit_off / 8] &= GENMASK(oob_bit_off - 1, 0);

So you're manufacturing a few 0 bits here, right? Is that safe? Would we
prefer to manufacture 1 bits, as if they are "erased"?

> +
> +		oob_byte_off = DIV_ROUND_UP(oob_bit_off, 8);
> +
> +		if (oob_byte_off  < mtd->oobsize)

Extra whitespace before '<'.

> +			memcpy(oob + oob_byte_off,
> +			       tmp_buf + mtd->writesize + oob_byte_off,
> +			       mtd->oobsize - oob_byte_off);
> +	}
> +
> +	return 0;
> +}
> +
> +static int gpmi_ecc_write_page_raw(struct mtd_info *mtd,
> +				   struct nand_chip *chip,
> +				   const uint8_t *buf,
> +				   int oob_required)

Same comment applies, about commenting the function.

> +{
> +	struct gpmi_nand_data *this = chip->priv;
> +	struct bch_geometry *nfc_geo = &this->bch_geometry;
> +	int eccsize = nfc_geo->ecc_chunk_size;
> +	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
> +	u8 *tmp_buf = this->raw_buffer;
> +	uint8_t *oob = chip->oob_poi;
> +	size_t dst_bit_off;
> +	size_t oob_bit_off;
> +	size_t oob_byte_off;
> +	int step;
> +
> +	if (!buf || !oob_required)

Can buf be zero?

> +		memset(tmp_buf, 0xff, mtd->writesize + mtd->oobsize);
> +
> +	memcpy(tmp_buf, oob, nfc_geo->metadata_size);
> +	oob_bit_off = nfc_geo->metadata_size * 8;
> +	dst_bit_off = oob_bit_off;
> +
> +	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
> +		if (buf)

Again, can buf be zero?

> +			gpmi_move_bits(tmp_buf, dst_bit_off,
> +				       buf, step * eccsize * 8, eccsize * 8);
> +		dst_bit_off += eccsize * 8;
> +
> +		/* Pad last ECC block to align following data on a byte */
> +		if (step == nfc_geo->ecc_chunk_count - 1 &&
> +		    (oob_bit_off + eccbits) % 8)
> +			eccbits += 8 - ((oob_bit_off + eccbits) % 8);
> +
> +		if (oob_required)
> +			gpmi_move_bits(tmp_buf, dst_bit_off,
> +				       oob, oob_bit_off, eccbits);
> +
> +		dst_bit_off += eccbits;
> +		oob_bit_off += eccbits;
> +	}
> +
> +	oob_byte_off = oob_bit_off / 8;
> +
> +	if (oob_required && oob_byte_off < mtd->oobsize)
> +		memcpy(tmp_buf + mtd->writesize + oob_byte_off,
> +		       oob + oob_byte_off, mtd->oobsize - oob_byte_off);
> +
> +	if (this->swap_block_mark) {
> +		u8 swap = tmp_buf[0];
> +
> +		tmp_buf[0] = tmp_buf[mtd->writesize];
> +		tmp_buf[mtd->writesize] = swap;
> +	}
> +
> +	chip->write_buf(mtd, tmp_buf, mtd->writesize + mtd->oobsize);
> +
> +	return 0;
> +}
> +
>  static int gpmi_block_markbad(struct mtd_info *mtd, loff_t ofs)
>  {
>  	struct nand_chip *chip = mtd->priv;
> @@ -1664,6 +1790,8 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
>  	ecc->write_page	= gpmi_ecc_write_page;
>  	ecc->read_oob	= gpmi_ecc_read_oob;
>  	ecc->write_oob	= gpmi_ecc_write_oob;
> +	ecc->read_page_raw = gpmi_ecc_read_page_raw;
> +	ecc->write_page_raw = gpmi_ecc_write_page_raw;
>  	ecc->mode	= NAND_ECC_HW;
>  	ecc->size	= bch_geo->ecc_chunk_size;
>  	ecc->strength	= bch_geo->ecc_strength;
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> index 17d0736..89ab5c8 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> @@ -189,6 +189,8 @@ struct gpmi_nand_data {
>  	void			*auxiliary_virt;
>  	dma_addr_t		auxiliary_phys;
>  
> +	void			*raw_buffer;
> +
>  	/* DMA channels */
>  #define DMA_CHANS		8
>  	struct dma_chan		*dma_chans[DMA_CHANS];

Brian
