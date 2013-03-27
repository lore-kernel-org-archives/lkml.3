Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab3C0NNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:13:48 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44297 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3C0NJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 05/17] drbd: fix effective error returned when refusing an invalidate
Date: Wed, 27 Mar 2013 14:08:37 +0100
Message-Id: <1364389729-17559-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit
  drbd: Disallow the peer_disk_state to be D_OUTDATED while connected
trying to invalidate a disconnected Primary returned an error code
that did not really match the situation:
"Refusing to be Outdated while Connected"

Insert two more specific conditions into is_valid_state(),
changing that to "Need access to UpToDate data",
respectively "Need a connection to start verify or resync".

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 3bc686f..22e259f 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -570,6 +570,13 @@ is_valid_state(struct drbd_conf *mdev, union drbd_state ns)
 		  mdev->tconn->agreed_pro_version < 88)
 		rv = SS_NOT_SUPPORTED;
 
+	else if (ns.role == R_PRIMARY && ns.disk < D_UP_TO_DATE && ns.pdsk < D_UP_TO_DATE)
+		rv = SS_NO_UP_TO_DATE_DISK;
+
+	else if ((ns.conn == C_STARTING_SYNC_S || ns.conn == C_STARTING_SYNC_T) &&
+                 ns.pdsk == D_UNKNOWN)
+		rv = SS_NEED_CONNECTION;
+
 	else if (ns.conn >= C_CONNECTED && ns.pdsk == D_UNKNOWN)
 		rv = SS_CONNECTED_OUTDATES;
 
-- 
1.7.9.5

