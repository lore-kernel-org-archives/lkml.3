Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaFENa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:30:26 -0400
Received: from vegas.theobroma-systems.com ([144.76.126.164]:38772 "EHLO
	mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbaFENaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:30:25 -0400
X-Greylist: delayed 1339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2014 09:30:24 EDT
From: Marcus Nutzinger <marcus.nutzinger@theobroma-systems.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcus Nutzinger <marcus.nutzinger@theobroma-systems.com>
Subject: [PATCH] usb: gadget: gadgetfs: correct dev state
Date: Thu,  5 Jun 2014 15:08:00 +0200
Message-Id: <1401973680-18413-1-git-send-email-marcus.nutzinger@theobroma-systems.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1826e9b1 fixes the use after free of "dev".
However if this is not the final call to dev_release()
and the state is not reset to STATE_DEV_DISABLED and
hence all further open() calls to the gadgetfs ep0
device will fail with EBUSY.

So this commit reverts 1826e9b1 and places the call
put_dev() after setting the state.

Signed-off-by: Marcus Nutzinger <marcus.nutzinger@theobroma-systems.com>
Reviewed-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
---
 drivers/usb/gadget/inode.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index a925d0c..6330528 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -1264,8 +1264,13 @@ dev_release (struct inode *inode, struct file *fd)
 
 	kfree (dev->buf);
 	dev->buf = NULL;
-	put_dev (dev);
 
+	/* other endpoints were all decoupled from this device */
+	spin_lock_irq(&dev->lock);
+	dev->state = STATE_DEV_DISABLED;
+	spin_unlock_irq(&dev->lock);
+
+	put_dev (dev);
 	return 0;
 }
 
-- 
1.9.0

