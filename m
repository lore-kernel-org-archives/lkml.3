Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751690AbbAOHMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:12:34 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49428 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbbAOHMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:12:31 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0F7Bpf1016253, This message is accepted by code: ctloc85258
From: Roger Tseng <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>, <wei_wang@realsil.com.cn>,
        <micky_ching@realsil.com.cn>, Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 2/2] mfd: rtsx_usb: Defer autosuspend while card exists
Date: Thu, 15 Jan 2015 15:14:45 +0800
Message-ID: <1421306085-32254-3-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
References: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
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
 drivers/mfd/rtsx_usb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 076694126e5d..63883fd025c0 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -687,6 +687,20 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
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

