Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbaJXSkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 14:40:33 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:47572 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757091AbaJXSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 14:40:31 -0400
Date: Fri, 24 Oct 2014 14:40:28 -0400
From: Eric B Munson <emunson@akamai.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Commit 35ce7f29a breaks hibernation for XPS 13
Message-ID: <20141024184028.GA2220@akamai.com>
References: <20141024160815.GA2968@akamai.com>
 <20141024161634.GR4977@linux.vnet.ibm.com>
 <20141024163612.GA2256@akamai.com>
 <20141024171818.GU4977@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024171818.GU4977@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014, Paul E. McKenney wrote:

> On Fri, Oct 24, 2014 at 12:36:12PM -0400, Eric B Munson wrote:
> > On Fri, 24 Oct 2014, Paul E. McKenney wrote:
> > 
> > > On Fri, Oct 24, 2014 at 12:08:15PM -0400, Eric B Munson wrote:
> > > > Paul,
> > > > 
> > > > As of 3.18-rc1 I can no longer hibernate my Dell XPS-13.  Bisect points
> > > > the finger at 35ce7f29a.  A revert of that commit confirms, I can once
> > > > again hibernate my machine without it.
> > > > 
> > > > When the hibernation fails I see this in dmesg:
> > > > [   37.953313] PM: Syncing filesystems ... done.
> > > > [   37.963694] Freezing user space processes ... (elapsed 0.001 seconds) done.
> > > > [   37.965297] PM: Marking nosave pages: [mem 0x00000000-0x00000fff]
> > > > [   37.965299] PM: Marking nosave pages: [mem 0x00058000-0x00058fff]
> > > > [   37.965301] PM: Marking nosave pages: [mem 0x0009d000-0x000fffff]
> > > > [   37.965304] PM: Marking nosave pages: [mem 0xc496a000-0xc4b6bfff]
> > > > [   37.965315] PM: Marking nosave pages: [mem 0xdadb7000-0xdcffefff]
> > > > [   37.965479] PM: Marking nosave pages: [mem 0xdd000000-0xffffffff]
> > > > [   37.966000] PM: Basic memory bitmaps created
> > > > [   37.966046] PM: Preallocating image memory... done (allocated 181989 pages)
> > > > [   38.141524] PM: Allocated 727956 kbytes in 0.17 seconds (4282.09 MB/s)
> > > > [   38.141525] Freezing remaining freezable tasks ... 
> > > > [   58.151863] Freezing of tasks failed after 20.004 seconds (0 tasks refusing to freeze, wq_busy=1):
> > > > [   58.151894] 
> > > > [   58.151896] Restarting kernel threads ... done.
> > > > [   58.181915] PM: Basic memory bitmaps freed
> > > > [   58.181917] Restarting tasks ... done.
> > > > 
> > > > 
> > > > I am not sure what else I can provide that might be useful, but I did
> > > > see the thread on net-dev about this same commit.  Please CC me on any
> > > > fixes and I will be happy to test.
> > > 
> > > Thank you for the bug report!
> > > 
> > > Does the following patch help?
> > > 
> > > 							Thanx, Paul
> > 
> > Paul,
> > 
> > This patch does not help.  I see the same dmesg output and failure to
> > hibernate.
> 
> Thank you for testing it.  Does the following (untested, might not even
> build) patch help?  (Or feel free to wait until I have done some testing
> on it.)
> 
> 							Thanx, Paul

Still didn't help.  If it helps, when I attempt to reboot after trying
to hibernate I see a kworker thread hung and get the stack trace below
from that thread.  I assume this is the same thread that is holding up
the hibernate.

