Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146Ab3DKN2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:28:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757562Ab3DKN2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 02/26] rtl8192u: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerry Chuang <jerry-chuang@realtek.com>,
        linux-wireless@vger.kernel.org, viro@ZenIV.linux.org.uk
Date: Thu, 11 Apr 2013 14:27:54 +0100
Message-ID: <20130411132754.32763.591.stgit@warthog.procyon.org.uk>
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

Note: proc_get_stats_ap() should probably use seq_file iteration rather than
list_for_each_entry().

Further note: There appears to be a lot of locking missing in this file to
defend against concurrent access by the driver doing normal operations.
Notably, ieee->network_list traversal and RWCAM/RCAMO command/response access.
Further, do any of the registers read have side effects upon reading?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jerry Chuang <jerry-chuang@realtek.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-wireless@vger.kernel.org
cc: devel@driverdev.osuosl.org
---

 drivers/staging/rtl8192u/r8192U_core.c |  215 ++++++++++++++------------------
 1 file changed, 92 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index f7de2f6..0bec385 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -71,6 +71,8 @@ double __extendsfdf2(float a) {return a;}
 //#include "r8192xU_phyreg.h"
 #include <linux/usb.h>
 #include <linux/slab.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 // FIXME: check if 2.6.7 is ok
 
 #ifdef CONFIG_RTL8192_PM
@@ -472,103 +474,73 @@ void watch_dog_timer_callback(unsigned long data);
 
 static struct proc_dir_entry *rtl8192_proc;
 
-static int proc_get_stats_ap(char *page, char **start, off_t offset, int count,
-							int *eof, void *data)
+static int proc_get_stats_ap(struct seq_file *m, void *v)
 {
-	struct net_device *dev = data;
+	struct net_device *dev = m->private;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
 	struct ieee80211_network *target;
 
-	int len = 0;
-
 	list_for_each_entry(target, &ieee->network_list, list) {
-
-		len += snprintf(page + len, count - len, "%s ", target->ssid);
-
+		const char *wpa = "non_WPA";
 		if (target->wpa_ie_len > 0 || target->rsn_ie_len > 0)
-			len += snprintf(page + len, count - len, "WPA\n");
-		else
-			len += snprintf(page + len, count - len, "non_WPA\n");
+			wpa = "WPA";
+
+		seq_printf(m, "%s %s\n", target->ssid, wpa);
 	}
 
-	*eof = 1;
-	return len;
+	return 0;
 }
 
