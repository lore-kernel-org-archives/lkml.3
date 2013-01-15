Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3APAfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:35:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:41404 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619Ab3AOW2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [ 043/221] IB/mlx4: Fix spinlock order to avoid lockdep warnings
Date: Tue, 15 Jan 2013 10:49:30 -0800
Message-Id: <20130115185001.129009248@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit ceb7decb366591e9b67d70832e07f5d240572a3d upstream.

lockdep warns about taking a hard-irq-unsafe lock (sriov->id_map_lock)
inside a hard-irq-safe lock (sriov->going_down_lock).

Since id_map_lock is never taken in the interrupt context, we can
simply reverse the order of taking the two spinlocks, thus avoiding
the warning and the depencency.

Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx4/cm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -268,15 +268,15 @@ static void schedule_delayed(struct ib_d
 	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
 	unsigned long flags;
 
-	spin_lock_irqsave(&sriov->going_down_lock, flags);
 	spin_lock(&sriov->id_map_lock);
+	spin_lock_irqsave(&sriov->going_down_lock, flags);
 	/*make sure that there is no schedule inside the scheduled work.*/
 	if (!sriov->is_going_down) {
 		id->scheduled_delete = 1;
 		schedule_delayed_work(&id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 	}
-	spin_unlock(&sriov->id_map_lock);
 	spin_unlock_irqrestore(&sriov->going_down_lock, flags);
+	spin_unlock(&sriov->id_map_lock);
 }
 
 int mlx4_ib_multiplex_cm_handler(struct ib_device *ibdev, int port, int slave_id,


