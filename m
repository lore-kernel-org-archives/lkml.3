Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaLYPsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 10:48:52 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:49757 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaLYPsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 10:48:50 -0500
MIME-Version: 1.0
In-Reply-To: <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com>
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop> <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 25 Dec 2014 07:48:28 -0800
Message-ID: <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOetlOWkje+8mltQQVRDSF0gcGVyZiBjb3JlOiBVc2UgS1NUS19FU1AoKSBpbnN0ZQ==?=
	=?UTF-8?B?YWQgb2YgcHRfcmVncy0+c3Agd2hpbGUgb3V0cHV0IHVzZXIgcmVncw==?=
To: =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>
Cc: root <chenggang.qin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2014 at 4:13 AM, 秦承刚(承刚) <chenggang.qcg@alibaba-inc.com> wrote:
> The context is NMI (PMU) or IRQ (hrtimer). It is a bit complex. The process
> we want to sample is the current, so it is always running.
> We need to distinguish between IRQ context, syscall or user context that are
> interrupted by NMI.

Oh.  So you really are trying to get the user regs from NMI context
even if you interrupted the kernel.  This will be an unpleasant thing
to do correctly.

> Syscall: sp = current->thread.usersp;

Nope.  For x86_64 at least, sp is in old_rsp, not usersp, *if* the
syscall you interrupted was syscall64 instead of one of the ia32
entries, which are differently strange.  If you've context switched
out and back, then usersp will match it.  If not, then you're looking
at some random stale sp value.

Keep in mind that there is absolutely no guarantee that TIF_IA32
matches the syscall entry type.

>              old_rsp always point to current->thread.usersp. May be we
> shouldn't use current_user_stack_pointer();
> User: sp = task_pt_regs(task)->sp;
>           current's pt_regs are stored in kernel stack while NMI or IRQ
> occured.

This is the only easy case.

> IRQ: sp = task_pt_regs(task)->sp;
>           current's pt_regs are stored in kernel stack while IRQ which was
> interrupted occured.

Sort of.  It's true by the time you actually execute the IRQ handler.

I think that trying to do this is doomed to either failure or extreme
complexity.  You're in an NMI, so you could be part-way through a
context switch or you could be in the very first instruction of the
syscall handler.

On a quick look, there are plenty of other bugs in there besides just
the stack pointer issue.  The ABI check that uses TIF_IA32 in the perf
core is completely wrong.  TIF_IA32 may be equal to the actual
userspace bitness by luck, but, if so, that's more or less just luck.
And there's a user_mode test that should be user_mode_vm.

Also, it's not just sp that's wrong.  There are various places that
you can interrupt in which many of the registers have confusing
locations.  You could try using the cfi unwind data, but that's
unlikely to work for regs like cs and ss, and, during context switch,
this has very little chance of working.

What's the point of this feature?  Honestly, my suggestion would be to
delete it instead of trying to fix it.  It's also not clear to me that
there aren't serious security problems here -- it's entirely possible
for sensitive *kernel* values to and up in task_pt_regs at certain
times, and if you run during context switch and there's no code to
suppress this dump during context switch, then you could be showing
regs that belong to the wrong task.

--Andy

>
> Regards
> Chenggang
>
> ------------------------------------------------------------------
> 发件人：Andy Lutomirski <luto@amacapital.net>
> 发送时间：2014年12月23日(星期二) 16:30
> 收件人：root <chenggang.qin@gmail.com>，linux-kernel
> <linux-kernel@vger.kernel.org>
> 抄　送：秦承刚(承刚) <chenggang.qcg@taobao.com>，Andrew Morton
> <akpm@linux-foundation.org>，Arjan van de Ven <arjan@linux.intel.com>，David
> Ahern <dsahern@gmail.com>，Ingo Molnar <mingo@redhat.com>，Mike Galbraith
> <efault@gmx.de>，Namhyung Kim <namhyung@gmail.com>，Paul Mackerras
> <paulus@samba.org>，Peter Zijlstra <a.p.zijlstra@chello.nl>，Wu Fengguang
> <fengguang.wu@intel.com>，Yanmin Zhang <yanmin.zhang@intel.com>
> 主　题：Re: [PATCH] perf core: Use KSTK_ESP() instead of pt_regs->sp while
> output user regs
>
> On 12/22/2014 10:22 PM, root wrote:
>> From: Chenggang Qin <chenggang.qcg@taobao.com>
>>
>> For x86_64, the exact value of user stack's esp should be got by
>> KSTK_ESP(current).
>> current->thread.usersp is copied from PDA while enter ring0.
>> Now, we output the value of sp from pt_regs. But pt_regs->sp has changed
>> before
>> it was pushed into kernel stack.
>>
>> So, we cannot get the correct callchain while unwind some user stacks.
>> For example, if the stack contains __lll_unlock_wake()/__lll_lock_wait(),
>> the
>> callchain will break some times with the latest version of libunwind.
>> The root cause is the sp that is used by libunwind may be wrong.
>>
>> If we use KSTK_ESP(current), the correct callchain can be got everytime.
>> Other architectures also have KSTK_ESP() macro.
>>
>> Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Arjan van de Ven <arjan@linux.intel.com>
>> Cc: David Ahern <dsahern@gmail.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Mike Galbraith <efault@gmx.de>
>> Cc: Namhyung Kim <namhyung@gmail.com>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>> Cc: Yanmin Zhang <yanmin.zhang@intel.com>
>>
>> ---
>> arch/x86/kernel/perf_regs.c | 3 +++
>> 1 file changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
>> index e309cc5..5da8df8 100644
>> --- a/arch/x86/kernel/perf_regs.c
>> +++ b/arch/x86/kernel/perf_regs.c
>> @@ -60,6 +60,9 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
>> if (WARN_ON_ONCE(idx >= ARRAY_SIZE(pt_regs_offset)))
>> return 0;
>>
>> + if (idx == PERF_REG_X86_SP)
>> + return KSTK_ESP(current);
>> +
>
> This patch is probably fine, but KSTK_ESP seems to be bogus:
>
> unsigned long KSTK_ESP(struct task_struct *task)
> {
> return (test_tsk_thread_flag(task, TIF_IA32)) ?
> (task_pt_regs(task)->sp) : ((task)->thread.usersp);
> }
>
> I swear that every time I've looked at anything that references TIF_IA32
> in the last two weeks, it's been wrong. This should be something like:
>
> if (task_thread_info(task)->status & TS_COMPAT)
> return task_pt_regs(task)->sp;
> else if (task == current && task is in a syscall)
> return current_user_stack_pointer();
> else if (task is not running && task is in a syscall)
> return task->thread.usersp;
> else if (task is not in a syscall)
> return task_pt_regs(task)->sp;
> else
> we're confused; give up.
>
> What context are you using KSTK_ESP in?
>
> --Andy
>
>> return regs_get_register(regs, pt_regs_offset[idx]);
>> }
>>
>>



-- 
Andy Lutomirski
AMA Capital Management, LLC
