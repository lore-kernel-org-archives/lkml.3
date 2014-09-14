Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaINOH7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 10:07:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33900 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752519AbaINOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 10:07:58 -0400
Date: Sun, 14 Sep 2014 16:07:52 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Huang Shijie <shijie8@gmail.com>, Huang Shijie <shijie.huang@intel.com>,
        Mike Voytovich <mvoytovich@paypal.com>, linux-kernel@vger.kernel.org,
        Huang Shijie <b32955@freescale.com>, linux-mtd@lists.infradead.org,
        Roy Lee <roylee@paypal.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: add proper raw access support
Message-ID: <20140914160752.1cb404cc@bbrezillon>
In-Reply-To: <20140913173841.GA18093@brian-ubuntu>
References: <1410339339-25561-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140911120928.GA1585@localhost.localdomain>
	<20140911143616.3ebb025a@bbrezillon>
	<20140911142511.GA2543@localhost.localdomain>
	<20140911163847.5e2f85c7@bbrezillon>
	<20140912004550.GB26904@shldeISGChi005.sh.intel.com>
	<20140912143050.014ad4c3@bbrezillon>
	<20140913153622.GA10132@localhost.localdomain>
	<20140913173841.GA18093@brian-ubuntu>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian, Huang,

On Sat, 13 Sep 2014 10:38:41 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Sat, Sep 13, 2014 at 11:36:24PM +0800, Huang Shijie wrote:
> > On Fri, Sep 12, 2014 at 02:30:50PM +0200, Boris BREZILLON wrote:
> > > This test validates what's returned by ecc_strength file in sysfs
> > > (which in turn is specified by the NAND controller when initializing
> > > the NAND chip).
> > > 
> > > Doing this should not imply knowing the ECC algorithm in use in the
> > > NAND controller or the layout used to store data on NAND.
> > the difficulty is that the ECC parity area can be not byte aligned.
> 
> Is there a problem with just rounding up to the nearest byte alignment
> and ignoring the few bits that are wasted?
> 
> > As I ever said, it is hard to implement the two hooks.
> 
> "Hard" doesn't mean we shouldn't. I really would like to encourage more
> NAND drivers to be programmed against the expected MTD behavior -- that
> (if possible with the given hardware) they can pass the MTD tests
> (drivers/mtd/tests/*).

Here is a draft for a gpmi_move_bits function we could use to move bits
(not bytes :-) from one memory region to another:

void gpmi_move_bits(u8 *dst, size_t dst_bit_off,
		    const u8 *src, size_t src_bit_off,
		    size_t nbits)
{
	size_t i;
	size_t nbytes;
	u32 src_byte = 0;

	src += src_bit_off / 8;
	src_bit_off %= 8;

	dst += dst_bit_off / 8;
	dst_bit_off %= 8;

	if (src_bit_off) {
		src_byte = src[0] >> src_bit_off;
		nbits -= 8 - src_bit_off;
		src++;
	}

	nbytes = nbits / 8;

	if (src_bit_off <= dst_bit_off) {
		dst[0] &= GENMASK(dst_bit_off - 1, 0);
		dst[0] |= src_byte << dst_bit_off;
		src_bit_off += (8 - dst_bit_off);
		src_byte >>= (8 - dst_bit_off);
		dst_bit_off = 0;
		dst++;
	} else if (nbytes) {
		src_byte |= src[0] << (8 - src_bit_off);
		dst[0] &= GENMASK(dst_bit_off - 1, 0);
		dst[0] |= src_byte << dst_bit_off;
		src_bit_off += dst_bit_off;
		src_byte >>= (8 - dst_bit_off);
		dst_bit_off = 0;
		dst++;
		nbytes--;
		src++;
		if (src_bit_off > 7) {
			src_bit_off -= 8;
			dst[0] = src_byte;
			dst++;
			src_byte >>= 8;
		}
	}

	if (!src_bit_off && !dst_bit_off) {
		if (nbytes)
			memcpy(dst, src, nbytes);
	} else {
		for (i = 0; i < nbytes; i++) {
			src_byte |= src[i] << (8 - src_bit_off);
			dst[i] = src_byte;
			src_byte >>= 8;
		}
	}

	dst += nbytes;
	src += nbytes;
	nbits %= 8;

	if (!nbits && !src_bit_off)
		return;

	if (nbits)
		src_byte |= (*src & GENMASK(nbits - 1, 0)) <<
			    ((8 - src_bit_off) % 8);
	nbits += (8 - src_bit_off) % 8;

	if (dst_bit_off)
		src_byte = (src_byte << dst_bit_off) |
			   (*dst & GENMASK(dst_bit_off - 1, 0));
	nbits += dst_bit_off;

	if (nbits % 8)
		src_byte |= (dst[nbits / 8] & GENMASK(7, nbits % 8)) <<
			    (nbits / 8);

	nbytes = DIV_ROUND_UP(nbits, 8);
	for (i = 0; i < nbytes; i++) {
		dst[i] = src_byte;
		src_byte >>= 8;
	}
}

I haven't tested it, and I think there is room for optimization.

My point is that performance is not a key aspect of raw functions
(those are often used by testing and debugging tools), hence we could
rely on this move_bits function to address the ECC bit alignment
problem.

Let me know what's your opinion on this approach.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
