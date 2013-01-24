Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3AXD3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:29:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44191 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab3AXD2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:49 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 18/74] mwifiex: check wait_event_interruptible return value
Date: Thu, 24 Jan 2013 01:26:30 -0200
Message-Id: <1358998046-613-19-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 9c969d8ccb1e17bd20742f4ac9f00c1a64487234 upstream.

wait_event_interruptible function returns -ERESTARTSYS if it's
interrupted by a signal. Driver should check the return value
and handle this case properly.

In mwifiex_wait_queue_complete() routine, as we are now checking
wait_event_interruptible return value, the condition check is not
required. Also, we have removed mwifiex_cancel_pending_ioctl()
call to avoid a chance of sending second command to FW by other path
as soon as we clear current command node. FW can not handle two
commands simultaneously.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 106c449..a5db9f1 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -53,7 +53,6 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
  */
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
-	bool cancel_flag = false;
 	int status;
 	struct cmd_ctrl_node *cmd_queued;
 
@@ -70,14 +69,11 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 	queue_work(adapter->workqueue, &adapter->main_work);
 
 	/* Wait for completion */
-	wait_event_interruptible(adapter->cmd_wait_q.wait,
-				 *(cmd_queued->condition));
-	if (!*(cmd_queued->condition))
-		cancel_flag = true;
-
-	if (cancel_flag) {
-		mwifiex_cancel_pending_ioctl(adapter);
-		dev_dbg(adapter->dev, "cmd cancel\n");
+	status = wait_event_interruptible(adapter->cmd_wait_q.wait,
+					  *(cmd_queued->condition));
+	if (status) {
+		dev_err(adapter->dev, "cmd_wait_q terminated: %d\n", status);
+		return status;
 	}
 
 	status = adapter->cmd_wait_q.status;
@@ -430,8 +426,11 @@ int mwifiex_enable_hs(struct mwifiex_adapter *adapter)
 		return false;
 	}
 
-	wait_event_interruptible(adapter->hs_activate_wait_q,
-				 adapter->hs_activate_wait_q_woken);
+	if (wait_event_interruptible(adapter->hs_activate_wait_q,
+				     adapter->hs_activate_wait_q_woken)) {
+		dev_err(adapter->dev, "hs_activate_wait_q terminated\n");
+		return false;
+	}
 
 	return true;
 }
-- 
1.7.9.5

