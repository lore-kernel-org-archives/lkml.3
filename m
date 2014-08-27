Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935822AbaH0VVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:21:51 -0400
Received: from mail-lb0-f202.google.com ([209.85.217.202]:52900 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaH0VVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:21:50 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Baldyga <r.baldyga@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 4/5] usb: gadget: f_mass_storage: simplify start_transfer slightly
Date: Wed, 27 Aug 2014 22:58:48 +0200
Message-Id: <1409173129-19603-5-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409173129-19603-1-git-send-email-mina86@mina86.com>
References: <1409173129-19603-1-git-send-email-mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flatten the start_transfer function by reversing the if condition and
returning early out of the function if everything went fine.  It makes
the function look less complicated, at least to me, and easier to
understand.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/function/f_mass_storage.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index b963939..811929c 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -566,22 +566,22 @@ static void start_transfer(struct fsg_dev *fsg, struct usb_ep *ep,
 	*pbusy = 1;
 	*state = BUF_STATE_BUSY;
 	spin_unlock_irq(&fsg->common->lock);
+
 	rc = usb_ep_queue(ep, req, GFP_KERNEL);
-	if (rc != 0) {
-		*pbusy = 0;
-		*state = BUF_STATE_EMPTY;
+	if (rc == 0)
+		return;  /* All good, we're done */
 
-		/* We can't do much more than wait for a reset */
+	*pbusy = 0;
+	*state = BUF_STATE_EMPTY;
 
-		/*
-		 * Note: currently the net2280 driver fails zero-length
-		 * submissions if DMA is enabled.
-		 */
-		if (rc != -ESHUTDOWN &&
-		    !(rc == -EOPNOTSUPP && req->length == 0))
-			WARNING(fsg, "error in submission: %s --> %d\n",
-				ep->name, rc);
-	}
+	/* We can't do much more than wait for a reset */
+
+	/*
+	 * Note: currently the net2280 driver fails zero-length
+	 * submissions if DMA is enabled.
+	 */
+	if (rc != -ESHUTDOWN && !(rc == -EOPNOTSUPP && req->length == 0))
+		WARNING(fsg, "error in submission: %s --> %d\n", ep->name, rc);
 }
 
 static bool start_in_transfer(struct fsg_common *common, struct fsg_buffhd *bh)
@@ -3665,4 +3665,3 @@ void fsg_config_from_params(struct fsg_config *cfg,
 	cfg->fsg_num_buffers = fsg_num_buffers;
 }
 EXPORT_SYMBOL_GPL(fsg_config_from_params);
-
-- 
2.1.0.rc2.206.gedb03e5

