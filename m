Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030975AbaGCKES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:04:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51803 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbaGCJW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:28 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 070/198] USB: cdc-acm: fix potential urb leak and PM imbalance in write
Date: Thu,  3 Jul 2014 10:18:33 +0100
Message-Id: <1404379241-8590-71-git-send-email-luis.henriques@canonical.com>
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

commit 183a45087d126d126e8dd1d9b2602fc129dff9ad upstream.

Make sure to check return value of autopm get in write() in order to
avoid urb leak and PM counter imbalance on errors.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 014a1aa3f950..dc5cfa5a1118 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -654,7 +654,13 @@ static int acm_tty_write(struct tty_struct *tty,
 	memcpy(wb->buf, buf, count);
 	wb->len = count;
 
-	usb_autopm_get_interface_async(acm->control);
+	stat = usb_autopm_get_interface_async(acm->control);
+	if (stat) {
+		wb->use = 0;
+		spin_unlock_irqrestore(&acm->write_lock, flags);
+		return stat;
+	}
+
 	if (acm->susp_count) {
 		usb_anchor_urb(wb->urb, &acm->delayed);
 		spin_unlock_irqrestore(&acm->write_lock, flags);
-- 
1.9.1

