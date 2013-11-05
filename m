Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3KEDBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:01:45 -0500
Received: from mx2.pku.edu.cn ([162.105.129.22]:46464 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753371Ab3KEDBo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:01:44 -0500
X-Greylist: delayed 726 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2013 22:01:41 EST
X-Spam-Flag: NO
X-Spam-Score: -308.535
Date: Tue, 5 Nov 2013 10:49:15 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <289468516.24288.1383619755331.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <20131104044844.GN13318@ZenIV.linux.org.uk>
Subject: =?gbk?B?UmU6IGNvbnZlcnRpbmcgdW5pY29yZTMyIHRvIGdhdGVfdm1hIGFzIGRvbmUgZm9yIGFybSAod2FzIFJlOg0KIFtQQVRDSF0gbW06IGNhY2hlIGxhcmdlc3Qgdm1hKQ==?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is ok for unicore32. Thanks Al.

While testing this patch, a bug is found in arch/unicore32/include/asm/pgtable.h:

@@ -96,7 +96,7 @@ extern pgprot_t pgprot_kernel;
                                                                | PTE_EXEC)
 #define PAGE_READONLY          __pgprot(pgprot_val(pgprot_user | PTE_READ)
 #define PAGE_READONLY_EXEC     __pgprot(pgprot_val(pgprot_user | PTE_READ \
-                                                               | PTE_EXEC)
+                                                               | PTE_EXEC))

In fact, all similar macros are wrong. I'll post an bug-fix patch for this obvious error.

Xuetao

