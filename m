Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FXUN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:13:58 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:48037 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab3FXUN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:13:56 -0400
Date: Mon, 24 Jun 2013 16:13:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: azurIt <azurit@pobox.sk>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, cgroups mailinglist <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH for 3.2] memcg: do not trap chargers with full callstack
 on OOM
Message-ID: <20130624201345.GA21822@cmpxchg.org>
References: <20130210150310.GA9504@dhcp22.suse.cz>
 <20130210174619.24F20488@pobox.sk>
 <20130211112240.GC19922@dhcp22.suse.cz>
 <20130222092332.4001E4B6@pobox.sk>
 <20130606160446.GE24115@dhcp22.suse.cz>
 <20130606181633.BCC3E02E@pobox.sk>
 <20130607131157.GF8117@dhcp22.suse.cz>
 <20130617122134.2E072BA8@pobox.sk>
 <20130619132614.GC16457@dhcp22.suse.cz>
 <20130622220958.D10567A4@pobox.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130622220958.D10567A4@pobox.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Sat, Jun 22, 2013 at 10:09:58PM +0200, azurIt wrote:
> >> But i'm sure of one thing - when problem occurs, nothing is able to
> >> access hard drives (every process which tries it is freezed until
> >> problem is resolved or server is rebooted).
> >
> >I would be really interesting to see what those tasks are blocked on.
> 
> I'm trying to get it, stay tuned :)
> 
> Today i noticed one bug, not 100% sure it is related to 'your' patch
> but i didn't seen this before. I noticed that i have lots of cgroups
> which cannot be removed - if i do 'rmdir <cgroup_directory>', it
> just hangs and never complete. Even more, it's not possible to
> access the whole cgroup filesystem until i kill that rmdir
> (anything, which tries it, just hangs). All unremoveable cgroups has
> this in 'memory.oom_control': oom_kill_disable 0 under_oom 1

Somebody acquires the OOM wait reference to the memcg and marks it
under oom but then does not call into mem_cgroup_oom_synchronize() to
clean up.  That's why under_oom is set and the rmdir waits for
outstanding references.

> And, yes, 'tasks' file is empty.

It's not a kernel thread that does it because all kernel-context
handle_mm_fault() are annotated properly, which means the task must be
userspace and, since tasks is empty, have exited before synchronizing.

Can you try with the following patch on top?

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 5db0490..9a0b152 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -846,17 +846,6 @@ static noinline int
 mm_fault_error(struct pt_regs *regs, unsigned long error_code,
 	       unsigned long address, unsigned int fault)
 {
-	/*
-	 * Pagefault was interrupted by SIGKILL. We have no reason to
-	 * continue pagefault.
-	 */
-	if (fatal_signal_pending(current)) {
-		if (!(fault & VM_FAULT_RETRY))
-			up_read(&current->mm->mmap_sem);
-		if (!(error_code & PF_USER))
-			no_context(regs, error_code, address);
-		return 1;
-	}
 	if (!(fault & VM_FAULT_ERROR))
 		return 0;
 
