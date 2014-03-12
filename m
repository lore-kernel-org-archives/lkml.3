Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaCLJij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:38:39 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:47842 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753394AbaCLJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:38:36 -0400
Date: Wed, 12 Mar 2014 05:38:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ANNOUNCE] 3.2.55-rt80
Message-ID: <20140312053833.4793952f@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear RT Folks,

I'm pleased to announce the 3.2.55-rt80 stable release.

I don't usually release a new -rt non stable mainline update without an
rc, but as Ben Hutchings pointed out, this version had a patch
backported that should not have been. The only change is the revert of
the backported patch which caused the kernel to fail to compile.

I now will test against an allmodconfig to avoid errors like this in
the future.

You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  branch: v3.2-rt
  Head SHA1: 9f2ac1d122b2b75f9e50665d3e49325ba8e09f4f


Or to build 3.2.55-rt80 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.x/linux-3.2.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.x/patch-3.2.55.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/patch-3.2.55-rt80.patch.xz



You can also build from 3.2.55-rt79 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.2/incr/patch-3.2.55-rt79-rt80.patch.xz



Enjoy,

-- Steve


Changes from v3.2.55-rt79:

---

Steven Rostedt (Red Hat) (2):
      Revert "swait: Add a few more users"
      Linux 3.2.55-rt80

----
 drivers/net/wireless/orinoco/orinoco_usb.c | 2 +-
 drivers/usb/gadget/f_fs.c                  | 2 +-
 drivers/usb/gadget/inode.c                 | 4 ++--
 localversion-rt                            | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)
---------------------------
diff --git a/drivers/net/wireless/orinoco/orinoco_usb.c b/drivers/net/wireless/orinoco/orinoco_usb.c
index d45833f..0793e42 100644
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
index c6154ca..0e641a1 100644
--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -1270,7 +1270,7 @@ static void ffs_data_put(struct ffs_data *ffs)
 		BUG_ON(mutex_is_locked(&ffs->mutex) ||
 		       spin_is_locked(&ffs->ev.waitq.lock) ||
 		       waitqueue_active(&ffs->ev.waitq) ||
-		       swaitqueue_active(&ffs->ep0req_completion.wait));
+		       waitqueue_active(&ffs->ep0req_completion.wait));
 		kfree(ffs);
 	}
 }
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index 616d19e..7138540 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -339,7 +339,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 	spin_unlock_irq (&epdata->dev->lock);
 
 	if (likely (value == 0)) {
-		value = swait_event_interruptible (done.wait, done.done);
+		value = wait_event_interruptible (done.wait, done.done);
 		if (value != 0) {
 			spin_lock_irq (&epdata->dev->lock);
 			if (likely (epdata->ep != NULL)) {
@@ -348,7 +348,7 @@ ep_io (struct ep_data *epdata, void *buf, unsigned len)
 				usb_ep_dequeue (epdata->ep, epdata->req);
 				spin_unlock_irq (&epdata->dev->lock);
 
-				swait_event (done.wait, done.done);
+				wait_event (done.wait, done.done);
 				if (epdata->status == -ECONNRESET)
 					epdata->status = -EINTR;
 			} else {
diff --git a/localversion-rt b/localversion-rt
index cf94a55..5ba2c20 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt79
+-rt80