----- Al Viro <viro@ZenIV.linux.org.uk> 写道：
> On Sun, Nov 03, 2013 at 08:20:10PM -0800, Davidlohr Bueso wrote:
> > > > diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
> > > > index fb5e4c6..38cc7fc 100644
> > > > --- a/arch/unicore32/include/asm/mmu_context.h
> > > > +++ b/arch/unicore32/include/asm/mmu_context.h
> > > > @@ -73,7 +73,7 @@ do { \
> > > >  		else \
> > > >  			mm->mmap = NULL; \
> > > >  		rb_erase(&high_vma->vm_rb, &mm->mm_rb); \
> > > > -		mm->mmap_cache = NULL; \
> > > > +		vma_clear_caches(mm);			\
> > > >  		mm->map_count--; \
> > > >  		remove_vma(high_vma); \
> > > >  	} \
> 
> BTW, this one needs an analog of
> commit f9d4861fc32b995b1616775614459b8f266c803c
> Author: Will Deacon <will.deacon@arm.com>
> Date:   Fri Jan 20 12:01:13 2012 +0100
> 
>     ARM: 7294/1: vectors: use gate_vma for vectors user mapping
> 
> This code is a copy of older arm logics rewritten in that commit; unicore32
> never got its counterpart.  I have a [completely untested] variant sitting
> in vfs.git#vm^; it's probably worth testing - if it works, we'll get rid
> of one more place that needs to be aware of MM guts and unicore32 folks
> will have fewer potential headache sources...
> 
> FWIW, after porting to the current tree it becomes the following; I'm not
> sure whether we want VM_DONTEXPAND | VM_DONTDUMP set for this one, though...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/arch/unicore32/include/asm/elf.h b/arch/unicore32/include/asm/elf.h
> index 829042d..eeba258 100644
> --- a/arch/unicore32/include/asm/elf.h
> +++ b/arch/unicore32/include/asm/elf.h
> @@ -87,8 +87,4 @@ struct mm_struct;
>  extern unsigned long arch_randomize_brk(struct mm_struct *mm);
>  #define arch_randomize_brk arch_randomize_brk
>  
> -extern int vectors_user_mapping(void);
> -#define arch_setup_additional_pages(bprm, uses_interp) vectors_user_mapping()
> -#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
> -
>  #endif
> diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
> index fb5e4c6..600b1b8 100644
> --- a/arch/unicore32/include/asm/mmu_context.h
> +++ b/arch/unicore32/include/asm/mmu_context.h
> @@ -18,6 +18,7 @@
>  
>  #include <asm/cacheflush.h>
>  #include <asm/cpu-single.h>
> +#include <asm-generic/mm_hooks.h>
>  
>  #define init_new_context(tsk, mm)	0
>  
> @@ -56,32 +57,4 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
>  #define deactivate_mm(tsk, mm)	do { } while (0)
>  #define activate_mm(prev, next)	switch_mm(prev, next, NULL)
>  
> -/*
> - * We are inserting a "fake" vma for the user-accessible vector page so
> - * gdb and friends can get to it through ptrace and /proc/<pid>/mem.
> - * But we also want to remove it before the generic code gets to see it
> - * during process exit or the unmapping of it would  cause total havoc.
> - * (the macro is used as remove_vma() is static to mm/mmap.c)
> - */
> -#define arch_exit_mmap(mm) \
> -do { \
> -	struct vm_area_struct *high_vma = find_vma(mm, 0xffff0000); \
> -	if (high_vma) { \
> -		BUG_ON(high_vma->vm_next);  /* it should be last */ \
> -		if (high_vma->vm_prev) \
> -			high_vma->vm_prev->vm_next = NULL; \
> -		else \
> -			mm->mmap = NULL; \
> -		rb_erase(&high_vma->vm_rb, &mm->mm_rb); \
> -		mm->mmap_cache = NULL; \
> -		mm->map_count--; \
> -		remove_vma(high_vma); \
> -	} \
> -} while (0)
> -
> -static inline void arch_dup_mmap(struct mm_struct *oldmm,
> -				 struct mm_struct *mm)
> -{
> -}
> -
>  #endif
> diff --git a/arch/unicore32/include/asm/page.h b/arch/unicore32/include/asm/page.h
> index 594b322..e79da8b 100644
> --- a/arch/unicore32/include/asm/page.h
> +++ b/arch/unicore32/include/asm/page.h
> @@ -28,6 +28,8 @@ extern void copy_page(void *to, const void *from);
>  #define clear_user_page(page, vaddr, pg)	clear_page(page)
>  #define copy_user_page(to, from, vaddr, pg)	copy_page(to, from)
>  
> +#define __HAVE_ARCH_GATE_AREA 1
> +
>  #undef STRICT_MM_TYPECHECKS
>  
>  #ifdef STRICT_MM_TYPECHECKS
> diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
> index 778ebba..51d129e 100644
> --- a/arch/unicore32/kernel/process.c
> +++ b/arch/unicore32/kernel/process.c
> @@ -307,21 +307,39 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
>  
>  /*
>   * The vectors page is always readable from user space for the
> - * atomic helpers and the signal restart code.  Let's declare a mapping
> - * for it so it is visible through ptrace and /proc/<pid>/mem.
> + * atomic helpers and the signal restart code. Insert it into the
> + * gate_vma so that it is visible through ptrace and /proc/<pid>/mem.
>   */
> +static struct vm_area_struct gate_vma = {
> +	.vm_start	= 0xffff0000,
> +	.vm_end		= 0xffff0000 + PAGE_SIZE,
> +	.vm_flags	= VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYEXEC |
> +			  VM_DONTEXPAND | VM_DONTDUMP,
> +};
> +
> +static int __init gate_vma_init(void)
> +{
> +	gate_vma.vm_page_prot	= PAGE_READONLY_EXEC;
> +	return 0;
> +}
> +arch_initcall(gate_vma_init);
> +
> +struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
> +{
> +	return &gate_vma;
> +}
> +
> +int in_gate_area(struct mm_struct *mm, unsigned long addr)
> +{
> +	return (addr >= gate_vma.vm_start) && (addr < gate_vma.vm_end);
> +}
>  
> -int vectors_user_mapping(void)
> +int in_gate_area_no_mm(unsigned long addr)
>  {
> -	struct mm_struct *mm = current->mm;
> -	return install_special_mapping(mm, 0xffff0000, PAGE_SIZE,
> -				       VM_READ | VM_EXEC |
> -				       VM_MAYREAD | VM_MAYEXEC |
> -				       VM_DONTEXPAND | VM_DONTDUMP,
> -				       NULL);
> +	return in_gate_area(NULL, addr);
>  }
>  
>  const char *arch_vma_name(struct vm_area_struct *vma)
>  {
> -	return (vma->vm_start == 0xffff0000) ? "[vectors]" : NULL;
> +	return (vma == &gate_vma) ? "[vectors]" : NULL;
>  }

