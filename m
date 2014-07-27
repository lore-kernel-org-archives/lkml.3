Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599AbaG0ScO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:32:14 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:54284 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaG0ScM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:32:12 -0400
From: Nicolas Thery <nthery@gmail.com>
To: marek.belisko@gmail.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, nthery@gmail.com
Subject: [PATCH] staging: ft1000: remove procfs entries
Date: Sun, 27 Jul 2014 20:32:06 +0200
Message-Id: <1406485926-18820-1-git-send-email-nthery@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch started as a fix to some checkpatch complaints in ft1000
procfs code but Greg suggested to remove the procfs entries altogether:

http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2014-July/055594.html

Signed-off-by: Nicolas Thery <nthery@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/Makefile      |   3 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   2 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   4 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c | 211 ------------------
 drivers/staging/ft1000/ft1000-usb/Makefile         |   2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    | 241 ---------------------
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   8 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   3 -
 drivers/staging/ft1000/ft1000.h                    |   2 -
 9 files changed, 2 insertions(+), 474 deletions(-)
 delete mode 100644 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
 delete mode 100644 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/Makefile b/drivers/staging/ft1000/ft1000-pcmcia/Makefile
index 660b7a5..715de3f 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/Makefile
+++ b/drivers/staging/ft1000/ft1000-pcmcia/Makefile
@@ -1,3 +1,2 @@
 obj-$(CONFIG_FT1000_PCMCIA) = ft1000_pcmcia.o
-ft1000_pcmcia-y := ft1000_hw.o ft1000_dnld.o ft1000_proc.o ft1000_cs.o
-
+ft1000_pcmcia-y := ft1000_hw.o ft1000_dnld.o ft1000_cs.o
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
index 0c21ac6..1d52738 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -47,8 +47,6 @@ extern struct net_device *init_ft1000_card(struct pcmcia_device *link,
 extern void stop_ft1000_card(struct net_device *dev);
 extern int card_download(struct net_device *dev, const u8 *pFileStart,
 			 size_t FileLength);
-extern void ft1000InitProc(struct net_device *dev);
-extern void ft1000CleanupProc(struct net_device *dev);
 
 extern u16 ft1000_read_dpram(struct net_device *dev, int offset);
 extern void card_bootload(struct net_device *dev);
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index a6158be..21f09fe 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -19,8 +19,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/proc_fs.h>
-
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
@@ -2102,7 +2100,6 @@ void stop_ft1000_card(struct net_device *dev)
 	release_region(dev->base_addr,256);
 	release_firmware(fw_entry);
 	flarion_ft1000_cnt--;
-	ft1000CleanupProc(dev);
 
 }
 
