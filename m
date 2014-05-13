Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbaEMDN3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 23:13:29 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:60652 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbaEMDN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 23:13:28 -0400
MIME-Version: 1.0
In-Reply-To: <1399861195-21087-2-git-send-email-superlibj8301@gmail.com>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
	<1399861195-21087-2-git-send-email-superlibj8301@gmail.com>
Date: Mon, 12 May 2014 22:13:26 -0500
Message-ID: <CAL_JsqK=BiZx31xUC=_8s7+QeAGjrWePOzeDLEt=YfpdLbS_KA@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] mm/vmalloc: Add IO mapping space reused interface.
From: Rob Herring <robherring2@gmail.com>
To: Richard Lee <superlibj8301@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Lee <superlibj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 9:19 PM, Richard Lee <superlibj8301@gmail.com> wrote:
> For the IO mapping, for the same physical address space maybe
> mapped more than one time, for example, in some SoCs:
> 0x20000000 ~ 0x20001000: are global control IO physical map,
> and this range space will be used by many drivers.

What address or who the user is isn't really relevant.

> And then if each driver will do the same ioremap operation, we
> will waste to much malloc virtual spaces.

s/malloc/vmalloc/

>
> This patch add the IO mapping space reusing interface:
> - find_vm_area_paddr: used to find the exsit vmalloc area using

s/exsit/exist/

>   the IO physical address.
> - vm_area_is_aready_to_free: before vfree the IO mapped areas
>   using this to do the check that if this area is used by more
>   than one consumer.
>
> Signed-off-by: Richard Lee <superlibj@gmail.com>
> ---
>  include/linux/vmalloc.h |  5 ++++
>  mm/vmalloc.c            | 63 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 68 insertions(+)
>
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 4b8a891..2b811f6 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -34,6 +34,7 @@ struct vm_struct {
>         struct page             **pages;
>         unsigned int            nr_pages;
>         phys_addr_t             phys_addr;
> +       unsigned int            used;
>         const void              *caller;
>  };
>
> @@ -100,6 +101,10 @@ static inline size_t get_vm_area_size(const struct vm_struct *area)
>         return area->size - PAGE_SIZE;
>  }
>
> +extern int vm_area_is_aready_to_free(phys_addr_t addr);
> +struct vm_struct *find_vm_area_paddr(phys_addr_t paddr, size_t size,
> +                                    unsigned long *offset,
> +                                    unsigned long flags);
>  extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
>  extern struct vm_struct *get_vm_area_caller(unsigned long size,
>                                         unsigned long flags, const void *caller);
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bf233b2..f75b7b3 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1293,6 +1293,7 @@ static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
>         vm->addr = (void *)va->va_start;
>         vm->size = va->va_end - va->va_start;
>         vm->caller = caller;
> +       vm->used = 1;
>         va->vm = vm;
>         va->flags |= VM_VM_AREA;
>         spin_unlock(&vmap_area_lock);
> @@ -1383,6 +1384,68 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
>                                   NUMA_NO_NODE, GFP_KERNEL, caller);
>  }
>
> +int vm_area_is_aready_to_free(phys_addr_t addr)

aready is not a word.

> +{
> +       struct vmap_area *va;
> +
> +       va = find_vmap_area((unsigned long)addr);
> +       if (!va || !(va->flags & VM_VM_AREA) || !va->vm)
> +               return 1;
> +
> +       if (va->vm->used <= 1)
> +               return 1;
> +
> +       --va->vm->used;

What lock protects this? You should use atomic ops here.

> +
> +       return 0;
> +}
> +
> +/**
> + *     find_vm_area_paddr  -  find a continuous kernel virtual area using the
> + *                     physical addreess.
> + *     @paddr:         base physical address
> + *     @size:          size of the physical area range
> + *     @offset:        the start offset of the vm area
> + *     @flags:         %VM_IOREMAP for I/O mappings
> + *
> + *     Search for the kernel VM area, whoes physical address starting at @paddr,
> + *     and if the exsit VM area's size is large enough, then just return it, or
> + *     return NULL.
> + */
> +struct vm_struct *find_vm_area_paddr(phys_addr_t paddr, size_t size,
> +                                    unsigned long *offset,
> +                                    unsigned long flags)
> +{
> +       struct vmap_area *va;
> +
> +       if (!(flags & VM_IOREMAP))
> +               return NULL;
> +
> +       rcu_read_lock();
> +       list_for_each_entry_rcu(va, &vmap_area_list, list) {
> +               phys_addr_t phys_addr;
> +
> +               if (!va || !(va->flags & VM_VM_AREA) || !va->vm)
> +                       continue;
> +
> +               phys_addr = va->vm->phys_addr;
> +
> +               if (paddr < phys_addr || paddr + size > phys_addr + va->vm->size)
> +                       continue;
> +
> +               *offset = paddr - phys_addr;
> +
> +               if (va->vm->flags & VM_IOREMAP && va->vm->size >= size) {
> +                       va->vm->used++;

What lock protects this? It looks like you are modifying this with
only a rcu reader lock.

> +                       rcu_read_unlock();
> +                       return va->vm;
> +               }
> +       }
> +       rcu_read_unlock();
> +
> +       return NULL;
> +}
> +
>  /**
>   *     find_vm_area  -  find a continuous kernel virtual area
>   *     @addr:          base address
> --
> 1.8.4
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
