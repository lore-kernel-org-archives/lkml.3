Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab3ENAtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:49:20 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42055 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab3ENAtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:49:19 -0400
Date: Mon, 13 May 2013 07:00:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130513140005.GA9165@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
 <20130512182935.GD24440@8bytes.org>
 <20130512205747.GK3648@linux.vnet.ibm.com>
 <20130512213430.GE24440@8bytes.org>
 <20130513013518.GM3648@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130513013518.GM3648@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051400-2398-0000-0000-0000144E2238
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 06:35:18PM -0700, Paul E. McKenney wrote:
> On Sun, May 12, 2013 at 11:34:30PM +0200, Joerg Roedel wrote:
> > On Sun, May 12, 2013 at 01:57:48PM -0700, Paul E. McKenney wrote:
> > > That does look pretty extreme!  If you build with CONFIG_RCU_NO_HZ=n,
> > > but without the revert, do you still get the delays?
> > 
> > With CONFIG_RCU_NO_HZ=n (and no revert) the system boots fine, no boot
> > delay. I also enabled some RCU debugging options (with
> > CONFIG_RCU_NO_HZ=y), but didn't see anything so far.
> 
> OK, good -- we at least have an easy work-around while I am tracking
> this down.  ;-)

And could you please try out the following patch?

							Thanx, Paul

------------------------------------------------------------------------

rcu: Fix comparison sense in rcu_needs_cpu()

Commit c0f4dfd4f (rcu: Make RCU_FAST_NO_HZ take advantage of numbered
callbacks) introduced a bug that can result in excessively long grace
periods.  This bug reverse the senes of the "if" statement checking
for lazy callbacks, so that RCU takes a lazy approach when there are
in fact non-lazy callbacks.  This can result in excessive boot, suspend,
and resume times.

This commit therefore fixes the sense of this "if" statement.

Reported-by: Borislav Petkov <bp@alien8.de>
Reported-by: Bjørn Mork <bjorn@mork.no>
Reported-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 641991d..63098a5 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1692,7 +1692,7 @@ int rcu_needs_cpu(int cpu, unsigned long *dj)
 	rdtp->last_accelerate = jiffies;
 
 	/* Request timer delay depending on laziness, and round. */
-	if (rdtp->all_lazy) {
+	if (!rdtp->all_lazy) {
 		*dj = round_up(rcu_idle_gp_delay + jiffies,
 			       rcu_idle_gp_delay) - jiffies;
 	} else {

