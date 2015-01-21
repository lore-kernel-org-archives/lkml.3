Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbbAUKGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:06:31 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47999 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbAUKGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:06:25 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0LA6GPW022284, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>, Roger Tseng <rogerable@realtek.com>
Subject: [OVERWRITE] mfd: rtsx_usb: Defer autosuspend while card exists
Date: Wed, 21 Jan 2015 18:09:21 +0800
Message-ID: <1421834961-5829-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.121]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A card insertion happens after the lastest polling before reader is
suspended may never have a chance to be detected. Under current 1-HZ
polling interval setting in mmc_core, the worst case of such
undetectablility is about 1 second.

To further reduce the undetectability, detect card slot again in suspend
method and defer the autosuspend if the slot is loaded. The default 2
second autosuspend delay of USB subsystem should let the next polling
detects the card.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
---
 drivers/mfd/rtsx_usb.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 210d1f85679e..ede50244f265 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -681,9 +681,27 @@ static void rtsx_usb_disconnect(struct usb_interface *intf)
 #ifdef CONFIG_PM
 static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
 {
+	struct rtsx_ucr *ucr =
+		(struct rtsx_ucr *)usb_get_intfdata(intf);
+	u16 val = 0;
+
 	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
 			__func__, message.event);
 
+	if (PMSG_IS_AUTO(message)) {
+		if (mutex_trylock(&ucr->dev_mutex)) {
+			rtsx_usb_get_card_status(ucr, &val);
+			mutex_unlock(&ucr->dev_mutex);
+
+			/* Defer the autosuspend if card exists */
+			if (val & (SD_CD | MS_CD))
+				return -EAGAIN;
+		} else {
+			/* There is an ongoing operation*/
+			return -EAGAIN;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.1.3

