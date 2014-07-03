Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030692AbaGCJgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:36:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030474AbaGCJYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 166/198] USB: cdc-acm: fix runtime PM imbalance at shutdown
Date: Thu,  3 Jul 2014 10:20:09 +0100
Message-Id: <1404379241-8590-167-git-send-email-luis.henriques@canonical.com>
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

commit 5292afa657d0e790b7479ad8eef9450c1e040b3d upstream.

Make sure only to decrement the PM counters if they were actually
incremented.

Note that the USB PM counter, but not necessarily the driver core PM
counter, is reset when the interface is unbound.

Fixes: 11ea859d64b6 ("USB: additional power savings for cdc-acm devices
that support remote wakeup")

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/class/cdc-acm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 83a19ae3c31c..a72b7f1f6e17 100644
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
1.9.1

