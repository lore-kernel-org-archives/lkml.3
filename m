Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaBJCXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:23:18 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39712 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaBJCXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:23:15 -0500
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
Subject: [PATCH 09/24] Bluetooth: Fix RFCOMM tty teardown race
Date: Sun,  9 Feb 2014 20:59:09 -0500
Message-Id: <1391997564-1805-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFCOMM tty device teardown can race with new tty device registration
for the same device id:

CPU 0                           | CPU 1
rfcomm_dev_add                  | rfcomm_dev_destruct
                                |   spin_lock
                                |   list_del   <== dev_id no longer used
                                |   spin_unlock
  spin_lock                     |     .
  [search rfcomm_dev_list]      |     .
  [dev_id not in use]           |     .
  [initialize new rfcomm_dev]   |     .
  spin_unlock                   |     .
                                |     .
  tty_port_register_device      |   tty_unregister_device

Don't remove rfcomm_dev from the device list until after tty device
unregistration has completed.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index bb570d9..6ea08b0 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -84,10 +84,6 @@ static void rfcomm_dev_destruct(struct tty_port *port)
 
 	BT_DBG("dev %p dlc %p", dev, dlc);
 
-	spin_lock(&rfcomm_dev_lock);
-	list_del(&dev->list);
-	spin_unlock(&rfcomm_dev_lock);
-
 	rfcomm_dlc_lock(dlc);
 	/* Detach DLC if it's owned by this dev */
 	if (dlc->owner == dev)
@@ -98,6 +94,10 @@ static void rfcomm_dev_destruct(struct tty_port *port)
 
 	tty_unregister_device(rfcomm_tty_driver, dev->id);
 
+	spin_lock(&rfcomm_dev_lock);
+	list_del(&dev->list);
+	spin_unlock(&rfcomm_dev_lock);
+
 	kfree(dev);
 
 	/* It's safe to call module_put() here because socket still
-- 
1.8.1.2

