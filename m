Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaEMGV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:21:26 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:34133 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaEMGVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAL_JsqK=BiZx31xUC=_8s7+QeAGjrWePOzeDLEt=YfpdLbS_KA@mail.gmail.com>
References: <1399861195-21087-1-git-send-email-superlibj8301@gmail.com>
	<1399861195-21087-2-git-send-email-superlibj8301@gmail.com>
	<CAL_JsqK=BiZx31xUC=_8s7+QeAGjrWePOzeDLEt=YfpdLbS_KA@mail.gmail.com>
Date: Tue, 13 May 2014 14:21:24 +0800
Message-ID: <CAHPCO9G8nqVfBXw3ej_Ot8CUkKgVB5QiZtkd9y+JBOBAaeJ7GQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] mm/vmalloc: Add IO mapping space reused interface.
From: Richard Lee <superlibj8301@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Lee <superlibj@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:13 AM, Rob Herring <robherring2@gmail.com> wrote:
> On Sun, May 11, 2014 at 9:19 PM, Richard Lee <superlibj8301@gmail.com> wrote:
>> For the IO mapping, for the same physical address space maybe
>> mapped more than one time, for example, in some SoCs:
>> 0x20000000 ~ 0x20001000: are global control IO physical map,
>> and this range space will be used by many drivers.
>
> What address or who the user is isn't really relevant.
>
>> And then if each driver will do the same ioremap operation, we
>> will waste to much malloc virtual spaces.
>
> s/malloc/vmalloc/
>
>>
>> This patch add the IO mapping space reusing interface:
>> - find_vm_area_paddr: used to find the exsit vmalloc area using
>
> s/exsit/exist/
>

Yes, see the next version.

[...]
>> +{
>> +       struct vmap_area *va;
>> +
>> +       va = find_vmap_area((unsigned long)addr);
>> +       if (!va || !(va->flags & VM_VM_AREA) || !va->vm)
>> +               return 1;
>> +
>> +       if (va->vm->used <= 1)
>> +               return 1;
>> +
>> +       --va->vm->used;
>
> What lock protects this? You should use atomic ops here.
>

Yes, it is.


[...]
>> +       if (!(flags & VM_IOREMAP))
>> +               return NULL;
>> +
>> +       rcu_read_lock();
>> +       list_for_each_entry_rcu(va, &vmap_area_list, list) {
>> +               phys_addr_t phys_addr;
>> +
>> +               if (!va || !(va->flags & VM_VM_AREA) || !va->vm)
>> +                       continue;
>> +
>> +               phys_addr = va->vm->phys_addr;
>> +
>> +               if (paddr < phys_addr || paddr + size > phys_addr + va->vm->size)
>> +                       continue;
>> +
>> +               *offset = paddr - phys_addr;
>> +
>> +               if (va->vm->flags & VM_IOREMAP && va->vm->size >= size) {
>> +                       va->vm->used++;
>
> What lock protects this? It looks like you are modifying this with
> only a rcu reader lock.

I'll try to use the proper lock ops for this later.



Thanks very much,

Richard


>
>> +                       rcu_read_unlock();
>> +                       return va->vm;
>> +               }
>> +       }
>> +       rcu_read_unlock();
>> +
>> +       return NULL;
>> +}
>> +
>>  /**
>>   *     find_vm_area  -  find a continuous kernel virtual area
>>   *     @addr:          base address
>> --
>> 1.8.4
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
