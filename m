Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaJ0S7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:59:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52434 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaJ0S5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:57:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Champion Chen <champion_chen@realsil.com.cn>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Marcel Holtmann <marcel@holtmann.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 013/105] Bluetooth: Fix issue with USB suspend in btusb driver
Date: Mon, 27 Oct 2014 11:55:48 -0700
Message-Id: <1414436240-13879-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/bluetooth/btusb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3980fd1..f3cd23d 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -305,6 +305,9 @@ static void btusb_intr_complete(struct urb *urb)
 			BT_ERR("%s corrupted event packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_INTR_RUNNING, &data->flags))
@@ -393,6 +396,9 @@ static void btusb_bulk_complete(struct urb *urb)
 			BT_ERR("%s corrupted ACL packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_BULK_RUNNING, &data->flags))
@@ -487,6 +493,9 @@ static void btusb_isoc_complete(struct urb *urb)
 				hdev->stat.err_rx++;
 			}
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_ISOC_RUNNING, &data->flags))
-- 
1.9.1

