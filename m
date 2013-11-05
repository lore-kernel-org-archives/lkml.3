Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3KEQpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:45:36 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48505 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140Ab3KEQpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:45:35 -0500
Date: Tue, 5 Nov 2013 08:25:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes visible
 slowdown in ftrace switching
Message-ID: <20131105162508.GB18245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1383326384.6788.49.camel@pathway.suse.cz>
 <20131104170232.GS3947@linux.vnet.ibm.com>
 <1383666186.27527.57.camel@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383666186.27527.57.camel@pathway.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110516-7182-0000-0000-000009022194
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 04:43:06PM +0100, Petr Mladek wrote:
> Hello Paul,
> 
> Paul E. McKenney píše v Po 04. 11. 2013 v 09:02 -0800:
> > On Fri, Nov 01, 2013 at 06:19:44PM +0100, Petr Mladek wrote:
> > > Hi,
> > > 
> > > I am doing some clean up in x86 ftrace code. I check the performance by
> > > switching between different tracers and by enabling and disabling them.
> > > 
> > > The operation has started to be much slower after rebasing on the
> > > kernel tip tree. Bisecting has shown that the difference was caused by
> > > the commit c229828ca6bc62d6c654 (rcu: Throttle
> > > rcu_try_advance_all_cbs() execution)
> 
> > This is a slowpath, and that commit did fix a real bug, so I am OK with
> > this modest slowdown.
> > 
> > That said, if you have a workload where this is a problem, please try
> > building with CONFIG_RCU_FAST_NO_HZ=n.  The fact that this commit had any
> > effect at all leads me to believe that you used CONFIG_RCU_FAST_NO_HZ=y.
> 
> Yes, I used CONFIG_RCU_FAST_NO_HZ=y.
> 
> I am not aware of any other workload with this problem. I tried few
> benchmarks: dbench, unixbench, and aim. They did not show any
> considerable difference with and without the commit. If you are
> interested you might find more details in the attached logs.
> 
> Just for record, I also checked how the ftrace test was affected by the
> commit under various system load. The speed difference was there if at
> least one CPU was idle. But the test was slower on idle system even
> without the patch. Hence this is not the only change that causes some
> difference. See the attached "ftrace" file for more details.

Ah, the joys of energy efficiency!  ;-)

If the system is entirely non-idle, each CPU will respond to RCU in a
timely fashion.  However, RCU cannot be permitted to interrupt or in any
way disturb an idle CPU, most especially on a battery-powered system.
To do so would completely destroy energy efficiency and battery lifetime.
Instead, idle CPUs leave evidence of their idleness in per-CPU variables,
and RCU must check these variables for any CPUs that do not respond in
a timely fashion.

Of course, it would not do for RCU to be in a busy-waiting loop
continuously checking these variables.  Instead, RCU checks them
after a three-jiffy delay, which can be tuned if desired using the
rcutree.jiffies_till_first_fqs kernel boot parameter.  You can even set it
to zero if you like, which should speed up your ftrace test significantly
on idle systems.  You might also tune the rcutree.jiffies_till_next_fqs
kernel boot parameter, which governs the time delay until the second
and subsequent checks for a given RCU grace period.

The reason that the change mostly affected idle systems is that
CONFIG_RCU_FAST_NO_HZ=y (and thus the change to its code) affects
the transitions to and from idle.  If your system is never idle,
then CONFIG_RCU_FAST_NO_HZ=y will have no effect whatsoever.

> I am still a bit curious why ftrace code is so special here and why it
> does not affect the other benchmarks. Anyway, I agree that ftrace
> change/start/stop operations are not time critical and the extra delay
> might be worth fixing the other bug. I am fine with it :-)

The ftrace code makes heavy use of RCU updates when enabling and disabling
things, which makes its performance quite sensitive to grace-period
duration, and (as you saw) grace-period duration is increased somewhat
by CONFIG_RCU_FAST_NO_HZ=y.  This trade of increased energy efficiency
for longer grace-period duration is the right trade for most systems.

Other systems can use CONFIG_RCU_FAST_NO_HZ=n and/or tune the
rcutree.jiffies_till_first_fqs and rcutree.jiffies_till_next_fqs
kernel boot parameters.

Hey, you asked!  ;-)

							Thanx, Paul

> Best Regards,
> Petr



> test: ftrace
> CPU: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz
> RAM: 4GB
> 
> Started using the command:
> 
> 	time ./test-ftrace
> 
> Where test-ftrace is:
> 
> --- cut ---
> #!/bin/bash
> 
> echo "Testing ftrace - begin"
> cd /sys/kernel/debug/tracing
> 
> count=0
> while test $count -lt 100 ; do
>     for tracer in function nop ; do
> 	echo $tracer >current_tracer
> 	echo 1 >tracing_on
> 	echo 0 >tracing_on
>     done
>     count=$(($count + 1))
> done
> 
> cd -
> echo "Testing ftrace - end"
> --- cut ---
> 
> and the load was generated using the script make-load:
> 
> --- cut ---
> #!/bin/bash
> 
> a=1
> while true ; do
>     a=$(($a+1))
> done
> --- cut ---
> 
> Now, results with no load on the system; with the commit c229828ca6bc62d
> (rcu: Throttle rcu_try_advance_all_cbs() execution)
> 
> real    0m49.393s    0m49.632s    0m49.359
> user    0m0.004s     0m0.000s	  0m0.004s
> sys     0m0.996s     0m0.880s	  0m0.892s
> 
> and with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
> execution)
> 
> real    0m35.320s    0m35.687s    0m35.920s
> user    0m0.004s     0m0.004s	  0m0.000s
> sys     0m1.140s     0m1.208s	  0m1.152s
> 
> ---
> 
> Results with 100% load on one CPU and no load on 2nd CPU (started the script
> make-load once) with c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
> execution)
> 
> real    0m44.964s    0m45.083s    0m45.171s
> user    0m0.000s     0m0.000s	  0m0.004s
> sys     0m1.580s     0m1.612s	  0m1.576s
> 
> and with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
> execution)
> 
> real    0m30.816s    0m31.326s    0m31.191s
> user    0m0.004s     0m0.004s	  0m0.008s
> sys     0m1.240s     0m1.248s	  0m1.232s
> 
> ---
> 
> Results with 100% load on both CPUs (started script make-load twice)
> with c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs() execution)
> 
> real    0m20.294s    0m20.538s    0m20.470s
> user    0m0.004s     0m0.000s	  0m0.000s
> sys     0m1.284s     0m1.388s	  0m1.612s
> 
> and with reverted c229828ca6bc62d (rcu: Throttle rcu_try_advance_all_cbs()
> execution)
> 
> real    0m20.305s    0m20.056s    0m20.259
> user    0m0.000s     0m0.000s	  0m0.000s
> sys     0m1.416s     0m1.452s	  0m1.560s


