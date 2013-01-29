Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab3A2Dfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:35:42 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:45600 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756501Ab3A2Dfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:39 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 05/11] staging/fwserial: Cleanup /proc/tty/driver/ file
Date: Mon, 28 Jan 2013 22:34:39 -0500
Message-Id: <1359430485-5301-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factor out extra stats, data profiles, debugging info and peer info
from procfs file in preparation for using debugfs instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 39 ++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index e143b7a..ba8ffa2 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -1500,17 +1500,26 @@ static void fwtty_proc_show_port(struct seq_file *m, struct fwtty_port *port)
 	if (port->port.console)
 		(*port->fwcon_ops->stats)(&stats, port->con_data);
 
-	seq_printf(m, " tx:%d rx:%d", port->icount.tx + stats.xchars,
-		   port->icount.rx);
+	seq_printf(m, " addr:%012llx tx:%d rx:%d", port->rx_handler.offset,
+		   port->icount.tx + stats.xchars, port->icount.rx);
 	seq_printf(m, " cts:%d dsr:%d rng:%d dcd:%d", port->icount.cts,
 		   port->icount.dsr, port->icount.rng, port->icount.dcd);
 	seq_printf(m, " fe:%d oe:%d pe:%d brk:%d", port->icount.frame,
 		   port->icount.overrun, port->icount.parity, port->icount.brk);
+}
+
+static void fwtty_debugfs_show_port(struct seq_file *m, struct fwtty_port *port)
+{
+	struct stats stats;
+
+	memcpy(&stats, &port->stats, sizeof(stats));
+	if (port->port.console)
+		(*port->fwcon_ops->stats)(&stats, port->con_data);
+
 	seq_printf(m, " dr:%d st:%d err:%d lost:%d", stats.dropped,
 		   stats.tx_stall, stats.fifo_errs, stats.lost);
 	seq_printf(m, " pkts:%d thr:%d wtrmk:%d", stats.sent, stats.throttled,
 		   stats.watermark);
-	seq_printf(m, " addr:%012llx", port->rx_handler.offset);
 
 	if (port->port.console) {
 		seq_printf(m, "\n    ");
@@ -1520,7 +1529,7 @@ static void fwtty_proc_show_port(struct seq_file *m, struct fwtty_port *port)
 	dump_profile(m, &port->stats);
 }
 
-static void fwtty_proc_show_peer(struct seq_file *m, struct fwtty_peer *peer)
+static void fwtty_debugfs_show_peer(struct seq_file *m, struct fwtty_peer *peer)
 {
 	int generation = peer->generation;
 
@@ -1529,21 +1538,14 @@ static void fwtty_proc_show_peer(struct seq_file *m, struct fwtty_peer *peer)
 	seq_printf(m, " node:%04x gen:%d", peer->node_id, generation);
 	seq_printf(m, " sp:%d max:%d guid:%016llx", peer->speed,
 		   peer->max_payload, (unsigned long long) peer->guid);
-
-	if (capable(CAP_SYS_ADMIN)) {
-		seq_printf(m, " mgmt:%012llx",
-			   (unsigned long long) peer->mgmt_addr);
-		seq_printf(m, " addr:%012llx",
-			   (unsigned long long) peer->status_addr);
-	}
+	seq_printf(m, " mgmt:%012llx", (unsigned long long) peer->mgmt_addr);
+	seq_printf(m, " addr:%012llx", (unsigned long long) peer->status_addr);
 	seq_putc(m, '\n');
 }
 
 static int fwtty_proc_show(struct seq_file *m, void *v)
 {
 	struct fwtty_port *port;
-	struct fw_serial *serial;
-	struct fwtty_peer *peer;
 	int i;
 
 	seq_puts(m, "fwserinfo: 1.0 driver: 1.0\n");
@@ -1554,17 +1556,6 @@ static int fwtty_proc_show(struct seq_file *m, void *v)
 		fwtty_port_put(port);
 		seq_printf(m, "\n");
 	}
-	seq_putc(m, '\n');
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(serial, &fwserial_list, list) {
-		seq_printf(m, "card: %s  guid: %016llx\n",
-			   dev_name(serial->card->device),
-			   (unsigned long long) serial->card->guid);
-		list_for_each_entry_rcu(peer, &serial->peer_list, list)
-			fwtty_proc_show_peer(m, peer);
-	}
-	rcu_read_unlock();
 	return 0;
 }
 
-- 
1.8.1.1

