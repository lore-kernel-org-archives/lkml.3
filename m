Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3CUS3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:29:45 -0400
Received: from mail-da0-f54.google.com ([209.85.210.54]:54763 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3CUS3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:29:43 -0400
Date: Thu, 21 Mar 2013 11:29:37 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        suresh.b.siddha@intel.com, venki@google.com, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/7] workqueue: Add helpers to schedule work on any cpu
Message-ID: <20130321182937.GB20500@htj.dyndns.org>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
 <fb2e721fc43fbc3517a7ebb905aa573b12bb83a5.1363617402.git.viresh.kumar@linaro.org>
 <20130321001211.GC31256@htj.dyndns.org>
 <CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponKUGbwEZ_edu353Y7YVZKgFOhZunTSUi04FGYWveftkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Viresh.

On Thu, Mar 21, 2013 at 04:27:23PM +0530, Viresh Kumar wrote:
> > For some reason, I've been always unsure about this patchset.  I've
> > been thinking about it past few days and I think I now know why.
> 
> I knew this since the beginning and thought power numbers i showed might
> change your view. My hard luck :)

Heh, sorry about the trouble but, yeah, your numbers are impressive
and no matter how this discussion turns out, we're gonna have it in
some form, so please don't think that your numbers didn't change
anything.  Actually, to me, it seems that identifying which workqueues
are good candidates for conversion and determining how much powersave
can be gained are 90% of the work.

> Now there are two things i am worried about.
> 
> A.
> About the difference in behavior of scheduler and sched_select_non_idle_cpu().
> Scheduler will treat this work as any normal task and can schedule it anywhere
> based on what it feels is the right place and may still wake up an idle one for
> load balancing.
> 
> In our approach, We aren't switching CPU for a work if that cpu (or system) is
> busy enough, like in case of high IOPS for block layer. We will find that cpu as
> busy, most of the time on such situations and so we will stay where we were.
>
> In case system is fairly idle, then also we stay on the same cpu.
> The only time we migrate is when current cpu is idle but the whole system
> isn't.

Yes, I actually like that part a lot although I do wish the idle check
was inlined.

What I'm wondering is whether the kinda out-of-band decision via
sched_select_cpu() is justified given that it can and is likely to go
through full scheduling decision anyway.  For timer, we don't have
that, so it makes sense.  For work items, it's a bit different.

To rephrase, *if* the scheduler can't already make proper decisions
regarding power consumption on an idlish system, maybe it can be
improved to do so?  It could as well be that this CPU selection is
special enough that it's just better to keep it separate as this
patchset proposes.  This is something up to the scheduler people.
Peter, Ingo, what do you guys think?

> B.
> It is sort of difficult to teach users about BOUND and UNBOUND workqueues
> and people have used them without thinking too much about them since some
> time. We need a straightforward API to make this more transparent. And
> queue_work_on_any_cpu() was a good candidate here. I am not talking about
> its implementation but about the interface.
> 
> Though in both suggestions we need to fix user drivers one by one to use
> queue_work_on_any_cpu() or use WQ_UNBOUND..

I don't know.  Workqueues are attribute domains and I kinda dislike
having a completely separate set of interface for this.  Regardless of
how the backend gets implemented, I'd really much prefer it being
implemented as a workqueue attribute rather than another set of
queueing interface functions.

> Maybe people wouldn't suffer much because of the reasons i told you earlier.
> On a busy system we will never switch cpus.
> 
> This static configuration might not work well with multiplatform images.

Well, it doesn't have to be a compile time thing.  It can be
dynamically switched with, say, static_branch(), but I think that's a
minor point at this point.

Thanks.

-- 
tejun
