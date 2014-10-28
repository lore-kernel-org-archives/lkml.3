Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaJ1Dog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:44:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbaJ1Dob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:44:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Champion Chen <champion_chen@realsil.com.cn>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 3.16 067/127] Bluetooth: Fix issue with USB suspend in btusb driver
Date: Tue, 28 Oct 2014 11:35:02 +0800
Message-Id: <20141028033423.782989275@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Champion Chen <champion_chen@realsil.com.cn>

commit 85560c4a828ec9c8573840c9b66487b6ae584768 upstream.

Suspend could fail for some platforms because
btusb_suspend==> btusb_stop_traffic ==> usb_kill_anchored_urbs.

When btusb_bulk_complete returns before system suspend and resubmits
an URB, the system cannot enter suspend state.

Signed-off-by: Champion Chen <champion_chen@realsil.com.cn>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -317,6 +317,9 @@ static void btusb_intr_complete(struct u
 			BT_ERR("%s corrupted event packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_INTR_RUNNING, &data->flags))
@@ -405,6 +408,9 @@ static void btusb_bulk_complete(struct u
 			BT_ERR("%s corrupted ACL packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_BULK_RUNNING, &data->flags))
@@ -499,6 +505,9 @@ static void btusb_isoc_complete(struct u
 				hdev->stat.err_rx++;
 			}
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_ISOC_RUNNING, &data->flags))


