Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab3K0Mvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:51:54 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52384 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3K0Mvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:51:51 -0500
Date: Wed, 27 Nov 2013 13:51:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>
Subject: hci_h4p from linux-n900 branch: fix with new bluetooth for 3.13-rc1
Message-ID: <20131127125149.GA9389@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d18adf907651766c97eedae993f14c6e042914a6
Author: Pavel <pavel@ucw.cz>
Date:   Wed Nov 27 13:43:40 2013 +0100

Fix compilation of hci_h4p after bluetooth core changes. Only compile tested.
    
Signed-off-by: Pavel Machek <pavel@ucw.cz>

--

When you update to 3.13-rc1, you'll likely need this one.

(And good news is that it boots with that kernel, and video seems to work.)

index 7ed9d4e..dac3875 100644
--- a/drivers/bluetooth/hci_h4p/core.c
+++ b/drivers/bluetooth/hci_h4p/core.c
@@ -405,7 +405,7 @@ static inline void hci_h4p_recv_frame(struct hci_h4p_info *info,
 		}
 		hci_h4p_parse_fw_event(info, skb);
 	} else {
-		hci_recv_frame(skb);
+		hci_recv_frame(info->hdev, skb);
 		NBT_DBG("Frame sent to upper layer\n");
 	}
 }
@@ -789,10 +789,9 @@ static int hci_h4p_hci_close(struct hci_dev *hdev)
 	return 0;
 }
 
-static int hci_h4p_hci_send_frame(struct sk_buff *skb)
+static int hci_h4p_hci_send_frame(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct hci_h4p_info *info;
-	struct hci_dev *hdev = (struct hci_dev *)skb->dev;
 	int err = 0;
 	unsigned long flags;
 
@@ -841,12 +840,6 @@ static int hci_h4p_hci_send_frame(struct sk_buff *skb)
 	return 0;
 }
 
-static int hci_h4p_hci_ioctl(struct hci_dev *hdev, unsigned int cmd,
-			     unsigned long arg)
-{
-	return -ENOIOCTLCMD;
-}
-
 static int hci_h4p_register_hdev(struct hci_h4p_info *info)
 {
 	struct hci_dev *hdev;
@@ -867,7 +860,6 @@ static int hci_h4p_register_hdev(struct hci_h4p_info *info)
 	hdev->close = hci_h4p_hci_close;
 	hdev->flush = hci_h4p_hci_flush;
 	hdev->send = hci_h4p_hci_send_frame;
-	hdev->ioctl = hci_h4p_hci_ioctl;
 	set_bit(HCI_QUIRK_RESET_ON_CLOSE, &hdev->quirks);
 
 	SET_HCIDEV_DEV(hdev, info->dev);
diff --git a/drivers/bluetooth/hci_h4p/fw-csr.c b/drivers/bluetooth/hci_h4p/fw-csr.c
index af880d9..020fa52 100644
--- a/drivers/bluetooth/hci_h4p/fw-csr.c
+++ b/drivers/bluetooth/hci_h4p/fw-csr.c
@@ -31,7 +31,7 @@ void hci_h4p_bc4_parse_fw_event(struct hci_h4p_info *info, struct sk_buff *skb)
 {
 	/* Check if this is fw packet */
 	if (skb->data[0] != 0xff) {
-		hci_recv_frame(skb);
+		hci_recv_frame(info->hdev, skb);
 		return;
 	}
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
