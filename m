Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbaLLGrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:47:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51789 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758857AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Champion Chen" <champion_chen@realsil.com.cn>,
        "Larry Finger" <Larry.Finger@lwfinger.net>,
        "Marcel Holtmann" <marcel@holtmann.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.935583998@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 005/164] Bluetooth: Fix issue with USB suspend in
 btusb driver
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/btusb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -305,6 +305,9 @@ static void btusb_intr_complete(struct u
 			BT_ERR("%s corrupted event packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_INTR_RUNNING, &data->flags))
@@ -392,6 +395,9 @@ static void btusb_bulk_complete(struct u
 			BT_ERR("%s corrupted ACL packet", hdev->name);
 			hdev->stat.err_rx++;
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_BULK_RUNNING, &data->flags))
@@ -485,6 +491,9 @@ static void btusb_isoc_complete(struct u
 				hdev->stat.err_rx++;
 			}
 		}
+	} else if (urb->status == -ENOENT) {
+		/* Avoid suspend failed when usb_kill_urb */
+		return;
 	}
 
 	if (!test_bit(BTUSB_ISOC_RUNNING, &data->flags))

