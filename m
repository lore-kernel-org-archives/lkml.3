Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab3JJP77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:59:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab3JJP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:59:56 -0400
Date: Thu, 10 Oct 2013 09:00:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-Id: <20131010090044.7f12ddaf.akpm@linux-foundation.org>
In-Reply-To: <20131010152612.GA13375@redhat.com>
References: <20131008102505.404025673@infradead.org>
	<20131009225006.7101379c.akpm@linux-foundation.org>
	<20131010121908.GB28601@twins.programming.kicks-ass.net>
	<20131010145738.GA5167@gmail.com>
	<20131010152612.GA13375@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 17:26:12 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> On 10/10, Ingo Molnar wrote:
> >
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > But the thing is; our sense of NR_CPUS has shifted, where it used to be
> > > ok to do something like:
> > >
> > >   for_each_cpu()
> > >
> > > With preemption disabled; it gets to be less and less sane to do so,
> > > simply because 'common' hardware has 256+ CPUs these days. If we cannot
> > > rely on preempt disable to exclude hotplug, we must use
> > > get_online_cpus(), but get_online_cpus() is global state and thus cannot
> > > be used at any sort of frequency.
> >
> > So ... why not make it _really_ cheap, i.e. the read lock costing nothing,
> > and tie CPU hotplug to freezing all tasks in the system?
> >
> > Actual CPU hot unplugging and repluggin is _ridiculously_ rare in a
> > system, I don't understand how we tolerate _any_ overhead from this utter
> > slowpath.
> 
> Well, iirc Srivatsa (cc'ed) pointed out that some systems do cpu_down/up
> quite often to save the power.

cpu hotremove already uses stop_machine, so such an approach shouldn't
actually worsen things (a lot) for them?

It's been ages since I looked at this stuff :( Although it isn't used
much, memory hotplug manages to use stop_machine() on the add/remove
(ie, "writer") side and nothing at all on the "reader" side.  Is there
anything which fundamentally prevents cpu hotplug from doing the same?

