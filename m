Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab3FZKLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:11:38 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:46836 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3FZKLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:11:37 -0400
Date: Wed, 26 Jun 2013 12:11:32 +0200
From: Robert Richter <rric@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130626101132.GC21788@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624152557.GU28407@twins.programming.kicks-ass.net>
 <20130624194510.GC4065@gmail.com>
 <20130625175729.GI21579@rric.localhost>
 <20130625191654.GH4855@pd.tnic>
 <20130626081223.GB21788@rric.localhost>
 <20130626082408.GA20274@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626082408.GA20274@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.06.13 10:24:08, Borislav Petkov wrote:
> On Wed, Jun 26, 2013 at 10:12:23AM +0200, Robert Richter wrote:
> > We get a new fd by opening the persistent event with the syscall.
> > There would be 2 new ioctls:
> > 
> >  ioctl(fd, PERF_EVENT_IOC_DETACH, 0);
> >  ioctl(fd, PERF_EVENT_IOC_ATTACH, 0);
> > 
> > This would be fine and reuses existing infrastructure.
> 
> Well, how are you going to say that you want to open an already existing
> persistent event or your want to create exactly the same persistent
> event? Are we even going to allow identical persistent events to
> coexist?

Here is the scenario:

Creating a persistent event from userspace:

 * A process opens a system-wide event with the syscall and gets a fd.
 * The process mmaps the buffer.
 * The process does an ioctl to detach the process which increases the
   events and buffers refcount. The event is listed as 'persistent' in
   sysfs with a unique id.
 * The process closes the fd. Event and buffer remain in the system
   since the refcounts are not zero.

Opening a persistent event:

 * A process scans sysfs for persistent events.
 * To open the event it sets up the event attr according to sysfs.
 * The persistent event is opened with the syscall, the process gets a
   new fd of the event.
 * The process attaches to the event buffer with mmap.

Releasing a persistent event:

 * A process opens a persistent event and gets a fd.
 * The process does an ioctl to attach the process which decreases the
   refcounts. The sysfs entry is removed.
 * The process closes the fd.
 * After all processes that are tied to the event closed their event's
   fds, the persistent event and its buffer is released.

Sounds like a plan?

-Robert
