Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaLaPFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:05:05 -0500
Received: from mail-yk0-f179.google.com ([209.85.160.179]:33074 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaLaPFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:05:03 -0500
MIME-Version: 1.0
In-Reply-To: <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie>
	<1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie>
Date: Wed, 31 Dec 2014 17:05:01 +0200
Message-ID: <CAHp75VeYg1oAp5x9OCKOyZGvkt9n4WBRuWV4QPBHbrq+vTzANg@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, dvhart@infradead.org,
        platform-driver-x86@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 7:23 PM, Bryan O'Donoghue
<pure.logic@nexus-software.ie> wrote:
> Intel's Quark X1000 SoC contains a set of registers called Isolated Memory
> Regions. IMRs are accessed over the IOSF mailbox interface. IMRs are areas
> carved out of memory that define read/write access rights to the various
> system agents within the Quark system. For a given agent in the system it is
> possible to specify if that agent may read or write an area of memory
> defined by an IMR with a granularity of 1 kilobyte.

1 KiB? (Check entire patchset).

>
> Quark_SecureBootPRM_330234_001.pdf section 4.5 details the concept of IMRs

Missed dot at the end of sentence.

> eSRAM flush, CPU Snoop, CPU SMM Mode, CPU non-SMM mode, PMU and VC0/VC1 can
> have individual read/write access masks applied to them for a given memory
> region in Quark X1000. Quark supports eightIMR sets.

Missed space.

> Since all of the DMA capable SoC components in the X1000 are mapped to VC0
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
> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
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
>           If you don't require the option or are in doubt, say N.
>
> +config IMR
> +       tristate "Isolated Memory Region support"
> +       default m
> +       depends on IOSF_MBI
> +       ---help---
> +         This option enables support for Isolated Memory Regions.
> +         IMRs are a set of registers that define read and write access masks
> +         to prohibit certain system agents from accessing memory with 1k

1 KiB

> +         granularity.
> +         IMRs make it possible to control read/write access to an address
> +         by hardware agents inside the SoC. Read and write masks can be
> +         defined for
> +               - SMM mode
> +               - Non SMM mode
> +               - PCI VC0/VC1
> +               - CPU snoop
> +               - eSRAM flush
> +               - PMU access
> +         Quark contains a set of IMR registers and makes use of those
> +         registers during it's bootup process.
> +
> +         If you are running on a Galileo/Quark say Y here
> +
>  config X86_RDC321X
>         bool "RDC R-321x SoC"
>         depends on X86_32
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

2015 everywhere I guess.

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
> + *
> + * A macro is defined here which is an analog to the other cpu_has_x type
> + * features
> + */
> +#define cpu_has_imr cpu_is_quark
> +
> +/* IMR agent access mask bits */
> +#define IMR_ESRAM_FLUSH                0x80000000
> +#define IMR_CPU_SNOOP          0x40000000
> +#define IMR_HB_ACCESS          0x20000000
> +#define IMR_VC1_ID3            0x00008000
> +#define IMR_VC1_ID2            0x00004000
> +#define IMR_VC1_ID1            0x00002000
> +#define IMR_VC1_ID0            0x00001000
> +#define IMR_VC0_ID3            0x00000800
> +#define IMR_VC0_ID2            0x00000400
> +#define IMR_VC0_ID1            0x00000200
> +#define IMR_VC0_ID0            0x00000100
> +#define IMR_SMM                        0x00000002
> +#define IMR_NON_SMM            0x00000001
> +#define IMR_ACCESS_NONE                0x00000000

Can it be defined via BIT(x)?

> +
> +/* Definition of read/write masks from published BSP code */
> +#define IMR_READ_ACCESS_ALL    0xBFFFFFFF
> +#define IMR_WRITE_ACCESS_ALL   0xFFFFFFFF
> +
> +/* Number of IMRs provided by Quark X1000 SoC */
> +#define QUARK_X1000_IMR_NUM    0x07
> +#define QUARK_X1000_IMR_REGBASE 0x40
> +
> +/* IMR alignment bits - only bits 31:10 are checked for IMR validity */
> +#define IMR_ALIGN              0x400
> +#define IMR_MASK               (IMR_ALIGN - 1)
> +
> +/**
> + * imr_add_range - Add an Isolated Memory Region
> + * @base: Physical base address of region aligned to 4k
> + * @size: Physical size of region in bytes
> + * @read_mask: Read access mask
> + * @write_mask: Write access mask
> + * @lock: Indicates whether or not to permenantly lock this region

It would be nice to indent descriptions after colon and use small
letter at the beginning. (Check entire patchset)

> + * @return: Index of the IMR allocated or negative value indicating error

Usually it goes as a separate section called Return like:

* Return:
* foo if A, otherwise bar.

> + */

Entire comment block should be in *.c file only.

> +int imr_add(unsigned long base, unsigned long size,

Leave _range suffix here and in the other one. It would be better I think.

> +           unsigned int rmask, unsigned int wmask, bool lock);
> +
> +/**
> + * imr_del_range - Delete an Isolated Memory Region
> + * @reg: IMR index to remove
> + * @base: Physical base address of region aligned to 4k
> + * @size: Physical size of region in bytes
> + * @return:    -EINVAL on invalid range or out or range id
> + *             -ENODEV if reg is valid but no IMR exists or is locked
> + *             0 on success
> + */
> +int imr_del(int reg, unsigned long base, unsigned long size);

Same comments as for add_range.
Could it be imr_remove_range() ?

> +
> +#endif /* _IMR_H */
> diff --git a/arch/x86/include/asm/intel-quark.h b/arch/x86/include/asm/intel-quark.h
> new file mode 100644
> index 0000000..f51ac8c
> --- /dev/null
> +++ b/arch/x86/include/asm/intel-quark.h
> @@ -0,0 +1,31 @@
> +/*
> + * intel-quark.h: Quark shared defines and helper functions
> + *
> + * Copyright 2014 Bryan O'Donoghue <pure.logic@nexus-software.ie>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; version 2
> + * of the License.
> + */
> +
> +#ifndef _ASM_X86_INTEL_QUARK_H
> +#define _ASM_X86_INTEL_QUARK_H
> +
> +#include <asm/processor.h>
> +
> +#ifdef CONFIG_X86_32
> +static inline int cpu_is_quark(const struct cpuinfo_x86 *c)
> +{
> +       return (c->x86_vendor == X86_VENDOR_INTEL &&
> +               c->x86 == 5 && c->x86_model == 9);
> +}
> +#else
> +static inline int cpu_is_quark(const struct cpuinfo_x86 *c)
> +{
> +       return 0;
> +}
> +#endif
> +
> +#endif /* _ASM_X86_INTEL_QUARK_H */

Could we use x86_match_cpu() instead?

> +
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 5d4502c..0252de5 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -104,6 +104,7 @@ obj-$(CONFIG_EFI)                   += sysfb_efi.o
>  obj-$(CONFIG_PERF_EVENTS)              += perf_regs.o
>  obj-$(CONFIG_TRACING)                  += tracepoint.o
>  obj-$(CONFIG_IOSF_MBI)                 += iosf_mbi.o
> +obj-$(CONFIG_IMR)                      += imr.o
>  obj-$(CONFIG_PMC_ATOM)                 += pmc_atom.o
>
>  ###
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
> +       struct dentry   *debugfs_dir;
> +       struct mutex    lock;
> +       int             num;
> +       int             used;
> +       int             reg_base;
> +};
> +
> +static struct imr_device imr_dev;
> +
> +/**

Just /*.

> + * Values derived from published code in Quark BSP
> + *
> + * addr_lo
> + * 31          Lock bit
> + * 30          Enable bit - not implemented on Quark X1000
> + * 29:25       Reserved
> + * 24:2                1 kilobyte aligned lo address
> + * 1:0         Reserved
> + *
> + * addr_hi
> + * 31:25       Reserved
> + * 24:2                1 kilobyte aligned hi address
> + * 1:0         Reserved
> + */
> +#define IMR_LOCK       0x80000000
> +#define IMR_ENABLE     0x04000000

