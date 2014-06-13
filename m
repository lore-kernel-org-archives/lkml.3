Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaFMNiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:38:24 -0400
Received: from mail-wg0-f73.google.com ([74.125.82.73]:34513 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaFMNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:38:14 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Yang Wei <Wei.Yang@windriver.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv4 6/6] usb: gadget: f_mass_storage: Fix a warning while loading g_mass_storage
Date: Fri, 13 Jun 2014 15:38:09 +0200
Message-Id: <1402666689-4971-7-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402666689-4971-1-git-send-email-mina86@mina86.com>
References: <1402666689-4971-1-git-send-email-mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While loading g_mass_storage module, the following warning can
trigger:

WARNING: at drivers/usb/gadget/composite.c:
usb_composite_setup_continue: Unexpected call
Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
[<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
[<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
[<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
[<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
[<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
[<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
[<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
[<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)

The root cause is that the existing code fails to take into account
the possibility that common->new_fsg can change while
do_set_interface() is running, because the spinlock does not protect
it.

Change the code so that the common->new_fsg field is protected by the
common->lock spin lock.

Reported-by: Yang Wei <Wei.Yang@windriver.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c | 54 +++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b963939..bd663c2 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -264,7 +264,7 @@ struct fsg_common {
 	/* filesem protects: backing files in use */
 	struct rw_semaphore	filesem;
 
-	/* lock protects: state, all the req_busy's */
+	/* lock protects: state, all the req_busy's, and new_fsg */
 	spinlock_t		lock;
 
 	struct usb_ep		*ep0;		/* Copy of gadget->ep0 */
@@ -407,23 +407,39 @@ static void wakeup_thread(struct fsg_common *common)
 		wake_up_process(common->thread_task);
 }
 
-static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
+static void __raise_exception(struct fsg_common *common,
+			      enum fsg_state new_state)
 {
-	unsigned long		flags;
-
 	/*
 	 * Do nothing if a higher-priority exception is already in progress.
 	 * If a lower-or-equal priority exception is in progress, preempt it
 	 * and notify the main thread by sending it a signal.
 	 */
+	if (common->state > new_state)
+		return;
+
+	common->exception_req_tag = common->ep0_req_tag;
+	common->state = new_state;
+	if (common->thread_task)
+		send_sig_info(SIGUSR1, SEND_SIG_FORCED, common->thread_task);
+}
+
+static void raise_exception(struct fsg_common *common, enum fsg_state new_state)
+{
+	unsigned long		flags;
 	spin_lock_irqsave(&common->lock, flags);
-	if (common->state <= new_state) {
-		common->exception_req_tag = common->ep0_req_tag;
-		common->state = new_state;
-		if (common->thread_task)
-			send_sig_info(SIGUSR1, SEND_SIG_FORCED,
-				      common->thread_task);
-	}
+	__raise_exception(common, new_state);
+	spin_unlock_irqrestore(&common->lock, flags);
+}
+
+static void raise_config_change_exception(struct fsg_common *common,
+					  struct fsg_dev *new_fsg)
+{
+	unsigned long		flags;
+
+	spin_lock_irqsave(&common->lock, flags);
+	common->new_fsg = new_fsg;
+	__raise_exception(common, FSG_STATE_CONFIG_CHANGE);
 	spin_unlock_irqrestore(&common->lock, flags);
 }
 
@@ -2320,16 +2336,14 @@ reset:
 static int fsg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = fsg;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+	raise_config_change_exception(fsg->common, fsg);
 	return USB_GADGET_DELAYED_STATUS;
 }
 
 static void fsg_disable(struct usb_function *f)
 {
 	struct fsg_dev *fsg = fsg_from_func(f);
-	fsg->common->new_fsg = NULL;
-	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+	raise_config_change_exception(fsg->common, NULL);
 }
 
 
@@ -2342,6 +2356,7 @@ static void handle_exception(struct fsg_common *common)
 	struct fsg_buffhd	*bh;
 	enum fsg_state		old_state;
 	struct fsg_lun		*curlun;
+	struct fsg_dev		*new_fsg;
 	unsigned int		exception_req_tag;
 
 	/*
@@ -2405,6 +2420,7 @@ static void handle_exception(struct fsg_common *common)
 	common->next_buffhd_to_drain = &common->buffhds[0];
 	exception_req_tag = common->exception_req_tag;
 	old_state = common->state;
+	new_fsg = common->new_fsg;
 
 	if (old_state == FSG_STATE_ABORT_BULK_OUT)
 		common->state = FSG_STATE_STATUS_PHASE;
@@ -2460,8 +2476,8 @@ static void handle_exception(struct fsg_common *common)
 		break;
 
 	case FSG_STATE_CONFIG_CHANGE:
-		do_set_interface(common, common->new_fsg);
-		if (common->new_fsg)
+		do_set_interface(common, new_fsg);
+		if (new_fsg)
 			usb_composite_setup_continue(common->cdev);
 		break;
 
@@ -3178,8 +3194,7 @@ static void fsg_unbind(struct usb_configuration *c, struct usb_function *f)
 
 	DBG(fsg, "unbind\n");
 	if (fsg->common->fsg == fsg) {
-		fsg->common->new_fsg = NULL;
-		raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
+		raise_config_change_exception(fsg->common, NULL);
 		/* FIXME: make interruptible or killable somehow? */
 		wait_event(common->fsg_wait, common->fsg != fsg);
 	}
@@ -3665,4 +3680,3 @@ void fsg_config_from_params(struct fsg_config *cfg,
 	cfg->fsg_num_buffers = fsg_num_buffers;
 }
 EXPORT_SYMBOL_GPL(fsg_config_from_params);
-
-- 
2.0.0.526.g5318336

