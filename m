Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbaEOR2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:28:32 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:61820 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255AbaEOR2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:28:31 -0400
Date: Thu, 15 May 2014 13:28:28 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Richard Lee <superlibj8301@gmail.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, iamjoonsoo.kim@lge.com,
        santosh.shilimkar@ti.com, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, Li.Xiubo@freescale.com,
        robherring2@gmail.com, linux-kernel@vger.kernel.org,
        lauraa@codeaurora.org
Subject: Re: [PATCHv2] ARM: ioremap: Fix static vm area boundary checking.
In-Reply-To: <1400142562-9111-1-git-send-email-superlibj8301@gmail.com>
Message-ID: <alpine.LFD.2.11.1405151325250.17310@knanqh.ubzr>
References: <1400142562-9111-1-git-send-email-superlibj8301@gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Richard Lee wrote:

> Static vm area boundary check:
> 
>       paddr1 --->|       |
>                  |       |
>                  |-------| <-\--- svm->vm->addr(is page aligned)
>       paddr2 --->|       |    |
>                  |     --| <--|-- svm->vm->phys_addr
>                  |       |    |
>       paddr3 --->|       |    |
>                  |       |    |
>                  |-------| <--|-- next page boundary
>                  |       |    |
>       paddr4 --->|       |    | <----- svm->vm->size(including guard page)
>                  |       |    |
>                  |       |    |
> max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
>                  | ///// |    |
>       paddr5 --->| guard |    |
>                  | page  |    |
>                  | ///// |    |
>                   -------  <-/--- svm->vm->addr + svm->vm_size
> 
> <1> If the paddr == paddr1, then continue;
> <2> If the paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
>     then continue;
> <3> if the paddr >= paddr5 then continue;
> 
> Signed-off-by: Richard Lee <superlibj8301@gmail.com>

instead of doing this repeatedly, why not simply ensure the recorded 
static vm information is already page aligned in the first place?



> ---
> 
> 
> Change in V2:
>  - PAGE_SIZE --> PAGE_MASK
>  - remove the 'size' page size align operation.
> 
> 
> 
> 
> 
> 
>  arch/arm/mm/ioremap.c | 40 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index be69333..f235ab7 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -47,16 +47,52 @@ static struct static_vm *find_static_vm_paddr(phys_addr_t paddr,
>  {
>  	struct static_vm *svm;
>  	struct vm_struct *vm;
> +	size_t offset;
> +
> +	offset = paddr & ~PAGE_MASK;
>  
>  	list_for_each_entry(svm, &static_vmlist, list) {
> +		phys_addr_t paddr_end, phys_addr_end;
> +		size_t vmoff;
> +
>  		vm = &svm->vm;
>  		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
>  			continue;
>  		if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
>  			continue;
>  
> -		if (vm->phys_addr > paddr ||
> -			paddr + size - 1 > vm->phys_addr + vm->size - 1)
> +		/* Static vm area boundary check:
> +		 *
> +		 *       paddr1 --->|       |
> +		 *                  |       |
> +		 *                  |-------| <-\--- svm->vm->addr(page aligned)
> +		 *       paddr2 --->|       |    |
> +		 *                  |     --| <--|-- svm->vm->phys_addr
> +		 *                  |       |    |
> +		 *       paddr3 --->|       |    |
> +		 *                  |       |    |
> +		 *                  |-------| <--|-- next page boundary
> +		 *                  |       |    |
> +		 *       paddr4 --->|       |    | <----- svm->vm->size,
> +		 *                  |       |    |         including guard page
> +		 *                  |       |    |
> +		 * max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
> +		 *                  | ///// |    |
> +		 *       paddr5 --->| guard |    |
> +		 *                  | page  |    |
> +		 *                  | ///// |    |
> +		 *                   -------  <-/-- svm->vm->addr + svm->vm_size
> +		 *
> +		 * <1> If paddr == paddr1, then continue;
> +		 * <2> If paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
> +		 *     then continue;
> +		 * <3> if paddr >= paddr5 then continue;
> +		 */
> +		vmoff = vm->phys_addr & ~PAGE_MASK;
> +		phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - vmoff;
> +		paddr_end = paddr + size - offset;
> +		if (__phys_to_pfn(vm->phys_addr) > __phys_to_pfn(paddr) ||
> +			paddr_end - 1 > phys_addr_end - 1)
>  			continue;
>  
>  		return svm;
> -- 
> 1.8.4
> 