Oct 24 14:26:46 lappy-486 kernel: [  240.479810] INFO: task kworker/1:0:16 blocked for more than 120 seconds.
Oct 24 14:26:46 lappy-486 kernel: [  240.479815]       Tainted: G E  3.18.0-rc1+ #78
Oct 24 14:26:46 lappy-486 kernel: [  240.479816] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 24 14:26:46 lappy-486 kernel: [  240.479818] kworker/1:0     D ffff88021f254600     0    16      2 0x00000000
Oct 24 14:26:46 lappy-486 kernel: [  240.479827] Workqueue: usb_hub_wq hub_event
Oct 24 14:26:46 lappy-486 kernel: [  240.479829]  ffff880213a93908 0000000000000046 ffff880213a83200 ffff880213a93fd8
Oct 24 14:26:46 lappy-486 kernel: [  240.479831]  0000000000014600 0000000000014600 ffff88021357e400 ffff880213a83200
Oct 24 14:26:46 lappy-486 kernel: [  240.479834]  0000000000014600 ffffffff81c58a10 ffffffff81c58a18 7fffffffffffffff
Oct 24 14:26:46 lappy-486 kernel: [  240.479836] Call Trace:
Oct 24 14:26:46 lappy-486 kernel: [  240.479843]  [<ffffffff8174d919>] schedule+0x29/0x70
Oct 24 14:26:46 lappy-486 kernel: [  240.479846]  [<ffffffff8175091c>] schedule_timeout+0x20c/0x280
Oct 24 14:26:46 lappy-486 kernel: [  240.479851]  [<ffffffff81097bbd>] ?  check_preempt_curr+0x8d/0xa0
Oct 24 14:26:46 lappy-486 kernel: [  240.479854]  [<ffffffff81097bed>] ?  ttwu_do_wakeup+0x1d/0xd0
Oct 24 14:26:46 lappy-486 kernel: [  240.479857]  [<ffffffff8174e616>] wait_for_completion+0xa6/0x160
Oct 24 14:26:46 lappy-486 kernel: [  240.479860]  [<ffffffff8109abb0>] ?  wake_up_state+0x20/0x20
Oct 24 14:26:46 lappy-486 kernel: [  240.479863]  [<ffffffff810ce267>] _rcu_barrier+0x157/0x200
Oct 24 14:26:46 lappy-486 kernel: [  240.479865]  [<ffffffff810ce365>] rcu_barrier+0x15/0x20
Oct 24 14:26:46 lappy-486 kernel: [  240.479870]  [<ffffffff816632f0>] netdev_run_todo+0x60/0x300
Oct 24 14:26:46 lappy-486 kernel: [  240.479874]  [<ffffffff8166ddee>] rtnl_unlock+0xe/0x10
Oct 24 14:26:46 lappy-486 kernel: [  240.479877]  [<ffffffff8165d3c5>] unregister_netdev+0x25/0x30
Oct 24 14:26:46 lappy-486 kernel: [  240.479883]  [<ffffffffa05b9768>] usbnet_disconnect+0x48/0xf0 [usbnet]
Oct 24 14:26:46 lappy-486 kernel: [  240.479888]  [<ffffffff81577a28>] usb_unbind_interface+0x1f8/0x2c0
Oct 24 14:26:46 lappy-486 kernel: [  240.479893]  [<ffffffff814c90e6>] ?  rpm_idle+0xd6/0x2b0
Oct 24 14:26:46 lappy-486 kernel: [  240.479898]  [<ffffffff814bf3cf>] __device_release_driver+0x7f/0xf0
Oct 24 14:26:46 lappy-486 kernel: [  240.479901]  [<ffffffff814bf463>] device_release_driver+0x23/0x30
Oct 24 14:26:46 lappy-486 kernel: [  240.479904]  [<ffffffff814bed58>] bus_remove_device+0x108/0x180
Oct 24 14:26:46 lappy-486 kernel: [  240.479907]  [<ffffffff814bb4d9>] device_del+0x129/0x1e0
Oct 24 14:26:46 lappy-486 kernel: [  240.479910]  [<ffffffff81575140>] usb_disable_device+0xb0/0x290
Oct 24 14:26:46 lappy-486 kernel: [  240.479913]  [<ffffffff8156a554>] usb_disconnect+0x94/0x2c0
Oct 24 14:26:46 lappy-486 kernel: [  240.479915]  [<ffffffff8156cbe4>] hub_event+0x994/0x1500
Oct 24 14:26:46 lappy-486 kernel: [  240.479919]  [<ffffffff810a4c5e>] ?  dequeue_task_fair+0x44e/0x660
Oct 24 14:26:46 lappy-486 kernel: [  240.479924]  [<ffffffff81088280>] process_one_work+0x150/0x3f0
Oct 24 14:26:46 lappy-486 kernel: [  240.479927]  [<ffffffff81088971>] worker_thread+0x121/0x520
Oct 24 14:26:46 lappy-486 kernel: [  240.479930]  [<ffffffff81088850>] ?  rescuer_thread+0x330/0x330
Oct 24 14:26:46 lappy-486 kernel: [  240.479932]  [<ffffffff8108d942>] kthread+0xd2/0xf0
Oct 24 14:26:46 lappy-486 kernel: [  240.479935]  [<ffffffff8108d870>] ?  kthread_create_on_node+0x180/0x180
Oct 24 14:26:46 lappy-486 kernel: [  240.479939]  [<ffffffff81751ffc>] ret_from_fork+0x7c/0xb0
Oct 24 14:26:46 lappy-486 kernel: [  240.479941]  [<ffffffff8108d870>] ?  kthread_create_on_node+0x180/0x180

Eric

> 
> ------------------------------------------------------------------------
> 
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 29fb23f33c18..927c17b081c7 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -2546,9 +2546,13 @@ static void rcu_spawn_one_nocb_kthread(struct rcu_state *rsp, int cpu)
>  			rdp->nocb_leader = rdp_spawn;
>  			if (rdp_last && rdp != rdp_spawn)
>  				rdp_last->nocb_next_follower = rdp;
> -			rdp_last = rdp;
> -			rdp = rdp->nocb_next_follower;
> -			rdp_last->nocb_next_follower = NULL;
> +			if (rdp == rdp_spawn) {
> +				rdp = rdp->nocb_next_follower;
> +			} else {
> +				rdp_last = rdp;
> +				rdp = rdp->nocb_next_follower;
> +				rdp_last->nocb_next_follower = NULL;
> +			}
>  		} while (rdp);
>  		rdp_spawn->nocb_next_follower = rdp_old_leader;
>  	}
> 
