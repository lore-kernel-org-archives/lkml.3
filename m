Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623Ab3EAP5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:57:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740Ab3EAP5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:57:25 -0400
Date: Wed, 1 May 2013 17:52:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>, Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCHv3 0/4] perf, signal x86: Fix breakpoint events overflow
	handling
Message-ID: <20130501155253.GA5392@redhat.com>
References: <1367421944-19082-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367421944-19082-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01, Jiri Olsa wrote:
>
>   - added Oleg's Tested-by for signal related patches

See the test-case below. Without 1/4 + 2/4 it fails, it can
miss the 2nd bp or report the 1st one twice.

Jan, FYI.

Oleg.

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

