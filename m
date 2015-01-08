Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbbAHJAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 04:00:09 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:34442 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbAHJAH (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 8 Jan 2015 04:00:07 -0500
Message-ID: <1420707599.12346.14.camel@stgolabs.net>
Subject: Re: [LKP] [mm] c8c06efa8b5: -7.6% unixbench.score
From: Davidlohr Bueso <dave@stgolabs.net>
To: Huang Ying <ying.huang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Date: Thu, 08 Jan 2015 00:59:59 -0800
In-Reply-To: <1420703414.12346.12.camel@stgolabs.net>
References: <1420684064.6201.86.camel@linux.intel.com>
	 <1420703154.12346.10.camel@stgolabs.net>
	 <1420703414.12346.12.camel@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2015-01-07 at 23:50 -0800, Davidlohr Bueso wrote:
> On Wed, 2015-01-07 at 23:45 -0800, Davidlohr Bueso wrote:
> > On Thu, 2015-01-08 at 10:27 +0800, Huang Ying wrote:
> > Cc'ing Peter.
> 
> Err, resending with the complete msg.
> 
> > > FYI, we noticed the below changes on
> > > 
> > > commit c8c06efa8b552608493b7066c234cfa82c47fcea ("mm: convert i_mmap_mutex to rwsem")
> > 
> > Same exact everything, except for the lock type. No sharing going on.
> > 
> > > testbox/testcase/testparams: lituya/unixbench/performance-execl
> > > 
> > > 83cde9e8ba95d180  c8c06efa8b552608493b7066c2  
> > > ----------------  --------------------------  
> > >          %stddev     %change         %stddev
> > >              \          |                \  
> > >     721721 ±  1%    +303.6%    2913110 ±  3%  unixbench.time.voluntary_context_switches
> > >      11767 ±  0%      -7.6%      10867 ±  1%  unixbench.score
> > 
> > And this workload appears to be from execl, right? Make sense with some
> > of those numbers!!
> > 
> > >  2.323e+08 ±  0%      -7.2%  2.157e+08 ±  1%  unixbench.time.minor_page_faults
> > >        207 ±  0%      -7.0%        192 ±  1%  unixbench.time.user_time
> > >    4923450 ±  0%      -5.7%    4641672 ±  0%  unixbench.time.involuntary_context_switches
> > >        584 ±  0%      -5.2%        554 ±  0%  unixbench.time.percent_of_cpu_this_job_got
> > >        948 ±  0%      -4.9%        902 ±  0%  unixbench.time.system_time
> > >          0 ±  0%      +Inf%     672942 ±  2%  latency_stats.hits.call_rwsem_down_write_failed.vma_adjust.__split_vma.split_vma.mprotect_fixup.SyS_mprotect.system_call_fastpath
> > 
> > What does this "hits" thing mean exactly? Since I assume both before and
> > after runs have the same level of concurrency when pounding on mmap
> > operations, I doubt it means that its the amount of calls into the
> > slowpath... in addition the lock is obviously contended so we can forget
> > about anything in the fastpath.
> > 
> > So this is a call_rwsem_down_write_failed() vs __mutex_lock_common()
> > issue.
> 
> It's late, but for some initial thoughts I believe this comes down to
> differences in how mutexes and rwsems deal with ultimately blocking (and
> based on the nasty sched_debug numbers reported by Huang). We now do in
> call_rwsem_down_write_failed:
> 
> 	/* wait to be given the lock */
> 	while (true) {
> 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
> 		if (!waiter.task)
> 			break;
> 		schedule();
> 	}

heh I was actually looking at the reader code. We really do:

	/* wait until we successfully acquire the lock */
	set_current_state(TASK_UNINTERRUPTIBLE);
	while (true) {
		if (rwsem_try_write_lock(count, sem))
			break;
		raw_spin_unlock_irq(&sem->wait_lock);

		/* Block until there are no active lockers. */
		do {
			schedule();
			set_current_state(TASK_UNINTERRUPTIBLE);
		} while ((count = sem->count) & RWSEM_ACTIVE_MASK);

		raw_spin_lock_irq(&sem->wait_lock);
	}


Which still has similar issues with even two barriers, I guess for both
the rwsem_try_write_lock call (less severe) and count checks. Anyway...

