Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbaEGQDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934252AbaEGQD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:03:27 -0400
Date: Wed, 7 May 2014 12:02:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, Peter Zijlstra <peterz@infradead.org>, ak@linux.intel.com,
        gong.chen@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 1/5] x86, nmi:  Add new nmi type 'external'
Message-ID: <20140507160251.GQ39568@redhat.com>
References: <1399476883-98970-1-git-send-email-dzickus@redhat.com>
 <1399476883-98970-2-git-send-email-dzickus@redhat.com>
 <20140507153854.GA14926@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507153854.GA14926@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 05:38:54PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > I noticed when debugging a perf problem on a machine with GHES enabled,
> > perf seemed slow.  I then realized that the GHES NMI routine was taking
> > a global lock all the time to inspect the hardware.  This contended
> > with all the local perf counters which did not need a lock.  So each cpu
> > accidentally was synchronizing with itself when using perf.
> > 
> > This is because the way the nmi handler works.  It executes all the handlers
> > registered to a particular subtype (to deal with nmi sharing).  As a result
> > the GHES handler was executed on every PMI.
> > 
> > Fix this by creating a new nmi type called NMI_EXT, which is used by
> > handlers that need to probe external hardware and require a global lock
> > to do so.
> > 
> > Now the main NMI handler can check the internal NMI handlers first and
> > then the external ones if nothing is found.
> > 
> > This makes perf a little faster again on those machines with GHES enabled.
> 
> So what happens if GHES asserts an NMI at the same time a PMI 
> triggers?
> 
> If the perf PMI executes and indicates that it has handled something, 
> we don't execute the GHES handler, right? Will the GHES re-trigger the 
> NMI after we return?

In my head, I had thought they would be queued up and things work out
fine.  But I guess in theory, if a PMI NMI comes in and before the cpu can
accept it and GHES NMI comes in, then it would suffice to say it may get
dropped.  That would be not be good.  Though the race would be very small.

I don't have a good idea how to handle that.

On the flip side, we have the same exact problem, today, with the other
common external NMIs (SERR, IO).  If a PCI SERR comes in at the same time
as a PMI, then it gets dropped.  Worse, it doesn't get re-enabled and
blocks future SERRs (just found this out two weeks ago because of a dirty
perf status register on boot).

Again, I don't have a solution to juggle between PMI performance and
reliable delivery.  We could do away with the spinlocks and go back to
single cpu delivery (like it used to be).  Then devise a mechanism to
switch delivery to another cpu upon hotplug.

Thoughts?

Cheers,
Don
