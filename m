Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3DRSrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:47:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3DRSrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:47:17 -0400
Date: Thu, 18 Apr 2013 20:43:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] ptrace/x86: hw_breakpoints fixes/cleanups
Message-ID: <20130418184350.GA4407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "[PATCH 0/5] kill ptrace_{get,put}_breakpoints()".

V2:
	- 2/6 was updated as Frederic suggested,

		- if (!second_pass && rc)
		+ if (rc && !WARN_ON(second_pass))

	  and the changelog was rewritten. I preserved your ack,
	  hopefully this is fine.

	- 3-6 are new. 4/6 fixes the regression we discussed in V1.

Jan, this fixes watchpoint-zeroaddr test, but that test looks
"too simple", it doesn't check that bp actually works. I created
another test, see below.

Oleg.

------------------------------------------------------------------------------
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


void func1(void)
{
	printf("HERE_1\n");
}
void func2(void)
{
	printf("HERE_2\n");
}

int main(void)
{
	int pid, stat;
	unsigned long dr7;

	pid = fork();
	if (!pid) {
		assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
		kill(getpid(), SIGHUP);

		func1();
		func2();

		return 0x13;
	}

	assert(pid == waitpid(-1, &stat, 0));
	assert(WSTOPSIG(stat) == SIGHUP);

	dr7 = 0;
	dr7 |= encode_dr7(0, 1, DR_RW_EXECUTE, DR_LEN_1);
	dr7 |= encode_dr7(1, 1, DR_RW_EXECUTE, DR_LEN_1);
	assert(write_dr(pid, 7, dr7) == 0);

	assert(write_dr(pid, 0, (long)func1) == 0);
	assert(write_dr(pid, 1, (long)func2) == 0);

	assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
	assert(pid == waitpid(-1, &stat, 0));
	assert(WSTOPSIG(stat) == SIGTRAP);
	assert(get_ip(pid) == func1);

	assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
	assert(pid == waitpid(-1, &stat, 0));
	assert(WSTOPSIG(stat) == SIGTRAP);
	assert(get_ip(pid) == func2);

	assert(ptrace(PTRACE_CONT, pid, 0,0) == 0);
	assert(pid == waitpid(-1, &stat, 0));
	assert(stat == 0x1300);

	return 0;
}

