Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaCISHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 14:07:14 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:36635 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaCISHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 14:07:12 -0400
Message-ID: <531CADC6.6020606@redhat.com>
Date: Sun, 09 Mar 2014 19:07:02 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: Dave Jones <davej@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [qemu64,+smep,+smap] WARNING: CPU: 1 PID: 0 at arch/x86/kernel/cpu/amd.c:220
 init_amd()
References: <20140307015833.GA10048@localhost> <53195336.9080606@linux.intel.com> <20140307055035.GA5230@localhost> <531A164B.8040402@linux.intel.com> <20140307191050.GA10961@redhat.com> <531A33A2.5030706@linux.intel.com> <20140307213856.GF5255@pd.tnic>
In-Reply-To: <20140307213856.GF5255@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/03/2014 22:38, Borislav Petkov ha scritto:
> + Paolo.
>
> (drop Andreas' old, invalid now email).
>
> On Fri, Mar 07, 2014 at 01:01:22PM -0800, H. Peter Anvin wrote:
>>> qemu64 triggers this ? That spew comes from amd_k7_smp_check()
>>> which should only run on family 6, which was all 32bit.
>>
>> [    0.152749] smpboot: CPU0: AMD QEMU Virtual CPU version 1.6.0 (fam:
>> 06, model: 02, stepping: 03)
>>
>> Seems they are using a really odd CPUID combination, then.
>
> qemu64 is (family, model, stepping) (6/6/3) and it runs into the
> amd_k7_smp_check() when booting a 32-bit kernel:

tl;dr: do not use qemu64, especially in system emulation mode.  In user 
mode it should work, user mode programs are less susceptible to bogus 
family/member/stepping.  When using dynamic translation in system 
emulation mode, use Haswell,+smap or Opteron_G3,+smep,+smap.  When using 
KVM, use whatever CPU model you're running on (or a least common 
denominator if doing migration).

qemu64's family/member/stepping makes no sense at all.  It is a really 
odd combination that means "enable all features that the QEMU dynamic 
translator supported at some time where people cared about -cpu qemu64". 
  So it has SVM and at the same time it misses SMEP/SMAP.  It also lacks 
some instruction set extensions such as BMI and ADX that QEMU does 
implement (I don't know if the kernel has any hand-optimized assembly 
that uses them).

*** If the above already worsened your opinion of virt people, skip
*** the next three paragraphs.  I don't want to give you a bad day.

On KVM we always make the vendor the same as the host because of the 
sysenter/syscall mess in 32-bit mode (AMD supports one and Intel 
supports the other).  But even if you're using Intel the 
family/member/stepping remains AMD!

We really should give a loud warning if qemu64 is used with KVM.  It 
makes no sense with KVM, even less than it does with dynamic translation.

On TCG it does make some sense that vendor is AMD, because QEMU can 
emulate SVM.  So perhaps we could change the family/member/stepping to 
e.g. an Opteron G3 (the last AMD chip without xsave/xrstor), but then 
with KVM you would have family=15 on Intel and I don't want to go there. 
  Perhaps we could give a loud warning with qemu64+KVM, and then do the 
above.

> So, even if we enable X86_FEATURE_MP in qemu for the "qemu64" model
> (diff below), which is, or rather used to be CPUID_80000001[19] for K7,
> qemu goes and asks the host which CPUID bits it supports and filters
> those bits out from the requested features.

You're not adding the bit to TCG_EXT2_FEATURES, so it's masked out.

The patch has also some backwards-compatibility gunk missing, and we're 
in hard-freeze now, but if you remind me at the end of April (I'm on 
vacation until April 23) I'll try to fix all this mess for QEMU 2.1.

> Oh, and the thing has CPUID_EXT2_LM which is also a WTH moment for me.

Well, it's "64" for a reason.  LM in qemu64 is perhaps the only thing 
that makes sense.  :)

Paolo

> Paolo, what's going on here?
>
> Anyway, this is how it looks from here.
>
> diff --git a/target-i386/cpu.c b/target-i386/cpu.c
> index 0e8812a11d1e..981ce9ea992b 100644
> --- a/target-i386/cpu.c
> +++ b/target-i386/cpu.c
> @@ -565,7 +565,8 @@ static x86_def_t builtin_x86_defs[] = {
>              CPUID_EXT_SSE3 | CPUID_EXT_CX16 | CPUID_EXT_POPCNT,
>          .features[FEAT_8000_0001_EDX] =
>              (PPRO_FEATURES & CPUID_EXT2_AMD_ALIASES) |
> -            CPUID_EXT2_LM | CPUID_EXT2_SYSCALL | CPUID_EXT2_NX,
> +            CPUID_EXT2_LM | CPUID_EXT2_SYSCALL | CPUID_EXT2_NX |
> +           CPUID_EXT2_MP,
>          .features[FEAT_8000_0001_ECX] =
>              CPUID_EXT3_LAHF_LM | CPUID_EXT3_SVM |
>              CPUID_EXT3_ABM | CPUID_EXT3_SSE4A,
>
>

