Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030764AbaGCKFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:05:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758405AbaGCJWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 065/198] USB: cdc-acm: fix write and suspend race
Date: Thu,  3 Jul 2014 10:18:28 +0100
Message-Id: <1404379241-8590-66-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5a345c20c17d87099224a4be12e69e5bd7023dca upstream.

Fix race between write() and suspend() which could lead to writes being
dropped (or I/O while suspended) if the device is runtime suspended
while a write request is being processed.

Specifically, suspend() releases the write_lock after determining the
device is idle but before incrementing the susp_count, thus leaving a
window where a concurrent write() can submit an urb.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8b8236fd24cf..6ebcd38dfb06 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1420,18 +1420,15 @@ static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 	struct acm *acm = usb_get_intfdata(intf);
 	int cnt;
 
+	spin_lock_irq(&acm->read_lock);
+	spin_lock(&acm->write_lock);
 	if (PMSG_IS_AUTO(message)) {
-		int b;
-
-		spin_lock_irq(&acm->write_lock);
-		b = acm->transmitting;
-		spin_unlock_irq(&acm->write_lock);
-		if (b)
+		if (acm->transmitting) {
+			spin_unlock(&acm->write_lock);
+			spin_unlock_irq(&acm->read_lock);
 			return -EBUSY;
+		}
 	}
-
-	spin_lock_irq(&acm->read_lock);
-	spin_lock(&acm->write_lock);
 	cnt = acm->susp_count++;
 	spin_unlock(&acm->write_lock);
 	spin_unlock_irq(&acm->read_lock);
-- 
1.9.1

