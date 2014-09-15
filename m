Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaIOWNf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50749 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbaIOWNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chin-Ran Lo <crlo@marvell.com>, Jeff CF Chen <jeffc@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/187] Bluetooth: btmrvl: wait for HOST_SLEEP_ENABLE event in suspend
Date: Mon, 15 Sep 2014 15:07:47 -0700
Message-Id: <1410818997-9432-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chin-Ran Lo <crlo@marvell.com>

commit 396e04f4bb9afefb0744715dc76d9abe18ee5fb0 upstream.

After BT_CMD_HOST_SLEEP_ENABLE command finishes, driver should
wait until getting BT_EVENT_HOST_SLEEP_ENABLE event to complete
suspend procedure.
Without this patch the suspend handler would return success
earlier. By the time when the BT_EVENT_HOST_SLEEP_ENABLE event
comes in the controller driver could have already turned off the
bus clock. This causes kernel crash or system reboot eventually.

Signed-off-by: Chin-Ran Lo <crlo@marvell.com>
Signed-off-by: Jeff CF Chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/bluetooth/btmrvl_drv.h  |  1 +
 drivers/bluetooth/btmrvl_main.c | 25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
index f9d1833..c401de2 100644
--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -70,6 +70,7 @@ struct btmrvl_adapter {
 	u8 hs_state;
 	u8 wakeup_tries;
 	wait_queue_head_t cmd_wait_q;
+	wait_queue_head_t event_hs_wait_q;
 	u8 cmd_complete;
 	bool is_suspended;
 };
diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index 5cf31c4..245e9c7 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -115,6 +115,7 @@ int btmrvl_process_event(struct btmrvl_private *priv, struct sk_buff *skb)
 			adapter->hs_state = HS_ACTIVATED;
 			if (adapter->psmode)
 				adapter->ps_state = PS_SLEEP;
+			wake_up_interruptible(&adapter->event_hs_wait_q);
 			BT_DBG("HS ACTIVATED!");
 		} else {
 			BT_DBG("HS Enable failed");
@@ -254,11 +255,31 @@ EXPORT_SYMBOL_GPL(btmrvl_enable_ps);
 
 int btmrvl_enable_hs(struct btmrvl_private *priv)
 {
+	struct btmrvl_adapter *adapter = priv->adapter;
 	int ret;
 
 	ret = btmrvl_send_sync_cmd(priv, BT_CMD_HOST_SLEEP_ENABLE, NULL, 0);
-	if (ret)
+	if (ret) {
 		BT_ERR("Host sleep enable command failed\n");
+		return ret;
+	}
+
+	ret = wait_event_interruptible_timeout(adapter->event_hs_wait_q,
+					       adapter->hs_state,
+			msecs_to_jiffies(WAIT_UNTIL_HS_STATE_CHANGED));
+	if (ret < 0) {
+		BT_ERR("event_hs_wait_q terminated (%d): %d,%d,%d",
+		       ret, adapter->hs_state, adapter->ps_state,
+		       adapter->wakeup_tries);
+	} else if (!ret) {
+		BT_ERR("hs_enable timeout: %d,%d,%d", adapter->hs_state,
+		       adapter->ps_state, adapter->wakeup_tries);
+		ret = -ETIMEDOUT;
+	} else {
+		BT_DBG("host sleep enabled: %d,%d,%d", adapter->hs_state,
+		       adapter->ps_state, adapter->wakeup_tries);
+		ret = 0;
+	}
 
 	return ret;
 }
@@ -344,6 +365,7 @@ static void btmrvl_init_adapter(struct btmrvl_private *priv)
 	priv->adapter->ps_state = PS_AWAKE;
 
 	init_waitqueue_head(&priv->adapter->cmd_wait_q);
+	init_waitqueue_head(&priv->adapter->event_hs_wait_q);
 }
 
 static void btmrvl_free_adapter(struct btmrvl_private *priv)
@@ -716,6 +738,7 @@ int btmrvl_remove_card(struct btmrvl_private *priv)
 	hdev = priv->btmrvl_dev.hcidev;
 
 	wake_up_interruptible(&priv->adapter->cmd_wait_q);
+	wake_up_interruptible(&priv->adapter->event_hs_wait_q);
 
 	kthread_stop(priv->main_thread.task);
 
-- 
1.9.1

