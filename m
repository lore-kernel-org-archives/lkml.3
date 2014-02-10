Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaBJCYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:24:11 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39730 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbaBJCXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:23:40 -0500
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
Subject: [PATCH 19/24] Bluetooth: Refactor rfcomm_dev_add()
Date: Sun,  9 Feb 2014 20:59:19 -0500
Message-Id: <1391997564-1805-20-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move rfcomm_dev allocation and initialization into new function,
__rfcomm_dev_add(), to simplify resource release in error handling.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index ef27695..0537a05 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -208,17 +208,16 @@ static ssize_t show_channel(struct device *tty_dev, struct device_attribute *att
 static DEVICE_ATTR(address, S_IRUGO, show_address, NULL);
 static DEVICE_ATTR(channel, S_IRUGO, show_channel, NULL);
 
-static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
+static struct rfcomm_dev *__rfcomm_dev_add(struct rfcomm_dev_req *req,
+					   struct rfcomm_dlc *dlc)
 {
 	struct rfcomm_dev *dev, *entry;
 	struct list_head *head = &rfcomm_dev_list;
 	int err = 0;
 
-	BT_DBG("id %d channel %d", req->dev_id, req->channel);
-
 	dev = kzalloc(sizeof(struct rfcomm_dev), GFP_KERNEL);
 	if (!dev)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	spin_lock(&rfcomm_dev_lock);
 
@@ -301,22 +300,37 @@ static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
 	   holds reference to this module. */
 	__module_get(THIS_MODULE);
 
+	spin_unlock(&rfcomm_dev_lock);
+	return dev;
+
 out:
 	spin_unlock(&rfcomm_dev_lock);
+	kfree(dev);
+	return ERR_PTR(err);
+}
 
-	if (err < 0)
-		goto free;
+static int rfcomm_dev_add(struct rfcomm_dev_req *req, struct rfcomm_dlc *dlc)
+{
+	struct rfcomm_dev *dev;
+	struct device *tty;
+
+	BT_DBG("id %d channel %d", req->dev_id, req->channel);
 
-	dev->tty_dev = tty_port_register_device(&dev->port, rfcomm_tty_driver,
+	dev = __rfcomm_dev_add(req, dlc);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+
+	tty = tty_port_register_device(&dev->port, rfcomm_tty_driver,
 			dev->id, NULL);
-	if (IS_ERR(dev->tty_dev)) {
-		err = PTR_ERR(dev->tty_dev);
+	if (IS_ERR(tty)) {
 		spin_lock(&rfcomm_dev_lock);
 		list_del(&dev->list);
 		spin_unlock(&rfcomm_dev_lock);
-		goto free;
+		kfree(dev);
+		return PTR_ERR(tty);
 	}
 
+	dev->tty_dev = tty;
 	rfcomm_reparent_device(dev);
 	dev_set_drvdata(dev->tty_dev, dev);
 
@@ -327,10 +341,6 @@ out:
 		BT_ERR("Failed to create channel attribute");
 
 	return dev->id;
-
-free:
-	kfree(dev);
-	return err;
 }
 
 /* ---- Send buffer ---- */
-- 
1.8.1.2

