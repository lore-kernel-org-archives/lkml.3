Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaDARk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 13:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaDARkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 13:40:55 -0400
Date: Tue, 1 Apr 2014 18:39:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes/x86: Conditionalize the usage of
	handle_riprel_insn()
Message-ID: <20140401163934.GA26272@redhat.com>
References: <20140331194402.GA9287@redhat.com> <533A2FE3.3050101@hitachi.com> <20140401143346.GA18503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401143346.GA18503@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Oleg Nesterov wrote:
>
> Good point, I'll send v2.

Masami, et al, I was going to send v2 plus the next short RFC series
which fixes the problem today, but it turns out that I have no time.
Will try to do this tomorrow.

So let me explain the problem, and how (I think) it should be solved.
Unfortunately, I do not even know the terminology, so firstly I have
to explain you the things I recently learned when I investigated the
bug report ;)

Lets only discuss the "call" instruction (the one which starts with
"e8" byte), because (compared to "jmp") the fix is more complicated.
This instruction simply does

	push rip
	rip += offset_encoded_in_insn	// ignoring the length of insn

To simplify, suppose that we probe such an insn at virtual address
0x1000 and offset_encoded_in_insn == 0x10.

When this task hits the probe, the kernel simply copies this (unmodified)
insn into xol area, and the task does single step. Lets suppose that
the virtual address of xol slot == 0x2000. This means that regs->ip
becomes 0x2000 + 0x10 = 0x2010, and we only need to adjust ->ip and
return adrress.

Note that the new ->ip == 0x2010 can point to nowhere, to the unmapped
area or it can point to the kernel memory. This still works because
the task doesn't even try to execute the next insn at this address.

But! this does NOT works if the new ->ip is non-canonical (not sure this
is the common term, I mean the hole starting from 0xffff800000000000,
which I didn't know about until recently ;). In this case CPU generates
#GP and do_general_protection() kills the task which tries to execute
this insn out-of-line.

The test-case I wrote to ensure:

	void probe_func(void), callee(void);

	int failed = 1;

	asm (
		".text\n"
		".align 4096\n"
		".globl probe_func\n"
		"probe_func:\n"
		"call callee\n"
		"ret"
	);

	/*
	 * This assumes that:
	 *
	 *	- &probe_func = 0x401000 + a_bit, aligned = 0x402000
	 *
	 *	- xol_vma->vm_start = TASK_SIZE_MAX - PAGE_SIZE = 0x7fffffffe000
	 *	  as xol_add_vma() asks; the 1st slot = 0x7fffffffe080
	 *
	 * so we can target the non-canonical address from xol_vma using
	 * the simple math below, 100 * 4096 is just the random offset
	 */
	asm (".org . + 0x800000000000 - 0x7fffffffe080 - 5 - 1  + 100 * 4096\n");

	void callee(void)
	{
		failed = 0;
	}

	int main(void)
	{
		probe_func();
		return failed;
	}

It dies if you probe "probe_func" (although this test-case is not very
reliable, randomize_va_space/etc can change the placement of xol area).

Now let me describe how I am going to fix this. Please let me know if
you think this can't work or you see the better solution.

To simplify, lets ignore the fact we have lib/insn.c. The first change
will add

	bool call_emulate_op(...)
	{
		// push return adress
		if (put_user(regs->ip + 5, (long __user *)(regs->sp - 8)))
			return false;

		regs->sp -= 8;
		regs->ip += 5 + *(s32*)(auprobe->insn + 1);
		return true;
	}

and change "case 0xe8" in arch_uprobe_analyze_insn() to setup
->ops = call_xol_ops.

But this is obviously incomplete because put_user() can fail. In this case
we could send a signal an restart, but this is not simple. We do not know
which signal (say, SIGSEGV or SIGBUS ?), we do not know what should we put
into siginfo, etc. And we do not want to emulate __do_page_fault ;)

So the 2nd patch will do the following:

	1. Add "long call_offset" into "struct arch_uprobe". (yes, we
	   should also add a "union" into arch_uprobe, but lets ignore
	   the details).

	2. change "case 0xe8" in arch_uprobe_analyze_insn() to also do

		s32 *offset = (void*)(auprobe->insn + 1);

		arch_uprobe->call_offset = *offset;
		/*
		 * Turn this insn into
		 *
		 *	1: call 1b;
		 *
		 * This is only needed to expand the stack if emulate
		 * fails. We do not turn it into, say, "pushf" because
		 * we do not want to change the 1st byte used by
		 * set_orig_insn().
		 *
		*offset = -5;

	3. Change call_emulate_op() to use arch_uprobe->call_offset

	4. Add

		//
		// In practice, this will be almost never called. put_user()
		// in call_emulate_op() failed, single-step can only succeed
		// if another thread expanded our stack.
		//
		int call_post_xol_op(...)
		{
			regs->sp += 8;
			// tell the caller to restart
			return -EAGAIN;
		}

Once again, if this can work we need more changes to handle jmp's/etc. But
lets discuss this later. I am thinking in horror about conditional jmp ;)
In fact this should be simple, just I do not know (yet) to parse such an
insn, and I simply do not know if lib/insn.c can help me to figure out which
flag in regs->flags ->emulate() should check.

So this all looks a bit complicated, but I do not see a simpler solution.
Well, we could avoid ->emulate() altogether, we could just mangle the
problematic instructions and complicate arch_uprobe_post_xol(), but I do
not think this would be better. And if nothing else, ->emulate is a) simple
and b) should likely succeed and make the probing faster.

But perhaps I missed something?

Oleg.