Use BIT(x).

> +
> +struct imr {
> +       u32 addr_lo;
> +       u32 addr_hi;
> +       u32 rmask;
> +       u32 wmask;
> +};
> +
> +#define IMR_NUM_REGS   (sizeof(struct imr)/sizeof(u32))
> +#define IMR_SHIFT      8


> +#define imr_to_phys(x) (x << IMR_SHIFT)
> +#define phys_to_imr(x) (x >> IMR_SHIFT)

x -> (x)

> +
> +/**
> + * imr_enabled
> + * Determines if an IMR is enabled based on address range
> + *
> + * @imr:       Pointer to IMR descriptor
> + * @return     true if IMR enabled false if disabled
> + */
> +static int imr_enabled(struct imr *imr)
> +{
> +       return (imr_to_phys(imr->addr_lo) && imr_to_phys(imr->addr_hi));

No need to surround the return value by parentheses.

> +}
> +
> +/**
> + * imr_read
> + * Read an IMR at a given imr index. Requires caller to hold imr mutex

Summary.
* imr_read - read an IMR at a given index

This one goes to the Description I guess.
* Description:
* Requires caller to hold IMR device mutex.

Same for imr_write().

> + *
> + * @imr_id:    IMR entry to read
> + * @imr:       IMR structure representing address and access masks
> + * @return     0 on success or error code passed from mbi_iosf on failure
> + */
> +static int imr_read(u32 imr_id, struct imr *imr)
> +{
> +       u32 reg = imr_dev.reg_base + (imr_id * IMR_NUM_REGS);

No need to have parentheses.
Same for _write().

> +       int ret;
> +
> +       ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
> +                               reg, &imr->addr_lo);
> +       if (ret)
> +               return ret;
> +
> +       ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
> +                               ++reg, &imr->addr_hi);

