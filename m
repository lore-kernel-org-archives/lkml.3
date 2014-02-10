Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaBJCXk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:23:40 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39728 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaBJCXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:23:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Gianluca Anzolin <gianluca@sottospazio.it>,
        Alexander Holler <holler@ahsoftware.de>,
        Andrey Vihrov <andrey.vihrov@gmail.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 20/24] Bluetooth: Cleanup RFCOMM device registration error handling
Date: Sun,  9 Feb 2014 20:59:20 -0500
Message-Id: <1391997564-1805-21-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If RFCOMM tty device registration fails, cleanup by releasing
the tty_port reference to trigger rfcomm_dev destruction
(rather than open-coding it).

The dlc reference release is moved into rfcomm_dev_add(),
which ensures cleanup in both error paths -- ie., if
__rfcomm_dev_add() fails or if tty_port_register_device() fails.

Fixes releasing the module reference if device registration fails.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 0537a05..375b60d 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -93,7 +93,8 @@ static void rfcomm_dev_destruct(struct tty_port *port)
 
 	rfcomm_dlc_put(dlc);
 
-	tty_unregister_device(rfcomm_tty_driver, dev->id);
+	if (dev->tty_dev)
+		tty_unregister_device(rfcomm_tty_driver, dev->id);
 
 	spin_lock(&rfcomm_dev_lock);
 	list_del(&dev->list);
@@ -317,16 +318,15 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	BT_DBG("id %d channel %d", req->dev_id, req->channel);
 
 	dev = __rfcomm_dev_add(req, dlc);
-	if (IS_ERR(dev))
+	if (IS_ERR(dev)) {
+		rfcomm_dlc_put(dlc);
 		return PTR_ERR(dev);
+	}
 
 	tty = tty_port_register_device(&dev->port, rfcomm_tty_driver,
 			dev->id, NULL);
 	if (IS_ERR(tty)) {
-		spin_lock(&rfcomm_dev_lock);
-		list_del(&dev->list);
-		spin_unlock(&rfcomm_dev_lock);
-		kfree(dev);
+		tty_port_put(&dev->port);
 		return PTR_ERR(tty);
 	}
 
@@ -420,10 +420,8 @@ static int __rfcomm_create_dev(struct sock *sk, void __user *arg)
 	}
 
 	id = rfcomm_dev_add(&req, dlc);
-	if (id < 0) {
-		rfcomm_dlc_put(dlc);
+	if (id < 0)
 		return id;
-	}
 
 	if (req.flags & (1 << RFCOMM_REUSE_DLC)) {
 		/* DLC is now used by device.
-- 
1.8.1.2

