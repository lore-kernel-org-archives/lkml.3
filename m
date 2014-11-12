Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966771AbaKLCFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:05:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43119 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaKLCFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:05:25 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAC25N8j029948, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 3/3] r8152: check RTL8152_UNPLUG and netif_running before autoresume
Date: Wed, 12 Nov 2014 10:05:05 +0800
Message-ID: <1394712342-15778-94-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-91-Taiwan-albertk@realtek.com>
References: <1394712342-15778-79-Taiwan-albertk@realtek.com>
 <1394712342-15778-91-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is unplugged or !netif_running(), the workqueue
doesn't need to wake the device, and could return directly.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ad9dd7d..0a30fd3 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2857,15 +2857,18 @@ static void rtl_work_func_t(struct work_struct *work)
 {
 	struct r8152 *tp = container_of(work, struct r8152, schedule.work);
 
+	/* If the device is unplugged or !netif_running(), the workqueue
+	 * doesn't need to wake the device, and could return directly.
+	 */
+	if (test_bit(RTL8152_UNPLUG, &tp->flags) || !netif_running(tp->netdev))
+		return;
+
 	if (usb_autopm_get_interface(tp->intf) < 0)
 		return;
 
 	if (!test_bit(WORK_ENABLE, &tp->flags))
 		goto out1;
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		goto out1;
-
 	if (!mutex_trylock(&tp->control)) {
 		schedule_delayed_work(&tp->schedule, 0);
 		goto out1;
-- 
1.9.3

