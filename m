Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbaEJMUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 08:20:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:40880 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaEJMUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 08:20:36 -0400
Date: Sat, 10 May 2014 14:20:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        hughd@google.com, viresh.kumar@linaro.org,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: vmstat: On demand vmstat workers V4
In-Reply-To: <20140509234745.GB8754@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.02.1405101407290.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org> <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org> <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405090949170.11318@gentwo.org>
 <alpine.DEB.2.02.1405091659350.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405091027040.11318@gentwo.org> <alpine.DEB.2.02.1405092358390.6261@ionos.tec.linutronix.de> <20140509234745.GB8754@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Paul E. McKenney wrote:

> On Sat, May 10, 2014 at 12:57:15AM +0200, Thomas Gleixner wrote:
> > On Fri, 9 May 2014, Christoph Lameter wrote:
> > > On Fri, 9 May 2014, Thomas Gleixner wrote:
> > > > I understand why you want to get this done by a housekeeper, I just
> > > > did not understand why we need this whole move it around business is
> > > > required.
> > > 
> > > This came about because of another objection against having it simply
> > > fixed to a processor. After all that processor may be disabled etc etc.
> > 
> > I really regret that I did not pay more attention (though my cycle
> > constraints simply do not allow it).
> 
> As far as I can see, the NO_HZ_FULL timekeeping CPU is always zero.  If it
> can change in NO_HZ_FULL kernels, RCU will do some very strange things!

Good. I seriously hope it stays that way.

> One possible issue here is that Christoph's patch is unconditional.
> It takes effect for both NO_HZ_FULL and !NO_HZ_FULL.  If I recall
> correctly, the timekeeping CPU -can- change in !NO_HZ_FULL kernels,
> which might be what Christoph was trying to take into account.

Ok. Sorry, I was just in a lousy mood after wasting half a day in
reviewing even lousier patches related to that NO_HZ* muck.

So, right with NO_HZ_IDLE the time keeper can move around and
housekeeping stuff might want to move around as well.

But it's not necessary a good idea to bundle that with the timekeeper,
as under certain conditions the timekeeper duty can move around fast
and left unassigned again when the system is fully idle.

And we really do not want a gazillion of sites which implement a
metric ton of different ways to connect some random housekeeping jobs
with the timekeeper.

So the proper solution to this is to have either a thread or a
dedicated housekeeping worker, which is placed by the scheduler
depending on the system configuration and workload.

That way it can be kept at cpu0 for the nohz=off and the nohz_full
case. In the nohz_idle case we can have different placement
algorithms. On a big/little ARM machine you probably want to keep it
on the first cpu of one or the other cluster. And there might be other
constraints on servers.

So we are way better of with a generic facility, where the various
housekeeping jobs can be queued.

Does that make sense?

Thanks,

	tglx