@@ -2247,7 +2244,6 @@ struct net_device *init_ft1000_card(struct pcmcia_device *link,
 
 	ft1000_enable_interrupts(dev);
 
-	ft1000InitProc(dev);
 	ft1000_card_present = 1;
 	dev->ethtool_ops = &ops;
 	printk(KERN_INFO "ft1000: %s: addr 0x%04lx irq %d, MAC addr %pM\n",
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
deleted file mode 100644
index 88f6f9c..0000000
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ /dev/null
@@ -1,211 +0,0 @@
-/*---------------------------------------------------------------------------
-   FT1000 driver for Flarion Flash OFDM NIC Device
-
-   Copyright (C) 2006 Patrik Ostrihon, All rights reserved.
-   Copyright (C) 2006 ProWeb Consulting, a.s, All rights reserved.
-
-   This program is free software; you can redistribute it and/or modify it
-   under the terms of the GNU General Public License as published by the Free
-   Software Foundation; either version 2 of the License, or (at your option) any
-   later version. This program is distributed in the hope that it will be useful,
-   but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
-   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
-   more details. You should have received a copy of the GNU General Public
-   License along with this program; if not, write to the
-   Free Software Foundation, Inc., 59 Temple Place -
-   Suite 330, Boston, MA 02111-1307, USA.
------------------------------------------------------------------------------*/
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/string.h>
-#include <linux/vmalloc.h>
-#include <linux/netdevice.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include "ft1000.h"
-
-#define FT1000_PROC "ft1000"
-#define MAX_FILE_LEN 255
-
-#define seq_putx(m, message, size, var) \
-	seq_printf(m, message);	\
-	for (i = 0; i < (size - 1); i++) { \
-		seq_printf(m, "%02x:", var[i]); \
-	} \
-	seq_printf(m, "%02x\n", var[i])
-
-#define seq_putd(m, message, size, var) \
-	seq_printf(m, message); \
-	for (i = 0; i < (size - 1); i++) { \
-		seq_printf(m, "%d.", var[i]); \
-	} \
-	seq_printf(m, "%d\n", var[i])
-
-static int ft1000ReadProc(struct seq_file *m, void *v)
-{
-	static const char *status[] = {
-		"Idle (Disconnect)", "Searching", "Active (Connected)",
-		"Waiting for L2", "Sleep", "No Coverage", "", ""
-	};
-	static const char *signal[] = { "", "*", "**", "***", "****" };
-
-	struct net_device *dev = m->private;
-	struct ft1000_info *info = netdev_priv(dev);
-	int i;
-	int strength;
-	int quality;
-	struct timeval tv;
-	time_t delta;
-
-	if (info->AsicID == ELECTRABUZZ_ID) {
-		if (info->ProgConStat != 0xFF) {
-			info->LedStat =
-				ft1000_read_dpram(dev, FT1000_DSP_LED);
-			info->ConStat =
-				ft1000_read_dpram(dev, FT1000_DSP_CON_STATE);
-		} else {
-			info->ConStat = 0xf;
-		}
-	} else {
-		if (info->ProgConStat != 0xFF) {
-			info->LedStat =
-				ntohs(ft1000_read_dpram_mag_16(
-					      dev, FT1000_MAG_DSP_LED,
-					      FT1000_MAG_DSP_LED_INDX));
-			info->ConStat =
-				ntohs(ft1000_read_dpram_mag_16(
-					      dev, FT1000_MAG_DSP_CON_STATE,
-					      FT1000_MAG_DSP_CON_STATE_INDX));
-		} else {
-			info->ConStat = 0xf;
-		}
-	}
-
-	i = (info->LedStat) & 0xf;
-	switch (i) {
-	case 0x1:
-		strength = 1;
-		break;
-	case 0x3:
-		strength = 2;
-		break;
-	case 0x7:
-		strength = 3;
-		break;
-	case 0xf:
-		strength = 4;
-		break;
-	default:
-		strength = 0;
-	}
-
-	i = (info->LedStat >> 8) & 0xf;
-	switch (i) {
-	case 0x1:
-		quality = 1;
-		break;
-	case 0x3:
-		quality = 2;
-		break;
-	case 0x7:
-		quality = 3;
-		break;
-	case 0xf:
-		quality = 4;
-		break;
-	default:
-		quality = 0;
-	}
-
-	do_gettimeofday(&tv);
-	delta = tv.tv_sec - info->ConTm;
-	seq_printf(m, "Connection Time: %02ld:%02ld:%02ld\n",
-			 ((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
-	seq_printf(m, "Connection Time[s]: %ld\n", delta);
-	seq_printf(m, "Asic ID: %s\n",
-			 info->AsicID ==
-			 ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
-	seq_putx(m, "SKU: ", SKUSZ, info->Sku);
-	seq_putx(m, "EUI64: ", EUISZ, info->eui64);
-	seq_putd(m, "DSP version number: ", DSPVERSZ, info->DspVer);
-	seq_putx(m, "Hardware Serial Number: ", HWSERNUMSZ, info->HwSerNum);
-	seq_putx(m, "Caliberation Version: ", CALVERSZ, info->RfCalVer);
-	seq_putd(m, "Caliberation Date: ", CALDATESZ, info->RfCalDate);
-	seq_printf(m, "Media State: %s\n",
-			 (info->mediastate) ? "link" : "no link");
-	seq_printf(m, "Connection Status: %s\n", status[info->ConStat & 0x7]);
-	seq_printf(m, "RX packets: %ld\n", info->stats.rx_packets);
-	seq_printf(m, "TX packets: %ld\n", info->stats.tx_packets);
-	seq_printf(m, "RX bytes: %ld\n", info->stats.rx_bytes);
-	seq_printf(m, "TX bytes: %ld\n", info->stats.tx_bytes);
-	seq_printf(m, "Signal Strength: %s\n", signal[strength]);
-	seq_printf(m, "Signal Quality: %s\n", signal[quality]);
-	return 0;
-}
-
-/*
- * seq_file wrappers for procfile show routines.
- */
-static int ft1000_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ft1000ReadProc, PDE_DATA(inode));
-}
-
-static const struct file_operations ft1000_proc_fops = {
-	.open		= ft1000_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int ft1000NotifyProc(struct notifier_block *this, unsigned long event,
-				void *ptr)
-{
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct ft1000_info *info;
-
-	info = netdev_priv(dev);
-
-	switch (event) {
-	case NETDEV_CHANGENAME:
-		remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
-		proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
-				 &ft1000_proc_fops, dev);
-		snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
-		break;
-	}
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block ft1000_netdev_notifier = {
-	.notifier_call = ft1000NotifyProc
-};
-
-void ft1000InitProc(struct net_device *dev)
-{
-	struct ft1000_info *info;
-
-	info = netdev_priv(dev);
-
-	info->ft1000_proc_dir = proc_mkdir(FT1000_PROC, init_net.proc_net);
-
-	proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
-			 &ft1000_proc_fops, dev);
-
-	snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
-	register_netdevice_notifier(&ft1000_netdev_notifier);
-}
-
-void ft1000CleanupProc(struct net_device *dev)
-{
-	struct ft1000_info *info;
-
-	info = netdev_priv(dev);
-
-	remove_proc_entry(dev->name, info->ft1000_proc_dir);
-	remove_proc_entry(FT1000_PROC, init_net.proc_net);
-	unregister_netdevice_notifier(&ft1000_netdev_notifier);
-}
diff --git a/drivers/staging/ft1000/ft1000-usb/Makefile b/drivers/staging/ft1000/ft1000-usb/Makefile
index f0f5240..7c4b784 100644
--- a/drivers/staging/ft1000/ft1000-usb/Makefile
+++ b/drivers/staging/ft1000/ft1000-usb/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_FT1000_USB) += ft1000.o
 
-ft1000-y := ft1000_debug.o ft1000_download.o ft1000_hw.o ft1000_proc.o ft1000_usb.o
+ft1000-y := ft1000_debug.o ft1000_download.o ft1000_hw.o ft1000_usb.o
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
deleted file mode 100644
index e89b5d2..0000000
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ /dev/null
@@ -1,241 +0,0 @@
-/*
- * ft1000_proc.c - ft1000 proc interface
- *
- * Copyright	(C) 2009-2010 Quintec
- *		(C) 2010 Open-nandra
- *      <marek.belisko@open-nandra.com>
- *
- * This file is subject to the terms and conditions of the GNU General
- * Public License. See the file "COPYING" in the main directory of this
- * archive for more details.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-#include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/netdevice.h>
-
-
-#include "ft1000_usb.h"
-
-#define FT1000_PROC_DIR "ft1000"
-
-
-#define seq_putx(m, message, size, var) \
-	do { \
-		seq_printf(m, message);	\
-		for (i = 0; i < (size - 1); i++) \
-			seq_printf(m, "%02x:", var[i]); \
-		seq_printf(m, "%02x\n", var[i]);	\
-	} while (0)
-
-#define seq_putd(m, message, size, var) \
-	do { \
-		seq_printf(m, message); \
-		for (i = 0; i < (size - 1); i++) \
-			seq_printf(m, "%d.", var[i]); \
-		seq_printf(m, "%d\n", var[i]);	      \
-	} while (0)
-
-#define FTNET_PROC init_net.proc_net
-
-
-int ft1000_read_dpram16(struct ft1000_usb *ft1000dev, u16 indx,
-			 u8 *buffer, u8 highlow);
-
-
-static int ft1000ReadProc(struct seq_file *m, void *v)
-{
-	static const char *status[] = {
-		"Idle (Disconnect)",
-		"Searching",
-		"Active (Connected)",
-		"Waiting for L2",
-		"Sleep",
-		"No Coverage",
-		"",
-		"",
-	};
-	static const char *signal[] = { "", "*", "**", "***", "****" };
-
-	struct net_device *dev = m->private;
-	struct ft1000_info *info = netdev_priv(dev);
-	int i;
-	unsigned short ledStat;
-	unsigned short conStat;
-	int strength;
-	int quality;
-	struct timeval tv;
-	time_t delta;
-
-	if (info->ProgConStat != 0xFF) {
-		ft1000_read_dpram16(info->priv, FT1000_MAG_DSP_LED,
-			   (u8 *)&ledStat, FT1000_MAG_DSP_LED_INDX);
-		info->LedStat = ntohs(ledStat);
-
-		ft1000_read_dpram16(info->priv, FT1000_MAG_DSP_CON_STATE,
-			(u8 *)&conStat, FT1000_MAG_DSP_CON_STATE_INDX);
-		info->ConStat = ntohs(conStat);
-		do_gettimeofday(&tv);
-		delta = (tv.tv_sec - info->ConTm);
-	} else {
-		info->ConStat = 0xf;
-		delta = 0;
-	}
-
-	i = (info->LedStat) & 0xf;
-	switch (i) {
-	case 0x1:
-		strength = 1;
-		break;
-	case 0x3:
-		strength = 2;
-		break;
-	case 0x7:
-		strength = 3;
-		break;
-	case 0xf:
-		strength = 4;
-		break;
-	default:
-		strength = 0;
-	}
-
-	i = (info->LedStat >> 8) & 0xf;
-	switch (i) {
-	case 0x1:
-		quality = 1;
-		break;
-	case 0x3:
-		quality = 2;
-		break;
-	case 0x7:
-		quality = 3;
-		break;
-	case 0xf:
-		quality = 4;
-		break;
-	default:
-		quality = 0;
-	}
-
-	seq_printf(m, "Connection Time: %02ld:%02ld:%02ld\n",
-		((delta / 3600) % 24), ((delta / 60) % 60), (delta % 60));
-	seq_printf(m, "Connection Time[s]: %ld\n", delta);
-	seq_printf(m, "Asic ID: %s\n",
-	(info->AsicID) == ELECTRABUZZ_ID ? "ELECTRABUZZ ASIC" : "MAGNEMITE ASIC");
-	seq_putx(m, "SKU: ", SKUSZ, info->Sku);
-	seq_putx(m, "EUI64: ", EUISZ, info->eui64);
-	seq_putd(m, "DSP version number: ", DSPVERSZ, info->DspVer);
-	seq_putx(m, "Hardware Serial Number: ", HWSERNUMSZ, info->HwSerNum);
-	seq_putx(m, "Caliberation Version: ", CALVERSZ, info->RfCalVer);
-	seq_putd(m, "Caliberation Date: ", CALDATESZ, info->RfCalDate);
-	seq_printf(m, "Media State: %s\n", (info->mediastate) ? "link" : "no link");
-	seq_printf(m, "Connection Status: %s\n", status[info->ConStat & 0x7]);
-	seq_printf(m, "RX packets: %ld\n", info->stats.rx_packets);
-	seq_printf(m, "TX packets: %ld\n", info->stats.tx_packets);
-	seq_printf(m, "RX bytes: %ld\n", info->stats.rx_bytes);
-	seq_printf(m, "TX bytes: %ld\n", info->stats.tx_bytes);
-	seq_printf(m, "Signal Strength: %s\n", signal[strength]);
-	seq_printf(m, "Signal Quality: %s\n", signal[quality]);
-	return 0;
-}
-
-/*
- * seq_file wrappers for procfile show routines.
- */
-static int ft1000_proc_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, ft1000ReadProc, PDE_DATA(inode));
-}
-
-static const struct file_operations ft1000_proc_fops = {
-	.open		= ft1000_proc_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int
-ft1000NotifyProc(struct notifier_block *this, unsigned long event, void *ptr)
-{
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct ft1000_info *info;
-	struct proc_dir_entry *ft1000_proc_file;
-
-	info = netdev_priv(dev);
-
-	switch (event) {
-	case NETDEV_CHANGENAME:
-		remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
-		ft1000_proc_file =
-			proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
-					 &ft1000_proc_fops, dev);
-		snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
-		break;
-	}
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block ft1000_netdev_notifier = {
-	.notifier_call = ft1000NotifyProc,
-};
-
-
-int ft1000_init_proc(struct net_device *dev)
-{
-	struct ft1000_info *info;
-	struct proc_dir_entry *ft1000_proc_file;
-	int ret = -EINVAL;
-
-	info = netdev_priv(dev);
-
-	info->ft1000_proc_dir = proc_mkdir(FT1000_PROC_DIR, FTNET_PROC);
-	if (info->ft1000_proc_dir == NULL) {
-		netdev_warn(dev, "Unable to create %s dir.\n",
-			FT1000_PROC_DIR);
-		goto fail;
-	}
-
-	ft1000_proc_file =
-		proc_create_data(dev->name, 0644, info->ft1000_proc_dir,
-				 &ft1000_proc_fops, dev);
-
-	if (!ft1000_proc_file) {
-		netdev_warn(dev, "Unable to create /proc entry.\n");
-		goto fail_entry;
-	}
-
-	snprintf(info->netdevname, IFNAMSIZ, "%s", dev->name);
-
-	ret = register_netdevice_notifier(&ft1000_netdev_notifier);
-	if (ret)
-		goto fail_notif;
-
-	return 0;
-
-fail_notif:
-	remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
-fail_entry:
-	remove_proc_entry(FT1000_PROC_DIR, FTNET_PROC);
-fail:
-	return ret;
-}
-
-void ft1000_cleanup_proc(struct ft1000_info *info)
-{
-	remove_proc_entry(info->netdevname, info->ft1000_proc_dir);
-	remove_proc_entry(FT1000_PROC_DIR, FTNET_PROC);
-	unregister_netdevice_notifier(&ft1000_netdev_notifier);
-}
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 0a2544c..cc740c9 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -196,17 +196,10 @@ static int ft1000_probe(struct usb_interface *interface,
 	if (ret)
 		goto err_thread;
 
-	ret = ft1000_init_proc(ft1000dev->net);
-	if (ret)
-		goto err_proc;
-
 	ft1000dev->NetDevRegDone = 1;
 
 	return 0;
 
-err_proc:
-	unregister_netdev(ft1000dev->net);
-	free_netdev(ft1000dev->net);
 err_thread:
 	kthread_stop(ft1000dev->pPollThread);
 err_load:
@@ -230,7 +223,6 @@ static void ft1000_disconnect(struct usb_interface *interface)
 
 	if (pft1000info) {
 		ft1000dev = pft1000info->priv;
-		ft1000_cleanup_proc(pft1000info);
 		if (ft1000dev->pPollThread)
 			kthread_stop(ft1000dev->pPollThread);
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 464e5ab..8f7ccae 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -149,7 +149,4 @@ int reg_ft1000_netdev(struct ft1000_usb *ft1000dev,
 		      struct usb_interface *intf);
 int ft1000_poll(void *dev_id);
 
-int ft1000_init_proc(struct net_device *dev);
-void ft1000_cleanup_proc(struct ft1000_info *info);
-
 #endif  /* _FT1000_USB_H_ */
diff --git a/drivers/staging/ft1000/ft1000.h b/drivers/staging/ft1000/ft1000.h
index db57430..8a2e4ca 100644
--- a/drivers/staging/ft1000/ft1000.h
+++ b/drivers/staging/ft1000/ft1000.h
@@ -363,6 +363,4 @@ struct ft1000_info {
 		u16 Rec[MAX_DSP_SESS_REC];
 		u32 MagRec[MAX_DSP_SESS_REC/2];
 	} DSPSess;
-	struct proc_dir_entry *ft1000_proc_dir;
-	char netdevname[IFNAMSIZ];
 };
-- 
1.9.1

