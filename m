Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3GXOGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:06:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45838 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286Ab3GXOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:38 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felipe Balbi" <balbi@ti.com>,
        "UCHINO Satoshi" <satoshi.uchino@toshiba.co.jp>,
        "Michal Nazarewicz" <mina86@mina86.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.299006147@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [14/85] usb: gadget: f_mass_storage: add missing memory barrier
 for thread_wakeup_needed
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/f_mass_storage.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -512,6 +512,7 @@ static int fsg_set_halt(struct fsg_dev *
 /* Caller must hold fsg->lock */
 static void wakeup_thread(struct fsg_common *common)
 {
+	smp_wmb();	/* ensure the write of bh->state is complete */
 	/* Tell the main thread that something has happened */
 	common->thread_wakeup_needed = 1;
 	if (common->thread_task)
@@ -731,6 +732,7 @@ static int sleep_thread(struct fsg_commo
 	}
 	__set_current_state(TASK_RUNNING);
 	common->thread_wakeup_needed = 0;
+	smp_rmb();	/* ensure the latest bh->state is visible */
 	return rc;
 }
 