-static int proc_get_registers(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_registers(struct seq_file *m, void *v)
 {
-	struct net_device *dev = data;
-//	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-
-	int len = 0;
-	int i,n;
+	struct net_device *dev = m->private;
+	int i,n, max = 0xff;
 
-	int max=0xff;
-
-	/* This dump the current register page */
-	len += snprintf(page + len, count - len,
-			"\n####################page 0##################\n ");
+	seq_puts(m, "\n####################page 0##################\n ");
 
 	for (n=0;n<=max;) {
 		//printk( "\nD: %2x> ", n);
-		len += snprintf(page + len, count - len,
-			"\nD:  %2x > ",n);
+		seq_printf(m, "\nD:  %2x > ",n);
 
 		for (i=0;i<16 && n<=max;i++,n++)
-			len += snprintf(page + len, count - len,
-					"%2x ",read_nic_byte(dev,0x000|n));
+			seq_printf(m, "%2x ",read_nic_byte(dev,0x000|n));
 
 		//	printk("%2x ",read_nic_byte(dev,n));
 	}
-	len += snprintf(page + len, count - len,
-			"\n####################page 1##################\n ");
+
+	seq_puts(m, "\n####################page 1##################\n ");
 	for (n=0;n<=max;) {
 		//printk( "\nD: %2x> ", n);
-		len += snprintf(page + len, count - len,
-				"\nD:  %2x > ",n);
+		seq_printf(m, "\nD:  %2x > ",n);
 
 		for (i=0;i<16 && n<=max;i++,n++)
-			len += snprintf(page + len, count - len,
-					"%2x ",read_nic_byte(dev,0x100|n));
+			seq_printf(m, "%2x ",read_nic_byte(dev,0x100|n));
 
 		//      printk("%2x ",read_nic_byte(dev,n));
 	}
-	len += snprintf(page + len, count - len,
-			"\n####################page 3##################\n ");
+
+	seq_puts(m, "\n####################page 3##################\n ");
 	for (n=0;n<=max;) {
 		//printk( "\nD: %2x> ", n);
-		len += snprintf(page + len, count - len,
-			"\nD:  %2x > ",n);
+		seq_printf(m, "\nD:  %2x > ",n);
 
 		for(i=0;i<16 && n<=max;i++,n++)
-			len += snprintf(page + len, count - len,
-					"%2x ",read_nic_byte(dev,0x300|n));
+			seq_printf(m, "%2x ",read_nic_byte(dev,0x300|n));
 
 		//      printk("%2x ",read_nic_byte(dev,n));
 	}
 
-	len += snprintf(page + len, count - len,"\n");
-	*eof = 1;
-	return len;
+	seq_putc(m, '\n');
+	return 0;
 }
 
-
-
-
-
-static int proc_get_stats_tx(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_tx(struct seq_file *m, void *v)
 {
-	struct net_device *dev = data;
+	struct net_device *dev = m->private;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 
-	int len = 0;
-
-	len += snprintf(page + len, count - len,
+	seq_printf(m,
 		"TX VI priority ok int: %lu\n"
 		"TX VI priority error int: %lu\n"
 		"TX VO priority ok int: %lu\n"
@@ -629,22 +601,15 @@ static int proc_get_stats_tx(char *page, char **start,
 //		priv->stats.txbeaconerr
 		);
 
-	*eof = 1;
-	return len;
+	return 0;
 }
 
-
-
-static int proc_get_stats_rx(char *page, char **start,
-			  off_t offset, int count,
-			  int *eof, void *data)
+static int proc_get_stats_rx(struct seq_file *m, void *v)
 {
-	struct net_device *dev = data;
+	struct net_device *dev = m->private;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 
-	int len = 0;
-
-	len += snprintf(page + len, count - len,
+	seq_printf(m,
 		"RX packets: %lu\n"
 		"RX urb status error: %lu\n"
 		"RX invalid urb error: %lu\n",
@@ -652,9 +617,9 @@ static int proc_get_stats_rx(char *page, char **start,
 		priv->stats.rxstaterr,
 		priv->stats.rxurberr);
 
-	*eof = 1;
-	return len;
+	return 0;
 }
+
 void rtl8192_proc_module_init(void)
 {
 	RT_TRACE(COMP_INIT, "Initializing proc filesystem");
@@ -667,74 +632,78 @@ void rtl8192_proc_module_remove(void)
 	remove_proc_entry(RTL819xU_MODULE_NAME, init_net.proc_net);
 }
 
-
-void rtl8192_proc_remove_one(struct net_device *dev)
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int rtl8192_proc_open(struct inode *inode, struct file *file)
 {
-	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-
+	struct proc_dir_entry *e = PDE(inode);
+	struct net_device *dev = e->parent->data;
+	int (*show)(struct seq_file *, void *) = e->data;
 
-	if (priv->dir_dev) {
-	//	remove_proc_entry("stats-hw", priv->dir_dev);
-		remove_proc_entry("stats-tx", priv->dir_dev);
-		remove_proc_entry("stats-rx", priv->dir_dev);
-	//	remove_proc_entry("stats-ieee", priv->dir_dev);
-		remove_proc_entry("stats-ap", priv->dir_dev);
-		remove_proc_entry("registers", priv->dir_dev);
-	//	remove_proc_entry("cck-registers",priv->dir_dev);
-	//	remove_proc_entry("ofdm-registers",priv->dir_dev);
-		//remove_proc_entry(dev->name, rtl8192_proc);
-		remove_proc_entry("wlan0", rtl8192_proc);
-		priv->dir_dev = NULL;
-	}
+	return single_open(file, show, dev);
 }
 
+static const struct file_operations rtl8192_proc_fops = {
+	.open		= rtl8192_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+/*
+ * Table of proc files we need to create.
+ */
+struct rtl8192_proc_file {
+	char name[12];
+	int (*show)(struct seq_file *, void *);
+};
+
+static const struct rtl8192_proc_file rtl8192_proc_files[] = {
+	{ "stats-rx",	&proc_get_stats_rx },
+	{ "stats-tx",	&proc_get_stats_tx },
+	{ "stats-ap",	&proc_get_stats_ap },
+	{ "registers",	&proc_get_registers },
+	{ "" }
+};
 
 void rtl8192_proc_init_one(struct net_device *dev)
 {
-	struct proc_dir_entry *e;
+	const struct rtl8192_proc_file *f;
 	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-	priv->dir_dev = proc_mkdir(dev->name, rtl8192_proc);
-	if (!priv->dir_dev) {
-		RT_TRACE(COMP_ERR, "Unable to initialize /proc/net/rtl8192/%s\n",
-		      dev->name);
-		return;
-	}
-	e = create_proc_read_entry("stats-rx", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_stats_rx, dev);
-
-	if (!e) {
-		RT_TRACE(COMP_ERR,"Unable to initialize "
-		      "/proc/net/rtl8192/%s/stats-rx\n",
-		      dev->name);
-	}
-
 
-	e = create_proc_read_entry("stats-tx", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_stats_tx, dev);
-
-	if (!e) {
-		RT_TRACE(COMP_ERR, "Unable to initialize "
-		      "/proc/net/rtl8192/%s/stats-tx\n",
-		      dev->name);
+	if (rtl8192_proc) {
+		priv->dir_dev = proc_mkdir(dev->name, rtl8192_proc);
+		if (!priv->dir_dev) {
+			RT_TRACE(COMP_ERR, "Unable to initialize /proc/net/rtl8192/%s\n",
+				 dev->name);
+			return;
+		}
+		priv->dir_dev->data = dev;
+
+		for (f = rtl8192_proc_files; f->name[0]; f++) {
+			if (!proc_create_data(f->name, S_IFREG | S_IRUGO,
+					      priv->dir_dev,
+					      rtl8192_proc_fops, f->show)) {
+				RT_TRACE(COMP_ERR, "Unable to initialize "
+					 "/proc/net/rtl8192/%s/%s\n",
+					 dev->name, f->name);
+				return;
+			}
+		}
 	}
+}
 
-	e = create_proc_read_entry("stats-ap", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_stats_ap, dev);
-
-	if (!e) {
-		RT_TRACE(COMP_ERR, "Unable to initialize "
-		      "/proc/net/rtl8192/%s/stats-ap\n",
-		      dev->name);
-	}
+void rtl8192_proc_remove_one(struct net_device *dev)
+{
+	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
 
-	e = create_proc_read_entry("registers", S_IFREG | S_IRUGO,
-				   priv->dir_dev, proc_get_registers, dev);
-	if (!e) {
-		RT_TRACE(COMP_ERR, "Unable to initialize "
-		      "/proc/net/rtl8192/%s/registers\n",
-		      dev->name);
+	if (priv->dir_dev) {
+		remove_proc_subtree(dev->name, rtl8192_proc);
+		priv->dir_dev = NULL;
 	}
 }
+
 /****************************************************************************
    -----------------------------MISC STUFF-------------------------
 *****************************************************************************/

