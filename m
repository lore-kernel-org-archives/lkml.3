Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbaIQNxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:53:42 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:56158 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401AbaIQNxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140917132141.GD5358@nazgul.tnic>
References: <20140917124501.GC5358@nazgul.tnic>
	<1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
	<1410958454-7501-2-git-send-email-namit@cs.technion.ac.il>
	<20140917132141.GD5358@nazgul.tnic>
Date: Wed, 17 Sep 2014 16:53:39 +0300
X-Google-Sender-Auth: Tp2e9FPEdibYMfmcWWtNzSejMgE
Message-ID: <CAKLkAJ5wYuDL+96RcRwxi7xD1iAK8_oug1zC_niipV-ToCUu=A@mail.gmail.com>
Subject: Re: [RESEND PATCH 1/3] x86: Adding structs to reflect cpuid fields
From: Nadav Amit <namit@cs.technion.ac.il>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>, kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

Thanks for you comments - please see inline.

On Wed, Sep 17, 2014 at 4:21 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Sep 17, 2014 at 03:54:12PM +0300, Nadav Amit wrote:
>> Adding structs that reflect various cpuid fields in x86 architecture. Structs
>> were added only for functions that are not pure bitmaps.
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> ---
>>  arch/x86/include/asm/cpuid_def.h | 163 +++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 163 insertions(+)
>>  create mode 100644 arch/x86/include/asm/cpuid_def.h
>>
>> diff --git a/arch/x86/include/asm/cpuid_def.h b/arch/x86/include/asm/cpuid_def.h
>> new file mode 100644
>> index 0000000..0cf43ba
>> --- /dev/null
>> +++ b/arch/x86/include/asm/cpuid_def.h
>> @@ -0,0 +1,163 @@
>> +#ifndef ARCH_X86_KVM_CPUID_DEF_H
>> +#define ARCH_X86_KVM_CPUID_DEF_H
>> +
>> +union cpuid1_eax {
>> +     struct {
>> +             unsigned int stepping_id:4;
>> +             unsigned int model:4;
>> +             unsigned int family_id:4;
>> +             unsigned int processor_type:2;
>
> This is not present on AMD so now you need to start differentiate
> between vendors. Not a big deal, it simply doesn't get touched as it is
> in the reserved range there...

It does not seem to be coincidence; AMD and Intel appear to be
synchronised when it comes to CPUID, MSRs and opcodes.

>
>> +             unsigned int reserved:2;
>> +             unsigned int extended_model_id:4;
>> +             unsigned int extended_family_id:8;
>> +             unsigned int reserved2:4;
>> +     } split;
>> +     unsigned int full;
>> +};
>> +
>> +union cpuid1_ebx {
>> +     struct {
>> +             unsigned int brand_index:8;
>> +             unsigned int clflush_size:8;
>> +             unsigned int max_logical_proc:8;
>> +             unsigned int initial_apicid:8;
>> +     } split;
>> +     unsigned int full;
>> > +
>> +
>> +union cpuid4_eax {
>> +     struct {
>> +             unsigned int cache_type:5;
>> +             unsigned int cache_level:3;
>> +             unsigned int self_init_cache_level:1;
>> +             unsigned int fully_associative:1;
>> +             unsigned int reserved:4;
>> +             unsigned int max_logical_proc:12;
>> +             unsigned int max_package_proc:6;
>> +     } split;
>> +     unsigned int full;
>> +};
>> +
>> +union cpuid4_ebx {
>> +     struct {
>> +             unsigned int coherency_line_size:12;
>> +             unsigned int physical_line_partitions:10;
>> +             unsigned int ways:10;
>> +     } split;
>> +     unsigned int full;
>> +};
>> +
>> +union cpuid5_eax {
>> +     struct {
>> +             unsigned int min_monitor_line_size:16;
>> +             unsigned int reserved:16;
>
> ... the problem with hardcoding those bitfields I see are those reserved
> fields. The moment hw guys decide to widen, say, that smallest monitor
> line size, you need the ifdeffery around it. Which automatically becomes
> ugly and now all of a sudden you need to pay attention to it.

AFAIK backward compatibility is usually maintained in x86. I did not
see in Intel SDM anything that says "this CPUID field means something
for CPU X and something else for CPU Y". Anyhow, it is not different
than bitmasks in this respect.

>
> And not all vendors define all bits the same so you're probably going to
> have to differentiate there too, at some point.
I am not sure, unless an additional x86 competitor comes to the market...

>
> Oh, and I don't see what is wrong with opening the CPUID manual in
> parallel and looking at the bits.
Well, cscope still does not handle bitmasks. You could have made the
same argument for segment descriptors, yet desc_struct exists and I
think its wide use shows its easier to use.

>
> So, IMO, doing this is a bad idea.
I don't want to be a snitch, but cpuid10_eax and other PMU related
cpuid structures already use bitfields, so I don't understand what all
the fuss is about.

Regards,
Nadav
