Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbbAFHgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:36:49 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54376 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAFHgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:36:47 -0500
Date: Mon, 5 Jan 2015 23:36:34 -0800
From: Darren Hart <dvhart@infradead.org>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
Message-ID: <20150106073634.GB59754@vmdeb7>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
 <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 05:23:02PM +0000, Bryan O'Donoghue wrote:
> Intel's Quark X1000 SoC contains a set of registers called Isolated Memory
> Regions. IMRs are accessed over the IOSF mailbox interface. IMRs are areas
> carved out of memory that define read/write access rights to the various
> system agents within the Quark system. For a given agent in the system it is
> possible to specify if that agent may read or write an area of memory
> defined by an IMR with a granularity of 1 kilobyte.
> 
> Quark_SecureBootPRM_330234_001.pdf section 4.5 details the concept of IMRs

I won't repeat Andy's review, so please incorporate his suggestions unless I
specifically contradict him below... (which I don't intend to do...)

> 
> eSRAM flush, CPU Snoop, CPU SMM Mode, CPU non-SMM mode, PMU and VC0/VC1 can
> have individual read/write access masks applied to them for a given memory
> region in Quark X1000. Quark supports eightIMR sets.
> 
> Since all of the DMA capable SoC components in the X1000 are mapped to VC0

Please define less common acronymns the first time they are used:
Virtual Channel 0 (VC0)

> it is possible to define sections of memory as invalid for DMA write
> operations originating from Ethernet, USB, SD and any other DMA capable
> south-cluster component on VC0. Similarly it is possible to mark kernel
> memory as non-SMM mode read/write only or to mark BIOS runtime memory as SMM
> mode accessible only depending on the particular memory footprint on a given
> system.
> 
> On an IMR violation Quark SoC X1000 systems are configured to reset the
> system, so ensuring that the IMR memory map agrees with the EFI provided
> memory map is critical to ensure no IMR violations reset the system.
> 
> The API for accessing IMRs is based on MTRR code but doesn't provide a /proc
> or /sys interface to manipulate IMRs. Defining the size and extent of IMRs
> is exclusively the domain of in-kernel code.
> 

This provides a good description of what IMRs are and how they are used on X1000
SoCs, but it doesn't tell me what to expect in the following patch.

> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>

Since you have Intel (C) below and then your own, are you the sole author?

> ---
>  arch/x86/Kconfig                   |  23 ++
>  arch/x86/include/asm/imr.h         |  79 ++++++
>  arch/x86/include/asm/intel-quark.h |  31 +++
>  arch/x86/kernel/Makefile           |   1 +
>  arch/x86/kernel/imr.c              | 529 +++++++++++++++++++++++++++++++++++++
>  5 files changed, 663 insertions(+)
>  create mode 100644 arch/x86/include/asm/imr.h
>  create mode 100644 arch/x86/include/asm/intel-quark.h
>  create mode 100644 arch/x86/kernel/imr.c
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ba397bd..8303ca2 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -526,6 +526,29 @@ config IOSF_MBI_DEBUG
>  
>  	  If you don't require the option or are in doubt, say N.
>  
> +config IMR
> +	tristate "Isolated Memory Region support"
> +	default m
> +	depends on IOSF_MBI
> +	---help---
> +	  This option enables support for Isolated Memory Regions.

It supports manipulating them specifically, correct? No support is needed to
trigger an IMR violation and reboot the system, that happens in
hardware/firmware without any OS involvement. So we're specifically providing
the means to manipulate the IMRs.

> +	  IMRs are a set of registers that define read and write access masks
> +	  to prohibit certain system agents from accessing memory with 1k
> +	  granularity.

New line

> +	  IMRs make it possible to control read/write access to an address
> +	  by hardware agents inside the SoC. Read and write masks can be
> +	  defined for

colon

> +		- SMM mode
> +		- Non SMM mode
> +		- PCI VC0/VC1
> +		- CPU snoop
> +		- eSRAM flush
> +		- PMU access

New line

> +	  Quark contains a set of IMR registers and makes use of those

set of eight?

> +	  registers during it's bootup process.

its

> +
> +	  If you are running on a Galileo/Quark say Y here

period

> +
>  config X86_RDC321X
>  	bool "RDC R-321x SoC"
>  	depends on X86_32
> diff --git a/arch/x86/include/asm/imr.h b/arch/x86/include/asm/imr.h
> new file mode 100644
> index 0000000..fe8f3b8
> --- /dev/null
> +++ b/arch/x86/include/asm/imr.h
> @@ -0,0 +1,79 @@
> +/*
> + * imr.h: Isolated Memory Region API
> + *
> + * Copyright(c) 2013 Intel Corporation.
> + * Copyright(c) 2014 Bryan O'Donoghue <pure.logic@nexus-software.ie>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +#ifndef _IMR_H
> +#define _IMR_H
> +
> +#include <asm/intel-quark.h>
> +#include <linux/types.h>
> +
> +/*
> + * Right now IMRs are not reported via CPUID though it'd be really great if
> + * future silicon did report via CPUID for this feature bringing it in-line with
> + * other similar features - like MTRRs, MSRs etc.

I think we can drop the editorializing :-)

/*
 * Unfortunately, IMRs are not reported via CPUID, unlike MTRRs, MSRs, etc.
 * Define a macro analogous to cpu_has_x type features.
 */

> + *
> + * A macro is defined here which is an analog to the other cpu_has_x type
> + * features
> + */
> +#define cpu_has_imr cpu_is_quark
> +
> +/* IMR agent access mask bits */
> +#define IMR_ESRAM_FLUSH		0x80000000
> +#define IMR_CPU_SNOOP		0x40000000
> +#define IMR_HB_ACCESS		0x20000000
> +#define IMR_VC1_ID3		0x00008000
> +#define IMR_VC1_ID2		0x00004000
> +#define IMR_VC1_ID1		0x00002000
> +#define IMR_VC1_ID0		0x00001000
> +#define IMR_VC0_ID3		0x00000800
> +#define IMR_VC0_ID2		0x00000400
> +#define IMR_VC0_ID1		0x00000200
> +#define IMR_VC0_ID0		0x00000100
> +#define IMR_SMM			0x00000002
> +#define IMR_NON_SMM		0x00000001
> +#define IMR_ACCESS_NONE		0x00000000
> +
> +/* Definition of read/write masks from published BSP code */
> +#define IMR_READ_ACCESS_ALL	0xBFFFFFFF
> +#define IMR_WRITE_ACCESS_ALL	0xFFFFFFFF
> +
> +/* Number of IMRs provided by Quark X1000 SoC */
> +#define QUARK_X1000_IMR_NUM	0x07

Hrm, I thought there were 8?

...

> diff --git a/arch/x86/kernel/imr.c b/arch/x86/kernel/imr.c
> new file mode 100644
> index 0000000..4115138
> --- /dev/null
> +++ b/arch/x86/kernel/imr.c
> @@ -0,0 +1,529 @@
> +/**
> + * intel_imr.c
> + *
> + * Copyright(c) 2013 Intel Corporation.
> + * Copyright(c) 2014 Bryan O'Donoghue <pure.logic@nexus-software.ie>
> + *
> + * IMR registers define an isolated region of memory that can
> + * be masked to prohibit certain system agents from accessing memory.
> + * When a device behind a masked port performs an access - snooped or not, an
> + * IMR may optionally prevent that transaction from changing the state of memory
> + * or from getting correct data in response to the operation.
> + * Write data will be dropped and reads will return 0xFFFFFFFF, the system will
> + * reset and system BIOS will print out an error message to inform the user that
> + * an IMR has been violated.
> + * This code is based on the Linux MTRR code and refernece code from Intel's
> + * Quark BSP EFI, Linux and grub code.

The above text block is oddly formatted. Please wrap to a uniform width (72 or
so) and use a blank line between paragraphs.

> + */
> +#include <asm/intel-quark.h>
> +#include <asm/imr.h>
> +#include <asm/iosf_mbi.h>
> +#include <linux/debugfs.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +
> +struct imr_device {
> +	struct dentry	*debugfs_dir;
> +	struct mutex	lock;
> +	int		num;
> +	int		used;
> +	int		reg_base;
> +};
> +
> +static struct imr_device imr_dev;
> +
> +/**
> + * Values derived from published code in Quark BSP

Also in the datasheet here:

https://communities.intel.com/servlet/JiveServlet/previewBody/21828-102-2-25120/329676_QuarkDatasheet.pdf

> + *
> + * addr_lo
> + * 31		Lock bit
> + * 30		Enable bit - not implemented on Quark X1000

With the exception of bit 30, also marked as reserved per the above datasheet.
I'd prefer to reference the datasheet where possible rather than soon to be
obsolete code (assuming this is meant to replace it?)

> + * 29:25	Reserved
> + * 24:2		1 kilobyte aligned lo address

The above spec uses 23:2. Is it incorrect?
Section 12.7.4.5

> + * 1:0		Reserved
> + *
> + * addr_hi
> + * 31:25	Reserved
> + * 24:2		1 kilobyte aligned hi address
> + * 1:0		Reserved
> + */
> +#define IMR_LOCK	0x80000000
> +#define IMR_ENABLE	0x04000000
> +
> +struct imr {
> +	u32 addr_lo;
> +	u32 addr_hi;
> +	u32 rmask;
> +	u32 wmask;
> +};
> +
> +#define IMR_NUM_REGS	(sizeof(struct imr)/sizeof(u32))

Perhaps call the imr imr_regs so nobody breaks this in the future by adding
something other than a u32 to it? Alternatively, use a datatype that enforces
this... like the union Andy suggested...

> +#define IMR_SHIFT	8
> +#define imr_to_phys(x)	(x << IMR_SHIFT)
> +#define phys_to_imr(x)	(x >> IMR_SHIFT)
> +
> +/**
> + * imr_enabled
> + * Determines if an IMR is enabled based on address range
> + *
> + * @imr:	Pointer to IMR descriptor
> + * @return	true if IMR enabled false if disabled
> + */
> +static int imr_enabled(struct imr *imr)
> +{
> +	return (imr_to_phys(imr->addr_lo) && imr_to_phys(imr->addr_hi));

What are testing here? You have bit 30 marked as "Enabled" above (but it isn't
in the datasheet). With Reserved bits in each register, this test for non-zero
doesn't seem robust.

> +}

...

> +/**
> + * imr_write
> + * Write an IMR at a given imr index. Requires caller to hold imr mutex
> + * Note lock bits need to be written independently of address bits
> + *
> + * @imr_id:	IMR entry to write
> + * @imr:	IMR structure representing address and access masks
> + * @lock:	Indicates if the IMR lock bit should be applied
> + * @return	0 on success or error code passed from mbi_iosf on failure
> + */
> +static int imr_write(u32 imr_id, struct imr *imr, bool lock)
> +{
> +	unsigned long flags;
> +	u32 reg = imr_dev.reg_base + (imr_id * IMR_NUM_REGS);
> +	u32 reg_lock = reg;
> +	int ret;
> +
> +	local_irq_save(flags);
> +
> +	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE, reg,
> +				imr->addr_lo);
> +	if (ret)
> +		goto done;
> +
> +	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +				++reg, imr->addr_hi);
> +	if (ret)
> +		goto done;
> +
> +	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +				++reg, imr->rmask);
> +	if (ret)
> +		goto done;
> +
> +	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +				++reg, imr->wmask);
> +	if (ret)
> +		goto done;
> +
> +	/* Lock bit must be set separately to addr_lo address bits */
> +	if (lock) {
> +		imr->addr_lo |= IMR_LOCK;
> +		ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +					reg_lock, imr->addr_lo);
> +	}
> +
> +done:
> +	local_irq_restore(flags);
> +
> +	/*
> +	 * If writing to the IOSF failed then we're in an unknown state

comma at end

> +	 * likely a very bad state. An IMR in an invalid state will almost
> +	 * certainly lead to a memory access violation.
> +	 */
> +	if (ret)
> +		WARN(1, "IOSF-MBI write fail range 0x%08x-0x%08x unreliable\n",

No need for the redundant if test.

WARN(ret, "IOSF...

> +			imr_to_phys(imr->addr_lo),
> +			imr_to_phys(imr->addr_hi) + IMR_MASK);
> +
> +	return ret;
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +/**
> + * imr_dbgfs_state_show
> + * Print state of IMR registers
> + *
> + * @s:		pointer to seq_file for output
> + * @unused:	unused parameter
> + * @return	0 on success or error code passed from mbi_iosf on failure
> + */
> +static int imr_dbgfs_state_show(struct seq_file *s, void *unused)
> +{
> +	int i, ret = -ENODEV;

One line per variable please (per CodingStyle).
...

> +/**
> + * imr_debugfs_register
> + * Register debugfs hooks
> + *
> + * @imr:	IMR structure representing address and access masks
> + * @return	0 on success - errno on failure
> + */
> +static int imr_debugfs_register(struct imr_device *imr_dev)
> +{
> +	struct dentry *dir, *f;
> +
> +	dir = debugfs_create_dir("imr", NULL);
> +	if (!dir)
> +		return -ENOMEM;
> +
> +	f = debugfs_create_file("state", S_IFREG | S_IRUGO,
> +				dir, imr_dev, &imr_state_ops);
> +	if (!f)
> +		goto err;

		return -ENODEV;

And drop the err: label below.

> +
> +	imr_dev->debugfs_dir = dir;
> +
> +	return 0;
> +err:
> +	return -ENODEV;
> +}

...

> +/**
> + * imr_debugfs_unregister
> + * Dummy hook for !CONFIG_DEBUG_FS
> + *
> + * @imr:	IMR structure representing address and access masks
> + * @return	none
> + */
> +static void imr_debugfs_unregister(struct imr_device *imr_dev)
> +{
> +}
> +
> +#endif /* CONFIG_DEBUG_FS */
> +
> +/**
> + * imr_check_range
> + * Check the passed address range for an IMR is aligned
> + *
> + * @base: base address of intended IMR
> + * @size: size of intended IMR
> + * @return zero on valid range -EINVAL on unaligned base/size
> + */
> +static int imr_check_range(unsigned long base, unsigned long size)
> +{
> +	if ((base & (IMR_MASK)) || (size & (IMR_MASK))) {
> +		pr_warn("imr: base 0x%08lx size 0x%08lx must align to 1k\n",
> +			base, size);
> +		dump_stack();
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/**
> + * imr_add_range
> + * Add an Isolated Memory Region
> + *
> + * @base: Physical base address of region aligned to 4k
> + * @size: Physical size of region in bytes
> + * @read_mask: Read access mask
> + * @write_mask: Write access mask
> + * @lock: Indicates whether or not to permenantly lock this region
> + * @return: Index of the IMR allocated or negative value indicating error
> + */
> +int imr_add(unsigned long base, unsigned long size,
> +	    unsigned int rmask, unsigned int wmask, bool lock)
> +{
> +	unsigned long end = base + size;
> +	struct imr imr;
> +	int reg, i, overlap, ret;
> +
> +	if (imr_check_range(base, size))
> +		return -EINVAL;
> +
> +	if (!size) {
> +		pr_warn("imr: invalid size zero!\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&imr_dev.lock);
> +
> +	/* Find an free IMR while checking for an existing overlapping range */
> +	overlap = 0;
> +	reg = -1;
> +	for (i = 0; i <= imr_dev.num; i++) {
> +		ret = imr_read(i, &imr);
> +		if (ret)
> +			goto done;
> +
> +		/* Find overlap */
> +		if (imr_enabled(&imr)) {
> +			if (base >= imr_to_phys(imr.addr_lo) &&
> +				base <= imr_to_phys(imr.addr_hi)) {
> +				overlap = 1;
> +				break;
> +			}
> +			if (end >= imr_to_phys(imr.addr_lo) &&
> +				end <= imr_to_phys(imr.addr_hi)) {
> +				overlap = 1;
> +				break;
> +			}
> +		} else {
> +			reg = i;
> +		}
> +	}
> +
> +	/* Error out if we have an overlap or no free IMR entries */

According to the datasheet, overlapping ranges are valid, and access must be
granted by all IMRs associated with a given address. Why declare an overlap as
invalid here?

> +	if (overlap) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +	if (reg == -1) {
> +		ret = -ENODEV;
> +		goto done;
> +	}

...

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
