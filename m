Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaHMArF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 20:47:05 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:63176 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaHMArD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 20:47:03 -0400
MIME-Version: 1.0
In-Reply-To: <20140812120905.GB7049@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
	<1407804835-24763-2-git-send-email-xiyou.wangcong@gmail.com>
	<20140812120905.GB7049@dhcp22.suse.cz>
Date: Tue, 12 Aug 2014 17:47:02 -0700
Message-ID: <CAM_iQpWV8DRGBQ-Brz=_Nqen0fNPDk+6kn_Og3HnXnujmgA+JA@mail.gmail.com>
Subject: Re: [Patch] x86,mm: check freeze request in page fault handler
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 5:09 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 11-08-14 17:53:55, Cong Wang wrote:
>> When a process triggers a page fault and kernel keeps
>> trying to retry the fault, there is no chance for this process
>> to be frozen, so the freeze request will always be pending.
>
> The retry cannot happen indefinitely, no?
>
> Besides that the patch is broken in at least 2 ways. You are not
> releasing mmap_sem and this will break memcg OOM killer handling.

Ah, it's my bad to miss the up_read().

>
> If a memcg is under OOM (because of hard limit) then try_charge
> calls mem_cgroup_oom which marks the current task with OOM
> information. Notably takes a reference to memcg->css. The charge fail
> will then gets up the pagefault stack until we get to mm_fault_error
> where you put the task into freezer and then returns without
> pagefault_out_of_memory which would handle memcg specific parts in
> mem_cgroup_oom_synchronize. If the task wakes up and the page fault
> retry succeeds (because some charges were released in the meantime) then
> you leak a reference to memcg->css.

OK, I thought skipping pagefault_out_of_memory() is safe, you are right here,
thanks for explanation.

>
> Besides that the whole change would need a better justification. Why
> other archs do not need this?
>

They probably need this as well, just that I only have x86 to care and test. :)

Does the following updated patch make any sense to you? If not, I will just
drop it.

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index a241946..8c0a7d8 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -14,6 +14,7 @@
 #include <linux/hugetlb.h>             /* hstate_index_to_shift        */
 #include <linux/prefetch.h>            /* prefetchw                    */
 #include <linux/context_tracking.h>    /* exception_enter(), ...       */
+#include <linux/freezer.h>             /* try_to_freeze()              */

 #include <asm/traps.h>                 /* dotraplinkage, ...           */
 #include <asm/pgalloc.h>               /* pgd_*(), ...                 */
@@ -904,6 +905,9 @@ mm_fault_error(struct pt_regs *regs, unsigned long
error_code,
                 * oom-killed):
                 */
                pagefault_out_of_memory();
+
+               if (signal_pending(current))
+                       try_to_freeze();
        } else {
                if (fault & (VM_FAULT_SIGBUS|VM_FAULT_HWPOISON|
                             VM_FAULT_HWPOISON_LARGE))
