Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3FZLpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:45:43 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60711 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3FZLpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:45:42 -0400
Date: Wed, 26 Jun 2013 13:45:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130626114538.GA4117@gmail.com>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
 <20130626081223.GB21788@rric.localhost>
 <20130626082408.GA20274@pd.tnic>
 <20130626101132.GC21788@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626101132.GC21788@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <rric@kernel.org> wrote:

> On 26.06.13 10:24:08, Borislav Petkov wrote:
> > On Wed, Jun 26, 2013 at 10:12:23AM +0200, Robert Richter wrote:
> > > We get a new fd by opening the persistent event with the syscall.
> > > There would be 2 new ioctls:
> > > 
> > >  ioctl(fd, PERF_EVENT_IOC_DETACH, 0);
> > >  ioctl(fd, PERF_EVENT_IOC_ATTACH, 0);
> > > 
> > > This would be fine and reuses existing infrastructure.
> > 
> > Well, how are you going to say that you want to open an already existing
> > persistent event or your want to create exactly the same persistent
> > event? Are we even going to allow identical persistent events to
> > coexist?
> 
> Here is the scenario:

Looks mostly good - with a few suggestions:

> 
> Creating a persistent event from userspace:
> 
>  * A process opens a system-wide event with the syscall and gets a fd.

Should this really be limited to system-wide events?

>  * The process mmaps the buffer.
>  * The process does an ioctl to detach the process which increases the
>    events and buffers refcount. The event is listed as 'persistent' in
>    sysfs with a unique id.
>  * The process closes the fd. Event and buffer remain in the system
>    since the refcounts are not zero.
> 
> Opening a persistent event:
> 
>  * A process scans sysfs for persistent events.
>  * To open the event it sets up the event attr according to sysfs.

Basically it would just put some ID (found in sysfs) into the attr and set 
attr.persistent=1 - not any other information, right?

If it knows the ID straight away (the user told it, or it remembers it 
from some other file such as a temporary file, etc.) then it does not even 
have to scan sysfs.

[ How about to additional logic: attr.persistent=1 && attr.config==0 means 
  a new persistent event is created straight away - no ioctl is needed to 
  detach it explicitly. ]

>  * The persistent event is opened with the syscall, the process gets a
>    new fd of the event.
>  * The process attaches to the event buffer with mmap.

Yes. And gets the pre-existing event and mmap buffer.

> Releasing a persistent event:
> 
>  * A process opens a persistent event and gets a fd.
>  * The process does an ioctl to attach the process which decreases the
>    refcounts. The sysfs entry is removed.
>  * The process closes the fd.
>  * After all processes that are tied to the event closed their event's
>    fds, the persistent event and its buffer is released.
> 
> Sounds like a plan?

It does :-)

I'm sure there will be some details going down that path, but it looks 
workable at first glance.

Note, for tracing the PERF_FLAG_FD_OUTPUT method of multiplexing multiple 
events onto a single mmap buffers is probably useful (also usable via the 
PERF_EVENT_IOC_SET_OUTPUT ioctl()), so please make sure the scheme works 
naturally with that model as well, not just with 1:1 event+buffer 
mappings.

See the uses of PERF_EVENT_IOC_SET_OUTPUT in tools/perf/.

Thanks,

	Ingo
