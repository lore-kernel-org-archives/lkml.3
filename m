Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3A3AFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:05:38 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:51139 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3A3AFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:05:36 -0500
Date: Tue, 29 Jan 2013 19:05:32 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 2/3] ARM: static_vm: introduce an infrastructure for
 static mapped area
In-Reply-To: <1358990934-4893-3-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.LFD.2.02.1301291840580.6300@xanadu.home>
References: <1358990934-4893-1-git-send-email-iamjoonsoo.kim@lge.com> <1358990934-4893-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2013, Joonsoo Kim wrote:

> From: Joonsoo Kim <js1304@gmail.com>
> 
> In current implementation, we used ARM-specific flag, that is,
> VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
> The purpose of static mapped area is to re-use static mapped area when
> entire physical address range of the ioremap request can be covered
> by this area.
> 
> This implementation causes needless overhead for some cases.
> For example, assume that there is only one static mapped area and
> vmlist has 300 areas. Every time we call ioremap, we check 300 areas for
> deciding whether it is matched or not. Moreover, even if there is
> no static mapped area and vmlist has 300 areas, every time we call
> ioremap, we check 300 areas in now.
> 
> If we construct a extra list for static mapped area, we can eliminate
> above mentioned overhead.
> With a extra list, if there is one static mapped area,
> we just check only one area and proceed next operation quickly.
> 
> In fact, it is not a critical problem, because ioremap is not frequently
> used. But reducing overhead is better idea.
> 
> Another reason for doing this work is for removing architecture dependency
> on vmalloc layer. I think that vmlist and vmlist_lock is internal data
> structure for vmalloc layer. Some codes for debugging and stat inevitably
> use vmlist and vmlist_lock. But it is preferable that they are used
> as least as possible in outside of vmalloc.c
> 
> Now, I introduce an ARM-specific infrastructure for static mapped area. In
> the following patch, we will use this and resolve above mentioned problem.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

First of all, I don't think you really need a new file with a global 
scope header file.  Given that this code is meant to be used only for 
ioremap optimization  on ARM, it is probably a better idea to simply put 
it all into arch/arm/mm/ioremap.c instead.  The only function that needs 
to be exported out of ioremap.c is insert_static_vm(), and only for the 
benefit of arch/arm/mm/mmu.c, therefore this function prototype may as 
well just be added to arch/arm/mm/mm.h.

More comments below.

> diff --git a/arch/arm/include/asm/mach/static_vm.h b/arch/arm/include/asm/mach/static_vm.h
> new file mode 100644
> index 0000000..72c8339
> --- /dev/null
> +++ b/arch/arm/include/asm/mach/static_vm.h
> @@ -0,0 +1,45 @@
> +/*
> + * arch/arm/include/asm/mach/static_vm.h
> + *
> + * Copyright (C) 2012 LG Electronics, Joonsoo Kim <iamjoonsoo.kim@lge.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + */
> +
> +#ifndef _ASM_MACH_STATIC_VM_H
> +#define _ASM_MACH_STATIC_VM_H
> +
> +#include <linux/types.h>
> +#include <linux/vmalloc.h>
> +
> +struct static_vm {
> +	struct static_vm	*next;
> +	void			*vaddr;
> +	unsigned long		size;
> +	unsigned long		flags;
> +	phys_addr_t		paddr;
> +	const void		*caller;
> +};

Here you're duplicating most of the vm_struct content for no obvious 
reasons.  Patch #3 even allocates both a vm_struct and a static_vm 
instance in parallel for each mapping.  Instead, you should consider 
something like this:

struct static_vm {
	struct static_vm *next;
	struct vm_struct vm;
};

This way, you only need to allocate one structure:

	struct static_vm *svm = early_alloc(...);
	...
	svm->vm.addr = addr;
	...
	vm_area_add_early(&svm->vm);
	insert_static_vm(svm);

And then, it would make sense for the insert_static_vm() to do the 
vm_area_add_early() call itself as well.

Maybe rename insert_static_vm() to static_vm_area_add_early() to better 
identify its purpose as well.  It shouldn't be used for any other 
purpose anyway.

> +
> +extern struct static_vm *static_vmlist;
> +extern spinlock_t static_vmlist_lock;

Your patch is providing the proper accessors to manipulate those.  They 
therefore should not be exported globally.

> +
> +extern struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
> +			size_t size, unsigned long flags);
> +extern struct static_vm *find_static_vm_vaddr(void *vaddr);
> +extern void init_static_vm(struct static_vm *static_vm,
> +			struct vm_struct *vm, unsigned long flags);

Since those are only used in ioremap.c, and because I suggested their 
implementation be moved there as well, you shouldn't need prototype 
declarations anymore.  And init_static_vm() would be useless with my 
previous suggestions.


Nicolas
