Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935218Ab3DKNej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544Ab3DKN2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 04/26] ft1000: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: devel@driverdev.osuosl.org, Marek Belisko <marek.belisko@gmail.com>,
        Ondrej Zary <linux@rainbow-software.org>, viro@ZenIV.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 11 Apr 2013 14:28:10 +0100
Message-ID: <20130411132810.32763.81542.stgit@warthog.procyon.org.uk>
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
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marek Belisko <marek.belisko@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Ondrej Zary <linux@rainbow-software.org>
cc: devel@driverdev.osuosl.org
---

 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |  132 ++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |  131 +++++++++-----------
 2 files changed, 127 insertions(+), 136 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index 5337b41..4599fab 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 #include <linux/netdevice.h>
@@ -29,70 +30,55 @@
 #define FT1000_PROC "ft1000"
 #define MAX_FILE_LEN 255
 
-#define PUTM_TO_PAGE(len, page, args...) \
-	len += snprintf(page+len, PAGE_SIZE - len, args)
-
-#define PUTX_TO_PAGE(len, page, message, size, var) \
-	len += snprintf(page+len, PAGE_SIZE - len, message); \
+#define seq_putx(m, message, size, var) \
+	seq_printf(m, message);	\
 	for(i = 0; i < (size - 1); i++) { \
-		len += snprintf(page+len, PAGE_SIZE - len, "%02x:", var[i]); \
+		seq_printf(m, "%02x:", var[i]); \
 	} \
-	len += snprintf(page+len, PAGE_SIZE - len, "%02x\n", var[i])
+	seq_printf(m, "%02x\n", var[i])
 
-#define PUTD_TO_PAGE(len, page, message, size, var) \
-	len += snprintf(page+len, PAGE_SIZE - len, message); \
+#define seq_putd(m, message, size, var) \
+	seq_printf(m, message); \
 	for(i = 0; i < (size - 1); i++) { \
-		len += snprintf(page+len, PAGE_SIZE - len, "%d.", var[i]); \
+		seq_printf(m, "%d.", var[i]); \
 	} \
-	len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i])
+	seq_printf(m, "%d\n", var[i])
 
