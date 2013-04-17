Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862Ab3DQUGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 16:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935448Ab3DQUGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 16:06:11 -0400
Date: Wed, 17 Apr 2013 22:02:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/6] signal x86: Propage RF EFLAGS bit throught the
	signal restore call
Message-ID: <20130417200206.GA18253@redhat.com>
References: <1362940871-24486-1-git-send-email-jolsa@redhat.com> <1362940871-24486-2-git-send-email-jolsa@redhat.com> <20130416010524.GH17561@somewhere.redhat.com> <20130416144226.GA12848@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416144226.GA12848@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Oleg Nesterov wrote:
>
> On 04/16, Frederic Weisbecker wrote:
> >
> > On Sun, Mar 10, 2013 at 07:41:06PM +0100, Jiri Olsa wrote:
> > > Adding RF EFLAGS bit to be restored on return from signal from
> > > the original register context before the signal was entered.
> > >
> > > This will prevent the RF flag to disappear when returning
> > > from exception due to the signal handler being executed.
> >
> > So that happens if, say, we get a breakpoint exception and then we
> > run a signal handler before returning to the ip that triggered the
> > breakpoint?
>
> Afaics these changes (1 and 2) should fix the bug.
>
> Suppose that the first insn in the signal handler should trigger
> another bp, we should clear X86_EFLAGS_RF (2/6).
>
> Otoh, we should restore it when we return to the original insn
> which triggered the trap to avoid another trap.

I applied 1 and 2, and this fixes the test-case below.

> But. it seems that we have yet another problem? Suppose that
> the signal handler does siglongjmp() and jumps to yet another
> insn which should trigger the trap?

Argh. Sorry for confusion. I tried to say that the signal handler
can play with sigcontext->ip before sigreturn(). But probably we
can ignore this.

Oleg.

-------------------------------------------------------------------------------
#define _GNU_SOURCE 1
#include <stdio.h>
#include <unistd.h>
#include <sys/ptrace.h>
#include <sys/debugreg.h>
#include <sys/user.h>
#include <sys/wait.h>
#include <assert.h>
#include <assert.h>
#include <stddef.h>

#define DR_GLOBAL_ENABLE	0x2
#define DR_LOCAL_ENABLE		0x1

unsigned long encode_dr7(int drnum, int enable, unsigned int type, unsigned int len)
{
	unsigned long dr7;

	dr7 = ((len | type) & 0xf)
		<< (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
	if (enable)
		dr7 |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE));

	return dr7;
}

int write_dr(int pid, int dr, unsigned long val)
{
	return ptrace(PTRACE_POKEUSER, pid,
			offsetof (struct user, u_debugreg[dr]),
			val);
}

#define GET_REG(pid, reg)				\
	ptrace(PTRACE_PEEKUSER, (pid),			\
		offsetof(struct user, regs.reg), 0)

void *get_ip(int pid)
{
	return (void*)GET_REG(pid, rip);
}


void func(void)
{
	printf("bp_1 passed\n");
}

void sigh(int sig)
{
	printf("bp_2 passed\n");
}

int main(void)
{
	int pid, stat;
	unsigned long dr7;

	pid = fork();
	if (!pid) {
		assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
		kill(getpid(), SIGHUP);

		signal(SIGINT, sigh);

		func();

		return 0x13;
	}

	assert(pid == waitpid(-1, &stat, 0));
	assert(WSTOPSIG(stat) == SIGHUP);

	assert(write_dr(pid, 0, (long)func) == 0);
	assert(write_dr(pid, 1, (long)sigh) == 0);

	dr7 = 0;
	dr7 |= encode_dr7(0, 1, DR_RW_EXECUTE, DR_LEN_1);
	dr7 |= encode_dr7(1, 1, DR_RW_EXECUTE, DR_LEN_1);

	assert(write_dr(pid, 7, dr7) == 0);

	assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
	assert(pid == waitpid(-1, &stat, 0));
	assert(WSTOPSIG(stat) == SIGTRAP);
	assert(get_ip(pid) == func);

	kill(pid, SIGINT);
	assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
	assert(pid == waitpid(-1, &stat, 0));
	assert(WSTOPSIG(stat) == SIGINT);

	assert(ptrace(PTRACE_CONT, pid, 0,SIGINT) == 0);
	assert(pid == waitpid(-1, &stat, 0));
	assert(WSTOPSIG(stat) == SIGTRAP);
	assert(get_ip(pid) == sigh);

	assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
	assert(pid == waitpid(-1, &stat, 0));
	assert(stat == 0x1300);

	return 0;
}

