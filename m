Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaEUUJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:09:15 -0400
Received: from mout.gmx.net ([212.227.17.22]:51367 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaEUUIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:08:54 -0400
From: =?UTF-8?q?Manuel=20Sch=C3=B6lling?= <manuel.schoelling@gmx.de>
To: isdn@linux-pingi.de
Cc: manuel.schoelling@gmx.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] mISDN: Use mod_timer()
Date: Wed, 21 May 2014 22:08:48 +0200
Message-Id: <1400702928-29110-2-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1400702928-29110-1-git-send-email-manuel.schoelling@gmx.de>
References: <537CFE29.7050100@cogentembedded.com>
 <1400702928-29110-1-git-send-email-manuel.schoelling@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:FXZw8nIQM0xOhSrtUIpugcwWh37UYBGFlvzT+PCagCd4PYZVjk+
 4G5FIIQIEr40nplyreHk/5Z771hO58rjfRtD9WBHLlm+o5uWm4O6Ux1mLRApxtJa4AmbuLB
 gSoEJxp7FIWLM97RIm8spH0+UO250Q5nV+IR+rFOpO9wGlc0Vb/57hlKrKg/C2swrjOUhMK
 BDXz/Qt+MGMmURs3N5Vjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code for resetting the timer can be simplified if mod_timer() is used
instead of del_timer() followed by add_timer().

Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>
---
 drivers/isdn/mISDN/l1oip_core.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index 084f936..9f454d7 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -287,11 +287,9 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
 	p = frame;
 
 	/* restart timer */
-	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ)) {
-		del_timer(&hc->keep_tl);
-		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
-		add_timer(&hc->keep_tl);
-	} else
+	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ))
+		mod_timer(&hc->keep_tl, jiffies + L1OIP_KEEPALIVE * HZ);
+	else
 		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
 
 	if (debug & DEBUG_L1OIP_MSG)
@@ -623,9 +621,7 @@ multiframe:
 	/* restart timer */
 	if (time_before(hc->timeout_tl.expires, jiffies + 5 * HZ) || !hc->timeout_on) {
 		hc->timeout_on = 1;
-		del_timer(&hc->timeout_tl);
-		hc->timeout_tl.expires = jiffies + L1OIP_TIMEOUT * HZ;
-		add_timer(&hc->timeout_tl);
+		mod_timer(&hc->timeout_tl, jiffies + L1OIP_TIMEOUT * HZ);
 	} else /* only adjust timer */
 		hc->timeout_tl.expires = jiffies + L1OIP_TIMEOUT * HZ;
 
-- 
1.7.10.4

