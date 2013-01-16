Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab3APRAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:00:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab3APQBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:01:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 058/222] mlx4_core: Fix potential deadlock in mlx4_eq_int()
Date: Wed, 16 Jan 2013 13:54:18 -0200
Message-Id: <1358351822-7675-59-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit 311f813a2daefcba03f706a692fe0c67888d7622 upstream.

The slave_state_lock spinlock is used in both interrupt context and
process context, hence irq locking must be used.  Found by lockdep.

Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    9 +++++----
 drivers/net/ethernet/mellanox/mlx4/eq.c  |   10 ++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 842c8ce..92e7057 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -1256,6 +1256,7 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 	u32 reply;
 	u8 is_going_down = 0;
 	int i;
+	unsigned long flags;
 
 	slave_state[slave].comm_toggle ^= 1;
 	reply = (u32) slave_state[slave].comm_toggle << 31;
@@ -1330,12 +1331,12 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 		mlx4_warn(dev, "Bad comm cmd:%d from slave:%d\n", cmd, slave);
 		goto reset_slave;
 	}
-	spin_lock(&priv->mfunc.master.slave_state_lock);
+	spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 	if (!slave_state[slave].is_slave_going_down)
 		slave_state[slave].last_cmd = cmd;
 	else
 		is_going_down = 1;
-	spin_unlock(&priv->mfunc.master.slave_state_lock);
+	spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 	if (is_going_down) {
 		mlx4_warn(dev, "Slave is going down aborting command(%d)"
 			  " executing from slave:%d\n",
@@ -1351,10 +1352,10 @@ static void mlx4_master_do_cmd(struct mlx4_dev *dev, int slave, u8 cmd,
 reset_slave:
 	/* cleanup any slave resources */
 	mlx4_delete_all_resources_for_slave(dev, slave);
-	spin_lock(&priv->mfunc.master.slave_state_lock);
+	spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 	if (!slave_state[slave].is_slave_going_down)
 		slave_state[slave].last_cmd = MLX4_COMM_CMD_RESET;
-	spin_unlock(&priv->mfunc.master.slave_state_lock);
+	spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 	/*with slave in the middle of flr, no need to clean resources again.*/
 inform_slave_state:
 	memset(&slave_state[slave].event_eq, 0,
diff --git a/drivers/net/ethernet/mellanox/mlx4/eq.c b/drivers/net/ethernet/mellanox/mlx4/eq.c
index bce98d9..aa7b7c3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/eq.c
@@ -203,6 +203,7 @@ void mlx4_master_handle_slave_flr(struct work_struct *work)
 	struct mlx4_slave_state *slave_state = priv->mfunc.master.slave_state;
 	int i;
 	int err;
+	unsigned long flags;
 
 	mlx4_dbg(dev, "mlx4_handle_slave_flr\n");
 
@@ -214,10 +215,10 @@ void mlx4_master_handle_slave_flr(struct work_struct *work)
 
 			mlx4_delete_all_resources_for_slave(dev, i);
 			/*return the slave to running mode*/
-			spin_lock(&priv->mfunc.master.slave_state_lock);
+			spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 			slave_state[i].last_cmd = MLX4_COMM_CMD_RESET;
 			slave_state[i].is_slave_going_down = 0;
-			spin_unlock(&priv->mfunc.master.slave_state_lock);
+			spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 			/*notify the FW:*/
 			err = mlx4_cmd(dev, 0, i, 0, MLX4_CMD_INFORM_FLR_DONE,
 				       MLX4_CMD_TIME_CLASS_A, MLX4_CMD_WRAPPED);
@@ -241,6 +242,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 	u32 flr_slave;
 	u8 update_slave_state;
 	int i;
+	unsigned long flags;
 
 	while ((eqe = next_eqe_sw(eq))) {
 		/*
@@ -434,13 +436,13 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
 			} else
 				update_slave_state = 1;
 
-			spin_lock(&priv->mfunc.master.slave_state_lock);
+			spin_lock_irqsave(&priv->mfunc.master.slave_state_lock, flags);
 			if (update_slave_state) {
 				priv->mfunc.master.slave_state[flr_slave].active = false;
 				priv->mfunc.master.slave_state[flr_slave].last_cmd = MLX4_COMM_CMD_FLR;
 				priv->mfunc.master.slave_state[flr_slave].is_slave_going_down = 1;
 			}
-			spin_unlock(&priv->mfunc.master.slave_state_lock);
+			spin_unlock_irqrestore(&priv->mfunc.master.slave_state_lock, flags);
 			queue_work(priv->mfunc.master.comm_wq,
 				   &priv->mfunc.master.slave_flr_event_work);
 			break;
-- 
1.7.9.5

