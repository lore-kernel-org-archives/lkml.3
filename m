Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaGPVNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:13:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:59780 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaGPVEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:47 -0400
Message-Id: <20140716205055.407490656@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Eli Cohen <eli@mellanox.com>
Subject: [patch V2 38/64] net: mlx5: Use ktime_get_ns()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=net-mlx5-remove-silly-timespec-dance.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is beyond silly:

     struct timespec ts = ktime_get_ts();
     ktime_t ktime = timespec_to_ktime(ts);

Further down the code builds the delta of two ktime_t values and
converts the result to nanoseconds.

Use ktime_get_ns() and replace all the nonsense.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Eli Cohen <eli@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   16 ++++------------
 include/linux/mlx5/driver.h                   |    4 ++--
 2 files changed, 6 insertions(+), 14 deletions(-)

Index: tip/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
===================================================================
--- tip.orig/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ tip/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -548,7 +548,7 @@ static void cmd_work_handler(struct work
 	lay->status_own = CMD_OWNER_HW;
 	set_signature(ent, !cmd->checksum_disabled);
 	dump_command(dev, ent, 1);
-	ktime_get_ts(&ent->ts1);
+	ent->ts1 = ktime_get_ns();
 
 	/* ring doorbell after the descriptor is valid */
 	wmb();
@@ -637,7 +637,6 @@ static int mlx5_cmd_invoke(struct mlx5_c
 {
 	struct mlx5_cmd *cmd = &dev->cmd;
 	struct mlx5_cmd_work_ent *ent;
-	ktime_t t1, t2, delta;
 	struct mlx5_cmd_stats *stats;
 	int err = 0;
 	s64 ds;
@@ -668,10 +667,7 @@ static int mlx5_cmd_invoke(struct mlx5_c
 		if (err == -ETIMEDOUT)
 			goto out;
 
-		t1 = timespec_to_ktime(ent->ts1);
-		t2 = timespec_to_ktime(ent->ts2);
-		delta = ktime_sub(t2, t1);
-		ds = ktime_to_ns(delta);
+		ds = ent->ts2 - ent->ts1;
 		op = be16_to_cpu(((struct mlx5_inbox_hdr *)in->first.data)->opcode);
 		if (op < ARRAY_SIZE(cmd->stats)) {
 			stats = &cmd->stats[op];
@@ -1135,7 +1131,6 @@ void mlx5_cmd_comp_handler(struct mlx5_c
 	void *context;
 	int err;
 	int i;
-	ktime_t t1, t2, delta;
 	s64 ds;
 	struct mlx5_cmd_stats *stats;
 	unsigned long flags;
@@ -1149,7 +1144,7 @@ void mlx5_cmd_comp_handler(struct mlx5_c
 				sem = &cmd->pages_sem;
 			else
 				sem = &cmd->sem;
-			ktime_get_ts(&ent->ts2);
+			ent->ts2 = ktime_get_ns();
 			memcpy(ent->out->first.data, ent->lay->out, sizeof(ent->lay->out));
 			dump_command(dev, ent, 0);
 			if (!ent->ret) {
@@ -1163,10 +1158,7 @@ void mlx5_cmd_comp_handler(struct mlx5_c
 			}
 			free_ent(cmd, ent->idx);
 			if (ent->callback) {
-				t1 = timespec_to_ktime(ent->ts1);
-				t2 = timespec_to_ktime(ent->ts2);
-				delta = ktime_sub(t2, t1);
-				ds = ktime_to_ns(delta);
+				ds = ent->ts2 - ent->ts1;
 				if (ent->op < ARRAY_SIZE(cmd->stats)) {
 					stats = &cmd->stats[ent->op];
 					spin_lock_irqsave(&stats->lock, flags);
Index: tip/include/linux/mlx5/driver.h
===================================================================
--- tip.orig/include/linux/mlx5/driver.h
+++ tip/include/linux/mlx5/driver.h
@@ -604,8 +604,8 @@ struct mlx5_cmd_work_ent {
 	int			page_queue;
 	u8			status;
 	u8			token;
-	struct timespec		ts1;
-	struct timespec		ts2;
+	u64			ts1;
+	u64			ts2;
 	u16			op;
 };
 


