Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbbAMQgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:36:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753687AbbAMQgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:36:15 -0500
Message-ID: <54B5496E.7050001@redhat.com>
Date: Tue, 13 Jan 2015 11:35:58 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 02/11] x86,fpu: replace fpu_switch_t with a thread
 flag
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-3-git-send-email-riel@redhat.com> <20150113152409.GA23134@redhat.com>
In-Reply-To: <20150113152409.GA23134@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 10:24 AM, Oleg Nesterov wrote:
> Rik,
> 
> I can't review this series, I forgot almost everything I learned
> about this code. The only thing I can recall is that it needs
> cleanups and fixes ;) Just a couple of random questions.
> 
> On 01/11, riel@redhat.com wrote:
>> 
>> +static inline void switch_fpu_prepare(struct task_struct *old,
>> struct task_struct *new, int cpu) { -	fpu_switch_t fpu; - /* * If
>> the task has used the math, pre-load the FPU on xsave processors 
>> * or if the past 5 consecutive context-switches used math. */ -
>> fpu.preload = tsk_used_math(new) && (use_eager_fpu() || +	bool
>> preload = tsk_used_math(new) && (use_eager_fpu() || 
>> new->thread.fpu_counter > 5); if (__thread_has_fpu(old)) { if
>> (!__save_init_fpu(old)) @@ -433,8 +417,9 @@ static inline
>> fpu_switch_t switch_fpu_prepare(struct task_struct *old, struct
>> ta old->thread.fpu.has_fpu = 0;	/* But leave fpu_owner_task! */
>> 
>> /* Don't change CR0.TS if we just switch! */ -		if (fpu.preload)
>> { +		if (preload) { new->thread.fpu_counter++; +
>> set_thread_flag(TIF_LOAD_FPU); __thread_set_has_fpu(new); 
>> prefetch(new->thread.fpu.state); } else if (!use_eager_fpu()) @@
>> -442,16 +427,19 @@ static inline fpu_switch_t
>> switch_fpu_prepare(struct task_struct *old, struct ta } else { 
>> old->thread.fpu_counter = 0; old->thread.fpu.last_cpu = ~0; -		if
>> (fpu.preload) { +		if (preload) { new->thread.fpu_counter++; if
>> (!use_eager_fpu() && fpu_lazy_restore(new, cpu)) -				fpu.preload
>> = 0; -			else +				/* XXX: is this safe against ptrace??? */
> 
> Could you explain your concerns?

Ptrace could modify the in-memory copy of a task's FPU context,
while fpu_lazy_restore() could decide that the task's FPU context
is still loaded in the registers (nothing else on the CPU has used
the FPU since it last ran), and does not need to be re-loaded.

I address this later in the series.

>> +				__thread_fpu_begin(new);
> 
> this looks strange/unnecessary, there is another unconditonal 
> __thread_fpu_begin(new) below.
> 
> OK, the next patch moves it to switch_fpu_finish(), so perhaps this
> change should go into 3/11.

I would like to keep each patch small. I waffled between merging
patches 2 & 3 into one larger patch, or keeping patch 2 somewhat
awkward, but having both easier to review.

> And I am not sure I understand set_thread_flag(TIF_LOAD_FPU). This
> is called before __switch_to() updates kernel_stack, so it seems
> that the old thread gets this flag set, not new?
> 
> Even if this is correct, perhaps set_tsk_thread_flag(new) will look
> better?

It is correct in this patch, but this may just be the bug that has been
plaguing me later in the series!  Thanks for spotting this one, Oleg!

>> --- a/arch/x86/include/asm/thread_info.h +++
>> b/arch/x86/include/asm/thread_info.h @@ -91,6 +91,7 @@ struct
>> thread_info { #define TIF_SYSCALL_TRACEPOINT	28	/* syscall
>> tracepoint instrumentation */ #define TIF_ADDR32		29	/* 32-bit
>> address space on 64 bits */ #define TIF_X32			30	/* 32-bit native
>> x86-64 binary */ +#define TIF_LOAD_FPU		31	/* load FPU on return
>> to userspace */
> 
> Well, the comment is wrong after this patch, but I see 4/11...

I did not want to change that same line in two different patches,
with the idea that that would make things harder to review.

>> /* work to do in syscall_trace_enter() */ #define
>> _TIF_WORK_SYSCALL_ENTRY	\ @@ -141,7 +143,7 @@ struct thread_info
>> { /* Only used for 64 bit */ #define _TIF_DO_NOTIFY_MASK						\ 
>> (_TIF_SIGPENDING | _TIF_MCE_NOTIFY | _TIF_NOTIFY_RESUME |	\ -
>> _TIF_USER_RETURN_NOTIFY | _TIF_UPROBE) +	 _TIF_USER_RETURN_NOTIFY
>> | _TIF_UPROBE | _TIF_LOAD_FPU)
> 
> This too. I mean, this change has no effect until 4/11.

I can move this line to patch 4/11 if you prefer.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtUltAAoJEM553pKExN6DPGIH/Ais2KOa3eHr/eIcsBVR13Di
U9FEdFw6EH/pCvzSrO+PM/UaWplYDdPiEX01gvxQ/9KpoDyZRq63DmTyfksimXzD
k1tShoBLCCUJ3COelcYaqzCNI0qbkRPANbjqUp0xgh5FnBbebRnRQbyOLIFQ1CSZ
GjOe3XZbFn+v37f6v6YPJ5rktU2DWB6gIc8KnQ4hffQOyD0OH+WsHfQ3aWBEsYFj
QrlMqlgs4Qqg5S4jrTMc3Z2t6nQ7LPbYpWamPpUQ8Z+5gySU2ObZaLTV0LY/crYR
FDRyu6o/c0JTOq5cb7ayObBgZmnu4Hk3yA2XXD2qb/WdBKs7XQNypQXMt3naxbQ=
=hR1Z
-----END PGP SIGNATURE-----
