Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaKWViM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 16:38:12 -0500
Received: from www.linutronix.de ([62.245.132.108]:35252 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKWViL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 16:38:11 -0500
Date: Sun, 23 Nov 2014 22:38:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Mason <clm@fb.com>
cc: Borislav Petkov <bp@alien8.de>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: New crashes walking proc with Saturday's git
In-Reply-To: <1416777079.1732.0@mail.thefacebook.com>
Message-ID: <alpine.DEB.2.11.1411232235591.6439@nanos>
References: <20141123010239.GA12691@ret.masoncoding.com> <1416758187.24312.12@mail.thefacebook.com> <20141123161120.GB7070@pd.tnic> <1416759411.24312.13@mail.thefacebook.com> <20141123163258.GB6436@pd.tnic> <1416761342.24312.15@mail.thefacebook.com>
 <alpine.DEB.2.11.1411232141590.6439@nanos> <1416777079.1732.0@mail.thefacebook.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Nov 2014, Chris Mason wrote:
> On Sun, Nov 23, 2014 at 4:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Sun, 23 Nov 2014, Chris Mason wrote:
> > >  On Sun, Nov 23, 2014 at 11:32 AM, Borislav Petkov <bp@alien8.de> wrote:
> > >  > On Sun, Nov 23, 2014 at 11:16:51AM -0500, Chris Mason wrote:
> > >  > >  It must be:
> > >  > >
> > >  > >  commit 6e998916dfe327e785e7c2447959b2c1a3ea4930
> > >  > >  Author: Stanislaw Gruszka <sgruszka@redhat.com>
> > >  > >  Date:   Wed Nov 12 16:58:44 2014 +0100
> > >  > >
> > >  > >     sched/cputime: Fix clock_nanosleep()/clock_gettime()
> > > inconsistency
> > >  > >
> > >  > >  I'll do two runs to confirm, but it's the only related patch between
> > > rc5
> > >  > > and
> > >  > >  now.
> > > 
> > >  I've adding Ingo and Stanislaw to the cc.  With
> > >  6e998916dfe327e785e7c2447959b2c1a3ea4930 reverted, I'm no longer
> > > crashing.
> > > 
> > >  Repeating the stack trace for the new cc list.  I see the crash with atop
> > > or
> > >  similar walkers of /proc racing against exiting programs.  Given the NULL
> > > rip,
> > >  this line from the patch is probably broken, but it really feels like we
> > >  should be falling over on p->sched_class and not on the update_curr func.
> > > 
> > >  +               p->sched_class->update_curr(rq);
> > > 
> > >  I'm leaving my fork bomb running on two machines with the patch reverted
> > > to
> > >  make sure.
> > 
> > The sched_class instances which do not have update_curr are stop_task
> > and idle. Patch below.
> > 
> > I'm sure nobody thought about the stats read code path here.
> > 
> > [ 1053.759741]  [<ffffffff81208348>] do_task_stat+0x8b8/0xb00
> > 
> > do_task_stat(()
> >  thread_group_cputime_adjusted()
> >    thread_group_cputime()
> >      task_cputime()
> >        task_sched_runtime()
> > 	if (task_current(rq, p) && task_on_rq_queued(p)) {
> >                 update_rq_clock(rq);
> >                 p->sched_class->update_curr(rq);
> >         }
> > 
> > Now if the stats are read for a stomp machine task, aka 'migration/N'
> > and that task is current on its cpu. Ooops.
> > 
> > I added the callback for idle tasks as well for completeness sake.
> 
> This does make sense, but it doesn't match with the crash being much more
> likely during the fork bomb.  The difference is crashing within a few hours vs
> crashing within 5 minutes.

The fork bomb will kick the migration task pretty often into life, so
the probablity of do_task_stat() to hit a running migration thread is
higher than on a normaly loaded machine.

Thanks,

	tglx
