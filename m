Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaIJPud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:50:33 -0400
Received: from mail-la0-f74.google.com ([209.85.215.74]:62298 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaIJPub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:50:31 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH 1/2] usb: f_fs: refactor and document __ffs_ep0_read_events better
Date: Wed, 10 Sep 2014 17:50:24 +0200
Message-Id: <1410364225-6087-1-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using variable length array, use a static length equal to
the size of the ffs->ev.types array.  This gets rid of a sparse warning:

	drivers/usb/gadget/function/f_fs.c:401:44: warning:
	Variable length array is used.

and makes it more explicit that the array has a very tight upper size
limit.  Also add some more documentation about the ev.types array and
how its size is limited and affects the rest of the code.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 This has been compile tested only.

 drivers/usb/gadget/function/f_fs.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index dc30adf1..ec50e0d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -385,14 +385,16 @@ done_spin:
 	return ret;
 }
 
+/* Called with ffs->ev.waitq.lock and ffs->mutex held, both released on exit. */
 static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 				     size_t n)
 {
 	/*
-	 * We are holding ffs->ev.waitq.lock and ffs->mutex and we need
-	 * to release them.
+	 * n cannot be bigger than ffs->ev.count, which cannot be bigger than
+	 * size of ffs->ev.types array (which is four) so that's how much space
+	 * we reserve.
 	 */
-	struct usb_functionfs_event events[n];
+	struct usb_functionfs_event events[ARRAY_SIZE(ffs->ev.types)];
 	unsigned i = 0;
 
 	memset(events, 0, sizeof events);
@@ -405,12 +407,10 @@ static ssize_t __ffs_ep0_read_events(struct ffs_data *ffs, char __user *buf,
 		}
 	} while (++i < n);
 
-	if (n < ffs->ev.count) {
-		ffs->ev.count -= n;
+	ffs->ev.count -= n;
+	if (ffs->ev.count) {
 		memmove(ffs->ev.types, ffs->ev.types + n,
 			ffs->ev.count * sizeof *ffs->ev.types);
-	} else {
-		ffs->ev.count = 0;
 	}
 
 	spin_unlock_irq(&ffs->ev.waitq.lock);
@@ -2293,6 +2293,13 @@ static void __ffs_event_add(struct ffs_data *ffs,
 	if (ffs->setup_state == FFS_SETUP_PENDING)
 		ffs->setup_state = FFS_SETUP_CANCELLED;
 
+	/*
+	 * Logic of this function guarantees that there will be at most four
+	 * pending evens on the ffs->ev.types queue.  This is important since
+	 * that array has only place for four elements and __ffs_event_add
+	 * function also depends on that limit.  If more event types are added,
+	 * those limits have to be revisited or guaranteed to still hold.
+	 */
 	switch (type) {
 	case FUNCTIONFS_RESUME:
 		rem_type2 = FUNCTIONFS_SUSPEND;
-- 
2.1.0.rc2.206.gedb03e5

