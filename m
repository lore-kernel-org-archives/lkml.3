Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3LKAqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 19:46:47 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:46322 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751298Ab3LKAqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:46:44 -0500
Message-Id: <20131211004643.325379918@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 10 Dec 2013 19:46:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 2/5] a few open coded completions
References: <20131211004631.950208564@goodmis.org>
Content-Disposition: inline; filename=0002-a-few-open-coded-completions.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13-rt26-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/orinoco/orinoco_usb.c | 2 +-
 drivers/usb/gadget/f_fs.c                  | 2 +-
 drivers/usb/gadget/inode.c                 | 4 ++--
 include/linux/netdevice.h                  | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index 01624dc..b0f9d2c 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -714,7 +714,7 @@ static void ezusb_req_ctx_wait(struct ezusb_priv *upriv,
 			while (!ctx->done.done && msecs--)
 				udelay(1000);
 		} else {
-			wait_event_interruptible(ctx->done.wait,
+			swait_event_interruptible(ctx->done.wait,
 						 ctx->done.done);
 		}
 		break;
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index de3e266..5b2a068 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1284,7 +1284,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
-		       waitqueue_active(&ffs->ep0req_completion.wait));
+		       swaitqueue_active(&ffs->ep0req_completion.wait));
 		kfree(ffs->dev_name);
 		kfree(ffs);
 	}
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 8ac840f..fe85df7 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -338,7 +338,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 	spin_unlock_irq (&epdata->dev->lock);
 
 	if (likely (value == 0)) {
-		value = wait_event_interruptible (done.wait, done.done);
+		value = swait_event_interruptible (done.wait, done.done);
 		if (value != 0) {
 			spin_lock_irq (&epdata->dev->lock);
 			if (likely (epdata->ep != NULL)) {
@@ -347,7 +347,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				usb_ep_dequeue (epdata->ep, epdata->req);
 				spin_unlock_irq (&epdata->dev->lock);
 
-				wait_event (done.wait, done.done);
+				swait_event (done.wait, done.done);
 				if (epdata->status == -ECONNRESET)
 					epdata->status = -EINTR;
 			} else {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0b58fd6..bc45789 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1123,7 +1123,7 @@ struct net_device {
 	unsigned char		perm_addr[MAX_ADDR_LEN]; /* permanent hw address */
 	unsigned char		addr_assign_type; /* hw address assignment type */
 	unsigned char		addr_len;	/* hardware address length	*/
-	unsigned char		neigh_priv_len;
+	unsigned short		neigh_priv_len;
 	unsigned short          dev_id;		/* for shared network cards */
 
 	spinlock_t		addr_list_lock;
-- 
1.8.4.3


