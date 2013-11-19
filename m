Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab3KSGt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 01:49:56 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39117 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab3KSGtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 01:49:52 -0500
Date: Tue, 19 Nov 2013 07:49:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131119064948.GA32025@gmail.com>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Properly patching running code ("cross modification")
> is a quite complicated business on x86.
> 
> The CPU has specific rules that need to be followed, including
> multiple global barriers.
> 
> Self modifying code is getting more popular, so it's important
> to make it easy to follow the rules.
> 
> The kernel does it properly with text_poke_bp(). But the same
> method is hard to do for user programs.
> 
> This patch adds a (x86 specific) text_poke() syscall that exposes
> the text_poke_bp() machinery to user programs.
> 
> The interface is practically the same as text_poke_bp, just as
> a syscall. I added an extra timeout parameter, that
> will potentially allow batching the global barriers in
> the future. Right now it is enforced to be 0.
> 
> The call also still has a global lock, so it has some scaling
> limitations. If it was commonly used this could be fixed
> by setting up a list of break point locations. Then
> a lock would only be hold to modify the list.
> 
> Right now the implementation is just as simple as possible.
> 
> Proposed man page:
> 
> NAME
> 	text_poke - Safely modify running instructions (x86)
> 
> SYNOPSYS
> 	int text_poke(void *addr, const void *opcode, size_t len,
> 	              void (*handler)(void), int timeout);
> 
> DESCRIPTION
> 	The text_poke system allows to safely modify code that may
> 	be currently executing in parallel on other threads.
> 	Patch the instruction at addr with the new instructions
> 	at opcode of length len. The target instruction will temporarily
> 	be patched with a break point, before it is replaced
> 	with the final replacement instruction. When the break point
> 	hits the code handler will be called in the context
> 	of the thread. The handler does not save any registers
> 	and cannot return. Typically it would consist of the
> 	original instruction and then a jump to after the original
> 	instruction. The handler is only needed during the
> 	patching process and can be overwritten once the syscall
> 	returns. timeout defines an optional timout to indicate
> 	to the kernel how long the patching could be delayed.
> 	Right now it has to be 0.
> 
> EXAMPLE
> 
> volatile int finished;
> 
> extern char patch[], recovery[], repl[];
> 
> struct res {
>         long total;
>         long val1, val2, handler;
> };
> 
> int text_poke(void *insn, void *repl, int len, void *handler, int to)
> {
>         return syscall(314, insn, repl, len, handler, to);
> }
> 
> void *tfunc(void *arg)
> {
>         struct res *res = (struct res *)arg;
> 
>         while (!finished) {
>                 int val;
>                 asm volatile(   ".globl patch\n"
>                                 ".globl recovery\n"
>                                 ".global repl\n"
> 				/* original code to be patched */
>                                 "patch: mov $1,%0\n"
>                                 "1:\n"
>                                 ".section \".text.patchup\",\"x\"\n"
> 				/* Called when a race happens during patching.
> 				   Just execute the original code and jump back. */
>                                 "recovery:\n"
>                                 " mov $3,%0\n"
>                                 " jmp 1b\n"
> 				/* replacement code that gets patched in: */
>                                 "repl:\n"
>                                 " mov $2,%0\n"
>                                 ".previous" : "=a" (val));
>                         if (val == 1)
>                                 res->val1++;
>                         else if (val == 3)
>                                 res->handler++;
>                         else
>                                 res->val2++;
>                         res->total++;
>         }
>         return NULL;
> }
> 
> int main(int ac, char **av)
> {
>         int ncpus = sysconf(_SC_NPROCESSORS_ONLN);
>         int ps = sysconf(_SC_PAGESIZE);
>         pthread_t pthr[ncpus];
>         struct res res[ncpus];
>         int i;
> 
>         srand(1);
>         memset(&res, 0, sizeof(struct res) * ncpus);
>         mprotect(patch - (unsigned long)patch % ps, ps,
> 		 PROT_READ|PROT_WRITE|PROT_EXEC);
>         for (i = 0; i < ncpus - 1; i++)
>                 pthread_create(&pthr[i], NULL, tfunc, &res[i]);
>         for (i = 0; i < 500000; i++) {
>                 text_poke(patch, repl, 5, recovery, 0);
>                 nanosleep(&((struct timespec) { 0, rand() % 100 }), NULL);
>                 text_poke(repl, patch, 5, recovery, 0);
>         }
>         finished = 1;
>         for (i = 0; i < ncpus - 1; i++) {
>                 pthread_join(pthr[i], NULL);
>                 printf("%d: val1 %lu val2 %lu handler %lu to %lu\n",
>                                 i, res[i].val1, res[i].val2, res[i].handler,
> 				res[i].total);
>                 assert(res[i].val1 + res[i].val2 + res[i].handler
> 				== res[i].total);
>         }
>         return 0;
> }
> 
> RETURN VALUE
> 	On success, text_poke returns 0, otherwise -1 is returned
> 	and errno is set appropiately.
> 
> ERRORS
> 	EINVAL		len was too long
> 			timeout was an invalid value
> 	EFAULT		An error happened while accessing opcode
> 
> VERSIONS
> 	text_poke has been added with the Linux XXX kernel.
> 
> CONFORMING TO
> 	The call is Linux and x86 specific and should not be used
> 	in programs intended to be portable.
> ---
>  arch/x86/kernel/alternative.c    | 121 ++++++++++++++++++++++++++++++++-------
>  arch/x86/syscalls/syscall_32.tbl |   1 +
>  arch/x86/syscalls/syscall_64.tbl |   1 +
>  3 files changed, 102 insertions(+), 21 deletions(-)

A couple of observations:

1)

Documentation: as usual you hide information: please _explain_ in the 
changelog and in the manpage why self-modifying code is a 'complicated 
business' on x86, it's not rocket science: that on x86 in-flight 
speculative instructions which may correspond to the old, 
pre-modification state need to be flushed before code can be modified, 
and that not even atomic ops (can) achieve this.

So x86 code has to do an at least two-step dance of adding a 
single-byte breakpoint, flushing instructions, then modifying the 
first byte and flushing instructions again.

The 'flushing instructions' has to happen on all CPUs that may execute 
that code region, to be safe. (The kernel code does a 3-step 
synchronization dance but that is paranoia.)

2)

Locking: why should kernel-space code modifications and user-space 
code modifications be synchronized by the same single system-global 
mutex (text_mutex)?

Also, why should possibly unrelated user-space be synchronized with 
each other when they do a flush?

3)

Design: more fundamentally, you don't explain the design: why is this 
architecture specific and why is it a new syscall?

In particular I'm somewhat sceptical about doing this as a separate 
syscall, because such Linux-only syscall specials tend to propagate to 
the right tools rather slowly - especially if it's an x86-only 
Linux-special syscall ...

If we want to do this then it could be shaped as a straightforward 
ptrace() extension: ptrace already has the concept of self-tracing 
(PTRACE_TRACEME), so adding PTRACE_POKETEXT with pid==0 (or a special 
flag to denote 'careful text self-modification') would achieve that, 
and would make it instantly available to tooling, without fragile 
syscall wrappers.

That would also allow other SMP architectures with speculative 
execution to implement such code modification helpers as well, by 
reusing the same new ptrace ABI.

Thanks,

	Ingo
