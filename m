Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbaB1Jue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:50:34 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33554 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaB1Ju3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:50:29 -0500
Date: Fri, 28 Feb 2014 09:50:22 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russ Dill <Russ.Dill@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v6 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140228095022.GA25090@e102568-lin.cambridge.arm.com>
References: <1393545478-14908-1-git-send-email-sebastian.capella@linaro.org>
 <1393545478-14908-3-git-send-email-sebastian.capella@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1393545478-14908-3-git-send-email-sebastian.capella@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 Feb 2014 09:50:31.0502 (UTC) FILETIME=[84BA66E0:01CF346A]
X-MC-Unique: 114022809502600901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:57:58PM +0000, Sebastian Capella wrote:

[...]

> diff --git a/arch/arm/kernel/hibernate.c b/arch/arm/kernel/hibernate.c
> new file mode 100644
> index 0000000..a41e0e3
> --- /dev/null
> +++ b/arch/arm/kernel/hibernate.c
> @@ -0,0 +1,113 @@
> +/*
> + * Hibernation support specific for ARM
> + *
> + * Derived from work on ARM hibernation support by:
> + *
> + * Ubuntu project, hibernation support for mach-dove
> + * Copyright (C) 2010 Nokia Corporation (Hiroshi Doyu)
> + * Copyright (C) 2010 Texas Instruments, Inc. (Teerth Reddy et al.)
> + *  https://lkml.org/lkml/2010/6/18/4
> + *  https://lists.linux-foundation.org/pipermail/linux-pm/2010-June/027422.html
> + *  https://patchwork.kernel.org/patch/96442/
> + *
> + * Copyright (C) 2006 Rafael J. Wysocki <rjw@sisk.pl>
> + *
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/suspend.h>
> +#include <asm/tlbflush.h>
> +#include <asm/cacheflush.h>

You can drop tlbflush.h and cacheflush.h, they do not seem to be needed.

> +#include <asm/system_misc.h>
> +#include <asm/idmap.h>
> +#include <asm/suspend.h>
> +
> +extern const void __nosave_begin, __nosave_end;
> +
> +int pfn_is_nosave(unsigned long pfn)
> +{
> +	unsigned long nosave_begin_pfn =
> +			__pa_symbol(&__nosave_begin) >> PAGE_SHIFT;
> +	unsigned long nosave_end_pfn =
> +			PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
> +
> +	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
> +}
> +
> +void notrace save_processor_state(void)
> +{
> +	WARN_ON(num_online_cpus() != 1);
> +	local_fiq_disable();
> +}
> +
> +void notrace restore_processor_state(void)
> +{
> +	local_fiq_enable();
> +}
> +
> +/*
> + * Snapshot kernel memory and reset the system.
> + *
> + * swsusp_save() is executed in the suspend finisher so that the CPU
> + * context pointer and memory are part of the saved image, which is
> + * required by the resume kernel image to restart execution from
> + * swsusp_arch_suspend().
> + *
> + * soft_restart is not technically needed, but is used to get success
> + * returned from cpu_suspend.
> + *
> + * When soft reboot completes, the hibernation snapshot is written out.
> + */
> +static int notrace arch_save_image(unsigned long unused)
> +{
> +	int ret;
> +
> +	ret = swsusp_save();
> +	if (ret == 0)
> +		soft_restart(virt_to_phys(cpu_resume));
> +	return ret;
> +}
> +
> +/*
> + * Save the current CPU state before suspend / poweroff.
> + */
> +int notrace swsusp_arch_suspend(void)
> +{
> +	return cpu_suspend(0, arch_save_image);
> +}
> +
> +/*
> + * The framework loads the hibernation image into a linked list anchored
> + * at restore_pblist, for swsusp_arch_resume() to copy back to the proper
> + * destinations.
> + *
> + * To make this work if resume is triggered from initramfs, the
> + * pagetables need to be switched to allow writes to kernel mem.
> + */

Comment above needs updating. We are switching page tables to a set of
page tables that are certain to live at the same location in the older
kernel, that's the only reason, as we discussed. soft_restart will make
sure (again) to switch to 1:1 page tables so that we can call cpu_resume
with the MMU off.

> +static void notrace arch_restore_image(void *unused)
> +{
> +	struct pbe *pbe;
> +
> +	cpu_switch_mm(idmap_pgd, &init_mm);
> +	for (pbe = restore_pblist; pbe; pbe = pbe->next)
> +		copy_page(pbe->orig_address, pbe->address);
> +
> +	soft_restart(virt_to_phys(cpu_resume));
> +}
> +
> +static u8 resume_stack[PAGE_SIZE/2] __nosavedata;
> +
> +/*
> + * Resume from the hibernation image.
> + * Due to the kernel heap / data restore, stack contents change underneath
> + * and that would make function calls impossible; switch to a temporary
> + * stack within the nosave region to avoid that problem.
> + */
> +int swsusp_arch_resume(void)
> +{
> +	extern void call_with_stack(void (*fn)(void *), void *arg, void *sp);
> +	call_with_stack(arch_restore_image, 0,
> +		resume_stack + sizeof(resume_stack));

This does not guarantee your stack is 8-byte aligned, that's not AAPCS
compliant and might buy you trouble.

Either you align the stack or you align the pointer you are passing.

Please have a look at kernel/process.c

Thanks,
Lorenzo

