Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbaF3Mwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:52:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751982AbaF3MaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 148/181] Target/iser: Bail from accept_np if np_thread is trying to close
Date: Mon, 30 Jun 2014 13:52:49 +0200
Message-Id: <8293eeec3e774d15ab8f64ba06aaac7c16d868b4.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e346ab343f4f58c12a96725c7b13df9cc2ad56f6 upstream.

In case np_thread state is in RESET/SHUTDOWN/EXIT states,
no point for isert to stall there as we may get a hang in
case no one will wake it up later.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8645d19f7710..c09d2f0cae49 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2633,9 +2633,14 @@ accept_wait:
 		return -ENODEV;
 
 	spin_lock_bh(&np->np_thread_lock);
-	if (np->np_thread_state == ISCSI_NP_THREAD_RESET) {
+	if (np->np_thread_state >= ISCSI_NP_THREAD_RESET) {
 		spin_unlock_bh(&np->np_thread_lock);
-		pr_debug("ISCSI_NP_THREAD_RESET for isert_accept_np\n");
+		pr_debug("np_thread_state %d for isert_accept_np\n",
+			 np->np_thread_state);
+		/**
+		 * No point in stalling here when np_thread
+		 * is in state RESET/SHUTDOWN/EXIT - bail
+		 **/
 		return -ENODEV;
 	}
 	spin_unlock_bh(&np->np_thread_lock);
-- 
2.0.0

