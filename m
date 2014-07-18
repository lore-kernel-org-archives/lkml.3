Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbaGROcp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:32:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41823 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762177AbaGROcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:32:43 -0400
Date: Fri, 18 Jul 2014 15:31:57 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Sahasrabudhe, Sheetal" <sheetals@quicinc.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jolsa@redhat.com" <jolsa@redhat.com>
Subject: Re: perf: child events not killed on release paths, survive
 indefinitely
Message-ID: <20140718143157.GB17328@leverpostej>
References: <20140718123238.GF25180@leverpostej>
 <20140718140343.GC20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140718140343.GC20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 03:03:43PM +0100, Peter Zijlstra wrote:
> On Fri, Jul 18, 2014 at 01:32:39PM +0100, Mark Rutland wrote:
> > Hi all,
> > 
> > Sheetal reported a weird issue on arm where events which have been
> > closed seem to stay around and compete for HW counters if an application
> > has forked between the events being opened and them being closed.
> > 
> > I've reproduced this in mainline and linux-next and this seems to be a
> > generic issue; the below test case fires on my x86-64 workstation as
> > well as on arm and arm64.
> > 
> > The problem is the way we (don't) handle child events when releasing a
> > parent in perf_release and perf_event_release_kernel. We call put_event
> > on the parent when it is released, but this will exit early having done
> > nothing because each child will have incremented the parent refcount
> > when initialised from perf_event_init_task. We don't seem to do anything
> > about the children in this case.
> > 
> > Thus the parent event can't be killed until all the children have first
> > been killed. As the only places references to them exist are the
> > parent's child_list and their respective tasks' hardware
> > perf_event_context, they'll only get killed when their respective tasks
> > exit (I confirmed this with some printks in hw_perf_event_destroy and
> > put_event). Until that happens they remain in their respective contexts
> > and continue to compete for HW counters, adversely affecting events
> > opened later.
> > 
> > I'm not sure what the best way of handling this is. We need to clean up
> > the children when the last possible user of the event is gone, but it
> > looks to me like we'd need to have a separate child_refcount or
> > reader_refcount to be able to tell when the events are still useful and
> > when the only references which remain are internal.
> > 
> > Any ideas?
> 
> Jiri was recently poking at that:
> 
> lkml.kernel.org/r/1405079782-8139-3-git-send-email-jolsa@kernel.org

Ah. I hadn't spotted that, thanks for the link.

That approach (closing child events when the owner exits) doesn't seem
to fix the general case, as long running tasks (think interactive
debugger/profiler) could open and close many events before exiting, if
nothing else wasting memory until it does so.

My test case triggers with said patch applied (before hanging, probably
due to the AB-BA deadlock).

Jiri, could you add me to Cc for future versions of that series?

I'll have a look and see if I can come up with something; otherwise I'm
happy to test/review. :)

Cheers,
Mark.
