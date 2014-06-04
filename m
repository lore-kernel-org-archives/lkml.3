Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaFDO62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:58:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:22083 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751447AbaFDO60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:58:26 -0400
Date: Wed, 4 Jun 2014 10:58:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Brad Mouring" <bmouring@ni.com>
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 1/1] rtmutex: Handle when top lock owner changes
Message-ID: <20140604105823.0c7124c4@gandalf.local.home>
In-Reply-To: <20140604143830.GA3393@linuxgetsreal>
References: <1400855410-14773-1-git-send-email-brad.mouring@ni.com>
	<1400855410-14773-2-git-send-email-brad.mouring@ni.com>
	<20140603210609.62de6451@gandalf.local.home>
	<20140604130525.GA1621@linuxgetsreal>
	<20140604101612.0d47b399@gandalf.local.home>
	<20140604143830.GA3393@linuxgetsreal>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 09:38:30 -0500
"Brad Mouring" <bmouring@ni.com> wrote:

> On Wed, Jun 04, 2014 at 10:16:12AM -0400, Steven Rostedt wrote:
> > On Wed, 4 Jun 2014 08:05:25 -0500
> > "Brad Mouring" <bmouring@ni.com> wrote:
> > 
> >  >          A->L2
> > > 
> > > This is a slight variation on what I was seeing. To use the nomenclature
> > > that you proposed at the start, rewinding to the point
> > > 
> > >    A->L2->B->L3->C->L4->D
> > > 
> > > Let's assume things continue to unfold as you explain. Task is D,
> > > top_waiter is C. A is scheduled out and the chain shuffles.
> > > 
> > >        A->L2->B
> > > C->L4->D->'
> > 
> > But isn't that a lock ordering problem there?
> > 
> > If B can block on L3 owned by C, I see the following:
> > 
> >   B->L3->C->L4->D->L2->B
> > 
> > Deadlock!
> Yes, it could be. But currently no one owns L3. B is currently not
> blocked. Under these circumstances, there is no deadlock. Also, I
> somewhat arbitrarily picked L4, it could be Lfoo that C blocks on
> since the process is

OK, then you should have used L1, which basically makes it exactly my
scenario ;-)

> ...
> waiter = D->pi_blocked_on
> 
> // waiter is real_waiter D->L2
> 
> // orig_waiter still there, orig_lock still has an owner
> 
> // top_waiter was pointing to C->L4, now points to C->Lfoo
> // D does have top_waiters, and, as noted above, it aliased
> // to encompass a different waiter scenario
> 
> > 
> > In my scenario I was very careful to point out that the lock ordering
> > was: L1->L2->L3->L4
> > 
> > But you show that we can have both:
> > 
> >    L2-> ... ->L4
> > 
> >     and
> > 
> >    L4-> ... ->L2
> > 
> > Which is a reverse of lock ordering and a possible deadlock can occur.
> 
> So the numbering/ordering of the locks is really somewhat arbitrary.
> Here we *can* have L2-> ... ->L4 (if B decides to block on L2, it
> could just as easily block on L8), and we absolutely have
> L4-> ... ->L2. A deadlock *could* occur, but all of the traces that
> I dug through, no actual deadlocks occurred.

Heh, but that shows the code is broken. I'm not saying that our
deadlock detector is not returning false positives, I'm just stating
that you probably need to fix your code.

Yes, you can have a locking order of L1 -> L2 and also L2 -> L1, and if
you are lucky, that may never trigger any deadlocks. But why do you
think the kernel folks have put so much effort into lockdep. Lockdep
doesn't tell you that there is a deadlock (although it could), what it
is so useful with is to tell us where there are possible deadlocks.

If your code does take L1 -> L2 and then L2 -> L1, you have a chance of
hitting a deadlock right there. If you were to run the userspace
lockdep, it would spit out a nice warning for you.

But this is off topic, as I have shown that there exists an example
that the userspace code would never deadlock but our deadlock detector
would say it did.

-- Steve
