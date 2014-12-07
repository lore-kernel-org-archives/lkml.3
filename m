Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaLGKYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 05:24:35 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34498 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbaLGKYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 05:24:33 -0500
Date: Sun, 7 Dec 2014 11:24:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v2 2/5] OOM: thaw the OOM victim if it is frozen
Message-ID: <20141207102430.GF15892@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <1417797707-31699-3-git-send-email-mhocko@suse.cz>
 <20141206130657.GC18711@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141206130657.GC18711@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 06-12-14 08:06:57, Tejun Heo wrote:
> Hello,
> 
> On Fri, Dec 05, 2014 at 05:41:44PM +0100, Michal Hocko wrote:
> > oom_kill_process only sets TIF_MEMDIE flag and sends a signal to the
> > victim. This is basically noop when the task is frozen though because
> > the task sleeps in uninterruptible sleep. The victim is eventually
> > thawed later when oom_scan_process_thread meets the task again in a
> > later OOM invocation so the OOM killer doesn't live lock. But this is
> > less than optimal. Let's add the frozen check and thaw the task right
> > before we send SIGKILL to the victim.
> > 
> > The check and thawing in oom_scan_process_thread has to stay because the
> > task might got access to memory reserves even without an explicit
> > SIGKILL from oom_kill_process (e.g. it already has fatal signal pending
> > or it is exiting already).
> 
> How else would a task get TIF_MEMDIE?  If there are other paths which
> set TIF_MEMDIE, the right thing to do is creating a function which
> thaws / wakes up the target task and use it there too.  Please
> interlock these things properly from the get-go instead of scattering
> these things around.

See __out_of_memory which sets TIF_MEMDIE on current when it is exiting
or has fatal signals pending. This task cannot be frozen obviously.

> > @@ -545,6 +545,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
> >  	rcu_read_unlock();
> >  
> >  	mark_tsk_oom_victim(victim);
> > +	if (frozen(victim))
> > +		__thaw_task(victim);
> 
> The frozen() test here is racy.  Always calling __thaw_task() wouldn't
> be.  You can argue that being racy here is okay because the later
> scanning would find it but why complicate things like that?  Just
> properly interlock each instance and be done with it.

OK, changed. I didn't realize that __thaw_task does the check already
and was following what we have in oom_scan_process_thread. Removed the
check from that one as well.
-- 
Michal Hocko
SUSE Labs
