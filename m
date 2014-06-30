Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaF3MXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:23:41 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51925 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752568AbaF3LxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 063/181] USB: cdc-acm: fix potential urb leak and PM imbalance in write
Date: Mon, 30 Jun 2014 13:51:24 +0200
Message-Id: <26307821d8781367b154e5dadea8c42ccb4d1ff1.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 183a45087d126d126e8dd1d9b2602fc129dff9ad upstream.

Make sure to check return value of autopm get in write() in order to
avoid urb leak and PM counter imbalance on errors.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ae4d028b4209..6774bf165083 100644
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
2.0.0

