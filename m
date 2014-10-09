Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbaJIOjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:39:37 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:39455 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaJIOjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:39:32 -0400
Date: Thu, 9 Oct 2014 15:39:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 8/9] mtd: nand: stm_nand_bch: add support for ST's BCH
 NAND controller
Message-ID: <20141009143923.GR20647@lee--X1>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
 <1409143344-22458-9-git-send-email-lee.jones@linaro.org>
 <20141006062127.GH3248@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141006062127.GH3248@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> First off, this patch has several checkpatch warnings, some of which
> should be addressed:

Fixed.

> > +/* ONFI define 6 timing modes */
> > +#define ST_NAND_ONFI_TIMING_MODES		6
> 
> This is unused?

Removed.

[...]

> > +static inline void bch_load_prog_cpu(struct nandi_controller *nandi,
> > +				     struct bch_prog *prog)
> > +{
> > +	void __iomem *dst = nandi->base + NANDBCH_ADDRESS_REG_1;
> > +	uint32_t *src = (uint32_t *)prog;
> > +	int i;
> > +
> > +	for (i = 0; i < 16; i++) {
> > +		/* Skip registers marked as "reserved" */
> > +		if (i != 11 && i != 14)
> > +			writel(*src, dst);
> > +		src++;
> > +		dst += sizeof(uint32_t *);
> 
> Are you sure you want to base the increment on the pointer size? This
> looks like it might break if ever used on a 64-bit architecture. You're
> probably just looking for a constant 4, or maybe sizeof(u32).

Fixed

[...]

> > +static int check_erased_page(uint8_t *data, uint32_t page_size, int max_zeros)
> > +{
> > +	uint8_t *b = data;
> > +	int zeros = 0;
> > +	int i;
> > +
> > +	for (i = 0; i < page_size; i++) {
> > +		zeros += hweight8(~*b++);
> > +		if (zeros > max_zeros)
> > +			return -1;
> > +	}
> > +
> > +	if (zeros)
> > +		memset(data, 0xff, page_size);
> > +
> > +	return zeros;
> > +}
> 
> I pointed out some flaws in this function back in July [1]. You said
> you'd look into this one [2]. I really don't want to accept yet another
> custom, unsound erased-page check if at all possible.

That's not quite true.  I said that I think it doesn't matter about
not taking the OOB area into consideration, which I still believe is
the case.  This controller does not allow access into the OOB area.

> > +/* Returns the number of ECC errors, or '-1' for uncorrectable error */
> > +int bch_read_page(struct nandi_controller *nandi,
> > +		  loff_t offs,
> > +		  uint8_t *buf)
> > +{
> > +	struct nand_chip *chip = &nandi->info.chip;
> > +	struct bch_prog *prog = &bch_prog_read_page;
> > +	uint32_t page_size = nandi->info.mtd.writesize;
> > +	unsigned long list_phys;
> 
> Please use dma_addr_t. This is an intentionally opaque (to some degree)
> type.
> 
> > +	unsigned long buf_phys;
> 
> Ditto.
> 
> BTW, is your hardware actually restricted to a 32-bit address space? If
> it has some expanded registers for larger physical address ranges, it'd
> be good to handle the upper bits of the DMA address when mapping. Or
> else, it would be good to reflect this in your driver with
> dma_set_mask() I think.

Yes, it's 32bit only.  I will add a call to dma_set_mask() to reflect
this.

... or not.  See below.

> > +	uint32_t ecc_err;
> > +	int ret = 0;
> > +
> > +	dev_dbg(nandi->dev, "%s: offs = 0x%012llx\n", __func__, offs);
> > +
> > +	BUG_ON(offs & (NANDI_BCH_DMA_ALIGNMENT - 1));
> > +
> > +	emiss_nandi_select(nandi, STM_NANDI_BCH);
> > +
> > +	nandi_enable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
> > +	reinit_completion(&nandi->seq_completed);
> > +
> > +	/* Reset ECC stats */
> > +	writel(CFG_RESET_ECC_ALL | CFG_ENABLE_AFM,
> > +	       nandi->base + NANDBCH_CONTROLLER_CFG);
> > +	writel(CFG_ENABLE_AFM, nandi->base + NANDBCH_CONTROLLER_CFG);
> > +
> > +	prog->addr = (uint32_t)((offs >> (chip->page_shift - 8)) & 0xffffff00);
> > +
> > +	buf_phys = dma_map_single(NULL, buf, page_size, DMA_FROM_DEVICE);
> 
> Why NULL for the first arg? You should use the proper device (which will
> help with the 32-bit / 64-bit masking, I think.
> 
> Also, dma_map_single() can fail. It's good practice to check the return
> value with dma_mapping_error(). Same in a few other places.

If you do not supply the first parameter here, it falls back to
arm_dma_ops, which is what we want.  I guess this is also why we do
not have to set the DMA mask, as we're running on ARM32, rather than
AARCH64.

> > +	memset(nandi->buf_list, 0x00, NANDI_BCH_BUF_LIST_SIZE);
> > +	nandi->buf_list[0] = buf_phys | (nandi->sectors_per_page - 1);
> > +
> > +	list_phys = dma_map_single(NULL, nandi->buf_list,
> > +				   NANDI_BCH_BUF_LIST_SIZE, DMA_TO_DEVICE);

Fixed.

> > +
> > +	writel(list_phys, nandi->base + NANDBCH_BUFFER_LIST_PTR);
> > +
> > +	bch_load_prog_cpu(nandi, prog);
> > +
> > +	bch_wait_seq(nandi);
> > +
> > +	nandi_disable_interrupts(nandi, NANDBCH_INT_SEQNODESOVER);
> > +
> > +	dma_unmap_single(NULL, list_phys, NANDI_BCH_BUF_LIST_SIZE,
> > +			 DMA_TO_DEVICE);
> > +	dma_unmap_single(NULL, buf_phys, page_size, DMA_FROM_DEVICE);
> > +
> > +	/* Use the maximum per-sector ECC count! */
> > +	ecc_err = readl(nandi->base + NANDBCH_ECC_SCORE_REG_A) & 0xff;
> > +	if (ecc_err == 0xff) {
> > +		/*
> > +		 * Downgrade uncorrectable ECC error for an erased page,
> > +		 * tolerating 'bch_ecc_strength' bits at zero.
> > +		 */
> > +		ret = check_erased_page(buf, page_size, chip->ecc.strength);
> 
> I commented in [1] that you don't want to use the full ECC strength
> here.

Actually I took your first suggestion:

  "Couldn't this (more straightforwarly) just be chip->ecc.strength?"

... but I have now fixed it up to blindly /2 instead.

[...]

> > +static int bch_read(struct mtd_info *mtd, struct nand_chip *chip,
> > +			 uint8_t *buf, int oob_required, int page)
> > +{
> > +	struct nandi_controller *nandi = chip->priv;
> > +	uint32_t page_size = mtd->writesize;
> > +	loff_t offs = (loff_t)page * page_size;
> > +	bool bounce = false;
> > +	uint8_t *p;
> > +	int ret;
> > +
> > +	if (((unsigned int)buf & (NANDI_BCH_DMA_ALIGNMENT - 1)) ||
> > +	    (!virt_addr_valid(buf))) /* vmalloc'd buffer! */
> 
> If you really need this custom DMA check, can you at least make it the
> same as in bch_write_page(), and put it in a common macro / static
> inline function?

We absolutely do need it, as the buffers which the framework currently
provide are seldom 64 Byte aligned.  I will provide a static inline
function as requested.

[...]

> > +static int bch_mtd_read_oob(struct mtd_info *mtd,
> > +			    struct nand_chip *chip, int page)
> > +{
> > +	BUG();
> 
> Are you sure this can't be implemented, even if it's not the expected
> mode of operation? That's really unforunate.

It can.  We have a 'special' function for it using the extended
flexible mode.  Trying to upstream this has been hard enough already,
without more crud to deal with.  I will hopefully be adding this
functionality as small, succinct patches subsequently.

> > +	return 0;
> > +}
> > +
> > +static int bch_mtd_write_oob(struct mtd_info *mtd,
> > +			     struct nand_chip *chip, int page)
> > +{
> > +	BUG();
> 
> Same question.

Same answer.

> > +	return 0;
> > +}
> > +
> > +static int bch_read_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
> > +			     uint8_t *buf, int oob_required, int page)
> > +{
> > +	BUG();
> 
> Same question.

Same answer.

> > +	return 0;
> > +}
> > +
> > +static int bch_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
> > +			      const uint8_t *buf, int oob_required)
> > +{
> > +	BUG();
> 
> Same question.

Same answer.

> > +	return 0;
> > +}

[...]

> > +#ifdef CONFIG_MTD_NAND_STM_BCH_BBT
> 
> This #ifdef won't work right when you build the BBT code as a module.
> You may need IS_ENABLED(), and you'll have to ensure you can't make this
> driver built-in while the BBT code is a module.
> 
> One option: just disallow building your BBT code as a module.

Done.

[...]

> > +static int remap_named_resource(struct platform_device *pdev,
> > +				char *name,
> > +				void __iomem **io_ptr)
> > +{
> > +	struct resource *res, *mem;
> > +	resource_size_t size;
> > +	void __iomem *p;
> > +
> > +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
> > +	if (!res)
> > +		return -ENXIO;
> > +
> > +	size = resource_size(res);
> > +
> > +	mem = devm_request_mem_region(&pdev->dev, res->start, size, name);
> > +	if (!mem)
> > +		return -EBUSY;
> > +
> > +	p = devm_ioremap_nocache(&pdev->dev, res->start, size);
> > +	if (!p)
> > +		return -ENOMEM;
> 
> Can you use devm_ioremap_resource() for the above several lines? So:
> 
> 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, name);
> 	*io_ptr = devm_ioremap_resource(&pdev->dev, res);
> 	if (IS_ERR(*io_ptr))
> 		return PTR_ERR(*io_ptr);

I've been staring at this file so long now I'm missing the simple
stuff.  This is of course the new and improved way of doing this
stuff.  I will update.

[...]

> > +static int stm_nand_bch_probe(struct platform_device *pdev)
> > +{
> > +	const char *part_probes[] = { "cmdlinepart", "ofpart", NULL, };
> 
> I feel like I already mentioned this, but maybe that was a different
> driver: you're just using the defaults (see default_mtd_part_types /
> parse_mtd_partitions) so you don't need to supply this array. Just pass
> NULL to mtd_device_parse_register().

I don't recall you mentioning this before, but I could be wrong.

Now fixed.

[...]

> > +	/*
> > +	 * Configure timing registers
> > +	 */
> > +	if (bank && bank->timing_spec) {
> 
> It looks like no one actually sets the 'timing_spec' field any more,
> since you're not getting this info from the device tree any more. Should
> you kill it (and this condition branch)?

Looks that way.

Removed all mention of timing_spec.

[...]

> > +	chip->ecc.size = NANDI_BCH_SECTOR_SIZE;
> > +	chip->ecc.bytes = mtd->oobsize;
> 
> While ecc.bytes is not actually used in a meaningful way for your
> driver (with HWECC), this looks wrong. ecc.bytes should align with this
> code from nand_base.c:
> 
>         /*
>          * Set the number of read / write steps for one page depending on ECC
>          * mode.
>          */
>         ecc->steps = mtd->writesize / ecc->size;
>         if (ecc->steps * ecc->size != mtd->writesize) {
>                 pr_warn("Invalid ECC parameters\n");
>                 BUG();
>         }
>         ecc->total = ecc->steps * ecc->bytes;
> 
> Currently, it looks like ecc->total will be larger than oobsize, which
> doesn't really make sense.
> 
> (Maybe we need a new WARN_ON(ecc->total > mtd->oobsize) in
> nand_scan_tail()?)

[...]

> > +struct device_node *stm_of_get_partitions_node(struct device_node *np,
> > +					       int bank_nr)
> > +{
> > +	struct device_node *banknp, *partsnp = NULL;
> > +	char name[10];
> > +
> > +	sprintf(name, "bank%d", bank_nr);
> > +	banknp = of_get_child_by_name(np, name);
> > +	if (banknp)
> > +		return NULL;
> > +
> > +	partsnp = of_get_child_by_name(banknp, "partitions");
> > +	of_node_put(banknp);
> > +
> > +	return partsnp;
> > +}
> > +EXPORT_SYMBOL(stm_of_get_partitions_node);
> 
> If you follow my advice on the DT binding structure, you don't need this
> helper function at all.

It's gone.

> > +/**
> > + * stm_of_get_nand_banks - Get nand banks info from a given device node.
> > + *
> > + * @dev			device pointer to use for devm allocations.
> > + * @np			device node of the driver.
> > + * @banksptr		double pointer to banks which is allocated
> > + *			and filled with bank data.
> > + *
> > + * Returns a count of banks found in the given device node.
> > + *
> > + */
> > +int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
> > +			  struct stm_nand_bank_data **banksptr)
> > +{
> > +	struct stm_nand_bank_data *banks;
> > +	struct device_node *banknp;
> > +	int nr_banks = 0;
> > +
> > +	if (!np)
> > +		return -ENODEV;
> > +
> > +	nr_banks = of_get_child_count(np);
> > +	if (!nr_banks) {
> > +		dev_err(dev, "No NAND banks specified in DT: %s\n",
> > +		np->full_name);
> > +		return -EINVAL;
> > +	}
> > +
> > +	*banksptr = devm_kzalloc(dev, sizeof(*banks) * nr_banks, GFP_KERNEL);
> 
> Missing an OOM check here.
> 
> > +	banks = *banksptr;
> > +	banknp = NULL;
> 
> Is this initialization necessary? You overwrite it with the
> for_each_child_of_node() loop.

Both fixed.

> > +	for_each_child_of_node(np, banknp) {
> 
> If you change the DT binding to require a proper compatible property,
> you'll need of_device_is_compatible() here.

I see no reason to allocate a compatible property to the bank
descriptors.  They're not being registered/actioned through
of_platform_populate(), so ...

> Also, might the for_each_available_child_of_node() helper be preferable,
> so you will properly ignore any "disabled" nodes, if they exist?

Right, good catch.

> > +		int bank = 0;
> > +
> > +		of_property_read_u32(banknp, "st,nand-csn", &banks[bank].csn);
> > +
> > +		if (of_get_nand_bus_width(banknp) == 16)
> > +			banks[bank].options |= NAND_BUSWIDTH_16;
> > +		if (of_get_nand_on_flash_bbt(banknp))
> > +			banks[bank].bbt_options |= NAND_BBT_USE_FLASH;
> > +
> > +		banks[bank].nr_partitions = 0;
> > +		banks[bank].partitions = NULL;
> > +
> > +		of_property_read_u32(banknp, "st,nand-timing-relax",
> > +				     &banks[bank].timing_relax);
> > +		bank++;
> > +	}
> > +
> > +	return nr_banks;
> > +}
> > +EXPORT_SYMBOL(stm_of_get_nand_banks);
> > diff --git a/drivers/mtd/nand/stm_nand_dt.h b/drivers/mtd/nand/stm_nand_dt.h
> > new file mode 100644
> > index 0000000..0d2b920
> > --- /dev/null
> > +++ b/drivers/mtd/nand/stm_nand_dt.h

[...]

> > +int stm_of_get_nand_banks(struct device *dev, struct device_node *np,
> > +				 struct stm_nand_bank_data **banksp);
> 
> Hmm, really only two functions? And one of those might be not be needed,
> as I commented above. I don't think you need a separate *_dt.{c,h} file.
> Please merge the two.

Now squashed.

[...]

> > +	int			cached_page;	/* page number of page in */
> > +						/* 'page_buf'             */
> 
> You never use this field, except to set it to '-1'. Perhaps kill it? I
> doubt you actually will win much by trying to cache pages at the driver
> level anyway. It's pretty easy to get wrong too.

Gone.

[...]

> > +extern int flex_read_raw(struct nandi_controller *nandi,
> > +			 uint32_t page_addr,
> > +			 uint32_t col_addr,
> > +			 uint8_t *buf, uint32_t len);
> > +extern uint8_t bch_write_page(struct nandi_controller *nandi,
> > +			      loff_t offs, const uint8_t *buf);
> > +extern uint8_t bch_erase_block(struct nandi_controller *nandi,
> > +			       loff_t offs);
> > +extern int bch_read_page(struct nandi_controller *nandi,
> > +			 loff_t offs, uint8_t *buf);
> 
> This isn't exactly what I had in mind when I suggested the BBT
> implementation be separated from the NAND driver. I don't expect a
> driver to export its internal functions so that the BBT code can link to
> them. I expect the BBT implementation to use indirected versions.
> 
> Particularly, we already had discussion of using the mtd_*() API
> helpers, although there was some conflicting opinion there. At a
> minimum, I think your BBT driver can use the nand_chip function
> callbacks.
> 
> Basically, I think most / all of this header could be disintegrated and
> each driver be written in a more modular fashion. But anyway, if you
> take the first step of removing these exported functions, I think we can
> live with the rest.

No longer exported.

> > +#define EMISS_NAND_CONFIG_HAMMING_NOT_BCH 	(0x1 << 6)
> > +
> > +static inline void emiss_nandi_select(struct nandi_controller *nandi,
> > +				      enum nandi_controllers controller)
> > +{
> > +	unsigned v;
> > +
> > +	v = readl(nandi->emisscfg);
> > +
> > +	if (controller == STM_NANDI_HAMMING) {
> > +		if (v & EMISS_NAND_CONFIG_HAMMING_NOT_BCH)
> > +			return;
> > +		v |= EMISS_NAND_CONFIG_HAMMING_NOT_BCH;
> > +	} else {
> > +		if (!(v & EMISS_NAND_CONFIG_HAMMING_NOT_BCH))
> > +			return;
> > +		v &= ~EMISS_NAND_CONFIG_HAMMING_NOT_BCH;
> > +	}
> > +
> > +	writel(v, nandi->emisscfg);
> > +	readl(nandi->emisscfg);
> > +}
> 
> Any particular reason this function is in the header? It's only used in
> one file.

Yes, there are potentially two other drivers (that hopefully some
other poor sap will try to upstream). :D

> > +#endif /* __LINUX_STM_NAND_H */
> 
> Brian
> 
> [1] http://lists.infradead.org/pipermail/linux-mtd/2014-July/054500.html
> [2] http://lists.infradead.org/pipermail/linux-mtd/2014-July/054881.html

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
