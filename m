Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbaIWRQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:16:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60141 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755293AbaIWRQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:16:23 -0400
Date: Tue, 23 Sep 2014 19:16:19 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 2/3] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140923191619.0c0a667e@bbrezillon>
In-Reply-To: <20140923161041.GA2147@localhost.localdomain>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411481256-29141-3-git-send-email-boris.brezillon@free-electrons.com>
	<20140923161041.GA2147@localhost.localdomain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 00:10:44 +0800
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
> 
> 	In actually, i suggest to call the ecc->read_page() in this
> 	hook. And after the ecc->read_page(), copy the relative data to
> 	the relative buffers. Is my suggestion right? please correct me.

Unfortunately it's not. The user expect that ECC correction is not
involved when accessing the NAND in raw mode, which is not the case in
your read_page implementation.
This is particularly useful when one want to see the real page status
(including bitflips).

Moreover, I like to see the generated ECC bytes/bits when using raw
access (but I'm not sure this is a requirement). This will help
deducing the BCH algorithm and/or XOR mask applied after producing
these bits if someone ever want to spend some time reverse engineering
it.

> 
> 
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
> > +
> > +	return 0;
> > +}
> > +
> > +static int gpmi_ecc_write_page_raw(struct mtd_info *mtd,
> > +				   struct nand_chip *chip,
> > +				   const uint8_t *buf,
> > +				   int oob_required)
> > +{
> 
> 
> give me more time to think over this hook :(

Sure, no problem.

Actually it's doing the exact same thing read_page_raw is doing expect
it's applying on a write access.
I copy the provided data (in-band and out-of-band is required) into a
temporary buffer to match the GPMI controller layout, then write it
without involving the BCH block (which means no ECC bits generation).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
