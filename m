Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbbA2HoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:44:18 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36001 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbbA2HoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:44:16 -0500
Date: Thu, 29 Jan 2015 08:44:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dvhart@infradead.org, andy.shevchenko@gmail.com,
        boon.leong.ong@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Message-ID: <20150129074411.GA4817@gmail.com>
References: <1422470186-7860-1-git-send-email-pure.logic@nexus-software.ie>
 <1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422470186-7860-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:

> Intel's Quark X1000 SoC contains a set of registers called 
> Isolated Memory Regions. IMRs are accessed over the IOSF 
> mailbox interface. IMRs are areas carved out of memory that 
> define read/write access rights to the various system agents 
> within the Quark system. For a given agent in the system it is 
> possible to specify if that agent may read or write an area of 
> memory defined by an IMR with a granularity of 1 KiB.

A couple of minor details:

> +	if (ret)
> +		goto done;
> +
> +	/* Lock bit must be set separately to addr_lo address bits. */
> +	if (lock) {
> +		imr->addr_lo |= IMR_LOCK;
> +		ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +					reg - IMR_NUM_REGS, imr->addr_lo);
> +		if (ret)
> +			goto done;
> +	}
> +
> +	local_irq_restore(flags);
> +	return 0;
> +done:
> +	/*
> +	 * If writing to the IOSF failed then we're in an unknown state,
> +	 * likely a very bad state. An IMR in an invalid state will almost
> +	 * certainly lead to a memory access violation.
> +	 */
> +	local_irq_restore(flags);
> +	WARN(ret, "IOSF-MBI write fail range 0x%08x-0x%08x unreliable\n",
> +	     imr_to_phys(imr->addr_lo), imr_to_phys(imr->addr_hi) + IMR_MASK);
> +
> +	return ret;
> +}

looks like the 'done' label really wants to be 'error' or 
'failed'?

Also, if this message ever triggers in practice, if the IMR is in 
a likely bad state, we might as well attempt to turn it off, so 
that we have a chance to get the log out and all that?

