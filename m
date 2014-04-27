Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaD0Oh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 10:37:56 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:54471 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751854AbaD0OgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 10:36:09 -0400
Message-Id: <20140427143608.311663750@goodmis.org>
User-Agent: quilt/0.61-1
Date: Sun, 27 Apr 2014 10:35:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        <stable-rt@vger.kernel.org>, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH RT 1/4] net: sched: dev_deactivate_many(): use msleep(1) instead of yield()
 to wait for outstanding qdisc_run calls
References: <20140427143558.300461400@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-net-sched-dev_deactivate_many-use-msleep-1-instead-o.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4.82-rt103-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

On PREEMPT_RT enabled systems the interrupt handler run as threads at prio 50
(by default). If a high priority userspace process tries to shut down a busy
network interface it might spin in a yield loop waiting for the device to
become idle. With the interrupt thread having a lower priority than the
looping process it might never be scheduled and so result in a deadlock on UP
systems.

With Magic SysRq the following backtrace can be produced:

> test_app R running      0   174    168 0x00000000
> [<c02c7070>] (__schedule+0x220/0x3fc) from [<c02c7870>] (preempt_schedule_irq+0x48/0x80)
> [<c02c7870>] (preempt_schedule_irq+0x48/0x80) from [<c0008fa8>] (svc_preempt+0x8/0x20)
> [<c0008fa8>] (svc_preempt+0x8/0x20) from [<c001a984>] (local_bh_enable+0x18/0x88)
> [<c001a984>] (local_bh_enable+0x18/0x88) from [<c025316c>] (dev_deactivate_many+0x220/0x264)
> [<c025316c>] (dev_deactivate_many+0x220/0x264) from [<c023be04>] (__dev_close_many+0x64/0xd4)
> [<c023be04>] (__dev_close_many+0x64/0xd4) from [<c023be9c>] (__dev_close+0x28/0x3c)
> [<c023be9c>] (__dev_close+0x28/0x3c) from [<c023f7f0>] (__dev_change_flags+0x88/0x130)
> [<c023f7f0>] (__dev_change_flags+0x88/0x130) from [<c023f904>] (dev_change_flags+0x10/0x48)
> [<c023f904>] (dev_change_flags+0x10/0x48) from [<c024c140>] (do_setlink+0x370/0x7ec)
> [<c024c140>] (do_setlink+0x370/0x7ec) from [<c024d2f0>] (rtnl_newlink+0x2b4/0x450)
> [<c024d2f0>] (rtnl_newlink+0x2b4/0x450) from [<c024cfa0>] (rtnetlink_rcv_msg+0x158/0x1f4)
> [<c024cfa0>] (rtnetlink_rcv_msg+0x158/0x1f4) from [<c0256740>] (netlink_rcv_skb+0xac/0xc0)
> [<c0256740>] (netlink_rcv_skb+0xac/0xc0) from [<c024bbd8>] (rtnetlink_rcv+0x18/0x24)
> [<c024bbd8>] (rtnetlink_rcv+0x18/0x24) from [<c02561b8>] (netlink_unicast+0x13c/0x198)
> [<c02561b8>] (netlink_unicast+0x13c/0x198) from [<c025651c>] (netlink_sendmsg+0x264/0x2e0)
> [<c025651c>] (netlink_sendmsg+0x264/0x2e0) from [<c022af98>] (sock_sendmsg+0x78/0x98)
> [<c022af98>] (sock_sendmsg+0x78/0x98) from [<c022bb50>] (___sys_sendmsg.part.25+0x268/0x278)
> [<c022bb50>] (___sys_sendmsg.part.25+0x268/0x278) from [<c022cf08>] (__sys_sendmsg+0x48/0x78)
> [<c022cf08>] (__sys_sendmsg+0x48/0x78) from [<c0009320>] (ret_fast_syscall+0x0/0x2c)

This patch works around the problem by replacing yield() by msleep(1), giving
the interrupt thread time to finish, similar to other changes contained in the
rt patch set. Using wait_for_completion() instead would probably be a better
solution.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/sched/sch_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 67fc573..455d21a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -848,7 +848,7 @@ void dev_deactivate_many(struct list_head *head)
 	/* Wait for outstanding qdisc_run calls. */
 	list_for_each_entry(dev, head, unreg_list)
 		while (some_qdisc_is_busy(dev))
-			yield();
+			msleep(1);
 }
 
 void dev_deactivate(struct net_device *dev)
-- 
1.8.5.3


