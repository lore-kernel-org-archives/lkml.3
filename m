Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab3EWCQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 22:16:19 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:43098 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab3EWCQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 22:16:17 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 May 2013 22:16:17 EDT
Date: Thu, 23 May 2013 11:10:11 +0900 (JST)
Message-Id: <20130523.111011.203250975.satoshi.uchino@toshiba.co.jp>
To: balbi@ti.com, linux-usb@vger.kernel.org
Cc: mina86@mina86.com, stern@rowland.harvard.edu, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v2] usb: gadget: f_mass_storage: add missing memory
 barrier for thread_wakeup_needed
From: UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>
X-Mailer: Mew version 6.4 on Emacs 22.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this memory barrier, the file-storage thread may fail to
escape from the following while loop, because it may observe new
common->thread_wakeup_needed and old bh->state which are updated by
the callback functions.

	/* Wait for the CBW to arrive */
	while (bh->state != BUF_STATE_FULL) {
		rc = sleep_thread(common);
		if (rc)
			return rc;
	}

Cc: stable@vger.kernel.org
Signed-off-by: UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
Resending with revised to and cc list and Acked-by line.
Cf. http://marc.info/?l=linux-usb&m=136361467905630&w=2

 drivers/usb/gadget/f_mass_storage.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 97666e8..c35a9ec 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -413,6 +413,7 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 /* Caller must hold fsg->lock */
 static void wakeup_thread(struct fsg_common *common)
 {
+	smp_wmb();	/* ensure the write of bh->state is complete */
 	/* Tell the main thread that something has happened */
 	common->thread_wakeup_needed = 1;
 	if (common->thread_task)
@@ -632,6 +633,7 @@ static int sleep_thread(struct fsg_common *common)
 	}
 	__set_current_state(TASK_RUNNING);
 	common->thread_wakeup_needed = 0;
+	smp_rmb();	/* ensure the latest bh->state is visible */
 	return rc;
 }
 
-- 
1.7.4.1

