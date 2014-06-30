Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaF3MWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:22:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51932 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <jhovold@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 065/181] USB: cdc-acm: fix runtime PM imbalance at shutdown
Date: Mon, 30 Jun 2014 13:51:26 +0200
Message-Id: <31f1aa154ff793028bc7dc57372c476cea061022.1404128998.git.jslaby@suse.cz>
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

commit 5292afa657d0e790b7479ad8eef9450c1e040b3d upstream.

Make sure only to decrement the PM counters if they were actually
incremented.

Note that the USB PM counter, but not necessarily the driver core PM
counter, is reset when the interface is unbound.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/class/cdc-acm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index ebbe89f60f7b..669836ae53e0 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -575,12 +575,13 @@ static void acm_port_shutdown(struct tty_port *port)
 	struct urb *urb;
 	struct acm_wb *wb;
 	int i;
+	int pm_err;
 
 	dev_dbg(&acm->control->dev, "%s\n", __func__);
 
 	mutex_lock(&acm->mutex);
 	if (!acm->disconnected) {
-		usb_autopm_get_interface(acm->control);
+		pm_err = usb_autopm_get_interface(acm->control);
 		acm_set_control(acm, acm->ctrlout = 0);
 
 		for (;;) {
@@ -598,7 +599,8 @@ static void acm_port_shutdown(struct tty_port *port)
 		for (i = 0; i < acm->rx_buflimit; i++)
 			usb_kill_urb(acm->read_urbs[i]);
 		acm->control->needs_remote_wakeup = 0;
-		usb_autopm_put_interface(acm->control);
+		if (!pm_err)
+			usb_autopm_put_interface(acm->control);
 	}
 	mutex_unlock(&acm->mutex);
 }
-- 
2.0.0

