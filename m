Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaIWQLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:11:02 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37709 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115AbaIWQK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:10:59 -0400
Date: Wed, 24 Sep 2014 00:10:44 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 2/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140923161041.GA2147@localhost.localdomain>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411481256-29141-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411481256-29141-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 04:07:35PM +0200, Boris BREZILLON wrote:
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
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 126 +++++++++++++++++++++++++++++++++
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   2 +
>  2 files changed, 128 insertions(+)
> 
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> index 959cb9b..7921ba7 100644
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
> @@ -1347,6 +1351,126 @@ gpmi_ecc_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
>  	return status & NAND_STATUS_FAIL ? -EIO : 0;
>  }
>  
> +static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
> +				  struct nand_chip *chip, uint8_t *buf,
> +				  int oob_required, int page)

	In actually, i suggest to call the ecc->read_page() in this
	hook. And after the ecc->read_page(), copy the relative data to
	the relative buffers. Is my suggestion right? please correct me.



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
> +	if (oob_required && oob_bit_off % 8)
> +		oob[oob_bit_off / 8] &= GENMASK(oob_bit_off - 1, 0);
> +
> +	oob_byte_off = DIV_ROUND_UP(oob_bit_off, 8);
> +
> +	if (oob_required && oob_byte_off  < mtd->oobsize)
> +		memcpy(oob + oob_byte_off,
> +		       tmp_buf + mtd->writesize + oob_byte_off,
> +		       mtd->oobsize - oob_byte_off);
> +
> +	return 0;
> +}
> +
> +static int gpmi_ecc_write_page_raw(struct mtd_info *mtd,
> +				   struct nand_chip *chip,
> +				   const uint8_t *buf,
> +				   int oob_required)
> +{


give me more time to think over this hook :(

sorry.

thanks
Huang Shijie
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
> +		memset(tmp_buf, 0xff, mtd->writesize + mtd->oobsize);
> +
> +	memcpy(tmp_buf, oob, nfc_geo->metadata_size);
> +	oob_bit_off = nfc_geo->metadata_size * 8;
> +	dst_bit_off = oob_bit_off;
> +
> +	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
> +		if (buf)
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
> @@ -1664,6 +1788,8 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
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
> -- 
> 1.9.1
> 
