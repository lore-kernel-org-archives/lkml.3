Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754Ab3HMQcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:32:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4213 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757927Ab3HMQ0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:26:51 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=gxkWszt2KDgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=YJrJ-TgkFjwA:10 a=VwQbUJbxAAAA:8 a=lMwjtec1AAAA:8 a=sozttTNsAAAA:8 a=UqXsq3LT7gkJoKoG_8QA:9 a=6gwatna_2BgA:10 a=x2szoZtqnggA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155834.357308902@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:58:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>
Subject: [68/88] usb: gadget: f_mass_storage: add missing memory barrier for
 thread_wakeup_needed
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0068-usb-gadget-f_mass_storage-add-missing-memory-barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: UCHINO Satoshi <satoshi.uchino@toshiba.co.jp>

[ Upstream commit d68c277b501889b3a50c179d1c3d704db7947b83 ]

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
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/gadget/f_mass_storage.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 4f1142e..4d60ad3 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -433,6 +433,7 @@ static int fsg_set_halt(struct fsg_dev *fsg, struct usb_ep *ep)
 /* Caller must hold fsg->lock */
 static void wakeup_thread(struct fsg_common *common)
 {
+	smp_wmb();	/* ensure the write of bh->state is complete */
 	/* Tell the main thread that something has happened */
 	common->thread_wakeup_needed = 1;
 	if (common->thread_task)
@@ -652,6 +653,7 @@ static int sleep_thread(struct fsg_common *common)
 	}
 	__set_current_state(TASK_RUNNING);
 	common->thread_wakeup_needed = 0;
+	smp_rmb();	/* ensure the latest bh->state is visible */
 	return rc;
 }
 
-- 
1.7.10.4


