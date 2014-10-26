Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504AbaJZN6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 09:58:42 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:56502 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZN6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 09:58:41 -0400
Message-ID: <1414331916.5304.23.camel@marge.simpson.net>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Sun, 26 Oct 2014 14:58:36 +0100
In-Reply-To: <1414329375.5304.20.camel@marge.simpson.net>
References: <20141003194428.GA27084@sesse.net>
	 <1412782664.5179.75.camel@marge.simpson.net>
	 <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
	 <1412791184.5173.11.camel@marge.simpson.net>
	 <alpine.DEB.2.11.1410241724370.5308@nanos>
	 <1414168721.5308.3.camel@marge.simpson.net>
	 <20141026103918.GA5259@sesse.net>
	 <1414329375.5304.20.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-26 at 14:16 +0100, Mike Galbraith wrote: 
> On Sun, 2014-10-26 at 11:39 +0100, Steinar H. Gunderson wrote: 
> > On Fri, Oct 24, 2014 at 06:38:41PM +0200, Mike Galbraith wrote:
> > >>> Whew, good, futex.c is hard.  Heads up chess guys <punt>. 
> > >> I wonder whether the barrier fix which got into 3.17 late fixes that
> > >> issue as well.
> > > Yes, it did.
> > 
> > This is only about the lockup, right, not that the threads bounce around a
> > lot and make things slower?
> 
> Yes.  I couldn't reproduce your results, on my 28 core+ht box, there was
> little difference between pinned/unpinned.  Maybe the box was too quite,
> not enough random activity to motivate select_idle_sibling().

Can you try the below?

---
 kernel/sched/fair.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4477,6 +4477,12 @@ static int select_idle_sibling(struct ta
 		return i;
 
 	/*
+	 * Don't bounce hefty tasks about, they may be hitting contention.
+	 */
+	if (p->se.load.weight - (p->se.load.weight/4) < p->se.avg.load_avg_contrib)
+		return target;
+
+	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));


