Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3DWHP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:15:58 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29110 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab3DWHP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:15:57 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <tom.vaden@hp.com>, "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] driver,usb: Fix a warning in uhci-hcd driver
Date: Tue, 23 Apr 2013 15:15:01 +0800
Message-Id: <1366701301-16603-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>

This patch is trying to fix bug QXCR1001261767.
On some HP platform, when usb driver inits the iLo Virtual USB Controller, there may be a warning "Controller not stopped yet!". It is because driver does not wait enough time.
This patch adds more time waiting and retries.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/usb/host/uhci-hcd.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 4a86b63..514e9d7 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -277,6 +277,9 @@ static int global_suspend_mode_is_broken(struct uhci_hcd *uhci)
 		uhci->global_suspend_mode_is_broken(uhci) : 0;
 }
 
+#define UHCI_SUSPENDRH_RETRY_MAX      10
+#define UHCI_SUSPENDRH_RETRY_DELAY    100
+
 static void suspend_rh(struct uhci_hcd *uhci, enum uhci_rh_state new_state)
 __releases(uhci->lock)
 __acquires(uhci->lock)
@@ -284,6 +287,7 @@ __acquires(uhci->lock)
 	int auto_stop;
 	int int_enable, egsm_enable, wakeup_enable;
 	struct usb_device *rhdev = uhci_to_hcd(uhci)->self.root_hub;
+	u16 try, stopped;
 
 	auto_stop = (new_state == UHCI_RH_AUTO_STOPPED);
 	dev_dbg(&rhdev->dev, "%s%s\n", __func__,
@@ -355,7 +359,17 @@ __acquires(uhci->lock)
 		if (uhci->dead)
 			return;
 	}
-	if (!(uhci_readw(uhci, USBSTS) & USBSTS_HCH))
+
+	for (try = 0; try < UHCI_SUSPENDRH_RETRY_MAX; try++) {
+		/*
+		 * Sometimes we may need to wait more time and try again.
+		 */
+		stopped = uhci_readw(uhci, USBSTS) & USBSTS_HCH;
+		if (stopped)
+			break;
+		udelay(UHCI_SUSPENDRH_RETRY_DELAY);
+	}
+	if (!stopped)
 		dev_warn(uhci_dev(uhci), "Controller not stopped yet!\n");
 
 	uhci_get_current_frame_number(uhci);
-- 
1.7.10.4

