Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaHJQfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 12:35:34 -0400
Received: from mail.ispras.ru ([83.149.199.45]:55080 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaHJQfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 12:35:33 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] USB: dbgp gadget: fix use after free in dbgp_unbind()
Date: Sun, 10 Aug 2014 23:35:11 +0700
Message-Id: <1407688511-30063-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After dbgp_bind()-dbgp_unbind() cycle happens, static variable dbgp
contains pointers to already deallocated memory (dbgp.serial and dbgp.req).
If the next dbgp_bind() fails, for example in usb_ep_alloc_request(),
dbgp_bind() calls dbgp_unbind() on failure path,
and dbgp_unbind() frees dbgp.serial that still stores a pointer
to already deallocated memory.

The patch sets pointers to NULL in dbgp_unbind().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/gadget/legacy/dbgp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/legacy/dbgp.c b/drivers/usb/gadget/legacy/dbgp.c
index 986fc511a2ed..225e385a6160 100644
--- a/drivers/usb/gadget/legacy/dbgp.c
+++ b/drivers/usb/gadget/legacy/dbgp.c
@@ -222,10 +222,12 @@ static void dbgp_unbind(struct usb_gadget *gadget)
 {
 #ifdef CONFIG_USB_G_DBGP_SERIAL
 	kfree(dbgp.serial);
+	dbgp.serial = NULL;
 #endif
 	if (dbgp.req) {
 		kfree(dbgp.req->buf);
 		usb_ep_free_request(gadget->ep0, dbgp.req);
+		dbgp.req = NULL;
 	}
 
 	gadget->ep0->driver_data = NULL;
-- 
1.9.1

