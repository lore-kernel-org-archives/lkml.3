Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaLETGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:06:50 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:50911 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaLETGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:06:48 -0500
Message-ID: <54820244.5010304@gmail.com>
Date: Fri, 05 Dec 2014 11:06:44 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Zubair.Kakakhel@imgtec.com, geert+renesas@glider.be,
        david.daney@cavium.com, Peter Zijlstra <peterz@infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, davidlohr@hp.com,
        "Maciej W. Rozycki" <macro@linux-mips.org>, chenhc@lemote.com,
        cl@linux.com, Ingo Molnar <mingo@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        James Hogan <james.hogan@imgtec.com>, Tejun Heo <tj@kernel.org>,
        alex@alex-smith.me.uk, Paolo Bonzini <pbonzini@redhat.com>,
        John Crispin <blogic@openwrt.org>,
        Paul Burton <paul.burton@imgtec.com>, qais.yousef@imgtec.com,
        LKML <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Markos Chandras <markos.chandras@imgtec.com>, dengcheng.zhu@imgtec.com,
        manuel.lauss@gmail.com, lars.persson@axis.com
Subject: Re: [PATCH v3 3/3] MIPS: set stack/data protection as non-executable
References: <20141203015537.13886.50830.stgit@linux-yegoshin> <20141203015824.13886.74616.stgit@linux-yegoshin> <5481EB52.6060706@gmail.com> <CAGXu5jJJx0O7GhHghy+sC4fJL2O=RsO+Zgm78r9SNt-aTbhqcw@mail.gmail.com>
In-Reply-To: <CAGXu5jJJx0O7GhHghy+sC4fJL2O=RsO+Zgm78r9SNt-aTbhqcw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 10:51 AM, Kees Cook wrote:
> On Fri, Dec 5, 2014 at 9:28 AM, David Daney <ddaney.cavm@gmail.com> wrote:
>> On 12/02/2014 05:58 PM, Leonid Yegoshin wrote:
>>>
>>> This is a last step of 3 patches which shift FPU emulation out of
>>> stack into protected area. So, it disables a default executable stack.
>>>
>>> Additionally, it sets a default data area non-executable protection.
>>>
>>> Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
>>
>>
>> NAK!
>>
>> Some programs require an executable stack, this patch will break them.
>
> Have you tested this?

Do you require empirical evidence that the patch is incorrect, or is it 
enough to just to trust me when I say that it is incorrect?  Typically 
the burden of proof is with those proposing the patches.

>
>> You can only select a non-executable stack in response to PT_GNU_STACK
>> program headers in the ELF file of the executable program.
>
> This is already handled by fs/binfmt_elf.c. It does the parsing of the
> PT_GNU_STACK needs, and sets up the stack flags appropriately. All the
> change to VM_DATA_DEFAULT_FLAGS does is make sure that EXSTACK_DEFAULT
> now means no VM_EXEC by default. If PT_GNU_STACK requires it, it gets
> added back in.
>

The problem is not with "modern" executables that are properly annotated 
with PT_GNU_STACK.

My objection is to the intentional breaking of old executables that have 
no PT_GNU_STACK annotation, but require an executable stack.  Since we 
usually try not to break userspace, we cannot merge a patch like this one.

David Daney.


> -Kees
>
>>
>> David Daney
>>
>>
>>
>>> ---
>>>    arch/mips/include/asm/page.h |    2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/mips/include/asm/page.h b/arch/mips/include/asm/page.h
>>> index 3be81803595d..d49ba81cb4ed 100644
>>> --- a/arch/mips/include/asm/page.h
>>> +++ b/arch/mips/include/asm/page.h
>>> @@ -230,7 +230,7 @@ extern int __virt_addr_valid(const volatile void
>>> *kaddr);
>>>    #define virt_addr_valid(kaddr)
>>> \
>>>          __virt_addr_valid((const volatile void *) (kaddr))
>>>
>>> -#define VM_DATA_DEFAULT_FLAGS  (VM_READ | VM_WRITE | VM_EXEC | \
>>> +#define VM_DATA_DEFAULT_FLAGS  (VM_READ | VM_WRITE | \
>>>                                   VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
>>>
>>>    #define UNCAC_ADDR(addr)      ((addr) - PAGE_OFFSET + UNCAC_BASE)
>>>
>>>
>>>
>>>
>>
>
>
>

