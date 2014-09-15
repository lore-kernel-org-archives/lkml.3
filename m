Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbaIOUtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:49:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbaIOTgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:36:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chin-Ran Lo <crlo@marvell.com>, Jeff CF Chen <jeffc@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.16 116/158] Bluetooth: btmrvl: wait for HOST_SLEEP_ENABLE event in suspend
Date: Mon, 15 Sep 2014 12:25:55 -0700
Message-Id: <20140915192546.359164235@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btmrvl_drv.h  |    1 +
 drivers/bluetooth/btmrvl_main.c |   25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btmrvl_drv.h
+++ b/drivers/bluetooth/btmrvl_drv.h
@@ -68,6 +68,7 @@ struct btmrvl_adapter {
 	u8 hs_state;
 	u8 wakeup_tries;
 	wait_queue_head_t cmd_wait_q;
+	wait_queue_head_t event_hs_wait_q;
 	u8 cmd_complete;
 	bool is_suspended;
 };
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -114,6 +114,7 @@ int btmrvl_process_event(struct btmrvl_p
 			adapter->hs_state = HS_ACTIVATED;
 			if (adapter->psmode)
 				adapter->ps_state = PS_SLEEP;
+			wake_up_interruptible(&adapter->event_hs_wait_q);
 			BT_DBG("HS ACTIVATED!");
 		} else {
 			BT_DBG("HS Enable failed");
@@ -253,11 +254,31 @@ EXPORT_SYMBOL_GPL(btmrvl_enable_ps);
 
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
@@ -358,6 +379,7 @@ static void btmrvl_init_adapter(struct b
 	}
 
 	init_waitqueue_head(&priv->adapter->cmd_wait_q);
+	init_waitqueue_head(&priv->adapter->event_hs_wait_q);
 }
 
 static void btmrvl_free_adapter(struct btmrvl_private *priv)
@@ -666,6 +688,7 @@ int btmrvl_remove_card(struct btmrvl_pri
 	hdev = priv->btmrvl_dev.hcidev;
 
 	wake_up_interruptible(&priv->adapter->cmd_wait_q);
+	wake_up_interruptible(&priv->adapter->event_hs_wait_q);
 
 	kthread_stop(priv->main_thread.task);
 


