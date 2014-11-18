Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098AbaKRPYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:24:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbaKROJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anatol Pomozov <anatol.pomozov@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 029/206] Bluetooth: Fix crash in the Marvell driver initialization codepath
Date: Tue, 18 Nov 2014 15:06:24 +0100
Message-Id: <bf0736629bf30132d5429c118e4b6e5a856ddd0a.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anatol Pomozov <anatol.pomozov@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/bluetooth/btmrvl_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
index 9a9f51875df5..5592b71f3dae 100644
--- a/drivers/bluetooth/btmrvl_main.c
+++ b/drivers/bluetooth/btmrvl_main.c
@@ -628,12 +628,17 @@ struct btmrvl_private *btmrvl_add_card(void *card)
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

