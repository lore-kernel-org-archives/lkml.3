Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaKEMBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:01:39 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:48798 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaKEMBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:01:38 -0500
Date: Wed, 5 Nov 2014 12:01:31 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 8/9] mtd: nand: stm_nand_bch: add support for ST's BCH
 NAND controller
Message-ID: <20141105120131.GA26543@x1>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
 <1409143344-22458-9-git-send-email-lee.jones@linaro.org>
 <20141006062127.GH3248@norris-Latitude-E6410>
 <20141009143923.GR20647@lee--X1>
 <20141015230213.GY1193@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141015230213.GY1193@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014, Brian Norris wrote:

> On Thu, Oct 09, 2014 at 03:39:23PM +0100, Lee Jones wrote:
> > > > +static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
> > > > +{
> > > > +	uint8_t *b = data;
> > > > +	int zeros = 0;
> > > > +	int i;
> > > > +
> > > > +	for (i = 0; i < page_size; i++) {
> > > > +		zeros += hweight8(~*b++);
> > > > +		if (zeros > max_zeros)
> > > > +			return -1;
> > > > +	}
> > > > +
> > > > +	if (zeros)
> > > > +		memset(data, 0xff, page_size);
> > > > +
> > > > +	return zeros;
> > > > +}
> > > 
> > > I pointed out some flaws in this function back in July [1]. You said
> > > you'd look into this one [2]. I really don't want to accept yet another
> > > custom, unsound erased-page check if at all possible.
> > 
> > That's not quite true.  I said that I think it doesn't matter about
> > not taking the OOB area into consideration, which I still believe is
> > the case.  This controller does not allow access into the OOB area.
> 
> Perhaps I'm not being clear enough.
> 
> While the controller may not allow you to program the spare area
> directly, you do so implicitly by allowing the controller to program BCH
> parity bytes to the spare area, right? So when you want to check if the
> page is blank, you have to consider ALL areas that will be used -- both
> in-band and out-of-band.
> 
> So, I'll repeat my question and try to elaborate:
> 
>   "What if this is a mostly-blank page, with ECC data, but most of the
>   bitflips are in the spare area? Then you will "correct" this page to
>   all 0xFF, not noticing that this was really not a blank page at all."
> 
> More specifically:
> 
>   1. Suppose you program a page with just a single byte of non-0xff
>   data, and your correction strength is at least 8 bits per sector
> 
>   2. When programming this page, your BCH controller writes parity bytes
>   to the spare area
> 
>   3. Over time (a lot of reads, for example), suppose you develop a lot
>   of bit flips in the spare area, such that your controller cannot
>   correct them any longer
> 
> Now consider two algorithms:
> 
>   (A) Your current proposal, to just check the in-band data that you can
>   easily access. If there are more than X zero-bits in the page, return
>   an error. Otherwise, clear the page and log a correctable error.
> 
>   (B) My suggestion, to check both the in-band and out-of-band. Same as
>   algorithm (A), except you check for X total zero-bits in both the
>   in-band and out-of-band
> 
> In the scenario I described, algorithm A will only notice up to 8 zero
> bits (in that single byte we programmed), so if X is greater than 8,
> algorithm A will falsely declare this an erased page and silently
> clobber the data we programmed to it.
> 
> Algorithm B would notice that there are many zero bits in the spare area
> (due to the programmed parity bytes) and will correctly declare this a
> corrupt, non-erased page.
> 
> If I've made any false assumptions in here, please point them out. But
> otherwise, I'd say that any erased-page detection algorithm that ignores
> the spare area is incorrect.
> 
> If you agree with me, then you have at least two options:
> 
> (1) Remove this erased page check entirely from the initial driver, with
>     a TODO item to add spare area read support and to improve this
>     algorithm
> 
> (2) Keep the check as-is, but put a large FIXME warning which notes why
>     the algorithm is wrong. It's possible the wrong algorithm is still
>     marginally better than no erased-page detection at all. I'm not sure
>     what the probability distributions are like for this sort of error.

Thanks for taking the time to explain your points so thoughly, I
appreciate that a great deal.  After chatting with Angus it transpires
that check_erased_page() does not check the OOB intentionally. This
behaviour is documented (in a Documentation/ file that I didn't know
exsited).  I will take the liberty of placing an extract of this
document and placing it in the driver as a comment.

FYI:

  "The most robust approach would be to use Hamming-FLEX to re-read the entire
  raw page+OOB data.  However, it is assumed that just checking the returned
  'raw' page data offers an acceptable compromise with minimal impact on
  performance.  (Is is possible to get a genuine uncorrectable ECC error where
  the page data is all 0xff?)"