> +
> +/**
> + * imr_dbgfs_state_show - print state of IMR registers.
> + *
> + * @s:		pointer to seq_file for output.
> + * @unused:	unused parameter.
> + * @return:	0 on success or error code passed from mbi_iosf on failure.
> + */
> +static int imr_dbgfs_state_show(struct seq_file *s, void *unused)
> +{
> +	phys_addr_t base;
> +	phys_addr_t end;
> +	int i;
> +	struct imr_device *idev = s->private;
> +	struct imr_regs imr;
> +	size_t size;
> +	int ret = -ENODEV;
> +
> +	mutex_lock(&idev->lock);
> +
> +	for (i = 0; i < idev->max_imr; i++) {
>
> +int imr_add_range(phys_addr_t base, size_t size,
> +		  unsigned int rmask, unsigned int wmask, bool lock)
> +{
> +	phys_addr_t end;
> +	unsigned int i;
> +	struct imr_device *idev = &imr_dev;
> +	struct imr_regs imr;
> +	int reg;
> +	int ret;
> +
> +	if (idev->init == false)
> +		return -ENODEV;

You might want to add a WARN_ONCE() here? Someone tried to add an 
IMR but has done it too early. Return values get ignored so 
often, kernel messages not so much.

(Just like imr_check_range() does emit warnings.)

> +	ret = imr_check_range(base, size);
> +	if (ret)
> +		return ret;
> +
> +	if (size == 0)
> +		return -EINVAL;

Looks like the zero-size check could be added to 
imr_check_range(), and be renamed to imr_check_params() or so?

> +	/* Tweak the size value. */
> +	size = imr_fixup_size(size);

So why not add a 'raw_size' (or so) variable and use that, to not 
confuse user provided size with the offset-corrected size?

Then imr_fixup_size() could be renamed to imr_raw_size() as well, 
making it slightly easier on the eyes as well.

> +	end = base + size;
> +
> +	/*
> +	 * Check for reserved IMR value common to firmware, kernel and grub
> +	 * indicating a disabled IMR.
> +	 */
> +	imr.addr_lo = phys_to_imr(base);
> +	imr.addr_hi = phys_to_imr(end);
> +	imr.rmask = rmask;
> +	imr.wmask = wmask;
> +	if (!imr_is_enabled(&imr))
> +		return -EINVAL;
> +
> +	mutex_lock(&idev->lock);
> +
> +	/*
> +	 * Find a free IMR while checking for an existing overlapping range.
> +	 * Note there's no restriction in silicon to prevent IMR overlaps.
> +	 * For the sake of simplicity and ease in defining/debugging an IMR
> +	 * memory map we exclude IMR overlaps.
> +	 */
> +	reg = -1;
> +	for (i = 0; i < idev->max_imr; i++) {
> +		ret = imr_read(idev, i, &imr);
> +		if (ret)
> +			goto done;
> +
> +		/* Find overlap @ base or end of requested range. */
> +		if (imr_is_enabled(&imr)) {
> +			if (imr_address_overlap(base, &imr)) {
> +				ret = -EINVAL;
> +				goto done;
> +			}
> +			if (imr_address_overlap(end, &imr)) {
> +				ret = -EINVAL;
> +				goto done;
> +			}
> +		} else {
> +			reg = i;
> +		}
> +	}
> +
> +	/* Error out if we have no free IMR entries. */
> +	if (reg == -1) {
> +		ret = -ENODEV;
> +		goto done;
> +	}
> +
> +	pr_debug("IMR %d phys %pa-%pa rmask 0x%08x wmask 0x%08x\n",
> +		reg, &base, &end, rmask, wmask);
> +
> +	/* Allocate IMR. */

Technically we don't 'allocate' the IMR here, we write to an 
existing, currently disabled IMR, right?

> +	imr.addr_lo = phys_to_imr(base);
> +	imr.addr_hi = phys_to_imr(end);
> +	imr.rmask = rmask;
> +	imr.wmask = wmask;
> +
> +	ret = imr_write(idev, reg, &imr, lock);
> +
> +done:

So 'done:' should really be named 'fail:'.

> +	mutex_unlock(&idev->lock);
> +	return ret == 0 ? reg : ret;

So we have a variable named 'ret', but it turns out to not be the 
return value after all?

Why not just 'ret'? It's not like users of this API are supposed 
to know about the internals of the IMR code: in which register it 
was stored and such. (See my comments below about the removal 
API.)

If this is simply an MTRR leftover then good riddance!

> +}
> +EXPORT_SYMBOL(imr_add_range);

That should really be EXPORT_SYMBOL_GPL().

> +/**
> + * imr_remove_range - delete an Isolated Memory Region.
> + *
> + * This function allows you to delete an IMR by its index specified by reg or
> + * by address range specified by base and size respectively. If you specify an
> + * index on its own the base and size parameters are ignored.
> + * imr_remove_range(0, size, base); delete IMR at index 0 base/size ignored.
> + * imr_remove_range(-1, base, size); delete IMR from base to base+size.
> + *
> + * @reg:	imr index to remove.
> + * @base:	physical base address of region aligned to 1 KiB.
> + * @size:	physical size of region in bytes aligned to 1 KiB.
> + * @return:	-EINVAL on invalid range or out or range id
> + *		-ENODEV if reg is valid but no IMR exists or is locked
> + *		0 on success.
> + */
> +int imr_remove_range(int reg, phys_addr_t base, size_t size)

I think this API should lose the MTRR-ism as well: instead of 
allowing this weird deletion by index and by address as well, 
just split it in two variants, and only allow external users to 
delete by address.

That will simplify things and will allow future enhancements as 
well: like transparent merging and even reshuffling of IMRs, 
should the need arise.

> +{
> +	phys_addr_t end;
> +	bool found = false;
> +	unsigned int i;
> +	struct imr_device *idev = &imr_dev;
> +	struct imr_regs imr;
> +	int ret = 0;
> +
> +	if (idev->init == false)
> +		return -ENODEV;
> +
> +	if (imr_check_range(base, size))
> +		return -EINVAL;
> +
> +	if (reg >= idev->max_imr)
> +		return -EINVAL;
> +
> +	/* Tweak the size value. */
> +	size = imr_fixup_size(size);
> +	end = base + size;
> +
> +	mutex_lock(&idev->lock);
> +
> +	if (reg >= 0) {
> +		/* If a specific IMR is given try to use it. */
> +		ret = imr_read(idev, reg, &imr);
> +		if (ret)
> +			goto done;
> +
> +		if (!imr_is_enabled(&imr) || imr.addr_lo & IMR_LOCK) {
> +			ret = -ENODEV;
> +			goto done;
> +		}
> +		found = true;

By my simplification suggestions above this branch would go away 
from the external API.

> +	} else {
> +		/* Search for match based on address range. */
> +		for (i = 0; i < idev->max_imr; i++) {
> +			ret = imr_read(idev, i, &imr);
> +			if (ret)
> +				goto done;
> +
> +			if (!imr_is_enabled(&imr) || imr.addr_lo & IMR_LOCK)
> +				continue;
> +
> +			if ((imr_to_phys(imr.addr_lo) == base) &&
> +			    (imr_to_phys(imr.addr_hi) == end)) {
> +				found = true;
> +				reg = i;
> +				break;
> +			}
> +		}
> +	}
> +
> +	if (found == false) {

So writing this as:

	if (!found) {

is a lot more readable, right?

> +		ret = -ENODEV;
> +		goto done;
> +	}
> +
> +	/* Tear down the IMR. */
> +	imr.addr_lo = 0;
> +	imr.addr_hi = 0;
> +	imr.rmask = IMR_READ_ACCESS_ALL;
> +	imr.wmask = IMR_WRITE_ACCESS_ALL;
> +
> +	ret = imr_write(idev, reg, &imr, false);

So 'ret' here gets mixed with other potential failure modes.

If imr_write() fails here then that's a highly anomalous internal 
failure - so it might be better to add a WARN_ON(ret) or so.

> +
> +done:

s/done/failed/, or so.

> +	mutex_unlock(&idev->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(imr_remove_range);

Please make all new kernel internal symbol exports _GPL.

> +
> +/**
> + * imr_fixup_memmap - Tear down IMRs used during bootup.
> + *
> + * BIOS and Grub both setup IMRs around compressed kernel, initrd memory
> + * that need to be removed before the kernel hands out one of the IMR
> + * encased addresses to a downstream DMA agent such as the SD or Ethernet.
> + * IMRs on Galileo are setup to immediately reset the system on violation.
> + * As a result if you're running a root filesystem from SD - you'll need
> + * the boot-time IMRs torn down or you'll find seemingly random resets when
> + * using your filesystem.
> + *
> + * @idev:	pointer to imr_device structure.
> + * @return:
> + */
> +static void __init imr_fixup_memmap(struct imr_device *idev)
> +{
> +	phys_addr_t base = virt_to_phys(&_text);
> +	size_t size = virt_to_phys(&__end_rodata) - base;
> +	int i;
> +	int ret;
> +
> +	/* Tear down all existing unlocked IMRs. */
> +	for (i = 0; i < idev->max_imr; i++)
> +		imr_remove_range(i, 0, 0);

This would use a simpler variant of imr_remove_range() which is 
basically just an imr_write(). It might even be written as an 
imr_clear() helper.

> +
> +	/*
> +	 * Setup a locked IMR around the physical extent of the kernel
> +	 * from the beginning of the .text secton to the end of the
> +	 * .rodata section as one physically contiguous block.
> +	 */
> +	ret = imr_add_range(base, size, IMR_CPU, IMR_CPU, true);
> +	if (ret < 0)
> +		pr_err("unable to setup IMR for kernel: (%p - %p)\n",
> +			&_text, &__end_rodata);
> +	else
> +		pr_info("protecting kernel .text - .rodata: %zu KiB (%p - %p)\n",
> +			size / 1024, &_text, &__end_rodata);

Curly braces around multi-line statements and all that.

> --- /dev/null
> +++ b/arch/x86/platform/intel-quark/imr_selftest.c
> @@ -0,0 +1,135 @@
> +/**
> + * imr_selftest.c
> + *
> + * Copyright(c) 2013 Intel Corporation.
> + * Copyright(c) 2015 Bryan O'Donoghue <pure.logic@nexus-software.ie>
> + *
> + * IMR self test. The purpose of this module is to run a set of tests on the
> + * IMR API to validate it's sanity. We check for overlapping, reserved
> + * addresses and setup/teardown sanity.
> + *
> + */

Looks like we could shrink the kernel source code by 3 bytes 
there!

In any case, I don't see any major problems with this code, so if 
it's fixed it could go into v3.20.

Thanks,

	Ingo
