Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3BCPYX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:24:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34100 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753681Ab3BCOy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:54:59 -0500
Message-Id: <20130203144645.450407552@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:00 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Bing Zhao <bzhao@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 016/128] mwifiex: check wait_event_interruptible return value
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -53,7 +53,6 @@ int mwifiex_copy_mcast_addr(struct mwifi
  */
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
-	bool cancel_flag = false;
 	int status;
 	struct cmd_ctrl_node *cmd_queued;
 
@@ -70,14 +69,11 @@ int mwifiex_wait_queue_complete(struct m
 	queue_work(adapter->workqueue, &adapter->main_work);
 
 	/* Wait for completion */
-	wait_event_interruptible(adapter->cmd_wait_q.wait,
-					*(cmd_queued->condition));
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
@@ -427,8 +423,11 @@ int mwifiex_enable_hs(struct mwifiex_ada
 		return false;
 	}
 
-	wait_event_interruptible(adapter->hs_activate_wait_q,
-			adapter->hs_activate_wait_q_woken);
+	if (wait_event_interruptible(adapter->hs_activate_wait_q,
+				     adapter->hs_activate_wait_q_woken)) {
+		dev_err(adapter->dev, "hs_activate_wait_q terminated\n");
+		return false;
+	}
 
 	return true;
 }


