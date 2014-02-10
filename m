Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaBJCXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:23:14 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39706 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaBJCXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:23:09 -0500
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
Subject: [PATCH 06/24] Bluetooth: Exclude released devices from RFCOMMGETDEVLIST ioctl
Date: Sun,  9 Feb 2014 20:59:06 -0500
Message-Id: <1391997564-1805-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When enumerating RFCOMM devices in the rfcomm_dev_list, holding
the rfcomm_dev_lock only guarantees the existence of the enumerated
rfcomm_dev in memory, and not safe access to its state. Testing
the device state (such as RFCOMM_TTY_RELEASED) does not guarantee
the device will remain in that state for the subsequent access
to the rfcomm_dev's fields, nor guarantee that teardown has not
commenced.

Obtain an rfcomm_dev reference for the duration of rfcomm_dev
access.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/tty.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 7cf193f..b385d99 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -468,7 +468,7 @@ static int rfcomm_get_dev_list(void __user *arg)
 	spin_lock(&rfcomm_dev_lock);
 
 	list_for_each_entry(dev, &rfcomm_dev_list, list) {
-		if (test_bit(RFCOMM_TTY_RELEASED, &dev->flags))
+		if (!tty_port_get(&dev->port))
 			continue;
 		(di + n)->id      = dev->id;
 		(di + n)->flags   = dev->flags;
@@ -476,6 +476,7 @@ static int rfcomm_get_dev_list(void __user *arg)
 		(di + n)->channel = dev->channel;
 		bacpy(&(di + n)->src, &dev->src);
 		bacpy(&(di + n)->dst, &dev->dst);
+		tty_port_put(&dev->port);
 		if (++n >= dev_num)
 			break;
 	}
-- 
1.8.1.2

