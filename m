Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbaEOJCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 05:02:14 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51319 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaEOJCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 05:02:12 -0400
MIME-Version: 1.0
In-Reply-To: <623d49a4a07f4e5a956ccc8c2725e557@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1400133427-5653-1-git-send-email-superlibj8301@gmail.com>
	<623d49a4a07f4e5a956ccc8c2725e557@BY2PR03MB505.namprd03.prod.outlook.com>
Date: Thu, 15 May 2014 17:02:11 +0800
Message-ID: <CAHPCO9HVZSLHuL11zGnLQuuR-TnV7MTU2GDvJpf_+Qy5Dks6BA@mail.gmail.com>
Subject: Re: [PATCH] ARM: ioremap: Fix static vm area boundary checking.
From: Richard Lee <superlibj8301@gmail.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robherring2@gmail.com" <robherring2@gmail.com>,
        "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Thu, May 15, 2014 at 4:55 PM, Li.Xiubo@freescale.com
<Li.Xiubo@freescale.com> wrote:
>> Subject: [PATCH] ARM: ioremap: Fix static vm area boundary checking.
>>
>> Static vm area boundary check:
>>
>>       paddr1 --->|       |
>>                  |       |
>>                  |-------| <-\--- svm->vm->addr(is page aligned)
>>       paddr2 --->|       |    |
>>                  |     --| <--|-- svm->vm->phys_addr
>>                  |       |    |
>>       paddr3 --->|       |    |
>>                  |       |    |
>>                  |-------| <--|-- next page boundary
>>                  |       |    |
>>       paddr4 --->|       |    | <----- svm->vm->size(including guard page)
>>                  |       |    |
>>                  |       |    |
>> max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
>>                  | ///// |    |
>>       paddr5 --->| guard |    |
>>                  | page  |    |
>>                  | ///// |    |
>>                   -------  <-/--- svm->vm->addr + svm->vm_size
>>
>> <1> If the paddr == paddr1, then continue;
>> <2> If the paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
>>     then continue;
>> <3> if the paddr >= paddr5 then continue;
>>
>> Signed-off-by: Richard Lee <superlibj8301@gmail.com>
>> ---
>>  arch/arm/mm/ioremap.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 42 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
>> index be69333..2fa41f4 100644
>> --- a/arch/arm/mm/ioremap.c
>> +++ b/arch/arm/mm/ioremap.c
>> @@ -47,16 +47,56 @@ static struct static_vm *find_static_vm_paddr(phys_addr_t
>> paddr,
>>  {
>>       struct static_vm *svm;
>>       struct vm_struct *vm;
>> +     size_t offset;
>> +
>> +     /*
>> +      * Make sure the size the mapping size is page aligned.
>> +      */
>> +     size = PAGE_ALIGN((paddr & ~PAGE_SIZE) + size);
>> +     offset = paddr & ~PAGE_SIZE;
>>
>
> Shouldn't it be PAGE_MASK ?
>

Yes, it is. I'll fix it.

Thanks,

Best regards,
Richard Lee


>
>>       list_for_each_entry(svm, &static_vmlist, list) {
>> +             phys_addr_t paddr_end, phys_addr_end;
>> +             size_t vmoff;
>> +
>>               vm = &svm->vm;
>>               if (!(vm->flags & VM_ARM_STATIC_MAPPING))
>>                       continue;
>>               if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
>>                       continue;
>>
>> -             if (vm->phys_addr > paddr ||
>> -                     paddr + size - 1 > vm->phys_addr + vm->size - 1)
>> +             /* Static vm area boundary check:
>> +              *
>> +              *       paddr1 --->|       |
>> +              *                  |       |
>> +              *                  |-------| <-\--- svm->vm->addr(page aligned)
>> +              *       paddr2 --->|       |    |
>> +              *                  |     --| <--|-- svm->vm->phys_addr
>> +              *                  |       |    |
>> +              *       paddr3 --->|       |    |
>> +              *                  |       |    |
>> +              *                  |-------| <--|-- next page boundary
>> +              *                  |       |    |
>> +              *       paddr4 --->|       |    | <----- svm->vm->size,
>> +              *                  |       |    |         including guard page
>> +              *                  |       |    |
>> +              * max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
>> +              *                  | ///// |    |
>> +              *       paddr5 --->| guard |    |
>> +              *                  | page  |    |
>> +              *                  | ///// |    |
>> +              *                   -------  <-/-- svm->vm->addr + svm->vm_size
>> +              *
>> +              * <1> If paddr == paddr1, then continue;
>> +              * <2> If paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
>> +              *     then continue;
>> +              * <3> if paddr >= paddr5 then continue;
>> +              */
>> +             vmoff = vm->phys_addr & ~PAGE_SIZE;
>
> And here.
>
> Thanks,
> BRs
> Xiubo
>
>> +             phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - vmoff;
>> +             paddr_end = paddr + size - offset;
>> +             if (__phys_to_pfn(vm->phys_addr) > __phys_to_pfn(paddr) ||
>> +                     paddr_end - 1 > phys_addr_end - 1)
>>                       continue;
>>
>>               return svm;
>> --
>> 1.8.4
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
