Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbaGOTDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:03:04 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:41780 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932734AbaGOTC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <53C57A68.10100@oracle.com>
References: <08bf951548224b92c0316c93cf0064d90e392578.1405441297.git.luto@amacapital.net>
 <53C562B4.3030709@oracle.com> <CALCETrVU=y_ym9ZGwSDy1bwpx+qxga8V=kEi4g9Pubnv0A91nw@mail.gmail.com>
 <53C57A68.10100@oracle.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Jul 2014 12:02:37 -0700
Message-ID: <CALCETrXGDvprLCB259Lhcx_iPO3fvNkbvEBnrSx0s86PAO-r6A@mail.gmail.com>
Subject: Re: [RFC PATCH] x86_64,entry,xen: Do not invoke espfix64 on Xen
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 12:00 PM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
> On 07/15/2014 01:22 PM, Andy Lutomirski wrote:
>>
>> On Tue, Jul 15, 2014 at 10:19 AM, Boris Ostrovsky
>> <boris.ostrovsky@oracle.com> wrote:
>>>
>>> On 07/15/2014 12:23 PM, Andy Lutomirski wrote:
>>>>
>>>>
>>>> diff --git a/arch/x86/kernel/paravirt_patch_64.c
>>>> b/arch/x86/kernel/paravirt_patch_64.c
>>>> index 3f08f34..a1da673 100644
>>>> --- a/arch/x86/kernel/paravirt_patch_64.c
>>>> +++ b/arch/x86/kernel/paravirt_patch_64.c
>>>> @@ -6,7 +6,6 @@ DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
>>>>    DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
>>>>    DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
>>>>    DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
>>>> -DEF_NATIVE(pv_cpu_ops, iret, "iretq");
>>>>    DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
>>>>    DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
>>>>    DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
>>>> @@ -50,7 +49,6 @@ unsigned native_patch(u8 type, u16 clobbers, void
>>>> *ibuf,
>>>>                  PATCH_SITE(pv_irq_ops, save_fl);
>>>>                  PATCH_SITE(pv_irq_ops, irq_enable);
>>>>                  PATCH_SITE(pv_irq_ops, irq_disable);
>>>> -               PATCH_SITE(pv_cpu_ops, iret);
>>>
>>>
>>>
>>> Does this mean that we are no longer patching IRET with a jump to a
>>> hypercall?
>>>
>> IIUC this means that, on native, we are no longer patching
>> INTERRUPT_RETURN with an "iretq" instruction, so INTERRUPT_RETURN will
>> remain a "jmp native_iret".  I'm not sure why this patch was there in
>> the first place.  On Xen, it should still get patched with the
>> hypercall (although someone should verify this).
>
>
> Right, I missed the fact that this is native_patch.
>
> I did some light testing and it appears to work. Are you targeting this for
> 3.16?
>

That's the idea -- this, or some other fix, is needed for 3.16.

--Andy

> One way or the other we need to disable espfix64 on PV --- I discovered that
> one of Peter's tests crashes the hypervisor.
>
>
> -boris



-- 
Andy Lutomirski
AMA Capital Management, LLC
