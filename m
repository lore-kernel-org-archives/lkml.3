Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab3HERlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:41:08 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:59034 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3HERk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:40:28 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 4/4] staging: ozwpan: Return correct hub status.
Date: Mon, 5 Aug 2013 18:40:15 +0100
Message-ID: <1375724415-10801-5-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug where we were not returning correct hub status
for 8th port.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b060e43..2f93a00 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -1871,17 +1871,24 @@ static int oz_hcd_hub_status_data(struct usb_hcd *hcd, char *buf)
 	int i;
 
 	buf[0] = 0;
+	buf[1] = 0;
 
 	spin_lock_bh(&ozhcd->hcd_lock);
 	for (i = 0; i < OZ_NB_PORTS; i++) {
 		if (ozhcd->ports[i].flags & OZ_PORT_F_CHANGED) {
 			oz_dbg(HUB, "Port %d changed\n", i);
 			ozhcd->ports[i].flags &= ~OZ_PORT_F_CHANGED;
-			buf[0] |= 1<<(i+1);
+			if (i < 7)
+				buf[0] |= 1 << (i+1);
+			else
+				buf[1] |= 1 << (i-7);
 		}
 	}
 	spin_unlock_bh(&ozhcd->hcd_lock);
-	return buf[0] ? 1 : 0;
+	if (buf[0] != 0 || buf[1] != 0)
+		return 2;
+	else
+		return 0;
 }
 /*------------------------------------------------------------------------------
  * Context: process
-- 
1.7.9.5

