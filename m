Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaCLJmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:42:13 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:44470 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752616AbaCLJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:42:12 -0400
Date: Wed, 12 Mar 2014 05:42:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [ANNOUNCE] 3.8.13.14-rt29
Message-ID: <20140312054210.7403a665@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.8.13.14-rt29 stable release.

I'm posting this without an -rc release because it only contains a
revert of a patch that caused the kernel to fail to compile.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.8-rt
  Head SHA1: 5c1d604be1956db39d5be31dd73dc61b4a99cc1c


Or to build 3.8.13.14-rt29 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.8.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.8.13.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/stable/patch-3.8.13.14.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/patch-3.8.13.14-rt29.patch.xz



You can also build from 3.8.13.14-rt28 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.8/incr/patch-3.8.13.14-rt28-rt29.patch.xz



Enjoy,

-- Steve


Changes from v3.8.13.14-rt28:

---

Steven Rostedt (Red Hat) (2):
      Revert "swait: Add a few more users"
      Linux 3.8.13.14-rt29

----
 drivers/net/wireless/orinoco/orinoco_usb.c | 2 +-
 drivers/usb/gadget/f_fs.c                  | 2 +-
 drivers/usb/gadget/inode.c                 | 4 ++--
 localversion-rt                            | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
---------------------------
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index b0f9d2c..01624dc 100644
--- a/drivers/net/wireless/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/orinoco/orinoco_usb.c
@@ -714,7 +714,7 @@ static void ezusb_req_ctx_wait(struct ezusb_priv *upriv,
 			while (!ctx->done.done && msecs--)
 				udelay(1000);
 		} else {
-			swait_event_interruptible(ctx->done.wait,
+			wait_event_interruptible(ctx->done.wait,
 						 ctx->done.done);
 		}
 		break;
diff --git a/drivers/usb/gadget/f_fs.c b/drivers/usb/gadget/f_fs.c
index 5b2a068..de3e266 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1284,7 +1284,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 		pr_info("%s(): freeing\n", __func__);
 		ffs_data_clear(ffs);
 		BUG_ON(waitqueue_active(&ffs->ev.waitq) ||
-		       swaitqueue_active(&ffs->ep0req_completion.wait));
+		       waitqueue_active(&ffs->ep0req_completion.wait));
 		kfree(ffs->dev_name);
 		kfree(ffs);
 	}
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index fe85df7..8ac840f 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -338,7 +338,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 	spin_unlock_irq (&epdata->dev->lock);
 
 	if (likely (value == 0)) {
-		value = swait_event_interruptible (done.wait, done.done);
+		value = wait_event_interruptible (done.wait, done.done);
 		if (value != 0) {
 			spin_lock_irq (&epdata->dev->lock);
 			if (likely (epdata->ep != NULL)) {
@@ -347,7 +347,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				usb_ep_dequeue (epdata->ep, epdata->req);
 				spin_unlock_irq (&epdata->dev->lock);
 
-				swait_event (done.wait, done.done);
+				wait_event (done.wait, done.done);
 				if (epdata->status == -ECONNRESET)
 					epdata->status = -EINTR;
 			} else {
diff --git a/localversion-rt b/localversion-rt
index 5a64c9c..90290c6 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt28
+-rt29
