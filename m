Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbaEFEDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:03:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47478 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbaEFEDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:03:31 -0400
From: David Matlack <dmatlack@google.com>
To: gregkh@linuxfoundation.org
Cc: liodot@gmail.com, charrer@alacritech.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Matlack <dmatlack@google.com>
Subject: [PATCH 4/7] staging: slicoss: remove gratuitous debug infrastructure
Date: Mon,  5 May 2014 21:02:34 -0700
Message-Id: <1399348957-16663-5-git-send-email-dmatlack@google.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1399348957-16663-1-git-send-email-dmatlack@google.com>
References: <1399348957-16663-1-git-send-email-dmatlack@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the TODO file, this patch removes the gratuitous debug
infrastructure. As an extra incentive for removing this code,
the debugfs files are not cleaned up properly. For example, if
register_netdev() fails in slic_entry_probe() then all debugfs
files get left behind, even after the driver module is unloaded.
Touching these files quickly leads to an oops.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/staging/slicoss/TODO      |   1 -
 drivers/staging/slicoss/slic.h    |   3 -
 drivers/staging/slicoss/slicoss.c | 450 +-------------------------------------
 3 files changed, 3 insertions(+), 451 deletions(-)

diff --git a/drivers/staging/slicoss/TODO b/drivers/staging/slicoss/TODO
index 62ff100..20cc9ab 100644
--- a/drivers/staging/slicoss/TODO
+++ b/drivers/staging/slicoss/TODO
@@ -18,7 +18,6 @@ TODO:
 	  use ethtool instead
 	- reorder code to elminate use of forward declarations
 	- don't keep private linked list of drivers.
-	- remove all the gratiutous debug infrastructure
 	- use PCI_DEVICE()
 	- do ethtool correctly using ethtool_ops
 	- NAPI?
diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
index 379c4f7..7de57c4 100644
--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -310,8 +310,6 @@ struct sliccard {
 	u32           loadtimerset;
 	uint              config_set;
 	struct slic_config  config;
-	struct dentry      *debugfs_dir;
-	struct dentry      *debugfs_cardinfo;
 	struct adapter  *master;
 	struct adapter  *adapter[SLIC_MAX_PORTS];
 	struct sliccard *next;
@@ -450,7 +448,6 @@ struct adapter {
 	u32             pingtimerset;
 	struct timer_list   loadtimer;
 	u32             loadtimerset;
-	struct dentry      *debugfs_entry;
 	struct slic_spinlock     upr_lock;
 	struct slic_spinlock     bit64reglock;
 	struct slic_rspqueue     rspqueue;
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index b0b8544..39e6489 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -81,7 +81,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/delay.h>
-#include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
@@ -104,19 +103,13 @@ static char *slic_banner = "Alacritech SLIC Technology(tm) Server "
 		"and Storage Accelerator (Non-Accelerated)";
 
 static char *slic_proc_version = "2.0.351  2006/07/14 12:26:00";
-static char *slic_product_name = "SLIC Technology(tm) Server "
-		"and Storage Accelerator (Non-Accelerated)";
-static char *slic_vendor = "Alacritech, Inc.";
 
-static int slic_debug = 1;
-static int debug = -1;
 static struct net_device *head_netdevice;
 
 static struct base_driver slic_global = { {}, 0, 0, 0, 1, NULL, NULL };
 static int intagg_delay = 100;
 static u32 dynamic_intagg;
 static unsigned int rcv_count;
-static struct dentry *slic_debugfs;
 
 #define DRV_NAME          "slicoss"
 #define DRV_VERSION       "2.0.1"
@@ -1802,430 +1795,6 @@ static u32 slic_rcvqueue_reinsert(struct adapter *adapter, struct sk_buff *skb)
 	return rcvq->count;
 }
 
-static int slic_debug_card_show(struct seq_file *seq, void *v)
-{
-#ifdef MOOKTODO
-	int i;
-	struct sliccard *card = seq->private;
-	struct slic_config *config = &card->config;
-	unsigned char *fru = (unsigned char *)(&card->config.atk_fru);
-	unsigned char *oemfru = (unsigned char *)(&card->config.OemFru);
-#endif
-
-	seq_printf(seq, "driver_version           : %s\n", slic_proc_version);
-	seq_puts(seq, "Microcode versions:\n");
-	seq_printf(seq, "    Gigabit (gb)         : %s %s\n",
-		    MOJAVE_UCODE_VERS_STRING, MOJAVE_UCODE_VERS_DATE);
-	seq_printf(seq, "    Gigabit Receiver     : %s %s\n",
-		    GB_RCVUCODE_VERS_STRING, GB_RCVUCODE_VERS_DATE);
-	seq_printf(seq, "Vendor                   : %s\n", slic_vendor);
-	seq_printf(seq, "Product Name             : %s\n", slic_product_name);
-#ifdef MOOKTODO
-	seq_printf(seq, "VendorId                 : %4.4X\n",
-		    config->VendorId);
-	seq_printf(seq, "DeviceId                 : %4.4X\n",
-		    config->DeviceId);
-	seq_printf(seq, "RevisionId               : %2.2x\n",
-		    config->RevisionId);
-	seq_printf(seq, "Bus    #                 : %d\n", card->busnumber);
-	seq_printf(seq, "Device #                 : %d\n", card->slotnumber);
-	seq_printf(seq, "Interfaces               : %d\n", card->card_size);
-	seq_printf(seq, "     Initialized         : %d\n",
-		    card->adapters_activated);
-	seq_printf(seq, "     Allocated           : %d\n",
-		    card->adapters_allocated);
-	for (i = 0; i < card->card_size; i++) {
-		seq_printf(seq,
-			   "     MAC%d : %2.2X %2.2X %2.2X %2.2X %2.2X %2.2X\n",
-			   i, config->macinfo[i].macaddrA[0],
-			   config->macinfo[i].macaddrA[1],
-			   config->macinfo[i].macaddrA[2],
-			   config->macinfo[i].macaddrA[3],
-			   config->macinfo[i].macaddrA[4],
-			   config->macinfo[i].macaddrA[5]);
-	}
-	seq_puts(seq, "     IF  Init State Duplex/Speed irq\n");
-	seq_puts(seq, "     -------------------------------\n");
-	for (i = 0; i < card->adapters_allocated; i++) {
-		struct adapter *adapter;
-
-		adapter = card->adapter[i];
-		if (adapter) {
-			seq_printf(seq,
-				    "     %d   %d   %s  %s  %s    0x%X\n",
-				    adapter->physport, adapter->state,
-				    SLIC_LINKSTATE(adapter->linkstate),
-				    SLIC_DUPLEX(adapter->linkduplex),
-				    SLIC_SPEED(adapter->linkspeed),
-				    (uint) adapter->irq);
-		}
-	}
-	seq_printf(seq, "Generation #             : %4.4X\n", card->gennumber);
-	seq_printf(seq, "RcvQ max entries         : %4.4X\n",
-		    SLIC_RCVQ_ENTRIES);
-	seq_printf(seq, "Ping Status              : %8.8X\n",
-		    card->pingstatus);
-	seq_printf(seq, "Minimum grant            : %2.2x\n",
-		    config->MinGrant);
-	seq_printf(seq, "Maximum Latency          : %2.2x\n", config->MaxLat);
-	seq_printf(seq, "PciStatus                : %4.4x\n",
-		    config->Pcistatus);
-	seq_printf(seq, "Debug Device Id          : %4.4x\n",
-		    config->DbgDevId);
-	seq_printf(seq, "DRAM ROM Function        : %4.4x\n",
-		    config->DramRomFn);
-	seq_printf(seq, "Network interface Pin 1  : %2.2x\n",
-		    config->NetIntPin1);
-	seq_printf(seq, "Network interface Pin 2  : %2.2x\n",
-		    config->NetIntPin1);
-	seq_printf(seq, "Network interface Pin 3  : %2.2x\n",
-		    config->NetIntPin1);
-	seq_printf(seq, "PM capabilities          : %4.4X\n",
-		    config->PMECapab);
-	seq_printf(seq, "Network Clock Controls   : %4.4X\n",
-		    config->NwClkCtrls);
-
-	switch (config->FruFormat) {
-	case ATK_FRU_FORMAT:
-		{
-			seq_puts(seq,
-			    "Vendor                   : Alacritech, Inc.\n");
-			seq_printf(seq,
-			    "Assembly #               : %c%c%c%c%c%c\n",
-				    fru[0], fru[1], fru[2], fru[3], fru[4],
-				    fru[5]);
-			seq_printf(seq,
-				    "Revision #               : %c%c\n",
-				    fru[6], fru[7]);
-
-			if (config->OEMFruFormat == VENDOR4_FRU_FORMAT) {
-				seq_printf(seq,
-					    "Serial   #               : %c%c%c%c%c%c%c%c%c%c%c%c\n",
-					    fru[8], fru[9], fru[10],
-					    fru[11], fru[12], fru[13],
-					    fru[16], fru[17], fru[18],
-					    fru[19], fru[20], fru[21]);
-			} else {
-				seq_printf(seq,
-					    "Serial   #               : %c%c%c%c%c%c%c%c%c%c%c%c%c%c\n",
-					    fru[8], fru[9], fru[10],
-					    fru[11], fru[12], fru[13],
-					    fru[14], fru[15], fru[16],
-					    fru[17], fru[18], fru[19],
-					    fru[20], fru[21]);
-			}
-			break;
-		}
-
-	default:
-		{
-			seq_puts(seq,
-			    "Vendor                   : Alacritech, Inc.\n");
-			seq_puts(seq,
-			    "Serial   #               : Empty FRU\n");
-			break;
-		}
-	}
-
-	switch (config->OEMFruFormat) {
-	case VENDOR1_FRU_FORMAT:
-		{
-			seq_puts(seq, "FRU Information:\n");
-			seq_printf(seq, "    Commodity #          : %c\n",
-				    oemfru[0]);
-			seq_printf(seq,
-				    "    Assembly #           : %c%c%c%c\n",
-				    oemfru[1], oemfru[2], oemfru[3], oemfru[4]);
-			seq_printf(seq,
-				    "    Revision #           : %c%c\n",
-				    oemfru[5], oemfru[6]);
-			seq_printf(seq,
-				    "    Supplier #           : %c%c\n",
-				    oemfru[7], oemfru[8]);
-			seq_printf(seq,
-				    "    Date                 : %c%c\n",
-				    oemfru[9], oemfru[10]);
-			seq_sprintf(seq,
-				    "    Sequence #           : %c%c%c\n",
-				    oemfru[11], oemfru[12], oemfru[13]);
-			break;
-		}
-
-	case VENDOR2_FRU_FORMAT:
-		{
-			seq_puts(seq, "FRU Information:\n");
-			seq_printf(seq,
-				    "    Part     #           : %c%c%c%c%c%c%c%c\n",
-				    oemfru[0], oemfru[1], oemfru[2],
-				    oemfru[3], oemfru[4], oemfru[5],
-				    oemfru[6], oemfru[7]);
-			seq_printf(seq,
-				    "    Supplier #           : %c%c%c%c%c\n",
-				    oemfru[8], oemfru[9], oemfru[10],
-				    oemfru[11], oemfru[12]);
-			seq_printf(seq,
-				    "    Date                 : %c%c%c\n",
-				    oemfru[13], oemfru[14], oemfru[15]);
-			seq_sprintf(seq,
-				    "    Sequence #           : %c%c%c%c\n",
-				    oemfru[16], oemfru[17], oemfru[18],
-				    oemfru[19]);
-			break;
-		}
-
-	case VENDOR3_FRU_FORMAT:
-		{
-			seq_puts(seq, "FRU Information:\n");
-		}
-
-	case VENDOR4_FRU_FORMAT:
-		{
-			seq_puts(seq, "FRU Information:\n");
-			seq_printf(seq,
-				    "    FRU Number           : %c%c%c%c%c%c%c%c\n",
-				    oemfru[0], oemfru[1], oemfru[2],
-				    oemfru[3], oemfru[4], oemfru[5],
-				    oemfru[6], oemfru[7]);
-			seq_sprintf(seq,
-				    "    Part Number          : %c%c%c%c%c%c%c%c\n",
-				    oemfru[8], oemfru[9], oemfru[10],
-				    oemfru[11], oemfru[12], oemfru[13],
-				    oemfru[14], oemfru[15]);
-			seq_printf(seq,
-				    "    EC Level             : %c%c%c%c%c%c%c%c\n",
-				    oemfru[16], oemfru[17], oemfru[18],
-				    oemfru[19], oemfru[20], oemfru[21],
-				    oemfru[22], oemfru[23]);
-			break;
-		}
-
-	default:
-		break;
-	}
-#endif
-
-	return 0;
-}
-
-static int slic_debug_adapter_show(struct seq_file *seq, void *v)
-{
-	struct adapter *adapter = seq->private;
-	struct net_device *netdev = adapter->netdev;
-
-	seq_printf(seq, "info: interface          : %s\n",
-			    adapter->netdev->name);
-	seq_printf(seq, "info: status             : %s\n",
-		SLIC_LINKSTATE(adapter->linkstate));
-	seq_printf(seq, "info: port               : %d\n",
-		adapter->physport);
-	seq_printf(seq, "info: speed              : %s\n",
-		SLIC_SPEED(adapter->linkspeed));
-	seq_printf(seq, "info: duplex             : %s\n",
-		SLIC_DUPLEX(adapter->linkduplex));
-	seq_printf(seq, "info: irq                : 0x%X\n",
-		(uint) adapter->irq);
-	seq_printf(seq, "info: Interrupt Agg Delay: %d usec\n",
-		adapter->card->loadlevel_current);
-	seq_printf(seq, "info: RcvQ max entries   : %4.4X\n",
-		SLIC_RCVQ_ENTRIES);
-	seq_printf(seq, "info: RcvQ current       : %4.4X\n",
-		    adapter->rcvqueue.count);
-	seq_printf(seq, "rx stats: packets                  : %8.8lX\n",
-		    netdev->stats.rx_packets);
-	seq_printf(seq, "rx stats: bytes                    : %8.8lX\n",
-		    netdev->stats.rx_bytes);
-	seq_printf(seq, "rx stats: broadcasts               : %8.8X\n",
-		    adapter->rcv_broadcasts);
-	seq_printf(seq, "rx stats: multicasts               : %8.8X\n",
-		    adapter->rcv_multicasts);
-	seq_printf(seq, "rx stats: unicasts                 : %8.8X\n",
-		    adapter->rcv_unicasts);
-	seq_printf(seq, "rx stats: errors                   : %8.8X\n",
-		    (u32) adapter->slic_stats.iface.rcv_errors);
-	seq_printf(seq, "rx stats: Missed errors            : %8.8X\n",
-		    (u32) adapter->slic_stats.iface.rcv_discards);
-	seq_printf(seq, "rx stats: drops                    : %8.8X\n",
-			(u32) adapter->rcv_drops);
-	seq_printf(seq, "tx stats: packets                  : %8.8lX\n",
-			netdev->stats.tx_packets);
-	seq_printf(seq, "tx stats: bytes                    : %8.8lX\n",
-			netdev->stats.tx_bytes);
-	seq_printf(seq, "tx stats: errors                   : %8.8X\n",
-			(u32) adapter->slic_stats.iface.xmt_errors);
-	seq_printf(seq, "rx stats: multicasts               : %8.8lX\n",
-			netdev->stats.multicast);
-	seq_printf(seq, "tx stats: collision errors         : %8.8X\n",
-			(u32) adapter->slic_stats.iface.xmit_collisions);
-	seq_printf(seq, "perf: Max rcv frames/isr           : %8.8X\n",
-			adapter->max_isr_rcvs);
-	seq_printf(seq, "perf: Rcv interrupt yields         : %8.8X\n",
-			adapter->rcv_interrupt_yields);
-	seq_printf(seq, "perf: Max xmit complete/isr        : %8.8X\n",
-			adapter->max_isr_xmits);
-	seq_printf(seq, "perf: error interrupts             : %8.8X\n",
-			adapter->error_interrupts);
-	seq_printf(seq, "perf: error rmiss interrupts       : %8.8X\n",
-			adapter->error_rmiss_interrupts);
-	seq_printf(seq, "perf: rcv interrupts               : %8.8X\n",
-			adapter->rcv_interrupts);
-	seq_printf(seq, "perf: xmit interrupts              : %8.8X\n",
-			adapter->xmit_interrupts);
-	seq_printf(seq, "perf: link event interrupts        : %8.8X\n",
-			adapter->linkevent_interrupts);
-	seq_printf(seq, "perf: UPR interrupts               : %8.8X\n",
-			adapter->upr_interrupts);
-	seq_printf(seq, "perf: interrupt count              : %8.8X\n",
-			adapter->num_isrs);
-	seq_printf(seq, "perf: false interrupts             : %8.8X\n",
-			adapter->false_interrupts);
-	seq_printf(seq, "perf: All register writes          : %8.8X\n",
-			adapter->all_reg_writes);
-	seq_printf(seq, "perf: ICR register writes          : %8.8X\n",
-			adapter->icr_reg_writes);
-	seq_printf(seq, "perf: ISR register writes          : %8.8X\n",
-			adapter->isr_reg_writes);
-	seq_printf(seq, "ifevents: overflow 802 errors      : %8.8X\n",
-			adapter->if_events.oflow802);
-	seq_printf(seq, "ifevents: transport overflow errors: %8.8X\n",
-			adapter->if_events.Tprtoflow);
-	seq_printf(seq, "ifevents: underflow errors         : %8.8X\n",
-			adapter->if_events.uflow802);
-	seq_printf(seq, "ifevents: receive early            : %8.8X\n",
-			adapter->if_events.rcvearly);
-	seq_printf(seq, "ifevents: buffer overflows         : %8.8X\n",
-			adapter->if_events.Bufov);
-	seq_printf(seq, "ifevents: carrier errors           : %8.8X\n",
-			adapter->if_events.Carre);
-	seq_printf(seq, "ifevents: Long                     : %8.8X\n",
-			adapter->if_events.Longe);
-	seq_printf(seq, "ifevents: invalid preambles        : %8.8X\n",
-			adapter->if_events.Invp);
-	seq_printf(seq, "ifevents: CRC errors               : %8.8X\n",
-			adapter->if_events.Crc);
-	seq_printf(seq, "ifevents: dribble nibbles          : %8.8X\n",
-			adapter->if_events.Drbl);
-	seq_printf(seq, "ifevents: Code violations          : %8.8X\n",
-			adapter->if_events.Code);
-	seq_printf(seq, "ifevents: TCP checksum errors      : %8.8X\n",
-			adapter->if_events.TpCsum);
-	seq_printf(seq, "ifevents: TCP header short errors  : %8.8X\n",
-			adapter->if_events.TpHlen);
-	seq_printf(seq, "ifevents: IP checksum errors       : %8.8X\n",
-			adapter->if_events.IpCsum);
-	seq_printf(seq, "ifevents: IP frame incompletes     : %8.8X\n",
-			adapter->if_events.IpLen);
-	seq_printf(seq, "ifevents: IP headers shorts        : %8.8X\n",
-			adapter->if_events.IpHlen);
-
-	return 0;
-}
-static int slic_debug_adapter_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, slic_debug_adapter_show, inode->i_private);
-}
-
-static int slic_debug_card_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, slic_debug_card_show, inode->i_private);
-}
-
-static const struct file_operations slic_debug_adapter_fops = {
-	.owner		= THIS_MODULE,
-	.open		= slic_debug_adapter_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static const struct file_operations slic_debug_card_fops = {
-	.owner		= THIS_MODULE,
-	.open		= slic_debug_card_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static void slic_debug_adapter_create(struct adapter *adapter)
-{
-	struct dentry *d;
-	char    name[7];
-	struct sliccard *card = adapter->card;
-
-	if (!card->debugfs_dir)
-		return;
-
-	sprintf(name, "port%d", adapter->port);
-	d = debugfs_create_file(name, S_IRUGO,
-				card->debugfs_dir, adapter,
-				&slic_debug_adapter_fops);
-	if (!d || IS_ERR(d))
-		pr_info(PFX "%s: debugfs create failed\n", name);
-	else
-		adapter->debugfs_entry = d;
-}
-
-static void slic_debug_adapter_destroy(struct adapter *adapter)
-{
-	debugfs_remove(adapter->debugfs_entry);
-	adapter->debugfs_entry = NULL;
-}
-
-static void slic_debug_card_create(struct sliccard *card)
-{
-	struct dentry *d;
-	char    name[IFNAMSIZ];
-
-	snprintf(name, sizeof(name), "slic%d", card->cardnum);
-	d = debugfs_create_dir(name, slic_debugfs);
-	if (!d || IS_ERR(d))
-		pr_info(PFX "%s: debugfs create dir failed\n",
-				name);
-	else {
-		card->debugfs_dir = d;
-		d = debugfs_create_file("cardinfo", S_IRUGO,
-				slic_debugfs, card,
-				&slic_debug_card_fops);
-		if (!d || IS_ERR(d))
-			pr_info(PFX "%s: debugfs create failed\n",
-					name);
-		else
-			card->debugfs_cardinfo = d;
-	}
-}
-
-static void slic_debug_card_destroy(struct sliccard *card)
-{
-	int i;
-
-	for (i = 0; i < card->card_size; i++) {
-		struct adapter *adapter;
-
-		adapter = card->adapter[i];
-		if (adapter)
-			slic_debug_adapter_destroy(adapter);
-	}
-	debugfs_remove(card->debugfs_cardinfo);
-	debugfs_remove(card->debugfs_dir);
-}
-
-static void slic_debug_init(void)
-{
-	struct dentry *ent;
-
-	ent = debugfs_create_dir("slic", NULL);
-	if (!ent || IS_ERR(ent)) {
-		pr_info(PFX "debugfs create directory failed\n");
-		return;
-	}
-
-	slic_debugfs = ent;
-}
-
-static void slic_debug_cleanup(void)
-{
-	debugfs_remove(slic_debugfs);
-}
-
 /*
  * slic_link_event_handler -
  *
@@ -2947,8 +2516,6 @@ static void slic_card_cleanup(struct sliccard *card)
 		del_timer_sync(&card->loadtimer);
 	}
 
-	slic_debug_card_destroy(card);
-
 	kfree(card);
 }
 
@@ -3402,7 +2969,6 @@ static void slic_init_driver(void)
 	if (slic_first_init) {
 		slic_first_init = 0;
 		spin_lock_init(&slic_global.driver_lock.lock);
-		slic_debug_init();
 	}
 }
 
@@ -3519,8 +3085,6 @@ static u32 slic_card_locate(struct adapter *adapter)
 			}
 		}
 		slic_global.num_slic_cards++;
-
-		slic_debug_card_create(card);
 	} else {
 		/* Card exists, find the card this adapter belongs to */
 		while (card) {
@@ -3597,9 +3161,9 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 	if (err)
 		return err;
 
-	if (slic_debug > 0 && did_version++ == 0) {
-		dev_dbg(&pcidev->dev, "%s\n", slic_banner);
-		dev_dbg(&pcidev->dev, "%s\n", slic_proc_version);
+	if (did_version++ == 0) {
+		dev_info(&pcidev->dev, "%s\n", slic_banner);
+		dev_info(&pcidev->dev, "%s\n", slic_proc_version);
 	}
 
 	if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
@@ -3685,8 +3249,6 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 	netdev->irq = adapter->irq;
 	netdev->netdev_ops = &slic_netdev_ops;
 
-	slic_debug_adapter_create(adapter);
-
 	strcpy(netdev->name, "eth%d");
 	err = register_netdev(netdev);
 	if (err) {
@@ -3720,18 +3282,12 @@ static int __init slic_module_init(void)
 {
 	slic_init_driver();
 
-	if (debug >= 0 && slic_debug != debug)
-		pr_debug("debug level is %d.\n", debug);
-	if (debug >= 0)
-		slic_debug = debug;
-
 	return pci_register_driver(&slic_driver);
 }
 
 static void __exit slic_module_cleanup(void)
 {
 	pci_unregister_driver(&slic_driver);
-	slic_debug_cleanup();
 }
 
 module_init(slic_module_init);
-- 
1.9.2

