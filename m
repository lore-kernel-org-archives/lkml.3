Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3LJPIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:08:53 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:56426 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3LJPIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:08:51 -0500
Date: Tue, 10 Dec 2013 07:08:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Will CPU 0 be forever prohibited from NO_HZ_FULL status?
Message-ID: <20131210150846.GO4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204193957.GA2847@linux.vnet.ibm.com>
 <20131205012053.GC6683@localhost.localdomain>
 <20131205025037.GM15492@linux.vnet.ibm.com>
 <20131210143702.GB10633@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210143702.GB10633@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121015-9332-0000-0000-0000027134C1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 03:37:03PM +0100, Frederic Weisbecker wrote:
> On Wed, Dec 04, 2013 at 06:50:37PM -0800, Paul E. McKenney wrote:
> > On Thu, Dec 05, 2013 at 02:20:55AM +0100, Frederic Weisbecker wrote:
> > > On Wed, Dec 04, 2013 at 11:39:57AM -0800, Paul E. McKenney wrote:
> > > > Hello, Frederic,
> > > > 
> > > > Just realized that I could further decrease RT latency of one of my "shut
> > > > up RCU on NO_HZ_FULL CPUs" patches if I relied on CPU 0 always having
> > > > a scheduling-clock tick unless the entire system is idle.  The trick
> > > > is that I could then rely on CPU 0 to detect RCU CPU stall warnings,
> > > > and remove the checking from the other CPUs.
> > > > 
> > > > Thoughts?
> > > 
> > > You're right on time as I'm currently working on that :)
> > > So the plan is to allow timekeeping to be handled by a set of CPUs (cpu_housekeeping_mask
> > > which I guess should be ~nohz_full_mask & cpu_online_mask). I think it will be better
> > > for powersaving. I guess you could balance the RCU stall checks in this
> > > set of housekeeping CPUs?
> > > 
> > > It should be very easy to make the rcu sysidle stuff to support that housekeeping set,
> > > I just looked into it and all we need to do is to turn the several "cpu == tick_do_timer"
> > > checks into something like is_housekeeping_cpu(cpu). And may be a few easy details, like which
> > > CPU from the housekeeping set should get the kick IPI, well the first one available should be a good start,
> > > of course I expect some issues with cpu hotplug.
> > > But other than that, RCU sysidle detection is mostly ready to support tracking only a given subset
> > > of CPUs instead of all of them. That's in fact what it already does currently by excluding the
> > > fixed boot timekeeping CPU.
> > > 
> > > So I'm working on that and should have some patches ready soon.
> > 
> > Thank you for the info!  Nice to know that RCU will continue to be able
> > to rely on there being at least one housekeeping CPU.  ;-)
> > 
> > At that point, tick_nohz_full_cpu() would still be a good way for RCU
> > to distinguish housekeeping CPUs from working CPUs, correct?
> 
> Correct!

Cool!  Maybe I should start future-proofing RCU in that manner.

> > > In fact I just realized that all the sysidle detection infrastructure is there and working
> > > but we forgot to plug it in the tick engine, and thus we are still running
> > > with periodic CPU 0 even with CONFIG_NO_HZ_FULL_SYSIDLE=y. Anyway I have a few changes
> > > ready to enable that, lets hope testing will be ok :)
> > 
> > Indeed!  ;-)
> > 
> > The CONFIG_NO_HZ_FULL_SYSIDLE=y might complicate things a bit.  But I
> > guess the problem would be a corner case -- the system entered sysidle
> > mode with a grace period pending, which should eventually wake up the
> > corresponding grace-period kthread, which might be prevented from ever
> > running due to high load or something.  If that problem arises, I will
> > fix it.
> 
> I see. Well we'll find out.
> In the meantime I successfully plugged sysidle detection with full dynticks and it
> surprisingly works like a charm. Which makes me think there must be some bug in my patches that make things
> working by accident :)

Must be some mistake!  ;-)

							Thanx, Paul

> I'll post soon.
> 
> Thanks.
> 

