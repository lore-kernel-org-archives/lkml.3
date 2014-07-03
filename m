Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041AbaGCKRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:17:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51532 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083AbaGCJV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 028/198] Target/iser: Bail from accept_np if np_thread is trying to close
Date: Thu,  3 Jul 2014 10:17:51 +0100
Message-Id: <1404379241-8590-29-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit e346ab343f4f58c12a96725c7b13df9cc2ad56f6 upstream.

In case np_thread state is in RESET/SHUTDOWN/EXIT states,
no point for isert to stall there as we may get a hang in
case no one will wake it up later.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8bb57deb86cc..b65e0c1c931c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2310,9 +2310,14 @@ accept_wait:
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
1.9.1

