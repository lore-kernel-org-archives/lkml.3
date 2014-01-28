Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaA1Vr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:47:29 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40913 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaA1Vr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:47:28 -0500
MIME-Version: 1.0
In-Reply-To: <52E7FA3E.4000400@redhat.com>
References: <1390769416-2835-1-git-send-email-yinghai@kernel.org>
	<52E7FA3E.4000400@redhat.com>
Date: Tue, 28 Jan 2014 13:47:27 -0800
X-Google-Sender-Auth: HY3ZoKKjqetyuGvm8i8_a0IcN6E
Message-ID: <CAE9FiQU9-WW4aD5Tjd3aNfGd3CELjCCrHRT5SO51R=zgmV-Uxg@mail.gmail.com>
Subject: Re: [PATCH -v2] x86, irq: get correct available vectors for cpu disable
From: Yinghai Lu <yinghai@kernel.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 10:43 AM, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 01/26/2014 03:50 PM, Yinghai Lu wrote:
>> assign_irq_vector will stop before first_system_vector.
>> also it will not vector that is set in used_vectors.
>>
>> used_vectors is used to track non per_cpu irq_vector in vector_irq.
>> It include first 32 exception [0,1f) and system vector near 0xfe.
>> and IA32_SYSCALL_VECTOR (0x80), IRQ_MOVE_CLEANUP_VECTOR (0x20).
>>
>> So add checking for them for counting avaiable vectors.
>>
>
> Yinghai, no objection to the patch ... but how about
>
>
> used_vectors is a bitmap for global irqs; it tracks the non per_cpu
> irq_vectors in vector_irq.  used_vectors contains information on the first 32
> exceptions (0 to 0x1f), the system vectors near the first system vector
> (0xfe), the IA32_SYSCALL_VECTOR (0x80), and the IRQ_MOVE_CLEANUP_VECTOR (0x20)
>
> assign_irq_vectors() assigns vectors up to first_system_vector (0xfe) and
> sets the used_vectors bit for each assigned vector.

No, assign_irq_vectors will not touch used_vectors.

>  Currently, the
> IRQ checking code only scans from the FIRST_EXTERNAL_VECTOR to the end of
> the vectors.  This patch modifies the code to scan to first_system_vector
> and do a test on the used_vectors bitmap.

first_system_vector start from 0xfe, and will be updated ....would end up with
0xf7.

>
>
> ... and ...
>
>> -v2: fix compiling problem.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
>> ---
>>  arch/x86/kernel/irq.c |   16 ++++++++++++++--
>>  1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> Index: linux-2.6/arch/x86/kernel/irq.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/irq.c
>> +++ linux-2.6/arch/x86/kernel/irq.c
>> @@ -17,6 +17,7 @@
>>  #include <asm/idle.h>
>>  #include <asm/mce.h>
>>  #include <asm/hw_irq.h>
>> +#include <asm/desc.h>
>>
>>  #define CREATE_TRACE_POINTS
>>  #include <asm/trace/irq_vectors.h>
>> @@ -321,8 +322,19 @@ int check_irq_vectors_for_cpu_disable(vo
>>       for_each_online_cpu(cpu) {
>>               if (cpu == this_cpu)
>>                       continue;
>> -             for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
>> -                  vector++) {
>> +
>> +             /*
>> +              * assign_irq_vector() only use vector under
>> +              * first_system_vector and not set in used_vectors bitmask.
>> +              * used_vectors could have bits set for
>> +              *      IA32_SYSCALL_VECTOR (0x80)
>> +              *      IRQ_MOVE_CLEANUP_VECTOR (0x20)
>> +              */
>
>
> +               /*
> +                * assign_irq_vector() will only scan non per_cpu vectors from
> +                * FIRST_EXTERNAL_VECTOR to first_system_vector (0xfe) and not
> +                * set in used_vectors bitmask.  This takes into account
> +                * the IA32_SYSCALL_VECTOR and the IRQ_MOVE_CLEANUP_VECTOR,
> +                * which should not be counted.
> +                */
>
> ... what do you think?
>

will send updated version.

Thanks

Yinghai
