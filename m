Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab3GKOwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:52:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42857 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573Ab3GKOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 08/98] usb: gadget: f_mass_storage: add missing memory barrier for thread_wakeup_needed
Date: Thu, 11 Jul 2013 15:23:38 +0100
Message-Id: <1373552708-15235-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/f_mass_storage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index f67b453..277bb9b 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -511,6 +511,7 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 /* Caller must hold fsg->lock */
 static void wakeup_thread(struct fsg_common *common)
 {
+	smp_wmb();	/* ensure the write of bh->state is complete */
 	/* Tell the main thread that something has happened */
 	common->thread_wakeup_needed = 1;
 	if (common->thread_task)
@@ -730,6 +731,7 @@ static int sleep_thread(struct fsg_common *common)
 	}
 	__set_current_state(TASK_RUNNING);
 	common->thread_wakeup_needed = 0;
+	smp_rmb();	/* ensure the latest bh->state is visible */
 	return rc;
 }
 
-- 
1.8.1.2

