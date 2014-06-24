Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaFXPzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:55:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaFXPzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:55:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.14 44/68] USB: cdc-acm: fix potential urb leak and PM imbalance in write
Date: Tue, 24 Jun 2014 11:51:03 -0400
Message-Id: <20140624154725.923629923@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 183a45087d126d126e8dd1d9b2602fc129dff9ad upstream.

Make sure to check return value of autopm get in write() in order to
avoid urb leak and PM counter imbalance on errors.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/class/cdc-acm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -666,7 +666,13 @@ static int acm_tty_write(struct tty_stru
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


