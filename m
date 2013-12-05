Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3LEBVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:21:01 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:56750 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab3LEBU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:20:58 -0500
Date: Thu, 5 Dec 2013 02:20:55 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Will CPU 0 be forever prohibited from NO_HZ_FULL status?
Message-ID: <20131205012053.GC6683@localhost.localdomain>
References: <20131204193957.GA2847@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131204193957.GA2847@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 11:39:57AM -0800, Paul E. McKenney wrote:
> Hello, Frederic,
> 
> Just realized that I could further decrease RT latency of one of my "shut
> up RCU on NO_HZ_FULL CPUs" patches if I relied on CPU 0 always having
> a scheduling-clock tick unless the entire system is idle.  The trick
> is that I could then rely on CPU 0 to detect RCU CPU stall warnings,
> and remove the checking from the other CPUs.
> 
> Thoughts?

You're right on time as I'm currently working on that :)
So the plan is to allow timekeeping to be handled by a set of CPUs (cpu_housekeeping_mask
which I guess should be ~nohz_full_mask & cpu_online_mask). I think it will be better
for powersaving. I guess you could balance the RCU stall checks in this
set of housekeeping CPUs?

It should be very easy to make the rcu sysidle stuff to support that housekeeping set,
I just looked into it and all we need to do is to turn the several "cpu == tick_do_timer"
checks into something like is_housekeeping_cpu(cpu). And may be a few easy details, like which
CPU from the housekeeping set should get the kick IPI, well the first one available should be a good start,
of course I expect some issues with cpu hotplug.
But other than that, RCU sysidle detection is mostly ready to support tracking only a given subset
of CPUs instead of all of them. That's in fact what it already does currently by excluding the
fixed boot timekeeping CPU.

So I'm working on that and should have some patches ready soon.

In fact I just realized that all the sysidle detection infrastructure is there and working
but we forgot to plug it in the tick engine, and thus we are still running
with periodic CPU 0 even with CONFIG_NO_HZ_FULL_SYSIDLE=y. Anyway I have a few changes
ready to enable that, lets hope testing will be ok :)

> 
> 							Thanx, Paul
> 
