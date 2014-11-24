Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956AbaKXVIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 16:08:10 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:34254 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaKXVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:08:07 -0500
MIME-Version: 1.0
In-Reply-To: <11772640.IZcxoRkMEM@wuerfel>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
 <1416796846-28149-12-git-send-email-cernekee@gmail.com> <11772640.IZcxoRkMEM@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 24 Nov 2014 13:07:46 -0800
Message-ID: <CAJiQ=7BXW5iWm7t_62dpm8fDppG0JCiW+okVKhPYUKSWGQhd_Q@mail.gmail.com>
Subject: Re: [PATCH V3 11/11] MIPS: Add multiplatform BMIPS target
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Jonas Gorski <jogo@openwrt.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 6:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> It mihgt be good to split this into multiple patches

OK.  For V4 I could submit the arch/mips/bmips code changes in one
patch, and then add the DTS files in the next patch?

>> --- /dev/null
>> +++ b/arch/mips/bmips/Kconfig
>> @@ -0,0 +1,50 @@
>> +choice
>> +     prompt "Built-in device tree"
>> +     help
>> +       Legacy bootloaders do not pass a DTB pointer to the kernel, so
>> +       if a "wrapper" is not being used, the kernel will need to include
>> +       a device tree that matches the target board.
>> +
>> +       The builtin DTB will only be used if the firmware does not supply
>> +       a valid DTB.
>> +
>> +config DT_NONE
>> +     bool "None"
>> +
>> +config DT_BCM93384WVG
>> +     bool "BCM93384WVG Zephyr CPU"
>> +     select BUILTIN_DTB
>> +
>> +config DT_BCM93384WVG_VIPER
>> +     bool "BCM93384WVG Viper CPU (EXPERIMENTAL)"
>> +     select BUILTIN_DTB
>
> Why do you have to pick just one? I liked the suggestion of just
> appending the dtb to the zImage as we do on ARM, so you can build
> a combined kernel and then run it on multiple machines.

I'm not sure this exists yet on MIPS.  Perhaps we can discuss it as a
possible future enhancement to the general arch/mips code?

One possible complication is that we're mostly using ELF images on
MIPS, not zImage.  Is it easy to calculate the end address of an ELF
file?

If there is no PT_LOAD segment for the blob, will the bootloader even
copy it into memory?

>> +unsigned int get_c0_compare_int(void)
>> +{
>> +     return CP0_LEGACY_COMPARE_IRQ;
>> +}
>
> Could this just become a function pointer instead of a global
> variable?

>> +void __init prom_free_prom_memory(void)
>> +{
>> +}
>
> This in turn could live outside of the platform codefor anything
> that is "multiplatform".

>> +#define R4600_V1_INDEX_ICACHEOP_WAR  0
>> +#define R4600_V1_HIT_CACHEOP_WAR     0
>> +#define R4600_V2_HIT_CACHEOP_WAR     0
>> ...
>
> As mentioned before, it seems like you are simply defining these all to zero,
> like most other platforms do too. Why not add this file as
> arch/mips/include/asm/mach-generic/war.h and delete all identical copies?

Likewise - currently every existing MIPS machine type implements it this way.

Perhaps a future patch series can generalize the way these definitions
are handled on MIPS?

>> +OF_DECLARE_2(irqchip, mips_cpu_intc, "mti,cpu-interrupt-controller",
>> +          mips_cpu_irq_of_init);
>
> OF_DECLARE_2 really wasn't meant to be used directly. Can you move this
> code into drivers/irqchip and make it use IRQCHIP_DECLARE()?

Perhaps arch/mips/kernel/irq_cpu.c could be moved under
drivers/irqchip in a future commit?  We'll probably have to change the
way arch/mips/ralink invokes it too.

Also, as a side note, it would be nice if irq_cpu.c let me cascade
child IRQ controllers on a specific CPU.  For instance, some of our
hardware looks like:

CPU0 MIPS IRQ 2 -> bcm7038 L1 instance #0
CPU1 MIPS IRQ 3 -> bcm7038 L1 instance #1
CPU2 MIPS IRQ 2 -> bcm7038 L1 instance #2
CPU3 MIPS IRQ 3 -> bcm7038 L1 instance #3

These would be handled by a single "brcm,bcm7038-l1-intc" DT node
which lists the 4 parent IRQs individually.  We'll need this
capability to support IRQ affinity with 4-way SMP on BCM7435.

>> +void __init prom_init(void)
>> +{
>> +     register_bmips_smp_ops();
>> +}
>
> This seems to be the wrong place for calling this function.

Hmm, looking around the tree:

cavium-octeon, ip27, loongson, netlogic xlr, paravirt, and sibyte call
register_smp_ops() from prom_init().

netlogic xlp calls it from plat_mem_setup().

>> +void __init plat_mem_setup(void)
>> +{
>> +     void *dtb;
>> +     const struct bmips_quirk *q;
>> +
>> +     set_io_port_base(0);
>> +     ioport_resource.start = 0;
>> +     ioport_resource.end = ~0;
>
> ioport_resource must not extend beyond IO_SPACE_LIMIT, which is
> 0xffff on MIPS. setting the I/O port base to zero is probably
> not what you want. What are you trying to do here?

Blindly plagiarize the bcm63xx/netlogic/pnx833x implementations ;-)

> Maybe defer this until you have PCI support? The new generic PCI
> handling should make this really easy to get right.

OK, I'll drop this code in V4 if nothing breaks.

