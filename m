Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaJPQWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 12:22:06 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60436 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbaJPQWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 12:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <20141016154914.GD30314@nazgul.tnic>
References: <cover.1413323611.git.luto@amacapital.net> <93ffc13d9e829f3ded9776fec62385bccb7439e1.1413323612.git.luto@amacapital.net>
 <20141016154914.GD30314@nazgul.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 16 Oct 2014 09:21:42 -0700
Message-ID: <CALCETrVmS+ZNj+iXNTy5zC8araMH=x=jUBNDMUNPDJwu0huMMQ@mail.gmail.com>
Subject: Re: [RFC 3/5] x86: Add a comment clarifying LDT context switching
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 8:49 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Oct 14, 2014 at 03:57:37PM -0700, Andy Lutomirski wrote:
>> The code is correct, but only for a rather subtle reason.  This
>> confused me for quite a while when I read switch_mm, so clarify the
>> code to avoid confusing other people, too.
>>
>> TBH, I wouldn't be surprised if this code was only correct by
>> accident.
>>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>> ---
>>  arch/x86/include/asm/mmu_context.h | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
>> index 166af2a8e865..04478103df37 100644
>> --- a/arch/x86/include/asm/mmu_context.h
>> +++ b/arch/x86/include/asm/mmu_context.h
>> @@ -53,7 +53,16 @@ static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
>>               /* Stop flush ipis for the previous mm */
>>               cpumask_clear_cpu(cpu, mm_cpumask(prev));
>>
>> -             /* Load the LDT, if the LDT is different: */
>> +             /*
>> +              * Load the LDT, if the LDT is different.
>> +              *
>> +              * It's possible leave_mm(prev) has been called.  If so,
>> +              * then prev->context.ldt could be out of sync with the
>> +              * LDT descriptor or the LDT register.  This can only happen
>
> I'm staring at the code and trying to figure out where on the leave_mm()
> path this could happen. Got any code pointers?

I think it's the same as in the other case in switch_mm.  leave_mm
does cpumask_clear_cpu(cpu, mm_cpumask(active_mm)), and, once that has
happened, modify_ldt won't send an IPI to this CPU.  So, if leave_mm
runs, and then another CPU calls modify_ldt on the mm that is in lazy
mode here, it won't update our LDT register, so the LDT register and
prev->context.ldt might not match.

I think that, if that's the case, then prev->context.ldt can't be NULL
and can't have the same non-NULL value as next->context.ldt.  I hope.

I'll try to make the comment clearer in v2.

--Andy

>
> :-)
>
>> +              * if prev->context.ldt is non-null, since we never free
>> +              * an LDT.  But LDTs can't be shared across mms, so
>> +              * prev->context.ldt won't be equal to next->context.ldt.
>> +              */
>>               if (unlikely(prev->context.ldt != next->context.ldt))
>>                       load_LDT_nolock(&next->context);
>>       }
>> --
>> 1.9.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> Regards/Gruss,
>     Boris.
> --



-- 
Andy Lutomirski
AMA Capital Management, LLC
