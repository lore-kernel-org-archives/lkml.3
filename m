Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaLOPCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:02:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38496 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaLOO14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 063/168] Bluetooth: Fix crash in the Marvell driver initialization codepath
Date: Mon, 15 Dec 2014 14:25:17 +0000
Message-Id: <1418653622-21105-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatol Pomozov <anatol.pomozov@gmail.com>

commit 8500d791c458ccbbb3e2d3fa9a0320ffd5729069 upstream.

btmrvl_add_card() function calls kthread_run that might return error
(e.g. if current thread is killed). If one tries to use the error
value as a pointer then invalid memory access oops happens.

Check kthread_run() return value, if it is an error then release resources
correctly.

TEST=boot computer with BT modules enabled. I see the error message that
BT device initialization failed. Now kernel does not crash. Hint: to enable
BT run 'rmmod btmrvl_sdio; modprobe btmrvl_sdio'

Signed-off-by: Anatol Pomozov <anatol.pomozov@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/bluetooth/btmrvl_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index 3ecba5c979bd..ae0b48471ffc 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -667,12 +667,17 @@ struct btmrvl_private *btmrvl_add_card(void *card)
 	init_waitqueue_head(&priv->main_thread.wait_q);
 	priv->main_thread.task = kthread_run(btmrvl_service_main_thread,
 				&priv->main_thread, "btmrvl_main_service");
+	if (IS_ERR(priv->main_thread.task))
+		goto err_thread;
 
 	priv->btmrvl_dev.card = card;
 	priv->btmrvl_dev.tx_dnld_rdy = true;
 
 	return priv;
 
+err_thread:
+	btmrvl_free_adapter(priv);
+
 err_adapter:
 	kfree(priv);
 
-- 
2.1.3

