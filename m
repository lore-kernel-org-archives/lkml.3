Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaFXPvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:51:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875AbaFXPvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:51:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.4 10/26] USB: cdc-acm: fix write and suspend race
Date: Tue, 24 Jun 2014 11:50:33 -0400
Message-Id: <20140624154619.986889275@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154619.499002156@linuxfoundation.org>
References: <20140624154619.499002156@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/class/cdc-acm.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1441,18 +1441,15 @@ static int acm_suspend(struct usb_interf
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


