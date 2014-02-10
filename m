Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbaBJCYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:24:43 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39721 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbaBJCX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:23:28 -0500
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
Subject: [PATCH 21/24] Bluetooth: Force -EIO from tty read/write if .activate() fails
Date: Sun,  9 Feb 2014 20:59:21 -0500
Message-Id: <1391997564-1805-22-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rfcomm_dlc_open() fails, set tty into error state which returns
-EIO from reads and writes.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 375b60d..f6b9f0c 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -111,8 +111,12 @@ static void rfcomm_dev_destruct(struct tty_port *port)
 static int rfcomm_dev_activate(struct tty_port *port, struct tty_struct *tty)
 {
 	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
+	int err;
 
-	return rfcomm_dlc_open(dev->dlc, &dev->src, &dev->dst, dev->channel);
+	err = rfcomm_dlc_open(dev->dlc, &dev->src, &dev->dst, dev->channel);
+	if (err)
+		set_bit(TTY_IO_ERROR, &tty->flags);
+	return err;
 }
 
 /* we block the open until the dlc->state becomes BT_CONNECTED */
-- 
1.8.1.2

