Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbaBEUFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:05:32 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48135 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaBEUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:27 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Neil Horman <nhorman@tuxdriver.com>, David Miller <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 066/213] drop_monitor: prevent init path from scheduling on the wrong cpu
Date: Wed, 5 Feb 2014 15:00:21 -0500
Message-ID: <1391630568-49251-67-git-send-email-paul.gortmaker@windriver.com>
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

commit 4fdcfa12843bca38d0c9deff70c8720e4e8f515f upstream.

I just noticed after some recent updates, that the init path for the drop
monitor protocol has a minor error.  drop monitor maintains a per cpu structure,
that gets initalized from a single cpu.  Normally this is fine, as the protocol
isn't in use yet, but I recently made a change that causes a failed skb
allocation to reschedule itself .  Given the current code, the implication is
that this workqueue reschedule will take place on the wrong cpu.  If drop
monitor is used early during the boot process, its possible that two cpus will
access a single per-cpu structure in parallel, possibly leading to data
corruption.

This patch fixes the situation, by storing the cpu number that a given instance
of this per-cpu data should be accessed from.  In the case of a need for a
reschedule, the cpu stored in the struct is assigned the rescheule, rather than
the currently executing cpu

Tested successfully by myself.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
CC: David Miller <davem@davemloft.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/core/drop_monitor.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 0b8aba761930..58c57fcc67ad 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -49,6 +49,7 @@ struct per_cpu_dm_data {
 	struct sk_buff /* __rcu <-- only 2.6.37+ */ *skb;
 	atomic_t dm_hit_count;
 	struct timer_list send_timer;
+	int cpu;
 };
 
 struct dm_hw_stat_delta {
@@ -73,7 +74,6 @@ static int dm_hit_limit = 64;
 static int dm_delay = 1;
 static unsigned long dm_hw_check_delta = 2*HZ;
 static LIST_HEAD(hw_stats_list);
-static int initialized = 0;
 
 static void reset_per_cpu_data(struct per_cpu_dm_data *data)
 {
@@ -96,8 +96,8 @@ static void reset_per_cpu_data(struct per_cpu_dm_data *data)
 				  sizeof(struct net_dm_alert_msg));
 		msg = nla_data(nla);
 		memset(msg, 0, al);
-	} else if (initialized)
-		schedule_work_on(smp_processor_id(), &data->dm_alert_work);
+	} else
+		schedule_work_on(data->cpu, &data->dm_alert_work);
 
 	/*
 	 * Don't need to lock this, since we are guaranteed to only
@@ -121,6 +121,8 @@ static void send_dm_alert(struct work_struct *unused)
 	struct sk_buff *skb;
 	struct per_cpu_dm_data *data = &get_cpu_var(dm_cpu_data);
 
+	WARN_ON_ONCE(data->cpu != smp_processor_id());
+
 	/*
 	 * Grab the skb we're about to send
 	 */
@@ -414,14 +416,14 @@ static int __init init_net_drop_monitor(void)
 
 	for_each_present_cpu(cpu) {
 		data = &per_cpu(dm_cpu_data, cpu);
-		reset_per_cpu_data(data);
+		data->cpu = cpu;
 		INIT_WORK(&data->dm_alert_work, send_dm_alert);
 		init_timer(&data->send_timer);
 		data->send_timer.data = cpu;
 		data->send_timer.function = sched_send_work;
+		reset_per_cpu_data(data);
 	}
 
-	initialized = 1;
 
 	goto out;
 
-- 
1.8.5.2

