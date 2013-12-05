Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3LEQ1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 11:27:06 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:49281 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3LEQ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 11:27:03 -0500
Date: Thu, 5 Dec 2013 17:26:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Christoph Lameter <cl@linux.com>,
        Peter Zijlstra <peterz@infradead.org>, zhang.yi20@zte.com.cn,
        lkml <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/1] usermodehelper: kill
 ____call_usermodehelper()->set_cpus_allowed_ptr()
Message-ID: <20131205162658.GB20828@localhost.localdomain>
References: <20131128133947.GR10022@twins.programming.kicks-ass.net>
 <20131128142359.GA6420@redhat.com>
 <20131128143155.GC3925@htj.dyndns.org>
 <20131128150055.GA11956@redhat.com>
 <20131128150233.GA10022@twins.programming.kicks-ass.net>
 <20131128193330.GA24767@redhat.com>
 <20131128193349.GB24767@redhat.com>
 <CAFTL4hw+Ztsy5uy2WOsyxQ1dL7B_rPEU=XtisoR5X18cPQ7LYg@mail.gmail.com>
 <20131205143745.GA18488@redhat.com>
 <20131205143903.GA3231@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205143903.GA3231@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 09:39:03AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Thu, Dec 05, 2013 at 03:37:45PM +0100, Oleg Nesterov wrote:
> > > I'm adding Christophe in Cc because he is interested in tweaking the
> > > affinity of call_usermodehelper for cpu isolation. This welcome
> > > cleanup confirms that we want to take the direction of being able to
> > > change the affinity of workqueue themselves instead of just
> > > call_usermodehelper() alone.
> > 
> > OK, but I'd like to remind just in case, as Tejun pointed out this
> > patch is wrong ;)
> > 
> > And "change the affinity of workqueue themselves" is not simple, but
> > we can make khelper_wq WQ_SYSFS.
> 
> Maybe workqueue should implement and expose default attributes which
> are inherited by all workqueues unless they're explicitly overridden?
> The use case here is not really about isolating certain subgroup of
> workers but rather being able to control the default behavior, right?

So the need I know of is to perform CPU isolation on a given set of CPUs.
Their are two known usecases:

1) Optimize the use of the CPU and avoid being disturbed with interrupts, other
tasks, etc... These disturbances trash the cache and steal cputime. We want to
maximize the use of the CPU. So that's the HPC case.

2) Guarantee that the CPU won't be disturbed while some high priority tasks are running.
So we have a critical task that has something to do under a given time deadline or
some bounded latency. That's the real time case.

Case 1) can deal with a few rare noise, but case 2) can't.

In both cases I think that people are happy with having one CPU that handles all
the housekeeping: handle timekeeping, unbound timers, workqueues, RCU callbacks
and random stats maintainance. But this housekeeping could possibly be divided in
the future with some per NUMA node affine housekeepers, who knows? So I think it may be nice to
have some flexibility in how we affine these workqueues, hence a user-driven
action taken through exisiting interfaces like sysfs sounds like a good
candidate.
 
> Thanks.
> 
> -- 
> tejun
