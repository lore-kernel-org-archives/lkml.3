Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaGaRyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 13:54:33 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48638 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaGaRyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:54:31 -0400
Date: Thu, 31 Jul 2014 10:54:27 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, "Gupta, Pekon\"" <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: Re: [PATCH] mtd: nand: stm_nand_bch: add new driver
Message-ID: <20140731175427.GO3711@ld-irv-0074>
References: <1401268805-26043-1-git-send-email-lee.jones@linaro.org>
 <20140703002237.GM3599@ld-irv-0074>
 <20140731164709.GK9030@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731164709.GK9030@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 05:47:09PM +0100, Lee Jones wrote:
> Finally getting round to this ...

Sounds like me :)

> On Wed, 02 Jul 2014, Brian Norris wrote:
> > On Wed, May 28, 2014 at 10:20:05AM +0100, Lee Jones wrote:
> > > This is a squashed version of the submission to avoid re-sending the
> > > entire set over and over, essentially clogging up the MLs.
> > 
> > Thanks. I think I'd prefer to accept your driver in a form like this
> > too.
> 
> You mean squashed?  I'd _really_ like _not_ to do that.

Any particular reason? Just to bump your patch count? ;) A half-finished
driver is not really bisectable.

> We've spoken
> about this in reasonable depth before.  I agreed to squash it for this
> review to keep the submissions nice and light, but we did have an
> agreement that once accepted the final delivery could be via
> pull-request.  I'd really like it if you honoured that.

I don't recall the part about final delivery, but that's what happens
via informal and unlogged communication like IRC, I guess. As I recall,
I just mentioned that you could link people to your git history if you
felt it was still useful.

Anyway, as long as the review process is sane (1 new driver = small
number of patches), then I don't particularly mind how the final
delivery comes.

> I can pull the vendor specific (rather than
> legacy :) ) BBT handling out and protect it with a CONFIG option.

A CONFIG option perhaps; but you also might need to specify what
'nand-on-flash-bbt' means in your DT. Personally, I'd prefer that
'nand-on-flash-bbt' refers only to one of the BBT's found in nand_bbt.c.
Maybe you could extend nand-on-flash-bbt to have a value, like:

	nand-on-flash-bbt = "ST";

Just a thought. I don't know if this is overdesign, or proper DT safety
(the whole "DT as ABI" thing is tricky, especially when dealing with
softer things like this).

> > >  Documentation/devicetree/bindings/mtd/stm-nand.txt |   87 +
> > 
> > See:
> > 
> >   Documentation/devicetree/bindings/submitting-patches.txt
> 
> This file doesn't exist.  What are you referencing?

commit 2a9330010bea5982a5c6593824bc036bf62d67b7
Author: Jason Cooper <jason@lakedaemon.net>
Date:   Tue Dec 17 16:59:40 2013 +0000

    dt/bindings: submitting patches and ABI documents

> > You're missing devicetree@vger.kernel.org on CC, and the binding doc
> > needs a separate patch. (Sorry if I confused this one earlier.)
> 
> The binding document will certainly be a separate patch.  This patch
> is the 'everything squashed' version which was requested.

I was only referring to the driver. For the DT guys' sake, you should
still follow their rules for patch review.

> > >  arch/arm/boot/dts/stih41x-b2020.dtsi               |   40 +
> > 
> > This will need refreshed and sent as a separate patch, to go through the
> > appropriate ARM tree.
> 
> As above.

OK, if you're really planning to send a final git pull request, you'll
need to have this in a separate branch for them to take, then.

