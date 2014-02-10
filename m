Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaBJCWV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:22:21 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39671 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaBJCWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:22:18 -0500
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
Subject: [PATCH 01/24] Revert "Bluetooth: Remove rfcomm_carrier_raised()"
Date: Sun,  9 Feb 2014 20:59:01 -0500
Message-Id: <1391997564-1805-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f86772af6a0f643d3e13eb3f4f9213ae0c333ee4.

This is the first of a 3-patch revert, together with
Revert "Bluetooth: Always wait for a connection on RFCOMM open()" and
Revert "Bluetooth: Move rfcomm_get_device() before rfcomm_dev_activate()".

Commit 4a2fb3ecc7467c775b154813861f25a0ddc11aa0,
"Bluetooth: Always wait for a connection on RFCOMM open()" open-codes
blocking on tty open(), rather than using the default behavior
implemented by the tty port.

The reasons for reverting that patch are detailed in that changelog;
this patch restores required functionality for that revert.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index f9c0980a..aeabade 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -160,6 +160,14 @@ static int rfcomm_dev_activate(struct tty_port *port, struct tty_struct *tty)
 	return err;
 }
 
+/* we block the open until the dlc->state becomes BT_CONNECTED */
+static int rfcomm_dev_carrier_raised(struct tty_port *port)
+{
+	struct rfcomm_dev *dev = container_of(port, struct rfcomm_dev, port);
+
+	return (dev->dlc->state == BT_CONNECTED);
+}
+
 /* device-specific cleanup: close the dlc */
 static void rfcomm_dev_shutdown(struct tty_port *port)
 {
-- 
1.8.1.2

