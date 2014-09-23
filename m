Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbaIWPfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:35:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59283 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752593AbaIWPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:34:58 -0400
Date: Tue, 23 Sep 2014 17:34:36 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 2/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140923173436.17ab0d36@bbrezillon>
In-Reply-To: <20140923151739.GA1791@localhost.localdomain>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411481256-29141-3-git-send-email-boris.brezillon@free-electrons.com>
	<20140923151739.GA1791@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014 23:17:41 +0800
Huang Shijie <shijie8@gmail.com> wrote:

> On Tue, Sep 23, 2014 at 04:07:35PM +0200, Boris BREZILLON wrote:
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
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > ---
> >  drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 126 +++++++++++++++++++++++++++++++++
> >  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |   2 +
> >  2 files changed, 128 insertions(+)
> > 
> > diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> > index 959cb9b..7921ba7 100644
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
> why add this buffer?

I don't why, but I experienced memory corruptions (triggering kernel
panics) when using the page_buffer_virt, even though I had resized it
according to the NAND writesize and oobsize (see my previous version).

Do you see anything that could generate an overflow ?

It seems to work when I allocate my own buffer...

> 
> did you meet some data overlapped?
> 
> 
> > +	if (!this->raw_buffer)
> > +		goto error_alloc;
> >  
> >  	/* Slice up the page buffer. */
> >  	this->payload_virt = this->page_buffer_virt;
> > @@ -1347,6 +1351,126 @@ gpmi_ecc_write_oob(struct mtd_info *mtd, struct nand_chip *chip, int page)
> >  	return status & NAND_STATUS_FAIL ? -EIO : 0;
> >  }
> >  
> > +static int gpmi_ecc_read_page_raw(struct mtd_info *mtd,
> > +				  struct nand_chip *chip, uint8_t *buf,
> > +				  int oob_required, int page)
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
> 	could this @buf become NULL?

It's just a check to later support raw OOB accesses (see patch
3) ;-).

> 
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
> > +	if (oob_required && oob_bit_off % 8)
> > +		oob[oob_bit_off / 8] &= GENMASK(oob_bit_off - 1, 0);
> > +
> > +	oob_byte_off = DIV_ROUND_UP(oob_bit_off, 8);
> > +
> > +	if (oob_required && oob_byte_off  < mtd->oobsize)
> > +		memcpy(oob + oob_byte_off,
> > +		       tmp_buf + mtd->writesize + oob_byte_off,
> > +		       mtd->oobsize - oob_byte_off);
> 
> For the above 9 lines, we'd better add a condition check here to make code more clear:
> 	if (oob_required) {
> 
> 		....
> 
> 	}

Absolutely, I'll change that.

Thanks,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
