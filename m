Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030210AbaFXQj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:39:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbaFXPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:53:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 3.10 36/52] USB: cdc-acm: fix runtime PM imbalance at shutdown
Date: Tue, 24 Jun 2014 11:50:51 -0400
Message-Id: <20140624154715.623916335@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154713.428945460@linuxfoundation.org>
References: <20140624154713.428945460@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/class/cdc-acm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -604,12 +604,13 @@ static void acm_port_shutdown(struct tty
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
@@ -627,7 +628,8 @@ static void acm_port_shutdown(struct tty
 		for (i = 0; i < acm->rx_buflimit; i++)
 			usb_kill_urb(acm->read_urbs[i]);
 		acm->control->needs_remote_wakeup = 0;
-		usb_autopm_put_interface(acm->control);
+		if (!pm_err)
+			usb_autopm_put_interface(acm->control);
 	}
 	mutex_unlock(&acm->mutex);
 }


