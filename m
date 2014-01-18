Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaARDPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:15:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaARDPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:15:43 -0500
Message-ID: <1390014929.5444.38.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
From: Mike Galbraith <bitbucket@online.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Date: Sat, 18 Jan 2014 04:15:29 +0100
In-Reply-To: <20140117170052.GF5785@linutronix.de>
References: <20131223225017.GA8623@linutronix.de>
	 <1387900067.5490.33.camel@marge.simpson.net>
	 <20140117170052.GF5785@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:W2/wBhq1eD/rlV7tBEnd9jP1PQFixKWCBEuh7q+FlNS
 xHNGEWMqdURWfVeVuNTybTt8oxaZjrCoACYQW8NVfVDe1zmtDR
 GJdX+56qP2CLaCtU+nxgEbGVoRMeyflud5+SIMphK44SuqRc+D
 mkNH5mw17SUXLmFyVKxuzRM9BclwoYAOiOaQ4nMfOdU740dB2P
 rRCkWk+MqWaYQbn4ireh6YJlWM75Zy9EhPqWErbq84/jBw591n
 4TWUz0lXffPmW5AocfbkPwfDpg6zo5BxmBiMxgUMFisAKD+4av
 /ht8Hgs1fNj60NuuG8y/dL34OlwFijxYkYRZvBjX7uJMhp3DI/
 NiKM2FPoU6PNvyI4pic4sP5ufDtFbC9fKyVf8czwtB/VDu+xNN
 KNJJRbMShqWHQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 18:00 +0100, Sebastian Andrzej Siewior wrote: 
> * Mike Galbraith | 2013-12-24 16:47:47 [+0100]:
> 
> >I built this kernel with Paul's patch and NO_HZ_FULL enabled again on 64
> >core box.  I haven't seen RCU grip yet, but I just checked on it after
> >3.5 hours into this boot/beat (after fixing crash+kdump setup), and
> >found it in the process of dumping. 
> 
> So you also have the timers-do-not-raise-softirq-unconditionally.patch?

Oh dear, there's holidays, vacation, and massive turkey overdose between
then and now, but I'm almost positive that the tree was virgin $subject,
with only Paul's patch enabled, that being what I wanted to beat on.

> I have a small problem with understanding this…
> 
> |#24 [ffff880273a03cd0] run_timer_softirq at ffffffff81069002
> 
> Here we obtain wait_lock from tvec_base of _this_ CPU. And we get to
> init_lists() before the apic timer kicks in. So we have the wait_lock.

gdb fibs a little, we're acquiring.

>--- <IRQ stack> ---
> >#21 [ffff880273a03b28] apic_timer_interrupt at ffffffff815cbf9d
> >    [exception RIP: _raw_spin_lock+50]

> In the hard interrupt triggered by the apic timer we get to
> get_next_timer_interrupt() and go again for same the wait_lock. Here we
> have the try_lock so we avoid this deadlock.
> The odd part: we get the lock. It should be the same lock because both use
> | struct tvec_base *base = __this_cpu_read(tvec_bases);
> to ge it. And we shouldn't get it because the lock is already hold.
> We get into trouble in the unlock path where we spin forever:
> 
> |#14 [ffff880276803e50] rt_spin_unlock_after_trylock_in_irq at ffffffff815c3425
> |#12 [ffff880276803e28] _raw_spin_trylock at ffffffff815c3790
> 
> which releases the lock with a trylock in order to keep lockdep happy.
> My understanding was that we should be able to obtain the wait_lock here
> since we were able to obtain it in the lock path and in irq off context
> there is nothing that could take the lock in the meantime.

IIRC, we were endlessly trying, but with an un-punched ticket under us,
and no Xen like evilness to save the day.

I've since cleaned out my crashdump directory and moved on to frolicking
with hotplug gremlins, so don't have that one to revisit, but the don't
unconditionally raise timer softirq patch is the bad guy.

-Mike

