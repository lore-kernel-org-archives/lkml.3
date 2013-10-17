Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3JQDAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 23:00:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:41283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762180Ab3JQDAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 23:00:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,511,1378882800"; 
   d="scan'208";a="375885637"
Subject: [PATCH] n_gsm: race between ld close and gsmtty open
From: channing <chao.bi@intel.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Oct 2013 11:29:10 +0800
Message-ID: <1381980550.19582.8.camel@bichao>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ttyA has ld associated to n_gsm, when ttyA is closing, it triggers
to release gsmttyB's ld data dlci[B], then race would happen if gsmttyB
is opening in parallel.

Here are some of race cases we found recently in test:

CASE #1
====================================================================
releasing dlci[B] race with gsmtty_install(gsmttyB), then panic
in gsmtty_open(gsmttyB), as below:

 tty_release(ttyA)                  tty_open(gsmttyB)
     |                                   |
   -----                           gsmtty_install(gsmttyB)
     |                                   |
   -----                    gsm_dlci_alloc(gsmttyB) => alloc dlci[B]
 tty_ldisc_release(ttyA)               -----
     |                                   |
 gsm_dlci_release(dlci[B])             -----
     |                                   |
 gsm_dlci_free(dlci[B])                -----
     |                                   |
   -----                           gsmtty_open(gsmttyB)

 gsmtty_open()
 {
     struct gsm_dlci *dlci = tty->driver_data; => here it uses dlci[B]
     ...
 }

 In gsmtty_open(gsmttyA), it uses dlci[B] which was release, so hit a panic.
=====================================================================

CASE #2
=====================================================================
releasing dlci[0] race with gsmtty_install(gsmttyB), then panic
in gsmtty_open(), as below:

 tty_release(ttyA)                  tty_open(gsmttyB)
     |                                   |
   -----                           gsmtty_install(gsmttyB)
     |                                   |
   -----                    gsm_dlci_alloc(gsmttyB) => alloc dlci[B]
     |                                   |
   -----                         gsmtty_open(gsmttyB) fail
     |                                   |
   -----                           tty_release(gsmttyB)
     |                                   |
   -----                           gsmtty_close(gsmttyB)
     |                                   |
   -----                        gsmtty_detach_dlci(dlci[B])
     |                                   |
   -----                             dlci_put(dlci[B])
     |                                   |
 tty_ldisc_release(ttyA)               -----
     |                                   |
 gsm_dlci_release(dlci[0])             -----
     |                                   |
 gsm_dlci_free(dlci[0])                -----
     |                                   |
   -----                             dlci_put(dlci[0])

 In gsmtty_detach_dlci(dlci[B]), it tries to use dlci[0] which was released,
 then hit panic.
=====================================================================

IMHO, n_gsm tty operations would refer released ldisc,  as long as
gsm_dlci_release() has chance to release ldisc data when some gsmtty operations
are not completed..

This patch is try to avoid it by:

1) in n_gsm driver, use a global gsm spin lock to avoid gsm_dlci_release() run in
parallel with gsmtty_install();

2) Increase dlci's ref count in gsmtty_install() instead of in gsmtty_open(), the
purpose is to prevent gsm_dlci_release() releasing dlci after gsmtty_install()
allocats dlci but before gsmtty_open increases dlci's ref count;

3) Decrease dlci's ref count in gsmtty_remove(), which is a tty framework api, and
this is the opposite process of step 2).

Signed-off-by: Chao Bi <chao.bi@intel.com>
---
 drivers/tty/n_gsm.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c0f76da..41ef7d7 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2054,9 +2054,11 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
 					dlci->state == DLCI_CLOSED);
 	}
 	/* Free up any link layer users */
+	spin_lock(&gsm->lock);
 	for (i = 0; i < NUM_DLCI; i++)
 		if (gsm->dlci[i])
 			gsm_dlci_release(gsm->dlci[i]);
+	spin_unlock(&gsm->lock);
 	/* Now wipe the queues */
 	list_for_each_entry_safe(txq, ntxq, &gsm->tx_list, list)
 		kfree(txq);
@@ -2909,23 +2911,33 @@ static int gsmtty_install(struct tty_driver *driver, struct tty_struct *tty)
 	This is ok from a locking
 	perspective as we don't have to worry about this
 	if DLCI0 is lost */
-	if (gsm->dlci[0] && gsm->dlci[0]->state != DLCI_OPEN)
+	spin_lock(&gsm->lock);
+	if (gsm->dlci[0] && gsm->dlci[0]->state != DLCI_OPEN) {
+		spin_unlock(&gsm->lock);
 		return -EL2NSYNC;
+	}
 	dlci = gsm->dlci[line];
 	if (dlci == NULL) {
 		alloc = true;
 		dlci = gsm_dlci_alloc(gsm, line);
 	}
-	if (dlci == NULL)
+	if (dlci == NULL) {
+		spin_unlock(&gsm->lock);
 		return -ENOMEM;
+	}
 	ret = tty_port_install(&dlci->port, driver, tty);
 	if (ret) {
 		if (alloc)
 			dlci_put(dlci);
+		spin_unlock(&gsm->lock);
 		return ret;
 	}
 
+	dlci_get(dlci);
+	dlci_get(gsm->dlci[0]);
+	mux_get(gsm);
 	tty->driver_data = dlci;
+	spin_unlock(&gsm->lock);
 
 	return 0;
 }
@@ -2936,9 +2948,6 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 	struct tty_port *port = &dlci->port;
 
 	port->count++;
-	dlci_get(dlci);
-	dlci_get(dlci->gsm->dlci[0]);
-	mux_get(dlci->gsm);
 	tty_port_tty_set(port, tty);
 
 	dlci->modem_rx = 0;
@@ -2965,7 +2974,7 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 	mutex_unlock(&dlci->mutex);
 	gsm = dlci->gsm;
 	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
-		goto out;
+		return;
 	gsm_dlci_begin_close(dlci);
 	if (test_bit(ASYNCB_INITIALIZED, &dlci->port.flags)) {
 		if (C_HUPCL(tty))
@@ -2973,10 +2982,7 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
 	}
 	tty_port_close_end(&dlci->port, tty);
 	tty_port_tty_set(&dlci->port, NULL);
-out:
-	dlci_put(dlci);
-	dlci_put(gsm->dlci[0]);
-	mux_put(gsm);
+	return;
 }
 
 static void gsmtty_hangup(struct tty_struct *tty)
@@ -3153,6 +3159,16 @@ static int gsmtty_break_ctl(struct tty_struct *tty, int state)
 	return gsmtty_modem_update(dlci, encode);
 }
 
+static int gsmtty_remove(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct gsm_dlci *dlci = tty->driver_data;
+	struct gsm_mux *gsm = dlci->gsm;
+
+	dlci_put(dlci);
+	dlci_put(gsm->dlci[0]);
+	mux_put(gsm);
+	driver->ttys[tty->index] = NULL;
+}
 
 /* Virtual ttys for the demux */
 static const struct tty_operations gsmtty_ops = {
@@ -3172,6 +3188,7 @@ static const struct tty_operations gsmtty_ops = {
 	.tiocmget		= gsmtty_tiocmget,
 	.tiocmset		= gsmtty_tiocmset,
 	.break_ctl		= gsmtty_break_ctl,
+	.remove			= gsmtty_remove,
 };
 
 
-- 
1.7.1



