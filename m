Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3JHUvO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:51:14 -0400
Received: from mail.ispras.ru ([83.149.199.45]:46893 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756107Ab3JHUvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:51:09 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Won Kang <wonkang@gctsemi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH 2/2] staging: gdm7240: fix memory leak on failure path
Date: Wed,  9 Oct 2013 00:50:16 +0400
Message-Id: <1381265416-26333-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381265416-26333-1-git-send-email-khoroshilov@ispras.ru>
References: <1381265416-26333-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_usb() may fail after some of mux_rxes already allocated.
So we need to release them on the failure path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/gdm724x/gdm_mux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm724x/gdm_mux.c b/drivers/staging/gdm724x/gdm_mux.c
index 5221cf9..69813c7 100644
--- a/drivers/staging/gdm724x/gdm_mux.c
+++ b/drivers/staging/gdm724x/gdm_mux.c
@@ -541,7 +541,7 @@ static int gdm_mux_probe(struct usb_interface *intf, const struct usb_device_id
 
 	ret = init_usb(mux_dev);
 	if (ret)
-		goto err_free_tty;
+		goto err_free_usb;
 
 	tty_dev->priv_dev = (void *)mux_dev;
 	tty_dev->send_func = gdm_mux_send;
@@ -565,8 +565,8 @@ static int gdm_mux_probe(struct usb_interface *intf, const struct usb_device_id
 
 err_unregister_tty:
 	unregister_lte_tty_device(tty_dev);
+err_free_usb:
 	release_usb(mux_dev);
-err_free_tty:
 	kfree(tty_dev);
 err_free_mux:
 	kfree(mux_dev);
-- 
1.8.1.2

