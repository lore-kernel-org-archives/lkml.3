Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab3DKNd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:33:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934865Ab3DKN2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 03/26] rtl8187se: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Merello <andreamrl@tiscali.it>, linux-wireless@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Maxim Mikityanskiy <maxtram95@gmail.com>, viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:28:02 +0100
Message-ID: <20130411132802.32763.74672.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.  Whilst we're at it, reduce the
number of show functions where we can share them.

Question: Do any of the registers read by proc_get_registers() have side
effects upon reading?  If so, locking will be required.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Maxim Mikityanskiy <maxtram95@gmail.com>
cc: YAMANE Toshiaki <yamanetoshi@gmail.com>
cc: Bill Pemberton <wfp5p@virginia.edu>
cc: Andrea Merello <andreamrl@tiscali.it>
cc: linux-wireless@vger.kernel.org
cc: devel@driverdev.osuosl.org
---

 drivers/staging/rtl8187se/r8180_core.c |  135 +++++++++++++++-----------------
 1 file changed, 64 insertions(+), 71 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index d10d75e..a9bc82b 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -36,6 +36,8 @@
 #include <linux/syscalls.h>
 #include <linux/eeprom_93cx6.h>
 #include <linux/interrupt.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include "r8180_hw.h"
 #include "r8180.h"
@@ -204,51 +206,35 @@ void rtl8180_start_tx_beacon(struct net_device *dev);
 
 static struct proc_dir_entry *rtl8180_proc;
 
-static int proc_get_registers(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_registers(struct seq_file *m, void *v)
 {
-	struct net_device *dev = data;
-	int len = 0;
-	int i, n;
-	int max = 0xff;
+	struct net_device *dev = m->private;
+	int i, n, max = 0xff;
 
 	/* This dump the current register page */
 	for (n = 0; n <= max;) {
-		len += snprintf(page + len, count - len, "\nD:  %2x > ", n);
+		seq_printf(m, "\nD:  %2x > ", n);
 
 		for (i = 0; i < 16 && n <= max; i++, n++)
-			len += snprintf(page + len, count - len, "%2x ",
-					read_nic_byte(dev, n));
+			seq_printf(m, "%2x ", read_nic_byte(dev, n));
 	}
-	len += snprintf(page + len, count - len, "\n");
-
-	*eof = 1;
-	return len;
+	seq_putc(m, '\n');
+	return 0;
 }
 
 int get_curr_tx_free_desc(struct net_device *dev, int priority);
 
-static int proc_get_stats_hw(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_hw(struct seq_file *m, void *v)
 {
-	int len = 0;
-
-	*eof = 1;
-	return len;
+	return 0;
 }
 
-static int proc_get_stats_rx(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_rx(struct seq_file *m, void *v)
 {
-	struct net_device *dev = data;
+	struct net_device *dev = m->private;
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
-	int len = 0;
-
-	len += snprintf(page + len, count - len,
+	seq_printf(m,
 		"RX OK: %lu\n"
 		"RX Retry: %lu\n"
 		"RX CRC Error(0-500): %lu\n"
@@ -263,22 +249,17 @@ static int proc_get_stats_rx(char *page, char **start,
 		priv->stats.rxicverr
 		);
 
-	*eof = 1;
-	return len;
+	return 0;
 }
 
-static int proc_get_stats_tx(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_tx(struct seq_file *m, void *v)
 {
-	struct net_device *dev = data;
+	struct net_device *dev = m->private;
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-
-	int len = 0;
 	unsigned long totalOK;
 
 	totalOK = priv->stats.txnpokint+priv->stats.txhpokint+priv->stats.txlpokint;
-	len += snprintf(page + len, count - len,
+	seq_printf(m,
 		"TX OK: %lu\n"
 		"TX Error: %lu\n"
 		"TX Retry: %lu\n"
@@ -291,8 +272,7 @@ static int proc_get_stats_tx(char *page, char **start,
 		priv->stats.txbeaconerr
 	);
 
-	*eof = 1;
-	return len;
+	return 0;
 }
 
 void rtl8180_proc_module_init(void)
@@ -318,9 +298,44 @@ void rtl8180_proc_remove_one(struct net_device *dev)
 	}
 }
 
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int rtl8180_proc_open(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *e = PDE(inode);
+	struct net_device *dev = e->parent->data;
+	int (*show)(struct seq_file *, void *) = e->data;
+
+	return single_open(file, show, dev);
+}
+
+static const struct file_operations rtl8180_proc_fops = {
+	.open		= rtl8180_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+/*
+ * Table of proc files we need to create.
+ */
+struct rtl8180_proc_file {
+	char name[12];
+	int (*show)(struct seq_file *, void *);
+};
+
+static const struct rtl8180_proc_file rtl8180_proc_files[] = {
+	{ "stats-hw",	&proc_get_stats_hw },
+	{ "stats-rx",	&proc_get_stats_rx },
+	{ "stats-tx",	&proc_get_stats_tx },
+	{ "registers",	&proc_get_registers },
+	{ "" }
+};
+
 void rtl8180_proc_init_one(struct net_device *dev)
 {
-	struct proc_dir_entry *e;
+	const struct rtl8180_proc_file *f;
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
 
 	priv->dir_dev = rtl8180_proc;
@@ -329,38 +344,16 @@ void rtl8180_proc_init_one(struct net_device *dev)
 		      dev->name);
 		return;
 	}
+	priv->dir_dev->data = dev;
 
-	e = create_proc_read_entry("stats-hw", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_stats_hw, dev);
-	if (!e) {
-		DMESGE("Unable to initialize "
-		      "/proc/net/r8180/%s/stats-hw\n",
-		      dev->name);
-	}
-
-	e = create_proc_read_entry("stats-rx", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_stats_rx, dev);
-	if (!e) {
-		DMESGE("Unable to initialize "
-		      "/proc/net/r8180/%s/stats-rx\n",
-		      dev->name);
-	}
-
-
-	e = create_proc_read_entry("stats-tx", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_stats_tx, dev);
-	if (!e) {
-		DMESGE("Unable to initialize "
-		      "/proc/net/r8180/%s/stats-tx\n",
-		      dev->name);
-	}
-
-	e = create_proc_read_entry("registers", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_registers, dev);
-	if (!e) {
-		DMESGE("Unable to initialize "
-		      "/proc/net/r8180/%s/registers\n",
-		      dev->name);
+	for (f = rtl8180_proc_files; f->name[0]; f++) {
+		if (!proc_create_data(f->name, S_IFREG | S_IRUGO,
+				      priv->dir_dev,
+				      &rtl8180_proc_fops, f->show)) {
+			DMESGE("Unable to initialize /proc/net/r8180/%s\n",
+			       f->name);
+			return;
+		}
 	}
 }
 

