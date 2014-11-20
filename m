Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbaKTJfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:35:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:45268 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756779AbaKTJfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:35:34 -0500
Date: Thu, 20 Nov 2014 10:35:30 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v4 3/4] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141120103530.4c40daf9@bbrezillon>
In-Reply-To: <20141120090807.GC3212@norris-Latitude-E6410>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
	<1413794777-32220-4-git-send-email-boris.brezillon@free-electrons.com>
	<20141120090807.GC3212@norris-Latitude-E6410>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Thu, 20 Nov 2014 01:08:07 -0800
Brian Norris <computersforpeace@gmail.com> wrote:

> On Mon, Oct 20, 2014 at 10:46:16AM +0200, Boris Brezillon wrote:
> > Several MTD users (either in user or kernel space) expect a valid raw
> > access support to NAND chip devices.
> > This is particularly true for testing tools which are often touching the
> > data stored in a NAND chip in raw mode to artificially generate errors.
> > 
> > The GPMI drivers do not implemenent raw access functions, and thus rely on
> > default HW_ECC scheme implementation.
> > The default implementation consider the data and OOB area as properly
> > separated in their respective NAND section, which is not true for the GPMI
> > controller.
> > In this driver/controller some OOB data are stored at the beginning of the
> > NAND data area (these data are called metadata in the driver), then ECC
> > bytes are interleaved with data chunk (which is similar to the
> > HW_ECC_SYNDROME scheme), and eventually the remaining bytes are used as
> > OOB data.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > ---
> >  drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 128 +++++++++++++++++++++++++++++++++
> >  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   2 +
> >  2 files changed, 130 insertions(+)
> > 
> > diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> > index 959cb9b..bd4dedc 100644
> > --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> > +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> > @@ -791,6 +791,7 @@ static void gpmi_free_dma_buffer(struct gpmi_nand_data *this)
> >  					this->page_buffer_phys);
> >  	kfree(this->cmd_buffer);
> >  	kfree(this->data_buffer_dma);
> > +	kfree(this->raw_buffer);
> >  
> >  	this->cmd_buffer	= NULL;
> >  	this->data_buffer_dma	= NULL;
> > @@ -837,6 +838,9 @@ static int gpmi_alloc_dma_buffer(struct gpmi_nand_data *this)
> >  	if (!this->page_buffer_virt)
> >  		goto error_alloc;
> >  
> > +	this->raw_buffer = kzalloc(mtd->writesize + mtd->oobsize, GFP_KERNEL);
> > +	if (!this->raw_buffer)
> > +		goto error_alloc;
> >  
> >  	/* Slice up the page buffer. */
> >  	this->payload_virt = this->page_buffer_virt;
> > @@ -1347,6 +1351,128 @@ gpmi_ecc_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
> >  	return status & NAND_STATUS_FAIL ? -EIO : 0;
> >  }
> >  
> > +static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
> > +				  struct nand_chip *chip, uint8_t *buf,
> > +				  int oob_required, int page)
> 
> I think I follow what this function is doing, and gpmi-nand notes the
> ECC layout elsewhere in the driver, but can you put a few comments at
> above this function to describe what it's doing? Refer to existing
> comments as needed. And maybe note the tricky parts inline with the
> code.

Sure, I'll add some comments.

> 
> > +{
> > +	struct gpmi_nand_data *this = chip->priv;
> > +	struct bch_geometry *nfc_geo = &this->bch_geometry;
> > +	int eccsize = nfc_geo->ecc_chunk_size;
> > +	int eccbits = nfc_geo->ecc_strength * nfc_geo->gf_len;
> > +	u8 *tmp_buf = this->raw_buffer;
> > +	size_t src_bit_off;
> > +	size_t oob_bit_off;
> > +	size_t oob_byte_off;
> > +	uint8_t *oob = chip->oob_poi;
> > +	int step;
> > +
> > +	chip->read_buf(mtd, tmp_buf,
> > +		       mtd->writesize + mtd->oobsize);
> > +
> > +	if (this->swap_block_mark) {
> > +		u8 swap = tmp_buf[0];
> > +
> > +		tmp_buf[0] = tmp_buf[mtd->writesize];
> > +		tmp_buf[mtd->writesize] = swap;
> > +	}
> > +
> > +	if (oob_required)
> > +		memcpy(oob, tmp_buf, nfc_geo->metadata_size);
> > +
> > +	oob_bit_off = nfc_geo->metadata_size * 8;
> > +	src_bit_off = oob_bit_off;
> > +
> > +	for (step = 0; step < nfc_geo->ecc_chunk_count; step++) {
> > +		if (buf)
> 
> Can buf ever be zero here?

Actually, I call this function with a NULL buf in my 4th patch (to dump
the oob area).

> 
> > +			gpmi_move_bits(buf, step * eccsize * 8,
> > +				       tmp_buf, src_bit_off,
> > +				       eccsize * 8);
> > +		src_bit_off += eccsize * 8;
> > +
> > +		if (oob_required)
> > +			gpmi_move_bits(oob, oob_bit_off,
> > +				       tmp_buf, src_bit_off,
> > +				       eccbits);
> > +
> > +		src_bit_off += eccbits;
> > +		oob_bit_off += eccbits;
> > +	}
> > +
> > +	if (oob_required) {
> > +		if (oob_bit_off % 8)
> > +			oob[oob_bit_off / 8] &= GENMASK(oob_bit_off - 1, 0);
> 
> So you're manufacturing a few 0 bits here, right? Is that safe? Would we
> prefer to manufacture 1 bits, as if they are "erased"?

AFAIR this is what the controller is doing (but I'll have to re-check
that one).

> 
> > +
> > +		oob_byte_off = DIV_ROUND_UP(oob_bit_off, 8);
> > +
> > +		if (oob_byte_off  < mtd->oobsize)
> 
> Extra whitespace before '<'.

I'll Fix that.

Thanks for the review.

Regards,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
