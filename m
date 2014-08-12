Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaHLJWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaHLJWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:22:00 -0400
Message-ID: <53E9DCAC.6000108@redhat.com>
Date: Tue, 12 Aug 2014 11:21:48 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 17/17] x86: simplify iret stack handling on SYSCALL64
 fastpath
References: <1407519880-6719-1-git-send-email-dvlasenk@redhat.com> <1407519880-6719-18-git-send-email-dvlasenk@redhat.com> <CALCETrXDjOPR9kEwx9fJFFz=A1jRKPBbfpoe8XztchktrUaz0Q@mail.gmail.com> <53E7890F.4070109@redhat.com> <CALCETrVTw5amX-v_C+Bp5Y0B0KbzNKEEq_ZMke-AC7cZopGd9Q@mail.gmail.com> <53E8B5EF.9080209@redhat.com> <CALCETrWC7pFBbycJLgLck9_qzZfOa8x4hCKm3OrC-5XeGFc8_w@mail.gmail.com>
In-Reply-To: <CALCETrWC7pFBbycJLgLck9_qzZfOa8x4hCKm3OrC-5XeGFc8_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2014 10:06 PM, Andy Lutomirski wrote:
> On Mon, Aug 11, 2014 at 5:24 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>> On 08/11/2014 12:42 AM, Andy Lutomirski wrote:
>>> On Mon, Aug 11, 2014 at 12:00 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>>>> On 08/09/2014 12:59 AM, Andy Lutomirski wrote:
>>>>>> + * When returning through fast path, userspace sees rcx = return address,
>>>>>> + * r11 = rflags. When returning through iret (e.g. if audit is active),
>>>>>> + * these registers may contain garbage.
>>>>>> + * For ptrace we manage to avoid that: when we hit slow path on entry,
>>>>>> + * we do save rcx and r11 in pt_regs, so ptrace on exit also sees them.
>>>>>> + * If slow path is entered only on exit, there will be garbage.
>>>>>
>>>>> I don't like this.  At least the current code puts something
>>>>> deterministic in there (-1) for the slow path, even though it's wrong
>>>>> and makes the slow path behave visibly differently from the fast path.
>>>>>
>>>>> Leaking uninitialized data here is extra bad, though.  Keep in mind
>>>>> that, when a syscall entry is interrupted before fully setting up
>>>>> pt_regs, the interrupt frame overlaps task_pt_regs, so it's possible,
>>>>> depending on the stack slot ordering, for a kernel secret
>>>>> (kernel_stack?) to end up somewhere in task_pt_regs.
>>>>
>>>> It's easy to fix. We jump off fast path to slow path here:
>>>>
>>>>         movl TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS),%edx
>>>>         andl %edi,%edx
>>>>         jnz  sysret_careful
>>>>
>>>> This is the only use of "sysret_careful" label.
>>>> Therefore, there we don't need to think about any other scenarios
>>>> besides "we are returning from syscall here".
>>>
>>> I may be missing something here (on vacation, not really testing
>>> things, no big monitor, etc), but how is this compatible with things
>>> like rt_sigreturn?  rt_sigreturn is call from the fastpath, via a
>>> stub, and it returns through int_ret_from_syscall.  The C part needs
>>> to modify all the regs, and those regs need to stick, so fixing up rcx
>>> and r11 after rt_sigreturn can't work.
>>
>> Code at "sysret_careful" label is only reachable
>> on fast path return.
>> We don't go down this code path after rt_sigreturn.
>> stub_rt_sigreturn manually steers into iret code path instead:
>>
>> ENTRY(stub_rt_sigreturn)
>>         CFI_STARTPROC
>>         addq $8, %rsp
>>         DEFAULT_FRAME 0
>>         SAVE_EXTRA_REGS
>>         STORE_IRET_FRAME_CS_SS
>>         call sys_rt_sigreturn
>>         movq %rax,RAX(%rsp)
>>         RESTORE_EXTRA_REGS
>>         jmp int_ret_from_sys_call   <==== NOTE THIS
>>
>> So, we don't do any rcx/r11 fixups after sys_rt_sigreturn.
> 
> Oh, right.  rt_sigreturn overwrites all regs, so it doesn't need a
> fixup in advance.
> 
> That still leaves fork and everything that calls ptrace_event, though.

I think I have it covered:

[v]fork and clone have fully populated pt_regs.

Syscall entry/exit ptrace stops are on slow path and therefore
also have fully populated pt_regs.
