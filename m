Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbaJXRWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:22:16 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59436 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbaJXRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:22:15 -0400
Date: Fri, 24 Oct 2014 10:18:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric B Munson <emunson@akamai.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Commit 35ce7f29a breaks hibernation for XPS 13
Message-ID: <20141024171818.GU4977@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141024160815.GA2968@akamai.com>
 <20141024161634.GR4977@linux.vnet.ibm.com>
 <20141024163612.GA2256@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024163612.GA2256@akamai.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102417-0033-0000-0000-00000274A292
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 12:36:12PM -0400, Eric B Munson wrote:
> On Fri, 24 Oct 2014, Paul E. McKenney wrote:
> 
> > On Fri, Oct 24, 2014 at 12:08:15PM -0400, Eric B Munson wrote:
> > > Paul,
> > > 
> > > As of 3.18-rc1 I can no longer hibernate my Dell XPS-13.  Bisect points
> > > the finger at 35ce7f29a.  A revert of that commit confirms, I can once
> > > again hibernate my machine without it.
> > > 
> > > When the hibernation fails I see this in dmesg:
> > > [   37.953313] PM: Syncing filesystems ... done.
> > > [   37.963694] Freezing user space processes ... (elapsed 0.001 seconds) done.
> > > [   37.965297] PM: Marking nosave pages: [mem 0x00000000-0x00000fff]
> > > [   37.965299] PM: Marking nosave pages: [mem 0x00058000-0x00058fff]
> > > [   37.965301] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
> > > [   37.965304] PM: Marking nosave pages: [mem 0xc496a000-0xc4b6bfff]
> > > [   37.965315] PM: Marking nosave pages: [mem 0xdadb7000-0xdcffefff]
> > > [   37.965479] PM: Marking nosave pages: [mem 0xdd000000-0xffffffff]
> > > [   37.966000] PM: Basic memory bitmaps created
> > > [   37.966046] PM: Preallocating image memory... done (allocated 181989 pages)
> > > [   38.141524] PM: Allocated 727956 kbytes in 0.17 seconds (4282.09 MB/s)
> > > [   38.141525] Freezing remaining freezable tasks ... 
> > > [   58.151863] Freezing of tasks failed after 20.004 seconds (0 tasks refusing to freeze, wq_busy=1):
> > > [   58.151894] 
> > > [   58.151896] Restarting kernel threads ... done.
> > > [   58.181915] PM: Basic memory bitmaps freed
> > > [   58.181917] Restarting tasks ... done.
> > > 
> > > 
> > > I am not sure what else I can provide that might be useful, but I did
> > > see the thread on net-dev about this same commit.  Please CC me on any
> > > fixes and I will be happy to test.
> > 
> > Thank you for the bug report!
> > 
> > Does the following patch help?
> > 
> > 							Thanx, Paul
> 
> Paul,
> 
> This patch does not help.  I see the same dmesg output and failure to
> hibernate.

Thank you for testing it.  Does the following (untested, might not even
build) patch help?  (Or feel free to wait until I have done some testing
on it.)

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 29fb23f33c18..927c17b081c7 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2546,9 +2546,13 @@ static void rcu_spawn_one_nocb_kthread(struct rcu_state *rsp, int cpu)
 			rdp->nocb_leader = rdp_spawn;
 			if (rdp_last && rdp != rdp_spawn)
 				rdp_last->nocb_next_follower = rdp;
-			rdp_last = rdp;
-			rdp = rdp->nocb_next_follower;
-			rdp_last->nocb_next_follower = NULL;
+			if (rdp == rdp_spawn) {
+				rdp = rdp->nocb_next_follower;
+			} else {
+				rdp_last = rdp;
+				rdp = rdp->nocb_next_follower;
+				rdp_last->nocb_next_follower = NULL;
+			}
 		} while (rdp);
 		rdp_spawn->nocb_next_follower = rdp_old_leader;
 	}

