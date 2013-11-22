Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3KVSGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:06:39 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41184 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab3KVSGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:06:35 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH staging-next 3/4] staging/fwserial: Rename data profiling functions
Date: Fri, 22 Nov 2013 13:06:10 -0500
Message-Id: <1385143571-3571-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
References: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 22 +++++++++++-----------
 drivers/staging/fwserial/fwserial.h |  4 ++--
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index cad9e3f..12bd002 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -136,14 +136,14 @@ static struct fwtty_peer *__fwserial_peer_by_node_id(struct fw_card *card,
 
 #ifdef FWTTY_PROFILING
 
-static void profile_fifo_avail(struct fwtty_port *port, unsigned *stat)
+static void fwtty_profile_fifo(struct fwtty_port *port, unsigned *stat)
 {
 	spin_lock_bh(&port->lock);
-	profile_size_distrib(stat, dma_fifo_avail(&port->tx_fifo));
+	fwtty_profile_data(stat, dma_fifo_avail(&port->tx_fifo));
 	spin_unlock_bh(&port->lock);
 }
 
-static void dump_profile(struct seq_file *m, struct stats *stats)
+static void fwtty_dump_profile(struct seq_file *m, struct stats *stats)
 {
 	/* for each stat, print sum of 0 to 2^k, then individually */
 	int k = 4;
@@ -183,8 +183,8 @@ static void dump_profile(struct seq_file *m, struct stats *stats)
 }
 
 #else
-#define profile_fifo_avail(port, stat)
-#define dump_profile(m, stats)
+#define fwtty_profile_fifo(port, stat)
+#define fwtty_dump_profile(m, stats)
 #endif
 
 /*
@@ -550,7 +550,7 @@ static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
 	int err = 0;
 
 	fwtty_dbg(port, "%d\n", n);
-	profile_size_distrib(port->stats.reads, n);
+	fwtty_profile_data(port->stats.reads, n);
 
 	if (port->write_only) {
 		n = 0;
@@ -759,7 +759,7 @@ static int fwtty_tx(struct fwtty_port *port, bool drain)
 			if (n == -EAGAIN)
 				++port->stats.tx_stall;
 			else if (n == -ENODATA)
-				profile_size_distrib(port->stats.txns, 0);
+				fwtty_profile_data(port->stats.txns, 0);
 			else {
 				++port->stats.fifo_errs;
 				fwtty_err_ratelimited(port, "fifo err: %d\n",
@@ -768,7 +768,7 @@ static int fwtty_tx(struct fwtty_port *port, bool drain)
 			break;
 		}
 
-		profile_size_distrib(port->stats.txns, txn->dma_pended.len);
+		fwtty_profile_data(port->stats.txns, txn->dma_pended.len);
 
 		fwtty_send_txn_async(peer, txn, TCODE_WRITE_BLOCK_REQUEST,
 				     peer->fifo_addr, txn->dma_pended.data,
@@ -1115,7 +1115,7 @@ static int fwtty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 	int n, len;
 
 	fwtty_dbg(port, "%d\n", c);
-	profile_size_distrib(port->stats.writes, c);
+	fwtty_profile_data(port->stats.writes, c);
 
 	spin_lock_bh(&port->lock);
 	n = dma_fifo_in(&port->tx_fifo, buf, c);
@@ -1193,7 +1193,7 @@ static void fwtty_unthrottle(struct tty_struct *tty)
 
 	fwtty_dbg(port, "CRTSCTS: %d\n", (C_CRTSCTS(tty) != 0));
 
-	profile_fifo_avail(port, port->stats.unthrottle);
+	fwtty_profile_fifo(port, port->stats.unthrottle);
 
 	spin_lock_bh(&port->lock);
 	port->mctrl &= ~OOB_RX_THROTTLE;
@@ -1459,7 +1459,7 @@ static void fwtty_debugfs_show_port(struct seq_file *m, struct fwtty_port *port)
 		(*port->fwcon_ops->proc_show)(m, port->con_data);
 	}
 
-	dump_profile(m, &port->stats);
+	fwtty_dump_profile(m, &port->stats);
 }
 
 static void fwtty_debugfs_show_peer(struct seq_file *m, struct fwtty_peer *peer)
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index 149b24d..eab85b4 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -22,14 +22,14 @@
 #ifdef FWTTY_PROFILING
 #define DISTRIBUTION_MAX_SIZE     8192
 #define DISTRIBUTION_MAX_INDEX    (ilog2(DISTRIBUTION_MAX_SIZE) + 1)
-static inline void profile_size_distrib(unsigned stat[], unsigned val)
+static inline void fwtty_profile_data(unsigned stat[], unsigned val)
 {
 	int n = (val) ? min(ilog2(val) + 1, DISTRIBUTION_MAX_INDEX) : 0;
 	++stat[n];
 }
 #else
 #define DISTRIBUTION_MAX_INDEX    0
-#define profile_size_distrib(st, n)
+#define fwtty_profile_data(st, n)
 #endif
 
 /* Parameters for both VIRT_CABLE_PLUG & VIRT_CABLE_PLUG_RSP mgmt codes */
-- 
1.8.1.2