...
> > > diff --git a/Documentation/devicetree/bindings/mtd/stm-nand.txt b/Documentation/devicetree/bindings/mtd/stm-nand.txt
> > > new file mode 100644
> > > index 0000000..d957f49
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/mtd/stm-nand.txt
> > > @@ -0,0 +1,87 @@
> > > +STM BCH NAND Support
> > > +--------------------
> > > +
> > > +Required properties:
> > > +
> > > +- compatible		: Should be "st,nand-bch"
> > > +- reg			: Should contain register's location and length
> > > +- reg-names		: "nand_mem" - NAND Controller register map
> > > +			  "nand_dma" - BCH Controller DMA configuration map
> > > +- interrupts		: Interrupt number
> > > +- interrupt-names	: "nand_irq" - NAND Controller IRQ
> > > +- st,nand-banks		: Subnode representing one or more "banks" of NAND
> > > +			  Flash, connected to an STM NAND Controller (see
> > > +			  description below).
> > > +- nand-ecc-strength	: Generic NAND property (See mtd/nand.txt)
> > > +			  Options are; 0, 18, 30 or 0xFF (AUTO)
> > 
> > What is 0xFF (AUTO)?

Could you answer this one? IIRC, 0xff (AUTO) could easily be replaced by
language that "If nand-ecc-strength is not present", software is free to
auto-select the ECC strength. That removes this non-intuitive special
value.

Also, nand-ecc-strength should probably be paired with
nand-ecc-step-size, otherwise it doesn't really have any meaning.

