Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3DRSr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:47:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60139 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab3DRSr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:47:58 -0400
Date: Thu, 18 Apr 2013 20:44:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] ptrace: PTRACE_DETACH should do
	flush_ptrace_hw_breakpoint(child)
Message-ID: <20130418184425.GA4454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184350.GA4407@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change ptrace_detach() to call flush_ptrace_hw_breakpoint(child).
This frees the slots for non-ptrace PERF_TYPE_BREAKPOINT users, and
this ensures that the tracee won't be killed by SIGTRAP triggered by
the active breakpoints.

Test-case:

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

	void func(void)
	{
	}

	int main(void)
	{
		int pid, stat;
		unsigned long dr7;

		pid = fork();
		if (!pid) {
			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
			kill(getpid(), SIGHUP);

			func();
			return 0x13;
		}

		assert(pid == waitpid(-1, &stat, 0));
		assert(WSTOPSIG(stat) == SIGHUP);

		assert(write_dr(pid, 0, (long)func) == 0);
		dr7 = encode_dr7(0, 1, DR_RW_EXECUTE, DR_LEN_1);
		assert(write_dr(pid, 7, dr7) == 0);

		assert(ptrace(PTRACE_DETACH, pid, 0,0) == 0);
		assert(pid == waitpid(-1, &stat, 0));
		assert(stat == 0x1300);

		return 0;
	}

Before this patch the child is killed after PTRACE_DETACH.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 776ab3b..33752d9 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -467,6 +467,7 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
 	/* Architecture-specific hardware disable .. */
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+	flush_ptrace_hw_breakpoint(child);
 
 	write_lock_irq(&tasklist_lock);
 	/*
-- 
1.5.5.1

