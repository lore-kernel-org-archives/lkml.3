Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3JJRB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab3JJRB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:01:58 -0400
Date: Thu, 10 Oct 2013 18:54:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
Message-ID: <20131010165412.GA16553@redhat.com>
References: <20131008102505.404025673@infradead.org> <20131009225006.7101379c.akpm@linux-foundation.org> <20131010121908.GB28601@twins.programming.kicks-ass.net> <20131010145738.GA5167@gmail.com> <20131010152612.GA13375@redhat.com> <20131010090044.7f12ddaf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010090044.7f12ddaf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10, Andrew Morton wrote:
>
> On Thu, 10 Oct 2013 17:26:12 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 10/10, Ingo Molnar wrote:
> > >
> > > So ... why not make it _really_ cheap, i.e. the read lock costing nothing,
> > > and tie CPU hotplug to freezing all tasks in the system?
> > >
> > > Actual CPU hot unplugging and repluggin is _ridiculously_ rare in a
> > > system, I don't understand how we tolerate _any_ overhead from this utter
> > > slowpath.
> >
> > Well, iirc Srivatsa (cc'ed) pointed out that some systems do cpu_down/up
> > quite often to save the power.
>
> cpu hotremove already uses stop_machine,

And Srivatsa wants to remove it from cpu_down().

> so such an approach shouldn't
> actually worsen things (a lot) for them?

this depends on what this "freezing all tasks" actually means.
I understood it as try_to_freeze_tasks/etc, looks too heavy...

But my only point was, I am not sure we can assume that cpu_down/up
is extremly rare and its cost does not matter.

> use stop_machine() on the add/remove
> (ie, "writer") side and nothing at all on the "reader" side.  Is there
> anything which fundamentally prevents cpu hotplug from doing the same?

Well, then we actually need to park all tasks in system, I guess.
IOW, freezer.

Oleg.

