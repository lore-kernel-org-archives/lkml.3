Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbaFLI0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:26:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405AbaFLI0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:26:50 -0400
Date: Thu, 12 Jun 2014 10:26:45 +0200
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Peter Hurley <peter@hurleysoftware.com>,
        pmladek@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: console: lockup on boot
Message-ID: <20140612082645.GF9511@quack.suse.cz>
References: <5388838B.8070802@oracle.com>
 <53888E76.5040101@hurleysoftware.com>
 <20140530140757.GC2419@quack.suse.cz>
 <53921116.5050804@oracle.com>
 <53972B5C.5020605@hurleysoftware.com>
 <53986DFB.9030006@oracle.com>
 <20140611203436.GD9511@quack.suse.cz>
 <20140611213111.GE9511@quack.suse.cz>
 <53991958.4070106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53991958.4070106@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-06-14 23:07:04, Sasha Levin wrote:
> On 06/11/2014 05:31 PM, Jan Kara wrote:
> > On Wed 11-06-14 22:34:36, Jan Kara wrote:
> >> > On Wed 11-06-14 10:55:55, Sasha Levin wrote:
> >>> > > On 06/10/2014 11:59 AM, Peter Hurley wrote:
> >>>> > > > On 06/06/2014 03:05 PM, Sasha Levin wrote:
> >>>>> > > >> On 05/30/2014 10:07 AM, Jan Kara wrote:
> >>>>>> > > >>> On Fri 30-05-14 09:58:14, Peter Hurley wrote:
> >>>>>>>> > > >>>>> On 05/30/2014 09:11 AM, Sasha Levin wrote:
> >>>>>>>>>> > > >>>>>>> Hi all,
> >>>>>>>>>> > > >>>>>>>
> >>>>>>>>>> > > >>>>>>> I sometime see lockups when booting my KVM guest with the latest -next kernel,
> >>>>>>>>>> > > >>>>>>> it basically hangs right when it should start 'init', and after a while I get
> >>>>>>>>>> > > >>>>>>> the following spew:
> >>>>>>>>>> > > >>>>>>>
> >>>>>>>>>> > > >>>>>>> [   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
> >>>>>>>> > > >>>>>
> >>>>>>>> > > >>>>> Maybe related to this report: https://lkml.org/lkml/2014/5/30/26
> >>>>>>>> > > >>>>> from Jet Chen which was bisected to
> >>>>>>>> > > >>>>>
> >>>>>>>> > > >>>>> commit bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0
> >>>>>>>> > > >>>>> Author:     Jan Kara <jack@suse.cz>
> >>>>>>>> > > >>>>> AuthorDate: Thu May 22 10:43:35 2014 +1000
> >>>>>>>> > > >>>>> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> >>>>>>>> > > >>>>> CommitDate: Thu May 22 10:43:35 2014 +1000
> >>>>>>>> > > >>>>>
> >>>>>>>> > > >>>>>      printk: enable interrupts before calling console_trylock_for_printk()
> >>>>>>>> > > >>>>>          We need interrupts disabled when calling console_trylock_for_printk() only
> >>>>>>>> > > >>>>>      so that cpu id we pass to can_use_console() remains valid (for other
> >>>>>>>> > > >>>>>      things console_sem provides all the exclusion we need and deadlocks on
> >>>>>>>> > > >>>>>      console_sem due to interrupts are impossible because we use
> >>>>>>>> > > >>>>>      down_trylock()).  However if we are rescheduled, we are guaranteed to run
> >>>>>>>> > > >>>>>      on an online cpu so we can easily just get the cpu id in
> >>>>>>>> > > >>>>>      can_use_console().
> >>>>>>>> > > >>>>>          We can lose a bit of performance when we enable interrupts in
> >>>>>>>> > > >>>>>      vprintk_emit() and then disable them again in console_unlock() but OTOH it
> >>>>>>>> > > >>>>>      can somewhat reduce interrupt latency caused by console_unlock()
> >>>>>>>> > > >>>>>      especially since later in the patch series we will want to spin on
> >>>>>>>> > > >>>>>      console_sem in console_trylock_for_printk().
> >>>>>>>> > > >>>>>          Signed-off-by: Jan Kara <jack@suse.cz>
> >>>>>>>> > > >>>>>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>>>>>>> > > >>>>>
> >>>>>>>> > > >>>>> ?
> >>>>>> > > >>>    Yeah, very likely. I think I see the problem, I'll send the fix shortly.
> >>>>> > > >>
> >>>>> > > >> Hi Jan,
> >>>>> > > >>
> >>>>> > > >> It seems that the issue I'm seeing is different from the "[prink]  BUG: spinlock
> >>>>> > > >> lockup suspected on CPU#0, swapper/1".
> >>>>> > > >>
> >>>>> > > >> Is there anything else I could try here? The issue is very common during testing.
> >>>> > > > 
> >>>> > > > Sasha,
> >>>> > > > 
> >>>> > > > Is this bisectable? Maybe that's the best way forward here.
> >>> > > 
> >>> > > I've ran a bisection again and ended up at the same commit as Jet Chen
> >>> > > (the commit unfortunately already made it to Linus's tree).
> >>> > > 
> >>> > > Note that I did try Jan's proposed fix and that didn't solve the issue
> >>> > > for me, I believe we're seeing different issues caused by the same
> >>> > > commit.
> >> >   Sorry it has been busy time lately and I didn't have as much time to look
> >> > into this as would be needed.
> >   Oops, pressed send too early... So I have two debug patches for you. Can
> > you try whether the problem reproduces with the first one or with both of
> > them applied?
> 
> The first patch fixed it (I assumed that there's no need to try the second).
  Good. So that shows that it is the increased lockdep coverage which is
causing problems - with my patch, lockdep is able to identify some problem
because console drivers are now called with lockdep enabled. But because
the problem was found in some difficult context, lockdep just hung the
machine when trying to report it... Sadly the stacktraces you posted don't
tell us what lockdep found.

Adding Peter Zijlstra to CC. Peter, any idea how lockdep could report
problems when holding logbuf_lock? One possibility would be to extend
logbuf_cpu recursion logic to every holder of logbuf_lock. That will at
least avoid the spinlock recursion killing the machine but we won't be able
to see what lockdep found...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
