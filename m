Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaLHKTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:19:05 -0500
Received: from ozlabs.org ([103.22.144.67]:58806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbaLHKTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:19:03 -0500
Date: Mon, 8 Dec 2014 21:18:59 +1100
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20141208211859.6e81ec81@kryten>
In-Reply-To: <20141208083408.GA8023@gmail.com>
References: <1418009221-12719-1-git-send-email-anton@samba.org>
	<20141208083408.GA8023@gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

> So we cannot call set_task_cpu() because in the normal life time 
> of a task the ->cpu value gets set on wakeup. So if a task is 
> blocked right now, and its affinity changes, it ought to get a 
> correct ->cpu selected on wakeup. The affinity mask and the 
> current value of ->cpu getting out of sync is thus 'normal'.
> 
> (Check for example how set_cpus_allowed_ptr() works: we first set 
> the new allowed mask, then do we migrate the task away if 
> necessary.)
> 
> In the kthread_bind() case this is explicitly assumed: it only 
> calls do_set_cpus_allowed().
> 
> But obviously the bug triggers in kernel/smpboot.c, and that 
> assert shows a real bug - and your patch makes the assert go 
> away, so the question is, how did the kthread get woken up and 
> put on a runqueue without its ->cpu getting set?

I started going down this line earlier today, and found things like:

select_task_rq_fair:

        if (p->nr_cpus_allowed == 1)
                return prev_cpu;

I tried returning cpumask_first(tsk_cpus_allowed()) instead, and while
I couldn't hit the BUG I did manage to get a scheduler lockup during
testing.

At that point I thought the previous task_cpu() was somewhat ingrained
in the scheduler and came up with the patch. If not, we could go on a
hunt to see what else needs fixing.

Anton
