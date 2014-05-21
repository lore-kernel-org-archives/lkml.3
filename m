Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaEUTKT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 15:10:19 -0400
Received: from mout.gmx.net ([212.227.17.21]:56601 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbaEUTKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 15:10:14 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: isdn@linux-pingi.de
Cc: manuel.schoelling@gmx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mISDN: use mod_timer()
Date: Wed, 21 May 2014 21:10:06 +0200
Message-Id: <1400699406-31294-2-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400699406-31294-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400699406-31294-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:0I5xS+mpP3osStNr38edCCf5JKURSqxJnWqVBqggvKVgx9yEa+/
 XUJ+0f0cCuh2RclKgGLB3pTZGmYbdVU/qZjJng6auxQGVWy7Kh1Z0NoKmQN18YxGsbvGAm9
 UcOMNHkzvZ6Pi8PaNVEXc0gto3s/GPC1cnopMNNPf093JNWeFXacPeNLPGREjFnMGIoS1g/
 ymYCiK/ewLVN/nZpk4Ncg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code for resetting the timer can be simplified if mod_timer() is used
instead of del_timer() followed by add_timer().

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/isdn/mISDN/l1oip_core.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 1c2bc36..a4c6cc0 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -288,9 +288,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 
 	/* restart timer */
 	if (time_before(hc->keep_tl.expires - 5 * HZ, jiffies)) {
-		del_timer(&hc->keep_tl);
-		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
-		add_timer(&hc->keep_tl);
+		mod_timer(&hc->keep_tl, jiffies + L1OIP_KEEPALIVE * HZ);
 	} else
 		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
 
@@ -624,9 +622,7 @@ multiframe:
 	if (time_before(hc->timeout_tl.expires - 5 * HZ, jiffies)
 	    || !hc->timeout_on) {
 		hc->timeout_on = 1;
-		del_timer(&hc->timeout_tl);
-		hc->timeout_tl.expires = jiffies + L1OIP_TIMEOUT * HZ;
-		add_timer(&hc->timeout_tl);
+		mod_timer(&hc->timeout_tl, jiffies + L1OIP_TIMEOUT * HZ);
 	} else /* only adjust timer */
 		hc->timeout_tl.expires = jiffies + L1OIP_TIMEOUT * HZ;
 
-- 
1.7.10.4