Could you use reg++ in previous line and so on?

One more idea, if you make a union inside the structure you may do
this in a loop.
struct imr {
 union {
  struct imr {
 ...
  };
  u32 regs[IMR_NUM_REGS];
 };
}

Mostly same for _write().

> +       if (ret)
> +               return ret;
> +
> +       ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
> +                               ++reg, &imr->rmask);
> +       if (ret)
> +               return ret;
> +
> +       return iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
> +                               ++reg, &imr->wmask);
> +}
> +
> +/**
> + * imr_write
> + * Write an IMR at a given imr index. Requires caller to hold imr mutex
> + * Note lock bits need to be written independently of address bits
> + *
> + * @imr_id:    IMR entry to write
> + * @imr:       IMR structure representing address and access masks
> + * @lock:      Indicates if the IMR lock bit should be applied
> + * @return     0 on success or error code passed from mbi_iosf on failure
> + */
> +static int imr_write(u32 imr_id, struct imr *imr, bool lock)
> +{
> +       unsigned long flags;
> +       u32 reg = imr_dev.reg_base + (imr_id * IMR_NUM_REGS);
> +       u32 reg_lock = reg;

Do we need a separate variable? Would (reg - IMR_NUM_REGS) work for you?

> +       int ret;
> +
> +       local_irq_save(flags);
> +
> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE, reg,
> +                               imr->addr_lo);
> +       if (ret)
> +               goto done;
> +
> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +                               ++reg, imr->addr_hi);
> +       if (ret)
> +               goto done;
> +
> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +                               ++reg, imr->rmask);
> +       if (ret)
> +               goto done;
> +
> +       ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +                               ++reg, imr->wmask);
> +       if (ret)
> +               goto done;
> +
> +       /* Lock bit must be set separately to addr_lo address bits */
> +       if (lock) {
> +               imr->addr_lo |= IMR_LOCK;
> +               ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
> +                                       reg_lock, imr->addr_lo);
> +       }
> +
> +done:
> +       local_irq_restore(flags);

Could you do like

      local_irq_restore(flags);
      return 0;
done:
      local_irq_restore(flags);
      WARN(...)
     return ret;
