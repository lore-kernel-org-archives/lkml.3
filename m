Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab3A2Dqu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:46:50 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:33359 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750874Ab3A2Dqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:46:48 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 11/11] staging/fwserial: Remove unneeded push work
Date: Mon, 28 Jan 2013 22:34:45 -0500
Message-Id: <1359430485-5301-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since rx push can be performed synchronously with unthrottle,
remove the push work struct and code references to it.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 2 --
 drivers/staging/fwserial/fwserial.h | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 121beff..8983911 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1112,7 +1112,6 @@ static void fwtty_port_shutdown(struct tty_port *tty_port)
 
 	cancel_delayed_work_sync(&port->emit_breaks);
 	cancel_delayed_work_sync(&port->drain);
-	cancel_work_sync(&port->push);
 
 	spin_lock_bh(&port->lock);
 	list_for_each_entry_safe(buf, next, &port->buf_list, list) {
@@ -2300,7 +2299,6 @@ static int fwserial_create(struct fw_unit *unit)
 		INIT_DELAYED_WORK(&port->drain, fwtty_drain_tx);
 		INIT_DELAYED_WORK(&port->emit_breaks, fwtty_emit_breaks);
 		INIT_WORK(&port->hangup, fwtty_do_hangup);
-		INIT_WORK(&port->push, fwtty_pushrx);
 		INIT_LIST_HEAD(&port->buf_list);
 		init_waitqueue_head(&port->wait_tx);
 		port->max_payload = link_speed_to_max_payload(SCODE_100);
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index 33a3a53..6c179f0 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -223,9 +223,6 @@ struct buffered_rx {
  *         The work can race with the writer but concurrent sending is
  *         prevented with the IN_TX flag. Scheduled under lock to
  *         limit scheduling when fifo has just been drained.
- * @push: work responsible for pushing buffered rx to the ldisc.
- *	  rx can become buffered if the tty buffer is filled before the
- *	  ldisc throttles the sender.
  * @buf_list: list of buffered rx yet to be sent to ldisc
  * @buffered: byte count of buffered rx
  * @tx_fifo: fifo used to store & block-up writes for dma to remote
@@ -267,7 +264,6 @@ struct fwtty_port {
 	spinlock_t		   lock;
 	unsigned		   mctrl;
 	struct delayed_work	   drain;
-	struct work_struct	   push;
 	struct list_head	   buf_list;
 	int			   buffered;
 	struct dma_fifo		   tx_fifo;
-- 
1.8.1.1

