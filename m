Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaFKVbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:31:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870AbaFKVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:31:15 -0400
Date: Wed, 11 Jun 2014 23:31:11 +0200
From: Jan Kara <jack@suse.cz>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, Jan Kara <jack@suse.cz>,
        pmladek@suse.cz, Andrew Morton <akpm@linux-foundation.org>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: console: lockup on boot
Message-ID: <20140611213111.GE9511@quack.suse.cz>
References: <5388838B.8070802@oracle.com>
 <53888E76.5040101@hurleysoftware.com>
 <20140530140757.GC2419@quack.suse.cz>
 <53921116.5050804@oracle.com>
 <53972B5C.5020605@hurleysoftware.com>
 <53986DFB.9030006@oracle.com>
 <20140611203436.GD9511@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
In-Reply-To: <20140611203436.GD9511@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 11-06-14 22:34:36, Jan Kara wrote:
> On Wed 11-06-14 10:55:55, Sasha Levin wrote:
> > On 06/10/2014 11:59 AM, Peter Hurley wrote:
> > > On 06/06/2014 03:05 PM, Sasha Levin wrote:
> > >> On 05/30/2014 10:07 AM, Jan Kara wrote:
> > >>> On Fri 30-05-14 09:58:14, Peter Hurley wrote:
> > >>>>> On 05/30/2014 09:11 AM, Sasha Levin wrote:
> > >>>>>>> Hi all,
> > >>>>>>>
> > >>>>>>> I sometime see lockups when booting my KVM guest with the latest -next kernel,
> > >>>>>>> it basically hangs right when it should start 'init', and after a while I get
> > >>>>>>> the following spew:
> > >>>>>>>
> > >>>>>>> [   30.790833] BUG: spinlock lockup suspected on CPU#1, swapper/1/0
> > >>>>>
> > >>>>> Maybe related to this report: https://lkml.org/lkml/2014/5/30/26
> > >>>>> from Jet Chen which was bisected to
> > >>>>>
> > >>>>> commit bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0
> > >>>>> Author:     Jan Kara <jack@suse.cz>
> > >>>>> AuthorDate: Thu May 22 10:43:35 2014 +1000
> > >>>>> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> > >>>>> CommitDate: Thu May 22 10:43:35 2014 +1000
> > >>>>>
> > >>>>>      printk: enable interrupts before calling console_trylock_for_printk()
> > >>>>>          We need interrupts disabled when calling console_trylock_for_printk() only
> > >>>>>      so that cpu id we pass to can_use_console() remains valid (for other
> > >>>>>      things console_sem provides all the exclusion we need and deadlocks on
> > >>>>>      console_sem due to interrupts are impossible because we use
> > >>>>>      down_trylock()).  However if we are rescheduled, we are guaranteed to run
> > >>>>>      on an online cpu so we can easily just get the cpu id in
> > >>>>>      can_use_console().
> > >>>>>          We can lose a bit of performance when we enable interrupts in
> > >>>>>      vprintk_emit() and then disable them again in console_unlock() but OTOH it
> > >>>>>      can somewhat reduce interrupt latency caused by console_unlock()
> > >>>>>      especially since later in the patch series we will want to spin on
> > >>>>>      console_sem in console_trylock_for_printk().
> > >>>>>          Signed-off-by: Jan Kara <jack@suse.cz>
> > >>>>>      Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > >>>>>
> > >>>>> ?
> > >>>    Yeah, very likely. I think I see the problem, I'll send the fix shortly.
> > >>
> > >> Hi Jan,
> > >>
> > >> It seems that the issue I'm seeing is different from the "[prink]  BUG: spinlock
> > >> lockup suspected on CPU#0, swapper/1".
> > >>
> > >> Is there anything else I could try here? The issue is very common during testing.
> > > 
> > > Sasha,
> > > 
> > > Is this bisectable? Maybe that's the best way forward here.
> > 
> > I've ran a bisection again and ended up at the same commit as Jet Chen
> > (the commit unfortunately already made it to Linus's tree).
> > 
> > Note that I did try Jan's proposed fix and that didn't solve the issue
> > for me, I believe we're seeing different issues caused by the same
> > commit.
>   Sorry it has been busy time lately and I didn't have as much time to look
> into this as would be needed.
  Oops, pressed send too early... So I have two debug patches for you. Can
you try whether the problem reproduces with the first one or with both of
them applied?

The stacktrace from spinlock lockup is somewhat weird - the spinlock lockup
message comes from NMI context where we tried to do print stack dump.
Indeed calling printk from NMI context *can* lead to this sort of lockups
(and the current process is a worker thread which apparently runs
fb_flashcursor() function which calls console_unlock() which can hold
logbuf_lock so all these things fit together).  What I really fail to see
is how my patch makes the problem happen to you pretty reliably.

Another somewhat strange thing to me is that although lock->owner in your
dump looks fine and points to currently running process, lock->owner_cpu is
-1 which is a combination that shouldn't ever happen as I'm looking into
spinlock debug code.

So for now I'm still puzzled.
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--ZJcv+A0YCCLh2VIg
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-printk-Debug-patch1.patch"

>From bf739a5af7a73b08b3dea0491d38816f686dbf57 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 11 Jun 2014 22:33:23 +0200
Subject: [PATCH 1/2] printk: Debug patch1

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5ea6b148a1a6..da94dc18b6fa 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1649,6 +1649,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * console_sem which would prevent anyone from printing to console
 	 */
 	preempt_disable();
+	lockdep_off();
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
@@ -1656,6 +1657,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 */
 	if (console_trylock_for_printk())
 		console_unlock();
+	lockdep_on();
 	preempt_enable();
 
 	return printed_len;
-- 
1.8.1.4


--ZJcv+A0YCCLh2VIg
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-printk-Debug-patch-2.patch"

>From 976ab0ea1d855686d8166b9c08239aa50e1c983b Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 11 Jun 2014 22:38:41 +0200
Subject: [PATCH 2/2] printk: Debug patch 2

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index da94dc18b6fa..7263c4353150 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1638,17 +1638,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
 	lockdep_on();
-	local_irq_restore(flags);
-
-	/* If called from the scheduler, we can not call up(). */
-	if (in_sched)
-		return printed_len;
-
 	/*
 	 * Disable preemption to avoid being preempted while holding
 	 * console_sem which would prevent anyone from printing to console
 	 */
 	preempt_disable();
+	local_irq_restore(flags);
+
+	/* If called from the scheduler, we can not call up(). */
+	if (in_sched) {
+		preempt_enable();
+		return printed_len;
+	}
+
 	lockdep_off();
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
-- 
1.8.1.4


--ZJcv+A0YCCLh2VIg--
