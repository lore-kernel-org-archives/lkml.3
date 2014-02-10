Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaBJCWc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:22:32 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39678 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaBJCW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:22:27 -0500
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
Subject: [PATCH 16/24] Bluetooth: Fix RFCOMM parent device for reused dlc
Date: Sun,  9 Feb 2014 20:59:16 -0500
Message-Id: <1391997564-1805-17-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RFCOMM tty device is parented to the acl link device when
the dlc state_change(BT_CONNECTED) notification is received.
However, if the dlc from the RFCOMM socket is being reused
(RFCOMM_REUSE_DLC is set), then the dlc may already be connected,
and no notification will occur.

Instead, always parent the RFCOMM tty device to the acl link
device at registration time. If the acl link device is not available
(eg, because the dlc is not connected) then the tty will remain
unparented until the BT_CONNECTED notification is received.

Fixes regression with ModemManager when the rfcomm device is
created with the flag RFCOMM_REUSE_DLC.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 2975bc4..fa1226f 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -316,6 +316,7 @@ out:
 		goto free;
 	}
 
+	rfcomm_reparent_device(dev);
 	dev_set_drvdata(dev->tty_dev, dev);
 
 	if (device_create_file(dev->tty_dev, &dev_attr_address) < 0)
-- 
1.8.1.2

