Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967627Ab3HICNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:13:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967619Ab3HIB7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Adam Lee <adam.lee@canonical.com>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Subject: [ 052/102] Bluetooth: fix wrong use of PTR_ERR() in btusb
Date: Thu,  8 Aug 2013 18:57:28 -0700
Message-Id: <20130809015022.277252585@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Lee <adam8157@gmail.com>

commit d9c78e9738ccd0017b10b8f44462aafb61904a4a upstream.

PTR_ERR() returns a signed long type value which is limited by IS_ERR(),
it must be a negative number whose range is [-MAX_ERRNO, 0).

The bug here returns negative numbers as error codes, then check it by
"if (ret < 0)", but -PTR_ERR() is actually positive. The wrong use here
leads to failure as below, even panic.

[   12.958920] Bluetooth: hci0 command 0xfc8e tx timeout
[   14.961765] Bluetooth: hci0 command 0xfc8e tx timeout
[   16.964688] Bluetooth: hci0 command 0xfc8e tx timeout
[   20.954501] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   22.957358] Bluetooth: hci0 command 0xfc8e tx timeout
[   30.948922] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   32.951780] Bluetooth: hci0 command 0xfc8e tx timeout
[   40.943359] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   42.946219] Bluetooth: hci0 command 0xfc8e tx timeout
[   50.937812] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   52.940670] Bluetooth: hci0 command 0xfc8e tx timeout
[   60.932236] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   62.935092] Bluetooth: hci0 command 0xfc8e tx timeout
[   70.926688] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   72.929545] Bluetooth: hci0 command 0xfc8e tx timeout
[   80.921111] Bluetooth: hci0 sending Intel patch command (0xfc8e) failed (-110)
[   82.923969] Bluetooth: hci0 command 0xfc2f tx timeout
[   90.915542] Bluetooth: hci0 sending Intel patch command (0xfc2f) failed (-110)
[   92.918406] Bluetooth: hci0 command 0xfc11 tx timeout
[  100.909955] Bluetooth: hci0 sending Intel patch command (0xfc11) failed (-110)
[  102.912858] Bluetooth: hci0 command 0xfc60 tx timeout
[  110.904394] Bluetooth: hci0 sending Intel patch command (0xfc60) failed (-110)
[  112.907293] Bluetooth: hci0 command 0xfc11 tx timeout
[  120.898831] Bluetooth: hci0 exiting Intel manufacturer mode failed (-110)
[  120.904757] bluetoothd[1030]: segfault at 4 ip 00007f8b2eb55236 sp 00007fff53ff6920 error 4 in bluetoothd[7f8b2eaff000+cb000]

Signed-off-by: Adam Lee <adam.lee@canonical.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1099,7 +1099,7 @@ static int btusb_setup_intel_patching(st
 	if (IS_ERR(skb)) {
 		BT_ERR("%s sending Intel patch command (0x%4.4x) failed (%ld)",
 		       hdev->name, cmd->opcode, PTR_ERR(skb));
-		return -PTR_ERR(skb);
+		return PTR_ERR(skb);
 	}
 
 	/* It ensures that the returned event matches the event data read from
@@ -1151,7 +1151,7 @@ static int btusb_setup_intel(struct hci_
 	if (IS_ERR(skb)) {
 		BT_ERR("%s sending initial HCI reset command failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
-		return -PTR_ERR(skb);
+		return PTR_ERR(skb);
 	}
 	kfree_skb(skb);
 
@@ -1165,7 +1165,7 @@ static int btusb_setup_intel(struct hci_
 	if (IS_ERR(skb)) {
 		BT_ERR("%s reading Intel fw version command failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
-		return -PTR_ERR(skb);
+		return PTR_ERR(skb);
 	}
 
 	if (skb->len != sizeof(*ver)) {
@@ -1223,7 +1223,7 @@ static int btusb_setup_intel(struct hci_
 		BT_ERR("%s entering Intel manufacturer mode failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
 		release_firmware(fw);
-		return -PTR_ERR(skb);
+		return PTR_ERR(skb);
 	}
 
 	if (skb->data[0]) {
@@ -1280,7 +1280,7 @@ static int btusb_setup_intel(struct hci_
 	if (IS_ERR(skb)) {
 		BT_ERR("%s exiting Intel manufacturer mode failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
-		return -PTR_ERR(skb);
+		return PTR_ERR(skb);
 	}
 	kfree_skb(skb);
 
@@ -1296,7 +1296,7 @@ exit_mfg_disable:
 	if (IS_ERR(skb)) {
 		BT_ERR("%s exiting Intel manufacturer mode failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
-		return -PTR_ERR(skb);
+		return PTR_ERR(skb);
 	}
 	kfree_skb(skb);
 
@@ -1314,7 +1314,7 @@ exit_mfg_deactivate:
 	if (IS_ERR(skb)) {
 		BT_ERR("%s exiting Intel manufacturer mode failed (%ld)",
 		       hdev->name, PTR_ERR(skb));
-		return -PTR_ERR(skb);
+		return PTR_ERR(skb);
 	}
 	kfree_skb(skb);
 


