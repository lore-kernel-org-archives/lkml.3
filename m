Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaD1JJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:09:52 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62298 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbaD1JJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:09:50 -0400
Message-ID: <1398676186.30930.49.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.14-rt1
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Mon, 28 Apr 2014 11:09:46 +0200
In-Reply-To: <1398661784.30930.33.camel@marge.simpson.net>
References: <20140411185739.GA6644@linutronix.de>
	 <1397918766.5436.16.camel@marge.simpson.net>
	 <1398411635.11930.45.camel@marge.simpson.net>
	 <1398501491.12941.5.camel@marge.simpson.net>
	 <1398520699.28726.22.camel@marge.simpson.net>
	 <1398661784.30930.33.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 07:09 +0200, Mike Galbraith wrote: 
> Hi Nicholas,
> 
> On Sat, 2014-04-26 at 15:58 +0200, Mike Galbraith wrote: 
> > On Sat, 2014-04-26 at 10:38 +0200, Mike Galbraith wrote: 
> > > On Fri, 2014-04-25 at 09:40 +0200, Mike Galbraith wrote:
> > > 
> > > > Hotplug can still deadlock in rt trees too, and will if you beat it
> > > > hard.
> > > 
> > > Box actually deadlocks like so.
> > 
> > ...
> > 
> > 3.12-rt looks a bit busted migrate_disable/enable() wise.
> > 
> > /me eyeballs 3.10-rt (looks better), confirms 3.10-rt hotplug works,
> > swipes working code, confirms 3.12-rt now works.  Yup, that was it.
> 
> My boxen, including 64 core DL980 that ran hotplug stress for 3 hours
> yesterday with pre-pushdown rwlocks, say the migrate_disable/enable
> pushdown patches are very definitely busted.

migrate_disable-pushd-down-in-atomic_dec_and_spin_lo.patch

bug: migrate_disable() after blocking is too late.

@@ -1028,12 +1028,12 @@ int atomic_dec_and_spin_lock(atomic_t *a
        /* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
        if (atomic_add_unless(atomic, -1, 1))
                return 0;
-       migrate_disable();
        rt_spin_lock(lock);
-       if (atomic_dec_and_test(atomic))
+       if (atomic_dec_and_test(atomic)){
+               migrate_disable();
                return 1;
+       }
        rt_spin_unlock(lock);
-       migrate_enable();
        return 0;
 }
 EXPORT_SYMBOL(atomic_dec_and_spin_lock);

read_lock-migrate_disable-pushdown-to-rt_read_lock.patch

bug: ditto.

@@ -244,8 +246,10 @@ void __lockfunc rt_read_lock(rwlock_t *r
        /*
         * recursive read locks succeed when current owns the lock
         */
-       if (rt_mutex_owner(lock) != current)
+       if (rt_mutex_owner(lock) != current) {
                __rt_spin_lock(lock);
+               migrate_disable();
+       }
        rwlock->read_depth++;
 }

Moving that migrate_disable() up will likely fix my hotplug troubles.
I'll find out when I get back from physical torture (therapy) session.

-Mike

