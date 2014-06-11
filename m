Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaFKUbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:31:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaFKUba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:31:30 -0400
Date: Wed, 11 Jun 2014 22:31:26 +0200
From: Jan Kara <jack@suse.cz>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Jan Kara <jack@suse.cz>,
        pmladek@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: console: lockup on boot
Message-ID: <20140611203126.GC9511@quack.suse.cz>
References: <5388838B.8070802@oracle.com>
 <53888E76.5040101@hurleysoftware.com>
 <20140530140757.GC2419@quack.suse.cz>
 <53921116.5050804@oracle.com>
 <53972B5C.5020605@hurleysoftware.com>
 <53986DFB.9030006@oracle.com>
 <53987704.3030703@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53987704.3030703@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-06-14 11:34:28, Peter Hurley wrote:
> On 06/11/2014 10:55 AM, Sasha Levin wrote:
> >On 06/10/2014 11:59 AM, Peter Hurley wrote:
> >>On 06/06/2014 03:05 PM, Sasha Levin wrote:
> >>>On 05/30/2014 10:07 AM, Jan Kara wrote:
> >>>>On Fri 30-05-14 09:58:14, Peter Hurley wrote:
> >>>>>>On 05/30/2014 09:11 AM, Sasha Levin wrote:
> >>>>>>>>Hi all,
> >>>>>>>>
> >>>>>>>>I sometime see lockups when booting my KVM guest with the latest -next kernel,
> >>>>>>>>it basically hangs right when it should start 'init', and after a while I get
> >>>>>>>>the following spew:
> >>>>>>>>
> >>>>>>>>[   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
> >>>>>>
> >>>>>>Maybe related to this report: https://lkml.org/lkml/2014/5/30/26
> >>>>>>from Jet Chen which was bisected to
> >>>>>>
> >>>>>>commit bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0
> >>>>>>Author:     Jan Kara <jack@suse.cz>
> >>>>>>AuthorDate: Thu May 22 10:43:35 2014 +1000
> >>>>>>Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> >>>>>>CommitDate: Thu May 22 10:43:35 2014 +1000
> >>>>>>
> >>>>>>      printk: enable interrupts before calling console_trylock_for_printk()
> >>>>>>          We need interrupts disabled when calling console_trylock_for_printk() only
> >>>>>>      so that cpu id we pass to can_use_console() remains valid (for other
> >>>>>>      things console_sem provides all the exclusion we need and deadlocks on
> >>>>>>      console_sem due to interrupts are impossible because we use
> >>>>>>      down_trylock()).  However if we are rescheduled, we are guaranteed to run
> >>>>>>      on an online cpu so we can easily just get the cpu id in
> >>>>>>      can_use_console().
> >>>>>>          We can lose a bit of performance when we enable interrupts in
> >>>>>>      vprintk_emit() and then disable them again in console_unlock() but OTOH it
> >>>>>>      can somewhat reduce interrupt latency caused by console_unlock()
> >>>>>>      especially since later in the patch series we will want to spin on
> >>>>>>      console_sem in console_trylock_for_printk().
> >>>>>>          Signed-off-by: Jan Kara <jack@suse.cz>
> >>>>>>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >>>>>>
> >>>>>>?
> >>>>    Yeah, very likely. I think I see the problem, I'll send the fix shortly.
> >>>
> >>>Hi Jan,
> >>>
> >>>It seems that the issue I'm seeing is different from the "[prink]  BUG: spinlock
> >>>lockup suspected on CPU#0, swapper/1".
> >>>
> >>>Is there anything else I could try here? The issue is very common during testing.
> >>
> >>Sasha,
> >>
> >>Is this bisectable? Maybe that's the best way forward here.
> >
> >I've ran a bisection again and ended up at the same commit as Jet Chen (the commit
> >unfortunately already made it to Linus's tree).
> >
> >Note that I did try Jan's proposed fix and that didn't solve the issue for me, I
> >believe we're seeing different issues caused by the same commit.
> >
> >
> >939f04bec1a4ef6ba4370b0f34b01decc844b1b1 is the first bad commit
> >commit 939f04bec1a4ef6ba4370b0f34b01decc844b1b1
> >Author: Jan Kara <jack@suse.cz>
> >Date:   Wed Jun 4 16:11:37 2014 -0700
> >
> >     printk: enable interrupts before calling console_trylock_for_printk()
> >
> >     We need interrupts disabled when calling console_trylock_for_printk()
> >     only so that cpu id we pass to can_use_console() remains valid (for
> >     other things console_sem provides all the exclusion we need and
> >     deadlocks on console_sem due to interrupts are impossible because we use
> >     down_trylock()).  However if we are rescheduled, we are guaranteed to
> >     run on an online cpu so we can easily just get the cpu id in
> >     can_use_console().
> >
> >     We can lose a bit of performance when we enable interrupts in
> >     vprintk_emit() and then disable them again in console_unlock() but OTOH
> >     it can somewhat reduce interrupt latency caused by console_unlock()
> >     especially since later in the patch series we will want to spin on
> >     console_sem in console_trylock_for_printk().
> >
> >     Signed-off-by: Jan Kara <jack@suse.cz>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> I apologize; I didn't look at the patch very closely, but now that I do,
> this sticks out:
> 
> @@ -1597,17 +1599,22 @@ asmlinkage int vprintk_emit(int facility, int level,
> 
>  	logbuf_cpu = UINT_MAX;
>  	raw_spin_unlock(&logbuf_lock);
> +	lockdep_on();
> +	local_irq_restore(flags);
> +
> 
> What prevents cpu migration right here?
  Nothing.

> If nothing, then logbuf_cpu is now stale and the recursion test at
> the top of vprintk_emit is doing nothing to prevent recursion.
  Well, note that logbuf_cpu has just been set to UINT_MAX (i.e. undefined)
two lines above. So my patch changes nothing wrt. how printk recursion
detection works (at least AFAICT).
 
> +	/*
> +	 * Disable preemption to avoid being preempted while holding
> +	 * console_sem which would prevent anyone from printing to console
> +	 */
> +	preempt_disable();
>  	/*
>  	 * Try to acquire and then immediately release the console semaphore.
>  	 * The release will print out buffers and wake up /dev/kmsg and syslog()
>  	 * users.
>  	 */
> -	if (console_trylock_for_printk(this_cpu))
> +	if (console_trylock_for_printk())
>  		console_unlock();

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
