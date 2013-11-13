Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3KMQR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:17:26 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34117 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3KMQRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:17:24 -0500
Date: Wed, 13 Nov 2013 08:17:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        LKML <linux-kernel@vger.kernel.org>, mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20131113161719.GD4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131113113927.GA13875@mwhitehe.csb>
 <alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
 <20131113102153.5f10e6b5@gandalf.local.home>
 <20131113103134.5b8cf02f@gandalf.local.home>
 <alpine.DEB.2.02.1311131635580.30673@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311131635580.30673@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111316-0320-0000-0000-000001B5DB38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 04:50:20PM +0100, Thomas Gleixner wrote:
> On Wed, 13 Nov 2013, Steven Rostedt wrote:
> > > I'm not saying that we are actually getting into nohz, but something
> > > with the nohz code is messing with cpu accounting.
> > 
> > The trace does indeed show that a tick is happening, as the config has
> > HZ=250 (4ms) and we see a tick happen every 4ms. But for some reason,
> > we don't update the the idle time correctly when nohz is enabled.
> > 
> > When I say nohz is enabled, I mean that we don't have nohz=off in the
> > command line. There seems to be some difference between having nohz=off
> > and having nohz disabled at runtime.
> 
> Right that affects tick_nohz_enabled
> 
> Two files use this variable:
> kernel/rcu/tree_plugin.h
> kernel/time/tick-sched.c
> 
> The only accounting related stuff is in tick-sched.c:
> 
> get_cpu_idle_time_us() and get_cpu_iowait_time_us()
> 
> Both functions bail out if (!tick_nohz_enabled).
> 
> The users of get_cpu_idle_time_us() are cpufreq and fs/proc/stat.c!
> 
> Now the simplest fix is to let those functions check whether we
> actually switched into NOHZ mode. Should work for the RCU tree stuff
> as well.

RCU's use of tick_nohz_enabled is for the RCU_FAST_NO_HZ stuff.  If
it sees !tick_nohz_enabled, it skips trying to get RCU out of the way
of disabling the scheduling-clock tick.  If RCU detects a change
in the value of tick_nohz_enabled, it does a raise_softirq() to
force re-evaluation of the situation.

							Thanx, Paul