> > > > +/* Returns the number of ECC errors, or '-1' for uncorrectable error */
> > > > +int bch_read_page(struct nandi_controller *nandi,
> > > > +		  loff_t offs,
> > > > +		  uint8_t *buf)
> > > > +{
> > > > +	struct nand_chip *chip = &nandi->info.chip;
> > > > +	struct bch_prog *prog = &bch_prog_read_page;
> > > > +	uint32_t page_size = nandi->info.mtd.writesize;
> > > > +	unsigned long list_phys;
> > > 
> > > Please use dma_addr_t. This is an intentionally opaque (to some degree)
> > > type.
> > > 
> > > > +	unsigned long buf_phys;
> > > 
> > > Ditto.
> > > 
> > > BTW, is your hardware actually restricted to a 32-bit address space? If
> > > it has some expanded registers for larger physical address ranges, it'd
> > > be good to handle the upper bits of the DMA address when mapping. Or
> > > else, it would be good to reflect this in your driver with
> > > dma_set_mask() I think.
> > 
> > Yes, it's 32bit only.  I will add a call to dma_set_mask() to reflect
> > this.
> > 
> > ... or not.  See below.

Added.

> > > > +	uint32_t ecc_err;
> > > > +	int ret = 0;
> > > > +
> > > > +	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
> > > > +
> > > > +	BUG_ON(offs & (NANDI_BCH_DMA_ALIGNMENT - 1));
> > > > +
> > > > +	emiss_nandi_select(nandi, STM_NANDI_BCH);
> > > > +
> > > > +	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
> > > > +	reinit_completion(&nandi->seq_completed);
> > > > +
> > > > +	/* Reset ECC stats */
> > > > +	writel(CFG_RESET_ECC_ALL | CFG_ENABLE_AFM,
> > > > +	       nandi->base + NANDBCH_CONTROLLER_CFG);
> > > > +	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
> > > > +
> > > > +	prog->addr = (uint32_t)((offs >> (chip->page_shift - 8)) & 0xffffff00);
> > > > +
> > > > +	buf_phys = dma_map_single(NULL, buf, page_size, DMA_FROM_DEVICE);
> > > 
> > > Why NULL for the first arg? You should use the proper device (which will
> > > help with the 32-bit / 64-bit masking, I think.
> > > 
> > > Also, dma_map_single() can fail. It's good practice to check the return
> > > value with dma_mapping_error(). Same in a few other places.
> > 
> > If you do not supply the first parameter here, it falls back to
> > arm_dma_ops, which is what we want.  I guess this is also why we do
> > not have to set the DMA mask, as we're running on ARM32, rather than
> > AARCH64.
> 
> I think it's standard practice to make your hardware limitations
> explicit when writing a driver. From Documentation/DMA-API-HOWTO.txt
> under "DMA addressing limitations":
> 
>   "It is good style to do this even if your device holds the default
>   setting, because this shows that you did think about these issues wrt.
>   your device."
> 
> But I won't press this issue.

As above.  Although, I think the first parameter of dma_map_single()
needs to stay NULL for the desired behaviour.

> > > > +static int bch_mtd_read_oob(struct mtd_info *mtd,
> > > > +			    struct nand_chip *chip, int page)
> > > > +{
> > > > +	BUG();
> > > 
> > > Are you sure this can't be implemented, even if it's not the expected
> > > mode of operation? That's really unforunate.
> > 
> > It can.  We have a 'special' function for it using the extended
> > flexible mode.  Trying to upstream this has been hard enough already,
> > without more crud to deal with.  I will hopefully be adding this
> > functionality as small, succinct patches subsequently.
> 
> OK. But this is relevant to my points above -- particularly, you might
> want the 'read OOB' functionality to properly implement the erased page
> check.

I have added it anyway, as it's required by our BBT code.

> > > > +	for_each_child_of_node(np, banknp) {
> > > 
> > > If you change the DT binding to require a proper compatible property,
> > > you'll need of_device_is_compatible() here.
> > 
> > I see no reason to allocate a compatible property to the bank
> > descriptors.  They're not being registered/actioned through
> > of_platform_populate(), so ...
> 
> Well, this is all dependent on my comments on your DT binding patches. I
> commented there that you did, at times, list a "compatible" property,
> but you never actually used it and/or it was put in the wrong place. If
> you determine that you do not need the property, then this comment is
> also not applicable.
> 
> One reason for a "compatible" property might be if you have different
> types of subnodes eventually, and you'll need to differentiate them. I
> only see a need for a single type of subnode right now (the "bank"), but
> it's possible you'd need to plan for the future.

Right, if that's the case I'll add them then.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