-static int ft1000ReadProc(char *page, char **start, off_t off,
-			  int count, int *eof, void *data)
+static int ft1000ReadProc(struct seq_file *m, void *v)
 {
-	struct net_device *dev;
-	int len;
-	int i;
-	struct ft1000_info *info;
-	char *status[] = {
+	static const char *status[] = {
 		"Idle (Disconnect)", "Searching", "Active (Connected)",
 		"Waiting for L2", "Sleep", "No Coverage", "", ""
 	};
-	char *signal[] = { "", "*", "**", "***", "****" };
+	static const char *signal[] = { "", "*", "**", "***", "****" };
+
+	struct net_device *dev = m->private;
+	struct ft1000_info *info = netdev_priv(dev);
+	int i;
 	int strength;
 	int quality;
 	struct timeval tv;
 	time_t delta;
 
-	dev = (struct net_device *)data;
-	info = netdev_priv(dev);
-
-	if (off > 0) {
-		*eof = 1;
-		return 0;
-	}
-
-	/* Wrap-around */
-
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		if (info->ProgConStat != 0xFF) {
 			info->LedStat =
 				ft1000_read_dpram(dev, FT1000_DSP_LED);
 			info->ConStat =
-				ft1000_read_dpram(dev,
-						  FT1000_DSP_CON_STATE);
+				ft1000_read_dpram(dev, FT1000_DSP_CON_STATE);
 		} else {
 			info->ConStat = 0xf;
 		}
 	} else {
 		if (info->ProgConStat != 0xFF) {
 			info->LedStat =
-				ntohs(ft1000_read_dpram_mag_16
-				  (dev, FT1000_MAG_DSP_LED,
-				   FT1000_MAG_DSP_LED_INDX));
+				ntohs(ft1000_read_dpram_mag_16(
+					      dev, FT1000_MAG_DSP_LED,
+					      FT1000_MAG_DSP_LED_INDX));
 			info->ConStat =
-				ntohs(ft1000_read_dpram_mag_16
-				  (dev, FT1000_MAG_DSP_CON_STATE,
-				   FT1000_MAG_DSP_CON_STATE_INDX));
+				ntohs(ft1000_read_dpram_mag_16(
+					      dev, FT1000_MAG_DSP_CON_STATE,
+					      FT1000_MAG_DSP_CON_STATE_INDX));
 		} else {
 			info->ConStat = 0xf;
 		}
@@ -135,36 +121,48 @@ static int ft1000ReadProc(char *page, char **start, off_t off,
 	}
 
 	do_gettimeofday(&tv);
-	delta = (tv.tv_sec - info->ConTm);
-	len = 0;
-	PUTM_TO_PAGE(len, page, "Connection Time: %02ld:%02ld:%02ld\n",
+	delta = tv.tv_sec - info->ConTm;
+	seq_printf(m, "Connection Time: %02ld:%02ld:%02ld\n",
 			 ((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
-	PUTM_TO_PAGE(len, page, "Connection Time[s]: %ld\n", delta);
-	PUTM_TO_PAGE(len, page, "Asic ID: %s\n",
-			 (info->AsicID) ==
+	seq_printf(m, "Connection Time[s]: %ld\n", delta);
+	seq_printf(m, "Asic ID: %s\n",
+			 info->AsicID ==
 			 ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
-	PUTX_TO_PAGE(len, page, "SKU: ", SKUSZ, info->Sku);
-	PUTX_TO_PAGE(len, page, "EUI64: ", EUISZ, info->eui64);
-	PUTD_TO_PAGE(len, page, "DSP version number: ", DSPVERSZ, info->DspVer);
-	PUTX_TO_PAGE(len, page, "Hardware Serial Number: ", HWSERNUMSZ,
-			 info->HwSerNum);
-	PUTX_TO_PAGE(len, page, "Caliberation Version: ", CALVERSZ,
-			 info->RfCalVer);
-	PUTD_TO_PAGE(len, page, "Caliberation Date: ", CALDATESZ,
-			 info->RfCalDate);
-	PUTM_TO_PAGE(len, page, "Media State: %s\n",
+	seq_putx(m, "SKU: ", SKUSZ, info->Sku);
+	seq_putx(m, "EUI64: ", EUISZ, info->eui64);
+	seq_putd(m, "DSP version number: ", DSPVERSZ, info->DspVer);
+	seq_putx(m, "Hardware Serial Number: ", HWSERNUMSZ, info->HwSerNum);
+	seq_putx(m, "Caliberation Version: ", CALVERSZ, info->RfCalVer);
+	seq_putd(m, "Caliberation Date: ", CALDATESZ, info->RfCalDate);
+	seq_printf(m, "Media State: %s\n",
 			 (info->mediastate) ? "link" : "no link");
-	PUTM_TO_PAGE(len, page, "Connection Status: %s\n",
-			 status[((info->ConStat) & 0x7)]);
-	PUTM_TO_PAGE(len, page, "RX packets: %ld\n", info->stats.rx_packets);
-	PUTM_TO_PAGE(len, page, "TX packets: %ld\n", info->stats.tx_packets);
-	PUTM_TO_PAGE(len, page, "RX bytes: %ld\n", info->stats.rx_bytes);
-	PUTM_TO_PAGE(len, page, "TX bytes: %ld\n", info->stats.tx_bytes);
-	PUTM_TO_PAGE(len, page, "Signal Strength: %s\n", signal[strength]);
-	PUTM_TO_PAGE(len, page, "Signal Quality: %s\n", signal[quality]);
-	return len;
+	seq_printf(m, "Connection Status: %s\n", status[info->ConStat & 0x7]);
+	seq_printf(m, "RX packets: %ld\n", info->stats.rx_packets);
+	seq_printf(m, "TX packets: %ld\n", info->stats.tx_packets);
+	seq_printf(m, "RX bytes: %ld\n", info->stats.rx_bytes);
+	seq_printf(m, "TX bytes: %ld\n", info->stats.tx_bytes);
+	seq_printf(m, "Signal Strength: %s\n", signal[strength]);
+	seq_printf(m, "Signal Quality: %s\n", signal[quality]);
+	return 0;
+}
+
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int ft1000_proc_open(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *e = PDE(inode);
+	struct net_device *dev = e->data;
+	return single_open(file, ft1000ReadProc, dev);
 }
 
+static const struct file_operations ft1000_proc_fops = {
+	.open		= ft1000_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int ft1000NotifyProc(struct notifier_block *this, unsigned long event,
 				void *ptr)
 {
@@ -176,8 +174,8 @@ static int ft1000NotifyProc(struct notifier_block *this, unsigned long event,
 	switch (event) {
 	case NETDEV_CHANGENAME:
 		remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
-		create_proc_read_entry(dev->name, 0644, info->ft1000_proc_dir,
-					   ft1000ReadProc, dev);
+		proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
+				 &ft1000_proc_fops, dev);
 		snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
 		break;
 	}
@@ -195,8 +193,10 @@ void ft1000InitProc(struct net_device *dev)
 	info = netdev_priv(dev);
 
 	info->ft1000_proc_dir = proc_mkdir(FT1000_PROC, init_net.proc_net);
-	create_proc_read_entry(dev->name, 0644, info->ft1000_proc_dir,
-				   ft1000ReadProc, dev);
+
+	proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
+			 &ft1000_proc_fops, dev);
+
 	snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
 	register_netdevice_notifier(&ft1000_netdev_notifier);
 }
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index b996406..f0b5552 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/netdevice.h>
 
 
@@ -30,22 +31,17 @@
 #define FT1000_PROC_DIR "ft1000"
 
 
-#define PUTM_TO_PAGE(len,page,args...) \
-	len += snprintf(page+len, PAGE_SIZE - len, args)
+#define seq_putx(m, message, size, var) \
+	seq_printf(m, message);	\
+	for(i = 0; i < (size - 1); i++) \
+		seq_printf(m, "%02x:", var[i]); \
+	seq_printf(m, "%02x\n", var[i])
 
-#define PUTX_TO_PAGE(len,page,message,size,var) \
-	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for (i = 0; i < (size - 1); i++) {\
-		len += snprintf(page+len, PAGE_SIZE - len, "%02x:", var[i]); \
-	} \
-	len += snprintf(page+len, PAGE_SIZE - len, "%02x\n", var[i])
-
-#define PUTD_TO_PAGE(len,page,message,size,var) \
-	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for (i = 0; i < (size - 1); i++) {\
-		len += snprintf(page+len, PAGE_SIZE - len, "%d.", var[i]); \
-	} \
-	len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i])
+#define seq_putd(m, message, size, var) \
+	seq_printf(m, message); \
+	for(i = 0; i < (size - 1); i++) \
+		seq_printf(m, "%d.", var[i]); \
+	seq_printf(m, "%d\n", var[i])
 
 
 #define FTNET_PROC init_net.proc_net
@@ -55,19 +51,9 @@ int ft1000_read_dpram16 (struct ft1000_usb *ft1000dev, u16 indx,
 			 u8 *buffer, u8 highlow);
 
 
-static int
-ft1000ReadProc(char *page, char **start, off_t off, int count, int *eof,
-		void *data)
+static int ft1000ReadProc(struct seq_file *m, void *v)
 {
-	struct net_device *dev;
-	int len;
-	int i;
-	unsigned short ledStat;
-	unsigned short conStat;
-
-	struct ft1000_info *info;
-
-	char *status[] = { 
+	static const char *status[] = { 
 		"Idle (Disconnect)", 
 		"Searching",
 		"Active (Connected)",
@@ -77,22 +63,18 @@ ft1000ReadProc(char *page, char **start, off_t off, int count, int *eof,
 		"",
 		"",
 	};
+	static const char *signal[] = { "", "*", "**", "***", "****" };
 
-	char *signal[] = { "", "*", "**", "***", "****" };
+	struct net_device *dev = m->private;
+	struct ft1000_info *info = netdev_priv(dev);
+	int i;
+	unsigned short ledStat;
+	unsigned short conStat;
 	int strength;
 	int quality;
 	struct timeval tv;
 	time_t delta;
 
-	dev = (struct net_device *) data;
-	info = netdev_priv(dev);
-
-	if (off > 0) {
-		*eof = 1;
-		return 0;
-	}
-
-
 	if (info->ProgConStat != 0xFF) {
 		ft1000_read_dpram16(info->priv, FT1000_MAG_DSP_LED,
 			   (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
@@ -144,36 +126,45 @@ ft1000ReadProc(char *page, char **start, off_t off, int count, int *eof,
 		quality = 0;
 	}
 
-	len = 0;
-	PUTM_TO_PAGE(len, page, "Connection Time: %02ld:%02ld:%02ld\n",
+	seq_printf(m, "Connection Time: %02ld:%02ld:%02ld\n",
       		((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
-	PUTM_TO_PAGE(len, page, "Connection Time[s]: %ld\n", delta);
-	PUTM_TO_PAGE(len, page, "Asic ID: %s\n",
-      	(info->AsicID) ==
-      	ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
-	PUTX_TO_PAGE(len, page, "SKU: ", SKUSZ, info->Sku);
-	PUTX_TO_PAGE(len, page, "EUI64: ", EUISZ, info->eui64);
-	PUTD_TO_PAGE(len, page, "DSP version number: ", DSPVERSZ, info->DspVer);
-	PUTX_TO_PAGE(len, page, "Hardware Serial Number: ", HWSERNUMSZ,
-      		info->HwSerNum);
-	PUTX_TO_PAGE(len, page, "Caliberation Version: ", CALVERSZ,
-      		info->RfCalVer);
-	PUTD_TO_PAGE(len, page, "Caliberation Date: ", CALDATESZ,
-		info->RfCalDate);
-	PUTM_TO_PAGE(len, page, "Media State: %s\n",
-      		(info->mediastate) ? "link" : "no link");
-	PUTM_TO_PAGE(len, page, "Connection Status: %s\n",
-      		status[((info->ConStat) & 0x7)]);
-	PUTM_TO_PAGE(len, page, "RX packets: %ld\n", info->stats.rx_packets);
-	PUTM_TO_PAGE(len, page, "TX packets: %ld\n", info->stats.tx_packets);
-	PUTM_TO_PAGE(len, page, "RX bytes: %ld\n", info->stats.rx_bytes);
-	PUTM_TO_PAGE(len, page, "TX bytes: %ld\n", info->stats.tx_bytes);
-	PUTM_TO_PAGE(len, page, "Signal Strength: %s\n", signal[strength]);
-	PUTM_TO_PAGE(len, page, "Signal Quality: %s\n", signal[quality]);
-
-	return len;
+	seq_printf(m, "Connection Time[s]: %ld\n", delta);
+	seq_printf(m, "Asic ID: %s\n",
+      	(info->AsicID) == ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
+	seq_putx(m, "SKU: ", SKUSZ, info->Sku);
+	seq_putx(m, "EUI64: ", EUISZ, info->eui64);
+	seq_putd(m, "DSP version number: ", DSPVERSZ, info->DspVer);
+	seq_putx(m, "Hardware Serial Number: ", HWSERNUMSZ, info->HwSerNum);
+	seq_putx(m, "Caliberation Version: ", CALVERSZ, info->RfCalVer);
+	seq_putd(m, "Caliberation Date: ", CALDATESZ, info->RfCalDate);
+	seq_printf(m, "Media State: %s\n", (info->mediastate) ? "link" : "no link");
+	seq_printf(m, "Connection Status: %s\n", status[info->ConStat & 0x7]);
+	seq_printf(m, "RX packets: %ld\n", info->stats.rx_packets);
+	seq_printf(m, "TX packets: %ld\n", info->stats.tx_packets);
+	seq_printf(m, "RX bytes: %ld\n", info->stats.rx_bytes);
+	seq_printf(m, "TX bytes: %ld\n", info->stats.tx_bytes);
+	seq_printf(m, "Signal Strength: %s\n", signal[strength]);
+	seq_printf(m, "Signal Quality: %s\n", signal[quality]);
+	return 0;
+}
+
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int ft1000_proc_open(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *e = PDE(inode);
+	struct net_device *dev = e->data;
+	return single_open(file, ft1000ReadProc, dev);
 }
 
+static const struct file_operations ft1000_proc_fops = {
+	.open		= ft1000_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int
 ft1000NotifyProc(struct notifier_block *this, unsigned long event, void *ptr)
 {
@@ -186,9 +177,9 @@ ft1000NotifyProc(struct notifier_block *this, unsigned long event, void *ptr)
 	switch (event) {
 	case NETDEV_CHANGENAME:
 		remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
-		ft1000_proc_file = create_proc_read_entry(dev->name, 0644,
-					info->ft1000_proc_dir,
-					ft1000ReadProc, dev);
+		ft1000_proc_file =
+			proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
+					 &ft1000_proc_fops, dev);
 		snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
 		break;
 	}
@@ -217,10 +208,10 @@ int ft1000_init_proc(struct net_device *dev)
 	}
 
 	ft1000_proc_file =
-		create_proc_read_entry(dev->name, 0644,
-			info->ft1000_proc_dir, ft1000ReadProc, dev);
+		proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
+				 &ft1000_proc_fops, dev);
 
-	if (ft1000_proc_file == NULL) {
+	if (!ft1000_proc_file) {
 		printk(KERN_WARNING "Unable to create /proc entry.\n");
 		goto fail_entry;
 	}

