Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaIJObp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:31:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56881 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaIJObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:31:43 -0400
Message-ID: <541060CB.6000402@codeaurora.org>
Date: Wed, 10 Sep 2014 10:31:39 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Andrew Pinski <apinski@cavium.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Subject: Re: [PATCH 18/24] ARM64: Add vdso for ILP32 and use it for the signal
 return
References: <1409779158-30963-1-git-send-email-apinski@cavium.com> <1409779158-30963-19-git-send-email-apinski@cavium.com>
In-Reply-To: <1409779158-30963-19-git-send-email-apinski@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 09/03/2014 05:19 PM, Andrew Pinski wrote:
> This patch adds the VDSO for ILP32. We need to use a different
> VDSO than LP64 since ILP32 uses ELF32 while LP64 uses ELF64.
> 
> After this patch, signal handling works mostly.  In that signals
> go through their action and then returned correctly.
> 
> Signed-off-by: Andrew Pinski <apinski@cavium.com>
> ---
>  arch/arm64/include/asm/vdso.h                 |    4 +
>  arch/arm64/kernel/Makefile                    |    5 +
>  arch/arm64/kernel/signal.c                    |    4 +
>  arch/arm64/kernel/vdso-ilp32/.gitignore       |    2 +
>  arch/arm64/kernel/vdso-ilp32/Makefile         |   72 ++++++++++++++++++
>  arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S     |   33 ++++++++
>  arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S |   98 +++++++++++++++++++++++++
>  arch/arm64/kernel/vdso.c                      |   69 ++++++++++++++---
>  8 files changed, 274 insertions(+), 13 deletions(-)
>  create mode 100644 arch/arm64/kernel/vdso-ilp32/.gitignore
>  create mode 100644 arch/arm64/kernel/vdso-ilp32/Makefile
>  create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.S
>  create mode 100644 arch/arm64/kernel/vdso-ilp32/vdso-ilp32.lds.S
> 
> diff --git a/arch/arm64/include/asm/vdso.h b/arch/arm64/include/asm/vdso.h
> index 839ce00..84050c6 100644
> --- a/arch/arm64/include/asm/vdso.h
> +++ b/arch/arm64/include/asm/vdso.h
> @@ -29,6 +29,10 @@
>  
>  #include <generated/vdso-offsets.h>
>  
> +#ifdef CONFIG_ARM64_ILP32
> +#include <generated/vdso-ilp32-offsets.h>
> +#endif
> +
>  #define VDSO_SYMBOL(base, name)						   \
>  ({									   \
>  	(void *)(vdso_offset_##name - VDSO_LBASE + (unsigned long)(base)); \
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 6de85f5..dcb9033 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -31,6 +31,7 @@ arm64-obj-$(CONFIG_KGDB)		+= kgdb.o
>  arm64-obj-$(CONFIG_EFI)			+= efi.o efi-stub.o efi-entry.o
>  
>  obj-y					+= $(arm64-obj-y) vdso/
> +obj-$(CONFIG_ARM64_ILP32)		+= vdso-ilp32/
>  obj-m					+= $(arm64-obj-m)
>  head-y					:= head.o
>  extra-y					:= $(head-y) vmlinux.lds
> @@ -38,3 +39,7 @@ extra-y					:= $(head-y) vmlinux.lds
>  # vDSO - this must be built first to generate the symbol offsets
>  $(call objectify,$(arm64-obj-y)): $(obj)/vdso/vdso-offsets.h
>  $(obj)/vdso/vdso-offsets.h: $(obj)/vdso
> +
> +# vDSO - this must be built first to generate the symbol offsets
> +$(call objectify,$(arm64-obj-y)): $(obj)/vdso-ilp32/vdso-ilp32-offsets.h
> +$(obj)/vdso-ilp32/vdso-ilp32-offsets.h: $(obj)/vdso-ilp32
> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index f47c064..5311147 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
> @@ -242,6 +242,10 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
>  
>  	if (ka->sa.sa_flags & SA_RESTORER)
>  		sigtramp = ka->sa.sa_restorer;
> +#ifdef CONFIG_ARM64_ILP32
> +	else if (is_ilp32_compat_task())
> +		sigtramp = VDSO_SYMBOL(current->mm->context.vdso, sigtramp_ilp32);
> +#endif
>  	else
>  		sigtramp = VDSO_SYMBOL(current->mm->context.vdso, sigtramp);

In my opinion, moving the ifdef around the definition of
is_ilp32_compat_task() would make the code easier to read and maintain.

> diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
> index a777ac3..21b3726 100644
> --- a/arch/arm64/kernel/vdso.c
> +++ b/arch/arm64/kernel/vdso.c
> @@ -41,6 +41,12 @@ extern char vdso_start, vdso_end;
>  static unsigned long vdso_pages;
>  static struct page **vdso_pagelist;
>  
> +#ifdef CONFIG_ARM64_ILP32
> +extern char vdso_ilp32_start, vdso_ilp32_end;
> +static unsigned long vdso_ilp32_pages;
> +static struct page **vdso_ilp32_pagelist;
> +#endif
> +
>  /*
>   * The vDSO data page.
>   */
> @@ -110,24 +116,31 @@ int aarch32_setup_vectors_page(struct linux_binprm *bprm, int uses_interp)
>  }
>  #endif /* CONFIG_AARCH32_EL0 */
>  
> -static struct vm_special_mapping vdso_spec[2];
> +static struct vm_special_mapping vdso_spec[2][2];
>  
> -static int __init vdso_init(void)
> +static inline int __init vdso_init_common(char *vdso_start, char *vdso_end,
> +					  unsigned long *vdso_pagesp,
> +					  struct page ***vdso_pagelistp,
> +					  bool ilp32)
>  {
>  	int i;
> +	unsigned long vdso_pages;
> +	struct page **vdso_pagelist;
>  
> -	if (memcmp(&vdso_start, "\177ELF", 4)) {
> +	if (memcmp(vdso_start, "\177ELF", 4)) {
>  		pr_err("vDSO is not a valid ELF object!\n");
>  		return -EINVAL;
>  	}
>  
> -	vdso_pages = (&vdso_end - &vdso_start) >> PAGE_SHIFT;
> +	vdso_pages = (vdso_end - vdso_start) >> PAGE_SHIFT;
> +	*vdso_pagesp = vdso_pages;
>  	pr_info("vdso: %ld pages (%ld code @ %p, %ld data @ %p)\n",
> -		vdso_pages + 1, vdso_pages, &vdso_start, 1L, vdso_data);
> +		vdso_pages + 1, vdso_pages, vdso_start, 1L, vdso_data);
>  
>  	/* Allocate the vDSO pagelist, plus a page for the data. */
>  	vdso_pagelist = kcalloc(vdso_pages + 1, sizeof(struct page *),
>  				GFP_KERNEL);
> +	*vdso_pagelistp = vdso_pagelist;
>  	if (vdso_pagelist == NULL)
>  		return -ENOMEM;
>  
> @@ -136,33 +149,63 @@ static int __init vdso_init(void)
>  
>  	/* Grab the vDSO code pages. */
>  	for (i = 0; i < vdso_pages; i++)
> -		vdso_pagelist[i + 1] = virt_to_page(&vdso_start + i * PAGE_SIZE);
> +		vdso_pagelist[i + 1] = virt_to_page(vdso_start + i * PAGE_SIZE);
>  
>  	/* Populate the special mapping structures */
> -	vdso_spec[0] = (struct vm_special_mapping) {
> +	vdso_spec[ilp32][0] = (struct vm_special_mapping) {
>  		.name	= "[vvar]",
>  		.pages	= vdso_pagelist,
>  	};
>  
> -	vdso_spec[1] = (struct vm_special_mapping) {
> +	vdso_spec[ilp32][1] = (struct vm_special_mapping) {
>  		.name	= "[vdso]",
>  		.pages	= &vdso_pagelist[1],
>  	};
>  
>  	return 0;
>  }
> +
> +static int __init vdso_init(void)
> +{
> +	return vdso_init_common(&vdso_start, &vdso_end,
> +				&vdso_pages, &vdso_pagelist, 0);
> +}
>  arch_initcall(vdso_init);
>  
> +#ifdef CONFIG_ARM64_ILP32
> +static int __init vdso_ilp32_init(void)
> +{
> +	return vdso_init_common(&vdso_ilp32_start, &vdso_ilp32_end,
> +				&vdso_ilp32_pages, &vdso_ilp32_pagelist, 1);
> +}
> +arch_initcall(vdso_ilp32_init);
> +#endif
> +
>  int arch_setup_additional_pages(struct linux_binprm *bprm,
>  				int uses_interp)
>  {
>  	struct mm_struct *mm = current->mm;
>  	unsigned long vdso_base, vdso_text_len, vdso_mapping_len;
>  	void *ret;
> -
> -	vdso_text_len = vdso_pages << PAGE_SHIFT;
> +	struct page **pagelist;
> +	unsigned long pages;
> +	bool ilp32;
> +
> +#ifdef CONFIG_ARM64_ILP32
> +	ilp32 = is_ilp32_compat_task();
> +	if (is_ilp32_compat_task()) {
> +		pages = vdso_ilp32_pages;
> +		pagelist = vdso_ilp32_pagelist;
> +	} else
> +#endif

Same

> +	{
> +		ilp32 = false;
> +		pages = vdso_pages;
> +		pagelist = vdso_pagelist;
> +	}
> +	vdso_text_len = pages << PAGE_SHIFT;
>  	/* Be sure to map the data page */
> -	vdso_mapping_len = vdso_text_len + PAGE_SIZE;
> +	vdso_mapping_len = (pages + 1) << PAGE_SHIFT;
>  
>  	down_write(&mm->mmap_sem);
>  	vdso_base = get_unmapped_area(NULL, 0, vdso_mapping_len, 0, 0);
> @@ -172,7 +215,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
>  	}
>  	ret = _install_special_mapping(mm, vdso_base, PAGE_SIZE,
>  				       VM_READ|VM_MAYREAD,
> -				       &vdso_spec[0]);
> +				       &vdso_spec[ilp32][0]);
>  	if (IS_ERR(ret))
>  		goto up_fail;
>  
> @@ -181,7 +224,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
>  	ret = _install_special_mapping(mm, vdso_base, vdso_text_len,
>  				       VM_READ|VM_EXEC|
>  				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
> -				       &vdso_spec[1]);
> +				       &vdso_spec[ilp32][1]);
>  	if (IS_ERR(ret))
>  		goto up_fail;
>  
> 

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
