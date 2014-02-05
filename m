Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbaBEU4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:56:46 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48154 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbaBEUFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 064/213] drop_monitor: fix sleeping in invalid context warning
Date: Wed, 5 Feb 2014 15:00:19 -0500
Message-ID: <1391630568-49251-65-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit cde2e9a651b76d8db36ae94cd0febc82b637e5dd upstream.

Eric Dumazet pointed out this warning in the drop_monitor protocol to me:

[   38.352571] BUG: sleeping function called from invalid context at kernel/mutex.c:85
[   38.352576] in_atomic(): 1, irqs_disabled(): 0, pid: 4415, name: dropwatch
[   38.352580] Pid: 4415, comm: dropwatch Not tainted 3.4.0-rc2+ #71
[   38.352582] Call Trace:
[   38.352592]  [<ffffffff8153aaf0>] ? trace_napi_poll_hit+0xd0/0xd0
[   38.352599]  [<ffffffff81063f2a>] __might_sleep+0xca/0xf0
[   38.352606]  [<ffffffff81655b16>] mutex_lock+0x26/0x50
[   38.352610]  [<ffffffff8153aaf0>] ? trace_napi_poll_hit+0xd0/0xd0
[   38.352616]  [<ffffffff810b72d9>] tracepoint_probe_register+0x29/0x90
[   38.352621]  [<ffffffff8153a585>] set_all_monitor_traces+0x105/0x170
[   38.352625]  [<ffffffff8153a8ca>] net_dm_cmd_trace+0x2a/0x40
[   38.352630]  [<ffffffff8154a81a>] genl_rcv_msg+0x21a/0x2b0
[   38.352636]  [<ffffffff810f8029>] ? zone_statistics+0x99/0xc0
[   38.352640]  [<ffffffff8154a600>] ? genl_rcv+0x30/0x30
[   38.352645]  [<ffffffff8154a059>] netlink_rcv_skb+0xa9/0xd0
[   38.352649]  [<ffffffff8154a5f0>] genl_rcv+0x20/0x30
[   38.352653]  [<ffffffff81549a7e>] netlink_unicast+0x1ae/0x1f0
[   38.352658]  [<ffffffff81549d76>] netlink_sendmsg+0x2b6/0x310
[   38.352663]  [<ffffffff8150824f>] sock_sendmsg+0x10f/0x130
[   38.352668]  [<ffffffff8150abe0>] ? move_addr_to_kernel+0x60/0xb0
[   38.352673]  [<ffffffff81515f04>] ? verify_iovec+0x64/0xe0
[   38.352677]  [<ffffffff81509c46>] __sys_sendmsg+0x386/0x390
[   38.352682]  [<ffffffff810ffaf9>] ? handle_mm_fault+0x139/0x210
[   38.352687]  [<ffffffff8165b5bc>] ? do_page_fault+0x1ec/0x4f0
[   38.352693]  [<ffffffff8106ba4d>] ? set_next_entity+0x9d/0xb0
[   38.352699]  [<ffffffff81310b49>] ? tty_ldisc_deref+0x9/0x10
[   38.352703]  [<ffffffff8106d363>] ? pick_next_task_fair+0x63/0x140
[   38.352708]  [<ffffffff8150b8d4>] sys_sendmsg+0x44/0x80
[   38.352713]  [<ffffffff8165f8e2>] system_call_fastpath+0x16/0x1b

It stems from holding a spinlock (trace_state_lock) while attempting to register
or unregister tracepoint hooks, making in_atomic() true in this context, leading
to the warning when the tracepoint calls might_sleep() while its taking a mutex.
Since we only use the trace_state_lock to prevent trace protocol state races, as
well as hardware stat list updates on an rcu write side, we can just convert the
spinlock to a mutex to avoid this problem.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/drop_monitor.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index cf208d8042b1..e596db9fefd0 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -42,7 +42,7 @@ static void send_dm_alert(struct work_struct *unused);
  * netlink alerts
  */
 static int trace_state = TRACE_OFF;
-static DEFINE_SPINLOCK(trace_state_lock);
+static DEFINE_MUTEX(trace_state_mutex);
 
 struct per_cpu_dm_data {
 	struct work_struct dm_alert_work;
@@ -221,7 +221,7 @@ static int set_all_monitor_traces(int state)
 	struct dm_hw_stat_delta *new_stat = NULL;
 	struct dm_hw_stat_delta *temp;
 
-	spin_lock(&trace_state_lock);
+	mutex_lock(&trace_state_mutex);
 
 	switch (state) {
 	case TRACE_ON:
@@ -252,7 +252,7 @@ static int set_all_monitor_traces(int state)
 	if (!rc)
 		trace_state = state;
 
-	spin_unlock(&trace_state_lock);
+	mutex_unlock(&trace_state_mutex);
 
 	if (rc)
 		return -EINPROGRESS;
@@ -297,12 +297,12 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 
 		new_stat->dev = dev;
 		new_stat->last_rx = jiffies;
-		spin_lock(&trace_state_lock);
+		mutex_lock(&trace_state_mutex);
 		list_add_rcu(&new_stat->list, &hw_stats_list);
-		spin_unlock(&trace_state_lock);
+		mutex_unlock(&trace_state_mutex);
 		break;
 	case NETDEV_UNREGISTER:
-		spin_lock(&trace_state_lock);
+		mutex_lock(&trace_state_mutex);
 		list_for_each_entry_safe(new_stat, tmp, &hw_stats_list, list) {
 			if (new_stat->dev == dev) {
 				new_stat->dev = NULL;
@@ -313,7 +313,7 @@ static int dropmon_net_event(struct notifier_block *ev_block,
 				}
 			}
 		}
-		spin_unlock(&trace_state_lock);
+		mutex_unlock(&trace_state_mutex);
 		break;
 	}
 out:
-- 
1.8.5.2

