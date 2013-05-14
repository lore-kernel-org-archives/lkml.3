Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3ENBTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:40 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49048 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab3ENBTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:30 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 19/21] aio/usb: Update cancellation for new synchonization
Date: Mon, 13 May 2013 18:18:56 -0700
Message-Id: <1368494338-7069-20-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous patch got rid of kiocb->ki_users; this was done by having
kiocb_cancel()/aio_complete() explicitly synchronize with each other.

The new rule is that when a driver calls aio_complete(), after
aio_complete() returns ki_cancel cannot be running and it's safe to
dispose of kiocb->priv. But, this means ki_cancel() won't be able to
call aio_complete() itself, or aio_complete() will deadlock.

So, update the driver.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
---
 drivers/usb/gadget/inode.c | 61 +++++++++++++++++++++-------------------------
 1 file changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index f255ad7..69adb87 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -522,6 +522,7 @@ struct kiocb_priv {
 	const struct iovec	*iv;
 	unsigned long		nr_segs;
 	unsigned		actual;
+	int			status;
 };
 
 static int ep_aio_cancel(struct kiocb *iocb)
@@ -577,14 +578,26 @@ static void ep_user_copy_worker(struct work_struct *work)
 	struct kiocb_priv *priv = container_of(work, struct kiocb_priv, work);
 	struct mm_struct *mm = priv->mm;
 	struct kiocb *iocb = priv->iocb;
-	size_t ret;
 
-	use_mm(mm);
-	ret = ep_copy_to_user(priv);
-	unuse_mm(mm);
+	if (priv->iv && priv->actual) {
+		size_t ret;
+
+		use_mm(mm);
+		ret = ep_copy_to_user(priv);
+		unuse_mm(mm);
+
+		if (!priv->status)
+			priv->status = ret;
+		/*
+		 * completing the iocb can drop the ctx and mm, don't touch mm
+		 * after
+		 */
+	}
 
-	/* completing the iocb can drop the ctx and mm, don't touch mm after */
-	aio_complete(iocb, ret, ret);
+
+	/* aio_complete() reports bytes-transferred _and_ faults */
+	aio_complete(iocb, priv->actual ? priv->actual : priv->status,
+		     priv->status);
 
 	kfree(priv->buf);
 	kfree(priv);
@@ -596,36 +609,18 @@ static void ep_aio_complete(struct usb_ep *ep, struct usb_request *req)
 	struct kiocb_priv	*priv = iocb->private;
 	struct ep_data		*epdata = priv->epdata;
 
-	/* lock against disconnect (and ideally, cancel) */
-	spin_lock(&epdata->dev->lock);
-	priv->req = NULL;
-	priv->epdata = NULL;
-
-	/* if this was a write or a read returning no data then we
-	 * don't need to copy anything to userspace, so we can
-	 * complete the aio request immediately.
-	 */
-	if (priv->iv == NULL || unlikely(req->actual == 0)) {
-		kfree(req->buf);
-		kfree(priv);
-		iocb->private = NULL;
-		/* aio_complete() reports bytes-transferred _and_ faults */
-		aio_complete(iocb, req->actual ? req->actual : req->status,
-				req->status);
-	} else {
-		/* ep_copy_to_user() won't report both; we hide some faults */
-		if (unlikely(0 != req->status))
-			DBG(epdata->dev, "%s fault %d len %d\n",
-				ep->name, req->status, req->actual);
-
-		priv->buf = req->buf;
-		priv->actual = req->actual;
-		schedule_work(&priv->work);
-	}
-	spin_unlock(&epdata->dev->lock);
+	priv->buf	= req->buf;
+	priv->actual	= req->actual;
+	priv->status	= req->status;
 
 	usb_ep_free_request(ep, req);
 	put_ep(epdata);
+
+	if ((priv->iv && priv->actual) ||
+	    iocb->ki_cancel == KIOCB_CANCELLING)
+		schedule_work(&priv->work);
+	else
+		ep_user_copy_worker(&priv->work);
 }
 
 static ssize_t
-- 
1.8.2.1