...
> > > +Example:
> > > +
...
> > > +	nand_banks: nand-banks {
> > > +		bank0 {
...
> > > +			partitions {
...
> > > +				partition@0{
> > > +					label = "NAND Flash 1";
> > 
> > Do you really want spaces in your partition names?
> 
> No clue to be honest.  What are the known ramifications?

I thought it might give issues with the /proc/mtd columns, but actually,
the format there is quoted, so the columns will still be unambiguous.

It also could make things a little more difficult with boot cmdline
parameters, for instance if you want to specify a partition for UBI to
attach to:

  ubi.mtd="NAND Flash 1"

This will probably work OK (haven't tested it), but I can imagine some
boot environments in which getting the quoting right is more difficult.

> > > +					reg = <0x00000000 0x00800000>;
> > > +				};
> > > +				partition@800000{
> > > +					label = "NAND Flash 2";
> > > +					reg = <0x00800000 0x0F800000>;
> > > +				};
> > > +			};
> > > +		};
> > > +	};
...

> > > diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
> > > new file mode 100644
> > > index 0000000..5ad78ce
> > > --- /dev/null
> > > +++ b/drivers/mtd/nand/stm_nand_bch.c
> > > @@ -0,0 +1,2415 @@
...
> > > +/*
> > > + * ONFI NAND Timing Mode Specifications
> > > + *
> > > + * Note, 'tR' field (maximum page read time) is extracted from the ONFI
> > > + * parameter page during device probe.
> > > + */
> > > +const struct nand_sdr_timings st_nand_onfi_timing_specs[] = {
> > 
> > Did you ever take a look at Boris Brezillon's timing patch series? He
> > hasn't submitted an update recently, but it was looking good:
> > 
> >   http://article.gmane.org/gmane.comp.hardware.netbook.arm.sunxi/7976
> > 
> > Perhaps you could even modify/test/resubmit it (it's got a GPL Sign-off,
> > after all!). I'd prefer not to stick this stuff in your driver.
> 
> Not yet.  Will do that now.

FYI, some of the ONFI stubs are queued for 3.17, see l2-mtd.git
drivers/mtd/nand/nand_timings.c. There's also some discussion of adding
helpers that could reduce these to a more useful set of timings (e.g.,
some timings used by a NAND controller may actually be a composite of
two or more of the nand_sdr_timings fields).

> > > +	/*
> > > +	 * ONFI Timing Mode '0' (supported on all ONFI compliant devices)
> > > +	 */
> > > +	[0] = {
> > > +		.tCLS_min	= 50,
> > > +		.tCS_min	= 70,
> > > +		.tALS_min	= 50,
> > > +		.tDS_min	= 40,
> > > +		.tWP_min	= 50,
> > > +		.tCLH_min	= 20,
> > > +		.tCH_min	= 20,
> > > +		.tALH_min	= 20,
> > > +		.tDH_min	= 20,
> > > +		.tWB_max	= 200,
> > > +		.tWH_min	= 30,
> > > +		.tWC_min	= 100,
> > > +		.tRP_min	= 50,
> > > +		.tREH_min	= 30,
> > > +		.tRC_min	= 100,
> > > +		.tREA_max	= 40,
> > > +		.tRHOH_min	= 0,
> > > +		.tCEA_max	= 100,
> > > +		.tCOH_min	= 0,
> > > +		.tCHZ_max	= 100,
> > > +	},
...
> > (Related: Coverity caught a whole bunch of these type of bugs in the MTD
> > test modules. I have fixes queued up that I meant to test and submit
> > soon.)
> 
> I will attempt to play around with Coverity.

Good luck :) Coverity isn't always the easiest to get running
individually. You might have better luck (once your stuff is merged)
checking out the free service offered for open source projects through
github. There's a project instance set up for mainline:

  https://scan.coverity.com/projects/128?tab=overview

> > > +/*
> > > + * Detect an erased page, tolerating and correcting up to a specified number of
> > > + * bits at '0'.  (For many devices, it is now deemed within spec for an erased
> > > + * page to include a number of bits at '0', either as a result of read-disturb
> > > + * behaviour or 'stuck-at-zero' failures.)  Returns the number of corrected
> > > + * bits, or a '-1' if we have exceeded the maximum number of bits at '0' (likely
> > > + * to be a genuine uncorrectable ECC error).  In the latter case, the data must
> > > + * be returned unmodified, in accordance with the MTD API.
> > > + */
> > > +static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
> > 
> > Another "check erased page" implementation? Sigh... it would be nice if
> > we could agree on a common implementation to share. My last attempt was
> > unsuccessful, since some drivers have some very odd requirements.
> > 
> > > +{
> > > +	uint8_t *b = data;
> > > +	int zeros = 0;
> > > +	int i;
> > > +
> > > +	for (i = 0; i < page_size; i++) {
> > > +		zeros += hweight8(~*b++);
> > > +		if (zeros > max_zeros)
> > > +			return -1;
> > > +	}
> > > +
> > > +	if (zeros)
> > > +		memset(data, 0xff, page_size);
> > 
> > It seems like you're not considering the spare area at all. What if this
> > is a mostly-blank page, with ECC data, but most of the bitflips are in
> > the spare area? Then you will "correct" this page to all 0xFF, not
> > noticing that this was really not a blank page at all.
> 
> I could really use Angus' advice on this one.  Although, I fear he may
> have disappeared into the cosmos.  If I remember correctly (I'm
> getting rusty on this now), this controller doesn't allow access to
> the spare area easily.  I think it's all handled automatically
> i.e. without intervention.

That's tough. It's pretty hard to support NAND without *any* access to
spare area.

> > > +
> > > +	return zeros;
> > > +}
> > > +
...
> > > +static int bch_read(struct mtd_info *mtd, struct nand_chip *chip,
> > > +			 uint8_t *buf, int oob_required, int page)
> > > +{
> > > +	struct nandi_controller *nandi = chip->priv;
> > > +	uint32_t page_size = mtd->writesize;
> > > +	loff_t offs = page * page_size;
> > 
> > 32-bit overflow
> 
> Okay, will cast to loff_t.
> 
> > > +	bool bounce = false;
> > > +	uint8_t *p;
> > > +	int ret;
> > > +
> > > +	if (((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
> > > +	    (!virt_addr_valid(buf))) /* vmalloc'd buffer! */
> > > +		bounce = true;
> > > +
> > > +	p = bounce ? nandi->page_buf : buf;
> > 
> > It looks like you're reimplementing NAND_USE_BOUNCE_BUFFER. Can you try
> > using that flag? (You may need to extend it to account for your DMA
> > alignment, too.)
> 
> This didn't exist when I submitted.

I understand the difficulty. Given a long enough time between patch
revision submissions, there's almost always *something* new.

> I'll see what it's trying to do.
> 
> > > +
> > > +	ret = bch_read_page(nandi, offs, p);
> > > +
> > > +	if (bounce)
> > > +		memcpy(buf, p, page_size);
> > > +
> > > +	return ret;
> > > +}
> > > +
...
> > > +static int bch_block_markbad(struct mtd_info *mtd, loff_t offs)
> > > +{
> > > +	struct nand_chip *chip = mtd->priv;
> > > +	struct nandi_controller *nandi = chip->priv;
> > > +
> > > +	uint32_t block;
> > > +	int ret;
> > > +
> > > +	/* Is block already considered bad? (will also catch invalid offsets) */
> > > +	ret = mtd_block_isbad(mtd, offs);
> > 
> > You're violating some of the layering here; the low-level driver
> > probably shouldn't be calling the high-level mtd_*() APIs.
> 
> I'll try to figure out a way to keep the low-level code, low level.

I was actually second-guessing my statement above after I wrote it.
You'll notice that nand_bbt uses mtd_read() and mtd_read_oob().

But then, this is all moot, because I'm pretty sure this check is
redundant. Note in nand_block_markbad():

	ret = nand_block_isbad(mtd, ofs);
	if (ret) {
		/* If it was bad already, return success and do nothing */
		if (ret > 0)
			return 0;

So I think you can drop any bad block check within bch_block_markbad().

> > On a similar
> > note, I'm not 100% confident that the nand_base/nand_bbt separation is
> > written cleanly enough for easy maintenance of your nand_base + ST BBT
> > code in parallel. I might need a second look at that, and I think
> > modularizing your BBT code to a separate file could help ease this a
> > little.
> 
> I have moved all of the BBT code out, but actually have no intention
> of using them separately, as the vendor specific code is believed to
> be more robust.

That may be the case, and that's actually all the more reason to
separate it cleanly; robustness features can be borrowed to nand_bbt
more easily, or other drivers might even use your BBT as-is.

> > > +	if (ret < 0)
> > > +		return ret;
> > > +	if (ret == 1)
> > > +		return 0;
> > > +
> > > +	/* Mark bad */
> > > +	block = offs >> chip->phys_erase_shift;
> > > +	bbt_set_block_mark(nandi->info.bbt_info.bbt, block, BBT_MARK_BAD_WEAR);
> > > +
> > > +	/* Update BBTs, incrementing bbt_vers */
> > > +	ret = bch_update_bbts(nandi, &nandi->info.bbt_info,
> > > +			      NAND_IBBT_UPDATE_BOTH,
> > > +			      nandi->info.bbt_info.bbt_vers[0] + 1);
> > > +
> > > +	return ret;
> > > +}
...
> > > +#ifdef CONFIG_PM
> > 
> > Should this be CONFIG_PM_SLEEP?
> > 
> > > +static int stm_nand_bch_suspend(struct device *dev)
> > > +{
> > > +	struct nandi_controller *nandi = dev_get_drvdata(dev);
> > > +
> > > +	nandi_clk_disable(nandi);
> > > +
> > > +	return 0;
> > > +}
> > > +static int stm_nand_bch_resume(struct device *dev)
> > > +{
> > > +	struct nandi_controller *nandi = dev_get_drvdata(dev);
> > > +
> > > +	nandi_clk_enable(nandi);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int stm_nand_bch_restore(struct device *dev)
> > > +{
> > > +	struct nandi_controller *nandi = dev_get_drvdata(dev);
> > > +	struct stm_plat_nand_bch_data *pdata = dev->platform_data;
> > > +	struct stm_nand_bank_data *bank = pdata->bank;
> > > +
> > > +	nandi_init_controller(nandi, bank->csn);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static const struct dev_pm_ops stm_nand_bch_pm_ops = {
> > > +	.suspend = stm_nand_bch_suspend,
> > > +	.resume = stm_nand_bch_resume,
> > > +	.restore = stm_nand_bch_restore,
> > > +};
> > > +#else
> > > +static const struct dev_pm_ops stm_nand_bch_pm_ops;
> > 
> > I think this might as well be:
> > 
> > #define stm_nand_bch_pm_ops	NULL
> 
> Actually, I think it's all better written with SET_SYSTEM_SLEEP_PM_OPS()

Or even better, SIMPLE_DEV_PM_OPS().

> > > +#endif
...

Brian
