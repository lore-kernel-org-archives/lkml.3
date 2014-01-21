Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaAUCRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 21:17:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:50168 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751859AbaAUCRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 21:17:39 -0500
Date: Mon, 20 Jan 2014 21:17:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
Message-ID: <20140120211736.0c97418a@gandalf.local.home>
In-Reply-To: <1390014929.5444.38.camel@marge.simpson.net>
References: <20131223225017.GA8623@linutronix.de>
	<1387900067.5490.33.camel@marge.simpson.net>
	<20140117170052.GF5785@linutronix.de>
	<1390014929.5444.38.camel@marge.simpson.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jan 2014 04:15:29 +0100
Mike Galbraith <bitbucket@online.de> wrote:

 
> > So you also have the timers-do-not-raise-softirq-unconditionally.patch?
> 

People have been complaining that the latest 3.12-rt does not boot on
intel i7 boxes. And by reverting this patch, it boots fine.

I happen to have a i7 box to test on, and sure enough, the latest
3.12-rt locks up on boot and reverting the
timers-do-not-raise-softirq-unconditionally.patch, it boots fine.

Looking into it, I made this small update, and the box boots. Seems
checking "active_timers" is not enough to skip raising softirqs. I
haven't looked at why yet, but I would like others to test this patch
too.

I'll leave why this lets i7 boxes boot as an exercise for Thomas ;-)

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/timer.c b/kernel/timer.c
index 46467be..8212c10 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1464,13 +1464,11 @@ void run_local_timers(void)
 		raise_softirq(TIMER_SOFTIRQ);
 		return;
 	}
-	if (!base->active_timers)
-		goto out;
 
 	/* Check whether the next pending timer has expired */
 	if (time_before_eq(base->next_timer, jiffies))
 		raise_softirq(TIMER_SOFTIRQ);
-out:
+
 	rt_spin_unlock_after_trylock_in_irq(&base->lock);
 
 }
