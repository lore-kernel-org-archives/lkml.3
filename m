Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935047Ab3GSCXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:23:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934874Ab3GSCXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:23:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 04/18] usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed
Date: Thu, 18 Jul 2013 19:23:19 -0700
Message-Id: <20130719021049.265966328@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719021048.965829361@linuxfoundation.org>
References: <20130719021048.965829361@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>

commit d68c277b501889b3a50c179d1c3d704db7947b83 upstream.

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

Signed-off-by: UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_mass_storage.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -513,6 +513,7 @@ static int fsg_set_halt(struct fsg_dev *
 /* Caller must hold fsg->lock */
 static void wakeup_thread(struct fsg_common *common)
 {
+	smp_wmb();	/* ensure the write of bh->state is complete */
 	/* Tell the main thread that something has happened */
 	common->thread_wakeup_needed = 1;
 	if (common->thread_task)
@@ -730,6 +731,7 @@ static int sleep_thread(struct fsg_commo
 	}
 	__set_current_state(TASK_RUNNING);
 	common->thread_wakeup_needed = 0;
+	smp_rmb();	/* ensure the latest bh->state is visible */
 	return rc;
 }
 


