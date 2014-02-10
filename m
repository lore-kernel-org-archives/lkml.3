Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaBJCUf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:20:35 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39597 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaBJCU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:20:27 -0500
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
Subject: [PATCH 13/24] Bluetooth: Refactor dlc disconnect logic in rfcomm_dlc_close()
Date: Sun,  9 Feb 2014 20:59:13 -0500
Message-Id: <1391997564-1805-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for directly closing dlc if the RFCOMM session has not
yet been started; refactor the dlc disconnect logic into a separate
local function, __rfcomm_dlc_disconn(). Retains functional
equivalence.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/core.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 797b7e1..88f0edc 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -430,6 +430,20 @@ int rfcomm_dlc_open(struct rfcomm_dlc *d, bdaddr_t *src, bdaddr_t *dst, u8 chann
 	return r;
 }
 
+static void __rfcomm_dlc_disconn(struct rfcomm_dlc *d)
+{
+	struct rfcomm_session *s = d->session;
+
+	d->state = BT_DISCONN;
+	if (skb_queue_empty(&d->tx_queue)) {
+		rfcomm_send_disc(s, d->dlci);
+		rfcomm_dlc_set_timer(d, RFCOMM_DISC_TIMEOUT);
+	} else {
+		rfcomm_queue_disc(d);
+		rfcomm_dlc_set_timer(d, RFCOMM_DISC_TIMEOUT * 2);
+	}
+}
+
 static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 {
 	struct rfcomm_session *s = d->session;
@@ -457,14 +471,7 @@ static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 		/* Fall through */
 
 	case BT_CONNECTED:
-		d->state = BT_DISCONN;
-		if (skb_queue_empty(&d->tx_queue)) {
-			rfcomm_send_disc(s, d->dlci);
-			rfcomm_dlc_set_timer(d, RFCOMM_DISC_TIMEOUT);
-		} else {
-			rfcomm_queue_disc(d);
-			rfcomm_dlc_set_timer(d, RFCOMM_DISC_TIMEOUT * 2);
-		}
+		__rfcomm_dlc_disconn(d);
 		break;
 
 	default:
-- 
1.8.1.2

