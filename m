Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaIHSft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 14:35:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:65234 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaIHSfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 14:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140908105307.GF26030@arm.com>
References: <1409959460-15989-1-git-send-email-behanw@converseincode.com>
	<20140908105307.GF26030@arm.com>
Date: Mon, 8 Sep 2014 11:35:47 -0700
Message-ID: <CAFzeTN2Q-RkOeDx4jG5jiEtiN7i+gkfmyvBC1b3B1wpDPUDdxw@mail.gmail.com>
Subject: Re: [PATCH] arm64: LLVMLinux: Fix inline arm64 assembly for use with clang
From: Mark Charlebois <charlebm@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "behanw@converseincode.com" <behanw@converseincode.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "cl@linux.com" <cl@linux.com>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "jays.lee@samsung.com" <jays.lee@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        "srivatsa.bhat@linux.vnet.ibm.com" <srivatsa.bhat@linux.vnet.ibm.com>,
        "steve.capper@linaro.org" <steve.capper@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "takahiro.akashi@linaro.org" <takahiro.akashi@linaro.org>,
        "Vijaya.Kumar@caviumnetworks.com" <Vijaya.Kumar@caviumnetworks.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@kernel.org" <acme@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Matthew Leach <Matthew.Leach@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "paulus@samba.org" <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I compile

int main()
{
        u64 foo, tmp;

        // This works for both clang and gcc
        asm volatile(
        "       mrs     %0, mair_el1\n"
        "       bfi     %0, %1, %2, #8\n"
        "       msr     mair_el1, %0\n"
        "       isb\n"
        : "=&r" (tmp)
        : "r" (foo), "i" (MT_NORMAL * 8));
}

with clang I get:

00000000004004f0 <main>:
  4004f0: d538a208 mrs x8, mair_el1
  4004f4: b3601d08 bfi x8, x8, #32, #8
  4004f8: d518a208 msr mair_el1, x8
  4004fc: d5033fdf isb
  400500: 2a1f03e0 mov w0, wzr
  400504: d65f03c0 ret

When I compile it with GCC I get:

0000000000400510 <main>:
  400510: d10043ff sub sp, sp, #0x10
  400514: f94003e1 ldr x1, [sp]
  400518: d538a200 mrs x0, mair_el1
  40051c: b3601c20 bfi x0, x1, #32, #8
  400520: d518a200 msr mair_el1, x0
  400524: d5033fdf isb
  400528: f90007e0 str x0, [sp,#8]
  40052c: 910043ff add sp, sp, #0x10
  400530: d65f03c0 ret

When I compile

int main()
{
        u64 foo, tmp;

       // This fails for clang but not gcc
        asm volatile(
        "       mrs     %0, mair_el1\n"
        "       bfi     %0, %1, #%2, #8\n"
        "       msr     mair_el1, %0\n"
        "       isb\n"
        : "=&r" (tmp)
        : "r" (foo), "i" (MT_NORMAL * 8));
}

Clang fails and GCC generates:

00000000004004f0 <main>:
  4004f0: d538a208 mrs x8, mair_el1
  4004f4: b3601d08 bfi x8, x8, #32, #8
  4004f8: d518a208 msr mair_el1, x8
  4004fc: d5033fdf isb
  400500: 2a1f03e0 mov w0, wzr
  400504: d65f03c0 ret

On Mon, Sep 8, 2014 at 3:53 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Sat, Sep 06, 2014 at 12:24:20AM +0100, behanw@converseincode.com wrote:
>> From: Mark Charlebois <charlebm@gmail.com>
>>
>> Fix variable types for 64-bit inline assembly.
>>
>> This patch now works with both gcc and clang.
>
> Really? This looks like something the clang needs to do better on, as I
> really don't see people adding these casts to future code. They're ugly and
> redundant (or GCC).
>
> This hunk:
>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index c555672..6894ef3 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -94,7 +94,7 @@ static int __init early_cachepolicy(char *p)
>>        */
>>       asm volatile(
>>       "       mrs     %0, mair_el1\n"
>> -     "       bfi     %0, %1, #%2, #8\n"
>> +     "       bfi     %0, %1, %2, #8\n"
>>       "       msr     mair_el1, %0\n"
>>       "       isb\n"
>>       : "=&r" (tmp)
>
> also looks fishy. Does gas accept that without the '#' prefix?
>
> Will
