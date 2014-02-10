Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbaBJCX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:23:29 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39719 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaBJCXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:23:25 -0500
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
Subject: [PATCH 12/24] Bluetooth: Refactor deferred setup test in rfcomm_dlc_close()
Date: Sun,  9 Feb 2014 20:59:12 -0500
Message-Id: <1391997564-1805-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
References: <1391997564-1805-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for directly closing dlc if the RFCOMM session has not
yet been started; refactor the deferred setup test for only those
dlc states to which the test applies. Retains functional
equivalence.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/bluetooth/rfcomm/core.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index b5a3785..797b7e1 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -442,11 +442,18 @@ static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 	switch (d->state) {
 	case BT_CONNECT:
 	case BT_CONFIG:
+	case BT_OPEN:
+	case BT_CONNECT2:
 		if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
 			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
 			rfcomm_schedule();
-			break;
+			return 0;
 		}
+	}
+
+	switch (d->state) {
+	case BT_CONNECT:
+	case BT_CONFIG:
 		/* Fall through */
 
 	case BT_CONNECTED:
@@ -460,15 +467,6 @@ static int __rfcomm_dlc_close(struct rfcomm_dlc *d, int err)
 		}
 		break;
 
-	case BT_OPEN:
-	case BT_CONNECT2:
-		if (test_and_clear_bit(RFCOMM_DEFER_SETUP, &d->flags)) {
-			set_bit(RFCOMM_AUTH_REJECT, &d->flags);
-			rfcomm_schedule();
-			break;
-		}
-		/* Fall through */
-
 	default:
 		rfcomm_dlc_clear_timer(d);
 
-- 
1.8.1.2

