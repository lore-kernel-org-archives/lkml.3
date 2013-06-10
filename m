Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3FJT3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 15:29:39 -0400
Received: from mail.ispras.ru ([83.149.199.45]:41307 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab3FJT3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 15:29:38 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] staging: ft1000: fix memory leak on error path in ft1000_probe()
Date: Mon, 10 Jun 2013 23:29:16 +0400
Message-Id: <1370892556-14503-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ft1000dev->tx_urb and ft1000dev->rx_urb are not deallocated
if something goes wrong in ft1000_probe(). Also there is no
check for success of urb allocation. The patch fixes the both issues.

By the way, there is no sense in GFP_ATOMIC for urb allocation here,
so it is changed to GFP_KERNEL.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 614db55..29a7cd2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -79,8 +79,12 @@ static int ft1000_probe(struct usb_interface *interface,
 	ft1000dev->dev = dev;
 	ft1000dev->status = 0;
 	ft1000dev->net = NULL;
-	ft1000dev->tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
-	ft1000dev->rx_urb = usb_alloc_urb(0, GFP_ATOMIC);
+	ft1000dev->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
+	ft1000dev->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!ft1000dev->tx_urb || !ft1000dev->rx_urb) {
+		ret = -ENOMEM;
+		goto err_fw;
+	}
 
 	DEBUG("ft1000_probe is called\n");
 	numaltsetting = interface->num_altsetting;
@@ -209,6 +213,8 @@ err_thread:
 err_load:
 	kfree(pFileStart);
 err_fw:
+	usb_free_urb(ft1000dev->rx_urb);
+	usb_free_urb(ft1000dev->tx_urb);
 	kfree(ft1000dev);
 	return ret;
 }
-- 
1.8.1.2

