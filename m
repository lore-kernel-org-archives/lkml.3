Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab3APAHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:07:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:43091 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453Ab3AOWdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 155/221] mwifiex: check wait_event_interruptible return value
Date: Tue, 15 Jan 2013 10:51:22 -0800
Message-Id: <20130115185009.240869948@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/sta_ioctl.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -56,7 +56,6 @@ int mwifiex_copy_mcast_addr(struct mwifi
  */
 int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
-	bool cancel_flag = false;
 	int status;
 	struct cmd_ctrl_node *cmd_queued;
 
@@ -70,14 +69,11 @@ int mwifiex_wait_queue_complete(struct m
 	atomic_inc(&adapter->cmd_pending);
 
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
@@ -480,8 +476,11 @@ int mwifiex_enable_hs(struct mwifiex_ada
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


