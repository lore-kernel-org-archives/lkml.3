Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaIZLXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:23:18 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59088 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaIZLXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:23:17 -0400
Date: Fri, 26 Sep 2014 13:23:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf: Userspace software event and ioctl
Message-ID: <20140926112312.GB9870@gmail.com>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
 <1411050873-9310-3-git-send-email-pawel.moll@arm.com>
 <1411491764.3922.46.camel@hornet>
 <20140924074942.GB3797@gmail.com>
 <1411665649.4768.84.camel@hornet>
 <20140925183342.GB6854@gmail.com>
 <1411728487.3852.9.camel@hornet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411728487.3852.9.camel@hornet>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pawel Moll <pawel.moll@arm.com> wrote:

> On Thu, 2014-09-25 at 19:33 +0100, Ingo Molnar wrote:
> > > How would we select tasks that can write to a given buffer? Maybe an
> > > ioctl() on a perf fd? Something like this?
> > > 
> > > 	ioctl(perf_fd, PERF_EVENT_IOC_ENABLE_UEVENT, pid);
> > > 	ioctl(perf_fd, PERF_EVENT_IOC_DISABLE_UEVENT, pid);
> > 
> > No, I think there's a simpler way: this should be a regular 
> > perf_attr flag, which defaults to '0' (tasks cannot do this), 
> > but which can be set to 1 if the profiler explicitly allows 
> > such event injection.
> 
> As in: allows *all* tasks to inject the data? Are you sure we 
> don't want more fine-grained control, in particular per task?

Yeah. If the profiler allows it, then any task that is being 
traced can inject data.

More finegrained control might be useful if there's a 
justification for it, but only if this basic, most useful model 
is implemented. Too finegrained control will just make it 
unusable. So please keep it simple and useful.

> If we have two buffers, both created with the "injecting 
> allowed" flag, do we inject a given uevent into both of them?

Yes, and that semantics is desired: if I run two globally tracing 
apps, independent of each other, both ought to get the events if 
they ask for them.

> > I.e. whether user-events are allowed is controlled by the 
> > profiling/tracing context, via the regular perf syscall. It 
> > would propagate into the perf context, so it would be easy to 
> > check at event generation time.
> 
> It would definitely be the profiling/tracing tools that would 
> decide if the injection is allowed, no question about that. I 
> just feel that it should be able to select the tasks that can 
> do that, not just flip a big switch saying "everyone is 
> welcome". [...]

But that's the point: our main problem right now is too little 
data (not enough apps generating interesting events), not too 
much data.

So lets concentrate on the task of getting events to us as easily 
as possible first. If in the far future we are overwhelmed with 
events, and tools want to do some filtering on them, by all means 
we can implement it - but don't impose it straight away.

> [...] Other question is: should a non-root context be able to 
> receive events from root processes? Wouldn't it be a security 
> hole (for example, it could be used as a kind of covert 
> channel)? Maybe we should do what ptrace does? As in: if a task 
> can ptrace another task, it can also receive uevents from it.

So, by default a non-root context will not be able to 
profile/trace a root owned task already, it cannot generate per 
CPU events for example. So this already handled at event/buffer 
creation time. Plus if a task gains privilege (via suid exec) 
then we already zap its perf context IIRC.

Should be double checked, but the important part is to make it to 
willing tracing apps as easy as possible. Lets worry about the 
'too much data' case later, otherwise we _guarantee_ that this 
interface won't take off and apps, tools and people won't use it, 
ok?

Thanks,

	Ingo