>> +     /* Intended to somewhat resemble ARM; see Documentation/arm/Booting */
>> +     if (fw_arg0 == 0 && fw_arg1 == 0xffffffff)
>> +             dtb = phys_to_virt(fw_arg2);
>> +     else if (__dtb_start != __dtb_end)
>> +             dtb = (void *)__dtb_start;
>> +     else
>> +             panic("no dtb found");
>> +
>> +     __dt_setup_arch(dtb);
>> +     strlcpy(arcs_cmdline, boot_command_line, COMMAND_LINE_SIZE);
>
> Is this intended to become a generic MIPS boot interface? Better
> document it in Documentation/mips/

Not sure yet.  It's currently limited to BCM3384.

For V4 I can add an "Entry point for arch/mips/bmips" or even an
"Entry point for arch/mips" section to
Documentation/devicetree/booting-without-of.txt.  Any preferences?

>> +void __init device_tree_init(void)
>> +{
>> +     struct device_node *np;
>> +
>> +     unflatten_and_copy_device_tree();
>> +
>> +     /* Disable SMP boot unless both CPUs are listed in DT and !disabled */
>> +     np = of_find_node_by_name(NULL, "cpus");
>> +     if (np && of_get_available_child_count(np) <= 1)
>> +             bmips_smp_enabled = 0;
>> +     of_node_put(np);
>> +}
>
> this looks also like it should be in platform
> independent code

Hmm.  Do we want to add some logic to kernel/smp.c or kernel/cpu.c
that says something like: if there is a "cpus" node, clear
cpu_possible_mask and then set the corresponding bit for each cpu@N
listed in the DT?

Unfortunately, if enabled by default, this could impact a lot of other
systems too.

Another option is to make a generic helper function that individual
platforms can call to say "populate my CPU bitmap from DT," maybe
something like of_set_possible_cpus().

>> +void __init plat_time_init(void)
>> +{
>> +     struct device_node *np;
>> +     u32 freq;
>> +
>> +     np = of_find_node_by_name(NULL, "cpus");
>> +     if (!np)
>> +             panic("missing 'cpus' DT node");
>> +     if (of_property_read_u32(np, "mips-hpt-frequency", &freq) < 0)
>> +             panic("missing 'mips-hpt-frequency' property");
>> +     of_node_put(np);
>> +
>> +     mips_hpt_frequency = freq;
>> +}
>
> Could this be part of a drivers/clocksource driver?

See earlier replies / cover letter

>> +const char *get_system_type(void)
>> +{
>> +     return "BMIPS multiplatform kernel";
>> +}
>
> You could set the string from bmips_quirk_list and make this generic
> as well.

The way it currently looks is:

# cat /proc/cpuinfo
system type        : BMIPS multiplatform kernel
machine            : Broadcom BCM97425SVMB
processor        : 0
cpu model        : Broadcom BMIPS5000 V1.1  FPU V0.1
BogoMIPS        : 866.30
wait instruction    : yes
microsecond timers    : yes
tlb_entries        : 64
extra interrupt vector    : yes
hardware watchpoint    : no
isa            : mips1 mips2 mips32r1
[...]

So this indicates:

system type: the kernel build
machine: the board name from DT
cpu model: the detected CPU type

I would rather not tie quirks to the system identity, as sane
legacy-free systems (such as bcm3384-zephyr) probably shouldn't have
quirks.

>> diff --git a/arch/mips/include/asm/mach-bmips/dma-coherence.h b/arch/mips/include/asm/mach-bmips/dma-coherence.h
>> new file mode 100644
>> index 000000000000..5481a4d1bbbf
>> --- /dev/null
>> +++ b/arch/mips/include/asm/mach-bmips/dma-coherence.h
>> @@ -0,0 +1,45 @@
>> +#ifndef __ASM_MACH_BMIPS_DMA_COHERENCE_H
>> +#define __ASM_MACH_BMIPS_DMA_COHERENCE_H
>> +
>> +struct device;
>> +
>> +extern dma_addr_t plat_map_dma_mem(struct device *dev, void *addr, size_t size);
>> +extern dma_addr_t plat_map_dma_mem_page(struct device *dev, struct page *page);
>> +extern unsigned long plat_dma_addr_to_phys(struct device *dev,
>> +     dma_addr_t dma_addr);
>> +extern void plat_unmap_dma_mem(struct device *dev, dma_addr_t dma_addr,
>> +     size_t size, enum dma_data_direction direction);
>
> I think you could just add these to
> arch/mips/include/asm/mach-generic/dma-coherence.h and get rid of the
> header file, after adding a Kconfig symbol.

Some platforms mix and match inline definitions versus externs in this file.

Maybe Ralf can comment on whether we should move to an "all or nothing" model?

>> diff --git a/arch/mips/include/asm/mach-bmips/spaces.h b/arch/mips/include/asm/mach-bmips/spaces.h
>> new file mode 100644
>> index 000000000000..1f7bc6cb6160
>> --- /dev/null
>> +++ b/arch/mips/include/asm/mach-bmips/spaces.h
>> @@ -0,0 +1,17 @@
>> +#ifndef _ASM_BMIPS_SPACES_H
>> +#define _ASM_BMIPS_SPACES_H
>> +
>> +#define FIXADDR_TOP          ((unsigned long)(long)(int)0xff000000)
>> +
>> +#include <asm/mach-generic/spaces.h>
>> +
>> +#endif /* __ASM_BMIPS_SPACES_H */
>
> Why does this platform need a special FIXADDR_TOP value?

I thought I documented this somewhere but I can't find it now.  I'll
add a comment in V4.  BMIPS does need a special value as there are
registers in this range.

> Would either
> this value or the 0xfffe0000 from
> arch/mips/include/asm/mach-generic/spaces.h would everywhere?

I would have to defer to the other MIPS guys...

The other question is what "everywhere" means in this context.  Maybe
we want to just use 0xff00_0000 for a multiplatform kernel, and any
system that is too obscure or too "weird" would continue using its own
build.
