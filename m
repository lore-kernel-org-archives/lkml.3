Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaI1VNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 17:13:25 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:61708 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaI1VNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 17:13:24 -0400
Date: Sun, 28 Sep 2014 17:13:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: schedule_delayed_work with a 0 jiffy delay
Message-ID: <20140928211321.GB8349@mtj.dyndns.org>
References: <20140926105227.01325697@jlaw-desktop.mno.stratus.com>
 <20140928142714.GB3736@mtj.dyndns.org>
 <alpine.DEB.2.02.1409281232040.31609@jlaw-desktop.mno.stratus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1409281232040.31609@jlaw-desktop.mno.stratus.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Joe.

On Sun, Sep 28, 2014 at 12:39:34PM -0400, Joe Lawrence wrote:
> On Sun, 28 Sep 2014, Tejun Heo wrote:
> > Hello, Joe.
> > 
> > On Fri, Sep 26, 2014 at 10:52:27AM -0400, Joe Lawrence wrote:
> > ...
> > > I was wondering if such behavior was expected on !PREEMPT kernels,
> > > especially after b22ce2785d97 "workqueue: cond_resched() after
> > > processing each work item".  In the ftraces I've observed from the RCU
> > > stall, cond_resched() never seems to schedule.  Under what conditions
> > > would it be expected to do so?
> > 
> > Hmmm... it should yield if there's a higher priority task scheduled.
> > Maybe the workqueue in question is a highpri one?
> 
> I don't believe any high priority tasks or workqueues are involved here.  
> Consider a synthetic repro module like:
...
> When I load this, "kworker/4:1" goes to 100% CPU and the RCU grace 
> periods reported by rcusched freeze on CPU4 for minutes at a time.
>  
> > > Changing the worker function to reschedule with at least 1 jiffy avoids
> > > this problem -- I was just curious if a fix at that end was appropriate.
> > 
> > The fact that 0 delay means immediate execution is depended upon in
> > multiple places and changing it will break other things.  The
> > workqueue user itself sounds buggy to me.  Can't that be fixed?
> 
> Certainly modifying the workqueue user should be sufficient here.  I was 
> only wondering if the cond_resched in process_one_work was expected to 
> give the CPU some breathing room in this scenario.

It yields iff there are other higher priority tasks to run.  I haven't
dug the code but if sched RCU is using and sched RCU implements grace
periods passively (e.g. something like if all tasks have switched
since point X), cond_resched() is gonna be able stall RCU grace
periods by running continuously in the absense of higher priority task
to run on the same CPU.

That said, RCU could have implemented a workaround for situations like
that in the meantime so it could be worthwhile to test mainline.

Thanks.

-- 
tejun
