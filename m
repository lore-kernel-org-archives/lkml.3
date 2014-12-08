Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaLHIeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:34:15 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43543 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbaLHIeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:34:13 -0500
Date: Mon, 8 Dec 2014 09:34:08 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Anton Blanchard <anton@samba.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, tj@kernel.org, fengguang.wu@intel.com,
        rafael.j.wysocki@intel.com, yuyang.du@intel.com, lkp@01.org,
        yuanhan.liu@linux.intel.com, pjt@google.com, bsegall@google.com,
        daniel@numascale.com, subbaram@codeaurora.org,
        computersforpeace@gmail.com, sp@datera.io,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] kthread: kthread_bind fails to enforce CPU affinity
 (fixes kernel BUG at kernel/smpboot.c:134!)
Message-ID: <20141208083408.GA8023@gmail.com>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418009221-12719-1-git-send-email-anton@samba.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> I have a busy ppc64le KVM box where guests sometimes hit the 
> infamous "kernel BUG at kernel/smpboot.c:134!" issue during 
> boot:
> 
> BUG_ON(td->cpu != smp_processor_id());
> 
> Basically a per CPU hotplug thread scheduled on the wrong CPU. The oops
> output confirms it:
> 
> CPU: 0
> Comm: watchdog/130
> 
> The issue is in kthread_bind where we set the cpus_allowed 
> mask, but do not touch task_thread_info(p)->cpu. The scheduler 
> assumes the previously scheduled CPU is in the cpus_allowed 
> mask, but in this case we are moving a thread to another CPU so 
> it is not.
> 
> We used to call set_task_cpu which sets 
> task_thread_info(p)->cpu (in fact kthread_bind still has a 
> comment suggesting this). That was removed in e2912009fb7b 
> ("sched: Ensure set_task_cpu() is never called on blocked 
> tasks").
> 
> Since we cannot call set_task_cpu (the task is in a sleeping 
> state), just do an explicit set of task_thread_info(p)->cpu.

So we cannot call set_task_cpu() because in the normal life time 
of a task the ->cpu value gets set on wakeup. So if a task is 
blocked right now, and its affinity changes, it ought to get a 
correct ->cpu selected on wakeup. The affinity mask and the 
current value of ->cpu getting out of sync is thus 'normal'.

(Check for example how set_cpus_allowed_ptr() works: we first set 
the new allowed mask, then do we migrate the task away if 
necessary.)

In the kthread_bind() case this is explicitly assumed: it only 
calls do_set_cpus_allowed().

But obviously the bug triggers in kernel/smpboot.c, and that 
assert shows a real bug - and your patch makes the assert go 
away, so the question is, how did the kthread get woken up and 
put on a runqueue without its ->cpu getting set?

One possibility is a generic scheduler bug in ttwu(), resulting 
in ->cpu not getting set properly. If this was the case then 
other places would be blowing up as well, and I don't think we 
are seeing this currently, especially not over such a long 
timespan.

Another possibility would be that kthread_bind()'s assumption 
that the task is inactive is false: if the task activates when we 
think it's blocked and we just hotplug-migrate it away while its 
running (setting its td->cpu?), the assert could trigger I think 
- and the patch would make the assert go away.

A third possibility would be, if this is a freshly created 
thread, some sort of initialization race - either in the kthread 
or in the scheduler code.

Weird.

Thanks,

	Ingo
