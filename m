Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779Ab3BAKvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:51:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:33395 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422775Ab3BAKvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:51:20 -0500
Date: Fri, 1 Feb 2013 11:51:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 00/40] CPU hotplug rework - episode I
In-Reply-To: <CA+55aFypNfzA1HZMmAiyFo48MhUTr+gt+1uvM7SHFzXh60-KQQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302011128490.11905@ionos>
References: <20130131120348.372374706@linutronix.de> <20130131122342.31b28664.akpm@linux-foundation.org> <alpine.LFD.2.02.1301312233480.11905@ionos> <CA+55aFx=cv+HxKGx+oQk4iLnnTGO7P0u3+DnvuOWbYzM-wvEeQ@mail.gmail.com> <alpine.LFD.2.02.1301312302290.11905@ionos>
 <CA+55aFypNfzA1HZMmAiyFo48MhUTr+gt+1uvM7SHFzXh60-KQQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Linus Torvalds wrote:

> On Fri, Feb 1, 2013 at 9:44 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Just face it. The current hotplug maze has 100+ states which are
> > completely undocumented. They are asymetric vs. startup and
> > teardown. They just exists and work somehow aside of the occasional
> > hard to decode hickup.
> >
> > Do you really want to preserve that state by all means [F*ck no]?
> 
> No., But I also don't want to replace it with "there's now eleven
> documented states, and random people hook into random documented
> states".

That's not the plan.
 
> So for me it's the "expose these states" that I get worried about.. A
> random driver should not necessarily even be able to *see* this, and
> decide to be clever and take advantage of the ordering.
> 
> So I'd hope there would be some visibility restrictions. We currently
> have drivers already being confused by DOWN_PREPARE vs DOWN_FAILED etc
> etc random state transitions, and giving them even more flexibility to
> pick random states sounds like a really bad idea. I'd like to make
> sure that drivers and filesystems etc do not even *see* the states
> that are meant for the scheduler or workqueues, for example).

The only states where drivers, filesystems etc are going to see in the
end is:

    CPUHP_PREP_<datastructures>     // Get datastructures set up / freed.

This is _before_ a cpu comes to life and _after_ it is gone. And that
does not require ordering.

    CPUHP_ENABLE_<stuff_on_CPU>     // Enable/disable facilities 

This is _before_ a cpu becomes visible to the general scheduler and
_after_ it has been removed from it.

Those states do not require ordering at least not at the driver level.

And they are not going to be exposed with a dozen of substates. The
only information at both stages is going to be: setup or teardown.

The enable/disable stuff is not allowed to fail. There is no reason
why a driver could veto a cpu offline operation.

The only thing which can fail is the setup stage in preparation, where
you could fail to allocate memory etc.

> So 11 states (although some of those seem to have lots of substates,
> so there may be many more) is too many to *expose*. It's not
> necessarily too many to "have and document", if you see the
> difference.

I don't want to expose them to the general public. I just want the
(arch) core states documented proper with an explicit ordering
scheme. Drivers and stuff should not even know about ordering
requirements.

Thanks,

	tglx
