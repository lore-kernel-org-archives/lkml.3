Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaGJXb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 19:31:56 -0400
Received: from mail.ispras.ru ([83.149.199.45]:33572 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaGJXbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 19:31:55 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: gdm724x: fix leak at failure path in init_usb()
Date: Thu, 10 Jul 2014 19:31:41 -0400
Message-Id: <1405035101-6864-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an allocation in init_usb() failed, it returns without
deallocation of already allocated resources.

The patch fix it and replaces GFP_ATOMIC by GFP_KERNEL in
alloc_tx_sdu_struct() and alloc_rx_struct() as long as
they are called from probe only.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/gdm724x/gdm_usb.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_usb.c b/drivers/staging/gdm724x/gdm_usb.c
index ee6e40facca7..ea89d530ff3f 100644
--- a/drivers/staging/gdm724x/gdm_usb.c
+++ b/drivers/staging/gdm724x/gdm_usb.c
@@ -125,11 +125,11 @@ static struct usb_tx_sdu *alloc_tx_sdu_struct(void)
 {
 	struct usb_tx_sdu *t_sdu;
 
-	t_sdu = kzalloc(sizeof(struct usb_tx_sdu), GFP_ATOMIC);
+	t_sdu = kzalloc(sizeof(struct usb_tx_sdu), GFP_KERNEL);
 	if (!t_sdu)
 		return NULL;
 
-	t_sdu->buf = kmalloc(SDU_BUF_SIZE, GFP_ATOMIC);
+	t_sdu->buf = kmalloc(SDU_BUF_SIZE, GFP_KERNEL);
 	if (!t_sdu->buf) {
 		kfree(t_sdu);
 		return NULL;
@@ -183,14 +183,14 @@ static struct usb_rx *alloc_rx_struct(void)
 	struct usb_rx *r = NULL;
 	int ret = 0;
 
-	r = kmalloc(sizeof(struct usb_rx), GFP_ATOMIC);
+	r = kmalloc(sizeof(struct usb_rx), GFP_KERNEL);
 	if (!r) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	r->urb = usb_alloc_urb(0, GFP_ATOMIC);
-	r->buf = kmalloc(RX_BUF_SIZE, GFP_ATOMIC);
+	r->urb = usb_alloc_urb(0, GFP_KERNEL);
+	r->buf = kmalloc(RX_BUF_SIZE, GFP_KERNEL);
 	if (!r->urb || !r->buf) {
 		ret = -ENOMEM;
 		goto out;
@@ -366,6 +366,7 @@ static int init_usb(struct lte_udev *udev)
 	INIT_DELAYED_WORK(&udev->work_rx, do_rx);
 	return 0;
 fail:
+	release_usb(udev);
 	return ret;
 }
 
-- 
1.9.1

