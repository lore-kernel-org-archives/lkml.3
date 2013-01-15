Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3AOAgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:36:24 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52630 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681Ab3AOAgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:36:23 -0500
Message-ID: <50F4A484.4010506@gmail.com>
Date: Mon, 14 Jan 2013 16:36:20 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Cooper <alcooperx@gmail.com>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: function tracer: Fix broken function tracing
References: <1357914810-20656-1-git-send-email-alcooperx@gmail.com> <50F0454D.5060109@gmail.com> <CAOGqxeU3zZuFfL_M1u-hgjbPHgm6MrzoCK1KqpbazwKC4td4ww@mail.gmail.com> <50F482D1.4090301@gmail.com> <CAOGqxeW+roq4opj_1+bFTeFk1=75qooBxNLB9JGJWrfs-GG7hQ@mail.gmail.com>
In-Reply-To: <CAOGqxeW+roq4opj_1+bFTeFk1=75qooBxNLB9JGJWrfs-GG7hQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 04:13 PM, Alan Cooper wrote:
> On Mon, Jan 14, 2013 at 5:12 PM, David Daney <ddaney.cavm@gmail.com> wrote:
>> On 01/14/2013 01:10 PM, Alan Cooper wrote:
>>>
>>> I already tried using "adddiu sp, sp, 8" and it caused the kernel to
>>> randomly crash. After many hours of debugging the reason occurred to
>>> me while in bed in the middle of the night. The problem is that if we
>>> get an interrupt between the add 8 and the add -8 instructions, we
>>> trash the existing stack.
>>>
>>> The problem with the 2 nop approach is that there are a series of
>>> subroutines used to write each nop and these nested subroutines are
>>> traceable.
>>
>>
>> This seems like a bug.  The low-level code used to do code patching probably
>> should be CFLAGS_REMOVE_file.o = -pg
>
> While tracing mcount cannot be done because it's recursive, allowing
> tracing of the code to enable/disable the call to mcount can be done
> and seems useful. Also, fixing the 2 nop solution this way will still
> not allow us to stop using stop_machine() which is hugely disruptive
> to a running system. Remember that when tracing is enabled and
> disabled we end up modifying 20 to 30 thousand functions. Moving this
> functionality out of stop_machine() seems like a big benefit.


The main point of code patching is to have the Tracing Off state be very 
low overhead.  So low that it might be acceptable to leave it on in a 
production kernel.

Now imagine a highly pipe-lined CPU architecture with a good branch 
predictor.

Issuing a NOP instruction is very low overhead.  At most one cycle (a 
fraction of a cycle on a multi-issue CPU).  A Branch Likely that 
mispredicts (as all of these probably will) can incur a full pipeline 
flush which can be 10 or more cycles on some machines.  This is quite a 
hit for something that is supposed to be low overhead.

It is better than nothing I guess, but I think a better approach would 
be to modify GCC to generate something easier to handle (this is what we 
did for MIPS64).



>
>>
>>
>>
>>> This means on the second call to these subroutines they
>>> execute with only one nop and crash. I could  write  some new code
>>> that wrote the 2 nops at once, but (now that I understand
>>> "stop_machine") with the branch likely solution we should be able to
>>> stop using "stop_machine" when we write nops to the 20-30 thousand
>>> Linux functions. It looks like other platforms have stopped using
>>> stop_machine.
>>
>>
>> I don't particularly object to the 'branch likely solution', but I think the
>> failures of the other approaches indicates underlying bugs in the tracing
>> code.  Those bugs should probably be fixed.
>
> If a solution can be found that modifies a single 32bit instruction to
> enable/disable tracing, I don't see any bugs in the underlying code.
> Plus we can avoid using stop_machine().
>
>>
>> David Daney
>>
>>
>>
>>>
>>> Al
>>>
>>> On Fri, Jan 11, 2013 at 12:01 PM, David Daney <ddaney.cavm@gmail.com>
>>> wrote:
>>>>
>>>> On 01/11/2013 06:33 AM, Al Cooper wrote:
>>>>>
>>>>>
>>>>> Function tracing is currently broken for all 32 bit MIPS platforms.
>>>>> When tracing is enabled, the kernel immediately hangs on boot.
>>>>> This is a result of commit b732d439cb43336cd6d7e804ecb2c81193ef63b0
>>>>> that changes the kernel/trace/Kconfig file so that is no longer
>>>>> forces FRAME_POINTER when FUNCTION_TRACING is enabled.
>>>>>
>>>>> MIPS frame pointers are generally considered to be useless because
>>>>> they cannot be used to unwind the stack. Unfortunately the MIPS
>>>>> function tracing code has bugs that are masked by the use of frame
>>>>> pointers. This commit fixes the bugs so that MIPS frame pointers do
>>>>> not need to be enabled.
>>>>>
>>>>> The bugs are a result of the odd calling sequence used to call the trace
>>>>> routine. This calling sequence is inserted into every tracable function
>>>>> when the tracing CONFIG option is enabled. This sequence is generated
>>>>> for 32bit MIPS platforms by the compiler via the "-pg" flag.
>>>>> Part of the sequence is "addiu sp,sp,-8" in the delay slot after every
>>>>> call to the trace routine "_mcount" (some legacy thing where 2 arguments
>>>>> used to be pushed on the stack). The _mcount routine is expected to
>>>>> adjust the sp by +8 before returning.
>>>>>
>>>>> One of the bugs is that when tracing is disabled for a function, the
>>>>> "jalr _mcount" instruction is replaced with a nop, but the
>>>>> "addiu sp,sp,-8" is still executed and the stack pointer is left
>>>>> trashed. When frame pointers are enabled the problem is masked
>>>>> because any access to the stack is done through the frame
>>>>> pointer and the stack pointer is restored from the frame pointer when
>>>>> the function returns. This patch uses a branch likely instruction
>>>>> "bltzl zero, f1" instead of "nop" to disable the call because this
>>>>> instruction will not execute the "addiu sp,sp,-8" instruction in
>>>>> the delay slot. The other possible solution would be to nop out both
>>>>> the jalr and the "addiu sp,sp,-8", but this would need to be interrupt
>>>>> and SMP safe and would be much more intrusive.
>>>>
>>>>
>>>>
>>>> I thought all CPUs were in stop_machine() when the modifications were
>>>> done,
>>>> so that there is no issue with multi-word instruction patching.
>>>>
>>>> Am I wrong about this?
>>>>
>>>> So really I think you can do two NOP just as easily.
>>>>
>>>> The only reason I bring this up is that I am not sure all 32-bit CPUs
>>>> implement the 'Likely' branch variants. Also there may be an affect on
>>>> the
>>>> branch predictor.
>>>>
>>>> A third possibility would be to replace the JALR with 'ADDIU SP,SP,8'
>>>> That
>>>> way the following adjustment would be canceled out.  This would work well
>>>> on
>>>> single-issue CPUs, but the instructions may not be able to dual-issue on
>>>> a
>>>> multi issue machine due to data dependencies.
>>>>
>>>> David Daney
>>>>
>>>>
>>>>>
>>>>> A few other bugs were fixed where the _mcount routine itself did not
>>>>> always fix the sp on return.
>>>>>
>>>>
>>>
>>>
>>
>
>

