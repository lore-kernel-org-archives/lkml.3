Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab3D2Xh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:37:57 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:45860 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab3D2Xh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:37:56 -0400
Date: Tue, 30 Apr 2013 01:37:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] ptrace: PTRACE_DETACH should do
 flush_ptrace_hw_breakpoint(child)
Message-ID: <20130429233750.GE1760@somewhere>
References: <20130418184350.GA4407@redhat.com>
 <20130418184425.GA4454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184425.GA4454@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 08:44:25PM +0200, Oleg Nesterov wrote:
> Change ptrace_detach() to call flush_ptrace_hw_breakpoint(child).
> This frees the slots for non-ptrace PERF_TYPE_BREAKPOINT users, and
> this ensures that the tracee won't be killed by SIGTRAP triggered by
> the active breakpoints.
> 
> Test-case:
> 
> 	unsigned long encode_dr7(int drnum, int enable, unsigned int type, unsigned int len)
> 	{
> 		unsigned long dr7;
> 
> 		dr7 = ((len | type) & 0xf)
> 			<< (DR_CONTROL_SHIFT + drnum * DR_CONTROL_SIZE);
> 		if (enable)
> 			dr7 |= (DR_GLOBAL_ENABLE << (drnum * DR_ENABLE_SIZE));
> 
> 		return dr7;
> 	}
> 
> 	int write_dr(int pid, int dr, unsigned long val)
> 	{
> 		return ptrace(PTRACE_POKEUSER, pid,
> 				offsetof (struct user, u_debugreg[dr]),
> 				val);
> 	}
> 
> 	void func(void)
> 	{
> 	}
> 
> 	int main(void)
> 	{
> 		int pid, stat;
> 		unsigned long dr7;
> 
> 		pid = fork();
> 		if (!pid) {
> 			assert(ptrace(PTRACE_TRACEME, 0,0,0) == 0);
> 			kill(getpid(), SIGHUP);
> 
> 			func();
> 			return 0x13;
> 		}
> 
> 		assert(pid == waitpid(-1, &stat, 0));
> 		assert(WSTOPSIG(stat) == SIGHUP);
> 
> 		assert(write_dr(pid, 0, (long)func) == 0);
> 		dr7 = encode_dr7(0, 1, DR_RW_EXECUTE, DR_LEN_1);
> 		assert(write_dr(pid, 7, dr7) == 0);
> 
> 		assert(ptrace(PTRACE_DETACH, pid, 0,0) == 0);
> 		assert(pid == waitpid(-1, &stat, 0));
> 		assert(stat == 0x1300);
> 
> 		return 0;
> 	}
> 
> Before this patch the child is killed after PTRACE_DETACH.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

ACK.

Thanks a lot for this very nice series!
