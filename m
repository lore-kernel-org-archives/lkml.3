Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584Ab3A2Dfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:35:46 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:38710 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753717Ab3A2Dfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:42 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 06/11] staging/fwserial: Factor unstable stats/debug/status info to debugfs
Date: Mon, 28 Jan 2013 22:34:40 -0500
Message-Id: <1359430485-5301-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the following file hierarchy to debugfs:

  <debugfs>-+
            +- firewire_serial -+- <unit> -+- peers
                                |          +- stats
                                |
                                +- <unit> -+- peers
                                           +- stats

The 'peers' file (read-only) contains status and configuration
info for attached peers for the given fwserial unit.

The 'stats' file (read-only) contains statistics and data profiling
information for each tty port for the given fwserial unit.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 82 +++++++++++++++++++++++++++++++++++++
 drivers/staging/fwserial/fwserial.h |  2 +
 2 files changed, 84 insertions(+)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index ba8ffa2..66463d1 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -84,6 +84,8 @@ static struct kmem_cache *fwtty_txn_cache;
 struct tty_driver *fwtty_driver;
 static struct tty_driver *fwloop_driver;
 
+static struct dentry *fwserial_debugfs;
+
 struct fwtty_transaction;
 typedef void (*fwtty_transaction_cb)(struct fw_card *card, int rcode,
 				     void *data, size_t length,
@@ -1559,11 +1561,71 @@ static int fwtty_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int fwtty_debugfs_stats_show(struct seq_file *m, void *v)
+{
+	struct fw_serial *serial = m->private;
+	struct fwtty_port *port;
+	int i;
+
+	for (i = 0; i < num_ports; ++i) {
+		port = fwtty_port_get(serial->ports[i]->index);
+		if (port) {
+			seq_printf(m, "%2d:", port->index);
+			fwtty_proc_show_port(m, port);
+			fwtty_debugfs_show_port(m, port);
+			fwtty_port_put(port);
+			seq_printf(m, "\n");
+		}
+	}
+	return 0;
+}
+
+static int fwtty_debugfs_peers_show(struct seq_file *m, void *v)
+{
+	struct fw_serial *serial = m->private;
+	struct fwtty_peer *peer;
+
+	rcu_read_lock();
+	seq_printf(m, "card: %s  guid: %016llx\n",
+		   dev_name(serial->card->device),
+		   (unsigned long long) serial->card->guid);
+	list_for_each_entry_rcu(peer, &serial->peer_list, list)
+		fwtty_debugfs_show_peer(m, peer);
+	rcu_read_unlock();
+	return 0;
+}
+
 static int fwtty_proc_open(struct inode *inode, struct file *fp)
 {
 	return single_open(fp, fwtty_proc_show, NULL);
 }
 
+static int fwtty_stats_open(struct inode *inode, struct file *fp)
+{
+	return single_open(fp, fwtty_debugfs_stats_show, inode->i_private);
+}
+
+static int fwtty_peers_open(struct inode *inode, struct file *fp)
+{
+	return single_open(fp, fwtty_debugfs_peers_show, inode->i_private);
+}
+
+static const struct file_operations fwtty_stats_fops = {
+	.owner =	THIS_MODULE,
+	.open =		fwtty_stats_open,
+	.read =		seq_read,
+	.llseek =	seq_lseek,
+	.release =	single_release,
+};
+
+static const struct file_operations fwtty_peers_fops = {
+	.owner =	THIS_MODULE,
+	.open =		fwtty_peers_open,
+	.read =		seq_read,
+	.llseek =	seq_lseek,
+	.release =	single_release,
+};
+
 static const struct file_operations fwtty_proc_fops = {
 	.owner =        THIS_MODULE,
 	.open =         fwtty_proc_open,
@@ -2300,6 +2362,17 @@ static int fwserial_create(struct fw_unit *unit)
 		serial->ports[j]->loopback = true;
 	}
 
+	if (!IS_ERR_OR_NULL(fwserial_debugfs)) {
+		serial->debugfs = debugfs_create_dir(dev_name(&unit->device),
+						     fwserial_debugfs);
+		if (!IS_ERR_OR_NULL(serial->debugfs)) {
+			debugfs_create_file("peers", 0444, serial->debugfs,
+					    serial, &fwtty_peers_fops);
+			debugfs_create_file("stats", 0444, serial->debugfs,
+					    serial, &fwtty_stats_fops);
+		}
+	}
+
 	list_add_rcu(&serial->list, &fwserial_list);
 
 	fwtty_notice(&unit, "TTY over FireWire on device %s (guid %016llx)",
@@ -2312,6 +2385,8 @@ static int fwserial_create(struct fw_unit *unit)
 	fwtty_err(&unit, "unable to add peer unit device (%d)", err);
 
 	/* fall-through to error processing */
+	debugfs_remove_recursive(serial->debugfs);
+
 	list_del_rcu(&serial->list);
 	if (create_loop_dev)
 		tty_unregister_device(fwloop_driver, loop_idx(serial->ports[j]));
@@ -2403,6 +2478,8 @@ static int fwserial_remove(struct device *dev)
 		/* unlink from the fwserial_list here */
 		list_del_rcu(&serial->list);
 
+		debugfs_remove_recursive(serial->debugfs);
+
 		for (i = 0; i < num_ttys; ++i)
 			fwserial_close_port(fwtty_driver, serial->ports[i]);
 		if (create_loop_dev)
@@ -2797,6 +2874,9 @@ static int __init fwserial_init(void)
 {
 	int err, num_loops = !!(create_loop_dev);
 
+	/* XXX: placeholder for a "firewire" debugfs node */
+	fwserial_debugfs = debugfs_create_dir(KBUILD_MODNAME, NULL);
+
 	/* num_ttys/num_ports must not be set above the static alloc avail */
 	if (num_ttys + num_loops > MAX_CARD_PORTS)
 		num_ttys = MAX_CARD_PORTS - num_loops;
@@ -2911,6 +2991,7 @@ unregister_driver:
 	tty_unregister_driver(fwtty_driver);
 put_tty:
 	put_tty_driver(fwtty_driver);
+	debugfs_remove_recursive(fwserial_debugfs);
 	return err;
 }
 
@@ -2926,6 +3007,7 @@ static void __exit fwserial_exit(void)
 	}
 	tty_unregister_driver(fwtty_driver);
 	put_tty_driver(fwtty_driver);
+	debugfs_remove_recursive(fwserial_debugfs);
 }
 
 module_init(fwserial_init);
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index 3602809..c768aad 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -15,6 +15,7 @@
 #include <linux/serial_reg.h>
 #include <linux/module.h>
 #include <linux/seq_file.h>
+#include <linux/debugfs.h>
 
 #include "dma_fifo.h"
 
@@ -338,6 +339,7 @@ struct fw_serial {
 	struct fw_card	  *card;
 	struct kref	  kref;
 
+	struct dentry	  *debugfs;
 	struct fwtty_peer *self;
 
 	struct list_head  list;
-- 
1.8.1.1

