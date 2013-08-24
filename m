Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab3HXASg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 20:18:36 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:56292 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab3HXASf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 20:18:35 -0400
Date: Fri, 23 Aug 2013 17:18:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tibor Billes <tbilles@gmx.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unusually high system CPU usage with recent kernels
Message-ID: <20130824001831.GG3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130823132026.116850@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823132026.116850@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082400-7164-0000-0000-000000F76CBD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 03:20:25PM +0200, Tibor Billes wrote:
> > From: Paul E. McKenney Sent: 08/22/13 12:09 AM
> > On Wed, Aug 21, 2013 at 11:05:51PM +0200, Tibor Billes wrote:
> > > > From: Paul E. McKenney Sent: 08/21/13 09:12 PM
> > > > On Wed, Aug 21, 2013 at 08:14:46PM +0200, Tibor Billes wrote:
> > > > > > From: Paul E. McKenney Sent: 08/20/13 11:43 PM
> > > > > > On Tue, Aug 20, 2013 at 10:52:26PM +0200, Tibor Billes wrote:
> > > > > > > > From: Paul E. McKenney Sent: 08/20/13 04:53 PM
> > > > > > > > On Tue, Aug 20, 2013 at 08:01:28AM +0200, Tibor Billes wrote:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > I was using the 3.9.7 stable release and tried to upgrade to the 3.10.x series.
> > > > > > > > > The 3.10.x series was showing unusually high (>75%) system CPU usage in some
> > > > > > > > > situations, making things really slow. The latest stable I tried is 3.10.7.
> > > > > > > > > I also tried 3.11-rc5, they both show this behaviour. This behaviour doesn't
> > > > > > > > > show up when the system is idling, only when doing some CPU intensive work,
> > > > > > > > > like compiling with multiple threads. Compiling with only one thread seems not
> > > > > > > > > to trigger this behaviour.
> > > > > > > > > 
> > > > > > > > > To be more precise I did a `perf record -a` while compiling a large C++ program
> > > > > > > > > with scons using 4 threads, the result is appended at the end of this email.
> > > > > > > > 
> > > > > > > > New one on me! You are running a mainstream system (x86_64), so I am
> > > > > > > > surprised no one else noticed.
> > > > > > > > 
> > > > > > > > Could you please send along your .config file?
> > > > > > > 
> > > > > > > Here it is
> > > > > > 
> > > > > > Interesting. I don't see RCU stuff all that high on the list, but
> > > > > > the items I do see lead me to suspect RCU_FAST_NO_HZ, which has some
> > > > > > relevance to the otherwise inexplicable group of commits you located
> > > > > > with your bisection. Could you please rerun with CONFIG_RCU_FAST_NO_HZ=n?
> > > > > > 
> > > > > > If that helps, there are some things I could try.
> > > > > 
> > > > > It did help. I didn't notice anything unusual when running with CONFIG_RCU_FAST_NO_HZ=n.
> > > > 
> > > > Interesting. Thank you for trying this -- and we at least have a
> > > > short-term workaround for this problem. I will put a patch together
> > > > for further investigation.
> > > 
> > > I don't specifically need this config option so I'm fine without it in
> > > the long term, but I guess it's not supposed to behave like that.
> > 
> > OK, good, we have a long-term workload for your specific case,
> > even better. ;-)
> > 
> > But yes, there are situations where RCU_FAST_NO_HZ needs to work
> > a bit better. I hope you will bear with me with a bit more
> > testing...
> 
> Don't worry, I will :) Unfortunately I didn't have time yesterday and I
> won't have time today either. But I'll do what you asked tomorrow and I'll
> send you the results.

Not a problem!  I did find one issue that -might- help, please see
the patch below.  (Run with CONFIG_RCU_FAST_NO_HZ=y.)

Please let me know how it goes!

							Thanx, Paul

------------------------------------------------------------------------

rcu: Remove redundant code from rcu_cleanup_after_idle()

The rcu_try_advance_all_cbs() function returns a bool saying whether or
not there are callbacks ready to invoke, but rcu_cleanup_after_idle()
rechecks this regardless.  This commit therefore uses the value returned
by rcu_try_advance_all_cbs() instead of making rcu_cleanup_after_idle()
do this recheck.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 01676b7..a538e73 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1768,17 +1768,11 @@ static void rcu_prepare_for_idle(int cpu)
  */
 static void rcu_cleanup_after_idle(int cpu)
 {
-	struct rcu_data *rdp;
-	struct rcu_state *rsp;
 
 	if (rcu_is_nocb_cpu(cpu))
 		return;
-	rcu_try_advance_all_cbs();
-	for_each_rcu_flavor(rsp) {
-		rdp = per_cpu_ptr(rsp->rda, cpu);
-		if (cpu_has_callbacks_ready_to_invoke(rdp))
-			invoke_rcu_core();
-	}
+	if (rcu_try_advance_all_cbs())
+		invoke_rcu_core();
 }
 
 /*

