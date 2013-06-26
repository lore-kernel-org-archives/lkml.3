Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3FZMoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:44:30 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:54491 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab3FZMo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:44:29 -0400
Date: Wed, 26 Jun 2013 14:44:24 +0200
From: Robert Richter <rric@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130626124424.GD21788@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
 <20130626081223.GB21788@rric.localhost>
 <20130626082408.GA20274@pd.tnic>
 <20130626101132.GC21788@rric.localhost>
 <20130626114538.GA4117@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626114538.GA4117@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.06.13 13:45:38, Ingo Molnar wrote:
> * Robert Richter <rric@kernel.org> wrote:
> > Creating a persistent event from userspace:
> > 
> >  * A process opens a system-wide event with the syscall and gets a fd.
> 
> Should this really be limited to system-wide events?

It must not necessarily be restricted to system-wide events. Limiting
it is just to make it easier in the beginning, we don't need to think
about what happens if a process dies and permissions in case of
per-task events, etc (didn't thought about it yet ;).

Also, a persistent event is currently per-system, meaning there is one
entry only for the same kind of event scheduled on all cpus. This
keeps event handling easy (e.g. no need to export the cpu in the
event's sysfs entry, just the flag and id) but also has some drawbacks
(handling of multiple events per entry). Probably it's better to have
a 1:1 mapping.

> >  * The process mmaps the buffer.
> >  * The process does an ioctl to detach the process which increases the
> >    events and buffers refcount. The event is listed as 'persistent' in
> >    sysfs with a unique id.
> >  * The process closes the fd. Event and buffer remain in the system
> >    since the refcounts are not zero.
> > 
> > Opening a persistent event:
> > 
> >  * A process scans sysfs for persistent events.
> >  * To open the event it sets up the event attr according to sysfs.
> 
> Basically it would just put some ID (found in sysfs) into the attr and set 
> attr.persistent=1 - not any other information, right?
> 
> If it knows the ID straight away (the user told it, or it remembers it 
> from some other file such as a temporary file, etc.) then it does not even 
> have to scan sysfs.

Yes, there is a unique id which we could also return with the ioctl or
so. sysfs is esp. to let perf tools and the event parser know about
how to setup the events. It might be also useful if the syscall setup
changes in the future for these kind of events, then we just modify
the sysfs entry.

> [ How about to additional logic: attr.persistent=1 && attr.config==0 means 
>   a new persistent event is created straight away - no ioctl is needed to 
>   detach it explicitly. ]

That's correct. We could also do the following:

To connect to an existing event:

 attr.type=<persistent-pmu> && attr.config==<event-id>

(This might be harder to implement except the persistent event pmu
type will be fix, PERF_TYPE_PERSISTENT=6.)

To create a new persistent event:

 attr.persistent=1 && attr=<some event setup: pmu, config, flags, etc>

> >  * The persistent event is opened with the syscall, the process gets a
> >    new fd of the event.
> >  * The process attaches to the event buffer with mmap.
> 
> Yes. And gets the pre-existing event and mmap buffer.

That's what I mean.

A problem here is that mmap'ed buffer size (number of pages) must be
be equal to the pre-existing buffer size and thus to be known somehow.

> > Releasing a persistent event:
> > 
> >  * A process opens a persistent event and gets a fd.
> >  * The process does an ioctl to attach the process which decreases the
> >    refcounts. The sysfs entry is removed.
> >  * The process closes the fd.
> >  * After all processes that are tied to the event closed their event's
> >    fds, the persistent event and its buffer is released.
> > 
> > Sounds like a plan?
> 
> It does :-)
> 
> I'm sure there will be some details going down that path, but it looks 
> workable at first glance.

Yes, there will be some 'implementation details', but it should work.

> Note, for tracing the PERF_FLAG_FD_OUTPUT method of multiplexing multiple 
> events onto a single mmap buffers is probably useful (also usable via the 
> PERF_EVENT_IOC_SET_OUTPUT ioctl()), so please make sure the scheme works 
> naturally with that model as well, not just with 1:1 event+buffer 
> mappings.
> 
> See the uses of PERF_EVENT_IOC_SET_OUTPUT in tools/perf/.

Yes, thanks for this hint. I wasn't aware of this feature yet.

Thanks for your comments. Will start reworking the patches into this
direction.

-Robert
