Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaIWP0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 11:26:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59216 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932198AbaIWP0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 11:26:02 -0400
Date: Tue, 23 Sep 2014 17:25:58 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v3 1/3] mtd: nand: gpmi: add gpmi_move_bits function
Message-ID: <20140923172558.3f6a161c@bbrezillon>
In-Reply-To: <1411481256-29141-2-git-send-email-boris.brezillon@free-electrons.com>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
	<1411481256-29141-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

I've added some code comments inline (and I'll squash them in my next
version).

On Tue, 23 Sep 2014 16:07:34 +0200
Boris BREZILLON <boris.brezillon@free-electrons.com> wrote:

> Add a new function to move bits (not bytes) from a memory region to
> another one.
> This function is similar to memmove except it acts at bit level.
> This function is needed to implement GPMI raw access functions, given the
> fact that ECC engine does not pad ECC bits to the next byte boundary.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c  | 88 ++++++++++++++++++++++++++++++++++
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.h |  4 ++
>  2 files changed, 92 insertions(+)
> 
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> index 87e658c..e2f706a 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
> @@ -1353,3 +1353,91 @@ int gpmi_read_page(struct gpmi_nand_data *this,
>  	set_dma_type(this, DMA_FOR_READ_ECC_PAGE);
>  	return start_dma_with_bch_irq(this, desc);
>  }
> +
> +void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
> +		    const u8 *src, size_t src_bit_off,
> +		    size_t nbits)
> +{
> +	size_t i;
> +	size_t nbytes;
> +	u32 src_byte = 0;
> +


	/*
	 * Move src and dst pointers to the closest byte pointer and
	 * store bit offsets within a byte.
	 */

> +	src += src_bit_off / 8;
> +	src_bit_off %= 8;
> +
> +	dst += dst_bit_off / 8;
> +	dst_bit_off %= 8;
> +
	/*
	 * Initialize the src_byte value with bits available in the
	 * first byte of data so that we end up with a byte aligned
	 * src pointer.
	 */
> +	if (src_bit_off) {
> +		src_byte = src[0] >> src_bit_off;
> +		nbits -= 8 - src_bit_off;
> +		src++;
> +	}
> +
	/*
	 * Calculate the number of bytes that can be copied from src to
	 * dst.
	 */
> +	nbytes = nbits / 8;
> +

	/*
	 * Try to align dst to a byte boundary by peeking some bits
	 * from the source.
	 */

> +	if (dst_bit_off) {
> +		if (src_bit_off <= dst_bit_off) {
> +			dst[0] &= GENMASK(dst_bit_off - 1, 0);
> +			dst[0] |= src_byte << dst_bit_off;
> +			src_bit_off += (8 - dst_bit_off);
> +			src_byte >>= (8 - dst_bit_off);
> +			dst_bit_off = 0;
> +			dst++;
> +		} else if (nbytes) {
> +			src_byte |= src[0] << (8 - src_bit_off);
> +			dst[0] &= GENMASK(dst_bit_off - 1, 0);
> +			dst[0] |= src_byte << dst_bit_off;
> +			src_bit_off += dst_bit_off;
> +			src_byte >>= (8 - dst_bit_off);
> +			dst_bit_off = 0;
> +			dst++;
> +			nbytes--;
> +			src++;
> +			if (src_bit_off > 7) {
> +				src_bit_off -= 8;
> +				dst[0] = src_byte;
> +				dst++;
> +				src_byte >>= 8;
> +			}
> +		}
> +	}
> +
> +	if (!src_bit_off && !dst_bit_off) {
		/*
		 * Both src and dst pointers are byte aligned, thus we
		 * can just use the optimized memcpy function
		 */
> +		if (nbytes)
> +			memcpy(dst, src, nbytes);
> +	} else {

		/*
		 * src buffer is not byte aligned, hence we have to copy
		 * each src byte to the src_byte variable (after
		 * applying the appropriate shift depending on the
		 * src bit offset).
		 * We still try to work on bytes until there's not
		 * enough available data in the src buffer.
		 */

> +		for (i = 0; i < nbytes; i++) {
> +			src_byte |= src[i] << (8 - src_bit_off);
> +			dst[i] = src_byte;
> +			src_byte >>= 8;
> +		}
> +	}
> +
	/* move dst and src buffers */
> +	dst += nbytes;
> +	src += nbytes;

	/*
	 * nbits is the number of remaining bits. It should not exceed
	 * 8 as we've already worked on bytes as much as possible.
	 */


> +	nbits %= 8;
> +

	/*
	 * if there's no more bits to copy to the destination and src
	 * buffer was already byte aligned, then we're done.
	 */
> +	if (!nbits && !src_bit_off)
> +		return;
> +
	/* Copy the remaining bits to the src_byte variable */
> +	if (nbits)
> +		src_byte |= (*src & GENMASK(nbits - 1, 0)) <<
> +			    ((8 - src_bit_off) % 8);
> +	nbits += (8 - src_bit_off) % 8;
> +

	/*
	 * There were not enough bits to copy from src to dst to get a
	 * byte aligned dst buffer. In this case prepare the src_byte
	 * variable to match the dst organization (just shift src_byte
	 * by dst bit offset and retrieve least significant bits from
	 * dst).
	 */

> +	if (dst_bit_off)
> +		src_byte = (src_byte << dst_bit_off) |
> +			   (*dst & GENMASK(dst_bit_off - 1, 0));
> +	nbits += dst_bit_off;
> +

	/*
	 * Keep most significant bits from dst if we end up with an
	 * unaligned number bits.
	 */

> +	if (nbits % 8)
> +		src_byte |= (dst[nbits / 8] & GENMASK(7, nbits % 8)) <<
> +			    (nbits / 8);
> +

	/* Copy the remaining bytes to the destination */

> +	nbytes = DIV_ROUND_UP(nbits, 8);
> +	for (i = 0; i < nbytes; i++) {
> +		dst[i] = src_byte;
> +		src_byte >>= 8;
> +	}
> +}
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> index 32c6ba4..17d0736 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.h
> @@ -290,6 +290,10 @@ extern int gpmi_send_page(struct gpmi_nand_data *,
>  extern int gpmi_read_page(struct gpmi_nand_data *,
>  			dma_addr_t payload, dma_addr_t auxiliary);
>  
> +void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
> +		    const u8 *src, size_t src_bit_off,
> +		    size_t nbits);
> +
>  /* BCH : Status Block Completion Codes */
>  #define STATUS_GOOD		0x00
>  #define STATUS_ERASED		0xff



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