?

> +
> +       /*
> +        * If writing to the IOSF failed then we're in an unknown state
> +        * likely a very bad state. An IMR in an invalid state will almost
> +        * certainly lead to a memory access violation.
> +        */
> +       if (ret)
> +               WARN(1, "IOSF-MBI write fail range 0x%08x-0x%08x unreliable\n",
> +                       imr_to_phys(imr->addr_lo),
> +                       imr_to_phys(imr->addr_hi) + IMR_MASK);
> +
> +       return ret;
> +}
> +
> +#ifdef CONFIG_DEBUG_FS
> +
> +/**
> + * imr_dbgfs_state_show
> + * Print state of IMR registers
> + *
> + * @s:         pointer to seq_file for output
> + * @unused:    unused parameter
> + * @return     0 on success or error code passed from mbi_iosf on failure
> + */
> +static int imr_dbgfs_state_show(struct seq_file *s, void *unused)
> +{
> +       int i, ret = -ENODEV;
> +       struct imr imr;
> +       u32 size;
> +
> +       mutex_lock(&imr_dev.lock);

It seems you may get the imr_dev via parameters. I suggest to avoid
using global variables as much as possible.

> +
> +       for (i = 0; i <= imr_dev.num; i++) {

num is not num, but last one? Sounds confusing for me.

> +
> +               ret = imr_read(i, &imr);
> +               if (ret)
> +                       break;
> +
> +               /*
> +                * Remember to add IMR_ALIGN bytes to size to indicate the
> +                * inherent IMR_ALIGN size bytes contained in the masked away
> +                * lower ten bits
> +                */
> +               size = 0;

It might be an else branch.

> +               if (imr_enabled(&imr)) {
> +                       size = imr_to_phys(imr.addr_hi) -
> +                              imr_to_phys(imr.addr_lo);

Could it be one line?

> +                       size += IMR_ALIGN;

Could it fit this one too?

> +               }
> +               seq_printf(s, "imr%02i: base=0x%08x, end=0x%08x, size=0x%08x "
> +                          "rmask=0x%08x, wmask=0x%08x, %s, %s\n", i,
> +                          imr_to_phys(imr.addr_lo),
> +                          imr_to_phys(imr.addr_hi) + IMR_MASK, size,
> +                          imr.rmask, imr.wmask,
> +                          imr_enabled(&imr) ? "enabled " : "disabled",
> +                          imr.addr_lo & IMR_LOCK ? "locked" : "unlocked");
> +       }
> +
> +       mutex_unlock(&imr_dev.lock);
> +
> +       return ret;
> +}
> +
> +/**
> + * imr_state_open
> + * Debugfs open callback
> + *
> + * @inode:     pointer to struct inode
> + * @file:      pointer to struct file
> + * @return     result of single open
> + */
> +static int imr_state_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, imr_dbgfs_state_show, inode->i_private);
> +}
> +
> +static const struct file_operations imr_state_ops = {
> +       .open           = imr_state_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
> +/**
> + * imr_debugfs_register
> + * Register debugfs hooks
> + *
> + * @imr:       IMR structure representing address and access masks
> + * @return     0 on success - errno on failure
> + */
> +static int imr_debugfs_register(struct imr_device *imr_dev)
> +{
> +       struct dentry *dir, *f;
> +
> +       dir = debugfs_create_dir("imr", NULL);
> +       if (!dir)
> +               return -ENOMEM;

if (IS_ERR(dir))
 return PTR_ERR();

Though it seems not a case when you have this under ifdef.

> +
> +       f = debugfs_create_file("state", S_IFREG | S_IRUGO,
> +                               dir, imr_dev, &imr_state_ops);
> +       if (!f)
> +               goto err;

Are you planing to extend the debugfs contents? Would it be okay to
use only one file for now?

> +
> +       imr_dev->debugfs_dir = dir;
> +
> +       return 0;
> +err:
> +       return -ENODEV;

No need to have separate label for plain return.

> +}
> +
> +/**
> + * imr_debugfs_unregister
> + * Unregister debugfs hooks
> + *
> + * @imr:       IMR structure representing address and access masks
> + * @return     none
> + */
> +static void imr_debugfs_unregister(struct imr_device *imr_dev)
> +{

> +       if (!imr_dev->debugfs_dir)
> +               return;

Redundant check.

> +
> +       debugfs_remove_recursive(imr_dev->debugfs_dir);
> +       imr_dev->debugfs_dir = NULL;

No need to assign NULL.

> +}

No need to put this function under ifdef  - debugfs has the stubs.
Or add ifdefs around places where they are called and remove those
dummy functions below.

> +
> +#else
> +
> +/**
> + * imr_debugfs_register
> + * Register debugfs hooks
> + *
> + * @imr:       IMR structure representing address and access masks
> + * @return     0 on success - errno on failure
> + */
> +static int imr_debugfs_register(struct imr_device *imr_dev)
> +{
> +       return 0;
> +}
> +
> +/**
> + * imr_debugfs_unregister
> + * Dummy hook for !CONFIG_DEBUG_FS
> + *
> + * @imr:       IMR structure representing address and access masks
> + * @return     none
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
> +       if ((base & (IMR_MASK)) || (size & (IMR_MASK))) {

Too many parentheses. Looks like you may do it less.

> +               pr_warn("imr: base 0x%08lx size 0x%08lx must align to 1k\n",

Can you define pr_fmt() ?

1 KiB.

> +                       base, size);
> +               dump_stack();

dump_stack is really needed here? In that case why not to use WARN()?

> +               return -EINVAL;
> +       }
> +       return 0;
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
> +           unsigned int rmask, unsigned int wmask, bool lock)
> +{
> +       unsigned long end = base + size;
> +       struct imr imr;
> +       int reg, i, overlap, ret;
> +
> +       if (imr_check_range(base, size))
> +               return -EINVAL;

ret = imr_();
if (ret)
 return ret;

> +
> +       if (!size) {
> +               pr_warn("imr: invalid size zero!\n");
> +               return -EINVAL;
> +       }
> +
> +       mutex_lock(&imr_dev.lock);
> +
> +       /* Find an free IMR while checking for an existing overlapping range */
> +       overlap = 0;
> +       reg = -1;
> +       for (i = 0; i <= imr_dev.num; i++) {
> +               ret = imr_read(i, &imr);
> +               if (ret)
> +                       goto done;
> +
> +               /* Find overlap */
> +               if (imr_enabled(&imr)) {
> +                       if (base >= imr_to_phys(imr.addr_lo) &&
> +                               base <= imr_to_phys(imr.addr_hi)) {

> +                               overlap = 1;
> +                               break;

Maybe
ret = -EINVAL;
goto done;

> +                       }
> +                       if (end >= imr_to_phys(imr.addr_lo) &&
> +                               end <= imr_to_phys(imr.addr_hi)) {
> +                               overlap = 1;
> +                               break;

Ditto.

> +                       }

You may use one condition. If you still want to have them split you
may create a helper to check for overlap.

> +               } else {
> +                       reg = i;
> +               }
> +       }
> +
> +       /* Error out if we have an overlap or no free IMR entries */
> +       if (overlap) {
> +               ret = -EINVAL;
> +               goto done;
> +       }

...and remove overlap variable and this condition.

> +       if (reg == -1) {
> +               ret = -ENODEV;
> +               goto done;
> +       }
> +
> +       pr_debug("IMR %d phys 0x%08lx-0x%08lx rmask 0x%08x wmask 0x%08x\n",
> +               reg, base, end, rmask, wmask);
> +
> +       /* Allocate IMR */
> +       imr.addr_lo = IMR_ENABLE | phys_to_imr(base);
> +       imr.addr_hi = phys_to_imr(end);
> +       imr.rmask = rmask;
> +       imr.wmask = wmask;
> +
> +       ret = imr_write(reg, &imr, lock);
> +
> +done:
> +       mutex_unlock(&imr_dev.lock);
> +       return ret;
> +}
> +EXPORT_SYMBOL(imr_add);
> +
> +/**
> + * imr_del_range
> + * Delete an Isolated Memory Region
> + *
> + * @reg: IMR index to remove
> + * @base: Physical base address of region aligned to 4k
> + * @size: Physical size of region in bytes
> + * @return:    -EINVAL on invalid range or out or range id
> + *             -ENODEV if reg is valid but no IMR exists or is locked
> + *             0 on success
> + */
> +int imr_del(int reg, unsigned long base, unsigned long size)
> +{
> +       struct imr imr;
> +       int found = 0, i, ret = 0;
> +       unsigned long  max = base + size;
> +
> +       if (imr_check_range(base, size))
> +               return -EINVAL;
> +
> +       if (reg > imr_dev.num)
> +               return -EINVAL;
> +
> +       mutex_lock(&imr_dev.lock);
> +
> +       /* if a specific IMR is given try to use it */

Use capital letter to start a comment. Check a whole code.

> +       if (reg >= 0) {
> +               ret = imr_read(reg, &imr);
> +               if (ret)
> +                       goto done;
> +
> +               if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK) {
> +                       ret = -ENODEV;
> +                       goto done;
> +               }
> +               found = 1;

You may put a loop to the else branch instead of checking found at
each iteration.

> +       }
> +
> +       /* search for match based on address range */
> +       for (i = 0; i <= imr_dev.num && found == 0; i++) {
> +               ret = imr_read(reg, &imr);
> +               if (ret)
> +                       goto done;
> +
> +               if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK)
> +                       continue;
> +
> +               if ((imr_to_phys(imr.addr_lo) == base) &&
> +                   (imr_to_phys(imr.addr_hi) == max)) {
> +                       reg = i;

> +                       found = 1;
break;

> +               }
> +       }
> +
> +       if (found == 0) {
> +               ret = -ENODEV;
> +               goto done;
> +       }
> +
> +       /* Tear down the IMR */
> +       imr.addr_lo = 0;
> +       imr.addr_hi = 0;
> +       imr.rmask = IMR_READ_ACCESS_ALL;
> +       imr.wmask = IMR_WRITE_ACCESS_ALL;
> +
> +       ret = imr_write(reg, &imr, false);
> +
> +done:
> +       mutex_unlock(&imr_dev.lock);
> +       return ret;
> +}
> +EXPORT_SYMBOL(imr_del);
> +
> +/**
> + * intel_imr_probe
> + * entry point for IMR driver
> + *
> + * return: -ENODEV for no IMR support 0 if good to go
> + */
> +static int __init intel_imr_init(void)
> +{
> +       struct cpuinfo_x86 *c = &cpu_data(cpu);
> +
> +       if (!cpu_has_imr(c))
> +               return -ENODEV;
> +
> +       if (iosf_mbi_available() == false)
> +               return -ENODEV;
> +
> +       if (cpu_is_quark(c)) {
> +               imr_dev.num = QUARK_X1000_IMR_NUM;
> +               imr_dev.reg_base = QUARK_X1000_IMR_REGBASE;
> +       } else {
> +               pr_err("Unknown IMR implementation\n");
> +               return -ENODEV;
> +       }
> +
> +       mutex_init(&imr_dev.lock);
> +
> +       return imr_debugfs_register(&imr_dev);
> +}
> +
> +/**
> + * intel_imr_exit
> + * exit point for IMR code. Deregisters debugfs, leave IMR state as-is.
> + *
> + * return: none
> + */
> +static void __exit intel_imr_exit(void)
> +{
> +       imr_debugfs_unregister(&imr_dev);
> +}
> +
> +module_init(intel_imr_init);
> +module_exit(intel_imr_exit);
> +
> +MODULE_AUTHOR("Bryan O'Donoghue <pure.logic@nexus-software.ie>");
> +MODULE_DESCRIPTION("Intel Isolated Memory Region driver");
> +MODULE_LICENSE("GPL");
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Happy New Year!

-- 
With Best Regards,
Andy Shevchenko
