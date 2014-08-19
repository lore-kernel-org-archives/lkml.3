Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaHSPaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:30:39 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:47732 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaHSPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:30:36 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>, Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: [PATCH] staging: dgnc: remove DPR Macros and related codes.
Date: Wed, 20 Aug 2014 00:30:23 +0900
Message-Id: <1408462223-6379-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dgnc_drivers.h, DPR macro and DPR_* macros are defined but do nothing.

So remove them and related codes.

CC: Lidza Louina <lidza.louina@gmail.com>
CC: Mark Hounschell <markh@compro.net>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/dgnc_cls.c    |   51 --------
 drivers/staging/dgnc/dgnc_driver.c |   19 +--
 drivers/staging/dgnc/dgnc_driver.h |   21 ---
 drivers/staging/dgnc/dgnc_mgmt.c   |   23 ----
 drivers/staging/dgnc/dgnc_neo.c    |  104 ++-------------
 drivers/staging/dgnc/dgnc_tty.c    |  249 +++---------------------------------
 6 files changed, 29 insertions(+), 438 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
index fe099c6..84b1377 100644
--- a/drivers/staging/dgnc/dgnc_cls.c
+++ b/drivers/staging/dgnc/dgnc_cls.c
@@ -99,7 +99,6 @@ static inline void cls_set_cts_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_cls_uart->ier);
 	uchar isr_fcr = 0;
 
-	DPR_PARAM(("Setting CTSFLOW\n"));
 
 	/*
 	 * The Enhanced Register Set may only be accessed when
@@ -144,7 +143,6 @@ static inline void cls_set_ixon_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_cls_uart->ier);
 	uchar isr_fcr = 0;
 
-	DPR_PARAM(("Setting IXON FLOW\n"));
 
 	/*
 	 * The Enhanced Register Set may only be accessed when
@@ -193,7 +191,6 @@ static inline void cls_set_no_output_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_cls_uart->ier);
 	uchar isr_fcr = 0;
 
-	DPR_PARAM(("Unsetting Output FLOW\n"));
 
 	/*
 	 * The Enhanced Register Set may only be accessed when
@@ -240,7 +237,6 @@ static inline void cls_set_rts_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_cls_uart->ier);
 	uchar isr_fcr = 0;
 
-	DPR_PARAM(("Setting RTSFLOW\n"));
 
 	/*
 	 * The Enhanced Register Set may only be accessed when
@@ -283,7 +279,6 @@ static inline void cls_set_ixoff_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_cls_uart->ier);
 	uchar isr_fcr = 0;
 
-	DPR_PARAM(("Setting IXOFF FLOW\n"));
 
 	/*
 	 * The Enhanced Register Set may only be accessed when
@@ -328,7 +323,6 @@ static inline void cls_set_no_input_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_cls_uart->ier);
 	uchar isr_fcr = 0;
 
-	DPR_PARAM(("Unsetting Input FLOW\n"));
 
 	/*
 	 * The Enhanced Register Set may only be accessed when
@@ -394,8 +388,6 @@ static inline void cls_clear_break(struct channel_t *ch, int force)
 			writeb((temp & ~UART_LCR_SBC), &ch->ch_cls_uart->lcr);
 			ch->ch_flags &= ~(CH_BREAK_SENDING);
 			ch->ch_stop_sending_break = 0;
-			DPR_IOCTL(("Finishing UART_LCR_SBC! finished: %lx\n",
-								jiffies));
 		}
 	}
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
@@ -430,9 +422,6 @@ static inline void cls_parse_isr(struct dgnc_board *brd, uint port)
 		if (isr & UART_IIR_NO_INT)
 			break;
 
-		DPR_INTR(("%s:%d port: %x isr: %x\n", __FILE__, __LINE__,
-								 port, isr));
-
 		/* Receive Interrupt pending */
 		if (isr & (UART_IIR_RDI | UART_IIR_RDI_TIMEOUT)) {
 			/* Read data from uart -> queue */
@@ -464,7 +453,6 @@ static inline void cls_parse_isr(struct dgnc_board *brd, uint port)
 		}
 
 		/* Parse any modem signal changes */
-		DPR_INTR(("MOD_STAT: sending to parse_modem_sigs\n"));
 		cls_parse_modem(ch, readb(&ch->ch_cls_uart->msr));
 	}
 }
@@ -501,10 +489,6 @@ static void cls_param(struct tty_struct *tty)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	DPR_PARAM(("param start: tdev: %x cflags: %x oflags: %x iflags: %x\n",
-		ch->ch_tun.un_dev, ch->ch_c_cflag, ch->ch_c_oflag,
-							 ch->ch_c_iflag));
-
 	/*
 	 * If baud rate is zero, flush queues, and set mval to drop DTR.
 	 */
@@ -588,8 +572,6 @@ static void cls_param(struct tty_struct *tty)
 								(jindex < 16)) {
 			baud = bauds[iindex][jindex];
 		} else {
-			DPR_IOCTL(("baud indices were out of range (%d)(%d)",
-				iindex, jindex));
 			baud = 0;
 		}
 
@@ -840,14 +822,10 @@ static irqreturn_t cls_intr(int irq, void *voidbrd)
 
 	/* If 0, no interrupts pending */
 	if (!poll_reg) {
-		DPR_INTR((
-			 "Kernel interrupted to me, but no pending interrupts...\n"));
 		DGNC_UNLOCK(brd->bd_intr_lock, lock_flags);
 		return IRQ_NONE;
 	}
 
-	DPR_INTR(("%s:%d poll_reg: %x\n", __FILE__, __LINE__, poll_reg));
-
 	/* Parse each port to find out what caused the interrupt */
 	for (i = 0; i < brd->nasync; i++)
 		cls_parse_isr(brd, i);
@@ -859,7 +837,6 @@ static irqreturn_t cls_intr(int irq, void *voidbrd)
 
 	DGNC_UNLOCK(brd->bd_intr_lock, lock_flags);
 
-	DPR_INTR(("dgnc_intr finish.\n"));
 	return IRQ_HANDLED;
 }
 
@@ -938,9 +915,6 @@ static void cls_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * I hope thats okay with everyone? Yes? Good.
 		 */
 		while (qleft < 1) {
-			DPR_READ(("Queue full, dropping DATA:%x LSR:%x\n",
-				ch->ch_rqueue[tail], ch->ch_equeue[tail]));
-
 			ch->ch_r_tail = tail = (tail + 1) & RQUEUEMASK;
 			ch->ch_err_overrun++;
 			qleft++;
@@ -954,9 +928,6 @@ static void cls_copy_data_from_uart_to_queue(struct channel_t *ch)
 
 		qleft--;
 
-		DPR_READ(("DATA/LSR pair: %x %x\n", ch->ch_rqueue[head],
-							 ch->ch_equeue[head]));
-
 		if (ch->ch_equeue[head] & UART_LSR_PE)
 			ch->ch_err_parity++;
 		if (ch->ch_equeue[head] & UART_LSR_BI)
@@ -1012,8 +983,6 @@ static int cls_drain(struct tty_struct *tty, uint seconds)
 					 ((un->un_flags & UN_EMPTY) == 0));
 
 	/* If ret is non-zero, user ctrl-c'ed us */
-	if (rc)
-		DPR_IOCTL(("%d Drain - User ctrl c'ed\n", __LINE__));
 
 	return rc;
 }
@@ -1126,7 +1095,6 @@ static void cls_copy_data_from_queue_to_uart(struct channel_t *ch)
 		writeb(ch->ch_wqueue[ch->ch_w_tail], &ch->ch_cls_uart->txrx);
 		dgnc_sniff_nowait_nolock(ch, "UART WRITE",
 					    ch->ch_wqueue + ch->ch_w_tail, 1);
-		DPR_WRITE(("Tx data: %x\n", ch->ch_wqueue[ch->ch_w_tail]));
 		ch->ch_w_tail++;
 		ch->ch_w_tail &= WQUEUEMASK;
 		ch->ch_txcount++;
@@ -1149,9 +1117,6 @@ static void cls_parse_modem(struct channel_t *ch, uchar signals)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
-	DPR_MSIGS(("cls_parse_modem: port: %d signals: %d\n",
-					 ch->ch_portnum, msignals));
-
 	/*
 	 * Do altpin switching. Altpin switches DCD and DSR.
 	 * This prolly breaks DSRPACE, so we should be more clever here.
@@ -1206,17 +1171,6 @@ static void cls_parse_modem(struct channel_t *ch, uchar signals)
 	else
 		ch->ch_mistat &= ~UART_MSR_CTS;
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-
-	DPR_MSIGS((
-		"Port: %d DTR: %d RTS: %d CTS: %d DSR: %d " "RI: %d CD: %d\n",
-		ch->ch_portnum,
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MCR_DTR),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MCR_RTS),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_CTS),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_DSR),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_RI),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_DCD)));
 }
 
 
@@ -1363,8 +1317,6 @@ static void cls_send_break(struct channel_t *ch, int msecs)
 			writeb((temp & ~UART_LCR_SBC), &ch->ch_cls_uart->lcr);
 			ch->ch_flags &= ~(CH_BREAK_SENDING);
 			ch->ch_stop_sending_break = 0;
-			DPR_IOCTL(("Finishing UART_LCR_SBC! finished: %lx\n",
-								     jiffies));
 		}
 		return;
 	}
@@ -1382,9 +1334,6 @@ static void cls_send_break(struct channel_t *ch, int msecs)
 
 		writeb((temp | UART_LCR_SBC), &ch->ch_cls_uart->lcr);
 		ch->ch_flags |= (CH_BREAK_SENDING);
-		DPR_IOCTL((
-			"Port %d. Starting UART_LCR_SBC! start: %lx should end: %lx\n",
-			ch->ch_portnum, jiffies, ch->ch_stop_sending_break));
 	}
 }
 
diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index a9f1a8c..11bed56 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -250,7 +250,6 @@ static int __init dgnc_init_module(void)
 		dgnc_create_driver_sysfiles(&dgnc_driver);
 	}
 
-	DPR_INIT(("Finished init_module. Returning %d\n", rc));
 	return rc;
 }
 
@@ -325,10 +324,8 @@ static int dgnc_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		rc = -EIO;
 	} else {
 		rc = dgnc_found_board(pdev, ent->driver_data);
-		if (rc == 0) {
+		if (rc == 0)
 			dgnc_NumBoards++;
-			DPR_INIT(("Incrementing numboards to %d\n", dgnc_NumBoards));
-		}
 	}
 	return rc;
 }
@@ -467,8 +464,6 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 
 		brd->dpatype = T_CLASSIC | T_PCIBUS;
 
-		DPR_INIT(("dgnc_found_board - Classic.\n"));
-
 		/*
 		 * For PCI ClassicBoards
 		 * PCI Local Address (i.e. "resource" number) space
@@ -543,8 +538,6 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 		else
 			brd->dpatype = T_NEO | T_PCIBUS;
 
-		DPR_INIT(("dgnc_found_board - NEO.\n"));
-
 		/* get the PCI Base Address Registers */
 		brd->membase     = pci_resource_start(pdev, 0);
 		brd->membase_end = pci_resource_end(pdev, 0);
@@ -618,7 +611,6 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	/* init our poll helper tasklet */
 	tasklet_init(&brd->helper_tasklet, brd->bd_ops->tasklet, (unsigned long) brd);
 
-	DPR_INIT(("dgnc_scan(%d) - printing out the msgbuf\n", i));
 	DGNC_LOCK(dgnc_global_lock, flags);
 	brd->msgbuf = NULL;
 	printk("%s", brd->msgbuf_head);
@@ -649,13 +641,9 @@ static int dgnc_finalize_board_init(struct dgnc_board *brd)
 {
 	int rc = 0;
 
-	DPR_INIT(("dgnc_finalize_board_init() - start\n"));
-
 	if (!brd || brd->magic != DGNC_BOARD_MAGIC)
 		return -ENODEV;
 
-	DPR_INIT(("dgnc_finalize_board_init() - start #2\n"));
-
 	if (brd->irq) {
 		rc = request_irq(brd->irq, brd->bd_ops->intr,
 				 IRQF_SHARED, "DGNC", brd);
@@ -666,9 +654,6 @@ static int dgnc_finalize_board_init(struct dgnc_board *brd)
 			brd->state = BOARD_FAILED;
 			brd->dpastatus = BD_NOFEP;
 			rc = -ENODEV;
-		} else {
-			DPR_INIT(("Requested and received usage of IRQ %d\n",
-				  brd->irq));
 		}
 	}
 	return rc;
@@ -684,8 +669,6 @@ static void dgnc_do_remap(struct dgnc_board *brd)
 		return;
 
 	brd->re_map_membase = ioremap(brd->membase, 0x1000);
-
-	DPR_INIT(("remapped mem: 0x%p\n", brd->re_map_membase));
 }
 
 
diff --git a/drivers/staging/dgnc/dgnc_driver.h b/drivers/staging/dgnc/dgnc_driver.h
index d16d761..1111020 100644
--- a/drivers/staging/dgnc/dgnc_driver.h
+++ b/drivers/staging/dgnc/dgnc_driver.h
@@ -49,8 +49,6 @@
  * three lines, and the driver printk's will all automagically change.
  *
  * APR((fmt, args, ...));	Always prints message
- * DPR((fmt, args, ...));	Only prints if DGNC_TRACER is defined at
- *				  compile time and dgnc_debug!=0
  */
 #define	PROCSTR		"dgnc"			/* /proc entries	 */
 #define	DEVSTR		"/dev/dg/dgnc"		/* /dev entries		 */
@@ -93,25 +91,6 @@
 
 #define PRINTF_TO_KMEM(args)
 # define TRC(ARGS)
-# define DPR_INIT(ARGS)
-# define DPR_BASIC(ARGS)
-# define DPR_CORE(ARGS)
-# define DPR_OPEN(ARGS)
-# define DPR_CLOSE(ARGS)
-# define DPR_READ(ARGS)
-# define DPR_WRITE(ARGS)
-# define DPR_IOCTL(ARGS)
-# define DPR_PROC(ARGS)
-# define DPR_PARAM(ARGS)
-# define DPR_PSCAN(ARGS)
-# define DPR_EVENT(ARGS)
-# define DPR_DRAIN(ARGS)
-# define DPR_CARR(ARGS)
-# define DPR_MGMT(ARGS)
-# define DPR_INTR(ARGS)
-# define DPR_MSIGS(ARGS)
-
-# define DPR(args)
 
 /* Number of boards we support at once. */
 #define	MAXBOARDS	20
diff --git a/drivers/staging/dgnc/dgnc_mgmt.c b/drivers/staging/dgnc/dgnc_mgmt.c
index c5b425b..31e9f45 100644
--- a/drivers/staging/dgnc/dgnc_mgmt.c
+++ b/drivers/staging/dgnc/dgnc_mgmt.c
@@ -65,8 +65,6 @@ int dgnc_mgmt_open(struct inode *inode, struct file *file)
 	unsigned long lock_flags;
 	unsigned int minor = iminor(inode);
 
-	DPR_MGMT(("dgnc_mgmt_open start.\n"));
-
 	DGNC_LOCK(dgnc_global_lock, lock_flags);
 
 	/* mgmt device */
@@ -84,8 +82,6 @@ int dgnc_mgmt_open(struct inode *inode, struct file *file)
 
 	DGNC_UNLOCK(dgnc_global_lock, lock_flags);
 
-	DPR_MGMT(("dgnc_mgmt_open finish.\n"));
-
 	return 0;
 }
 
@@ -100,8 +96,6 @@ int dgnc_mgmt_close(struct inode *inode, struct file *file)
 	unsigned long lock_flags;
 	unsigned int minor = iminor(inode);
 
-	DPR_MGMT(("dgnc_mgmt_close start.\n"));
-
 	DGNC_LOCK(dgnc_global_lock, lock_flags);
 
 	/* mgmt device */
@@ -111,8 +105,6 @@ int dgnc_mgmt_close(struct inode *inode, struct file *file)
 	}
 	DGNC_UNLOCK(dgnc_global_lock, lock_flags);
 
-	DPR_MGMT(("dgnc_mgmt_close finish.\n"));
-
 	return 0;
 }
 
@@ -128,8 +120,6 @@ long dgnc_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	unsigned long lock_flags;
 	void __user *uarg = (void __user *) arg;
 
-	DPR_MGMT(("dgnc_mgmt_ioctl start.\n"));
-
 	switch (cmd) {
 
 	case DIGI_GETDD:
@@ -148,9 +138,6 @@ long dgnc_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		DGNC_UNLOCK(dgnc_global_lock, lock_flags);
 
-		DPR_MGMT(("DIGI_GETDD returning numboards: %d version: %s\n",
-			ddi.dinfo_nboards, ddi.dinfo_version));
-
 		if (copy_to_user(uarg, &ddi, sizeof(ddi)))
 			return -EFAULT;
 
@@ -166,8 +153,6 @@ long dgnc_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&brd, uarg, sizeof(int)))
 			return -EFAULT;
 
-		DPR_MGMT(("DIGI_GETBD asking about board: %d\n", brd));
-
 		if ((brd < 0) || (brd > dgnc_NumBoards) ||
 		    (dgnc_NumBoards == 0))
 			return -ENODEV;
@@ -190,9 +175,6 @@ long dgnc_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		DGNC_UNLOCK(dgnc_Board[brd]->bd_lock, lock_flags);
 
-		DPR_MGMT(("DIGI_GETBD returning type: %x state: %x ports: %x size: %x\n",
-			di.info_bdtype, di.info_bdstate, di.info_nports, di.info_physsize));
-
 		if (copy_to_user(uarg, &di, sizeof(di)))
 			return -EFAULT;
 
@@ -210,9 +192,6 @@ long dgnc_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&ni, uarg, sizeof(ni)))
 			return -EFAULT;
 
-		DPR_MGMT(("DIGI_GETBD asking about board: %d channel: %d\n",
-			ni.board, ni.channel));
-
 		board = ni.board;
 		channel = ni.channel;
 
@@ -298,7 +277,5 @@ long dgnc_mgmt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	}
 
-	DPR_MGMT(("dgnc_mgmt_ioctl finish.\n"));
-
 	return 0;
 }
diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index 86a1cd7..920ce2d 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -117,8 +117,6 @@ static inline void neo_set_cts_flow_control(struct channel_t *ch)
 	uchar efr = readb(&ch->ch_neo_uart->efr);
 
 
-	DPR_PARAM(("Setting CTSFLOW\n"));
-
 	/* Turn on auto CTS flow control */
 #if 1
 	ier |= (UART_17158_IER_CTSDSR);
@@ -155,8 +153,6 @@ static inline void neo_set_rts_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_neo_uart->ier);
 	uchar efr = readb(&ch->ch_neo_uart->efr);
 
-	DPR_PARAM(("Setting RTSFLOW\n"));
-
 	/* Turn on auto RTS flow control */
 #if 1
 	ier |= (UART_17158_IER_RTSDTR);
@@ -200,8 +196,6 @@ static inline void neo_set_ixon_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_neo_uart->ier);
 	uchar efr = readb(&ch->ch_neo_uart->efr);
 
-	DPR_PARAM(("Setting IXON FLOW\n"));
-
 	/* Turn off auto CTS flow control */
 	ier &= ~(UART_17158_IER_CTSDSR);
 	efr &= ~(UART_17158_EFR_CTSDSR);
@@ -239,8 +233,6 @@ static inline void neo_set_ixoff_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_neo_uart->ier);
 	uchar efr = readb(&ch->ch_neo_uart->efr);
 
-	DPR_PARAM(("Setting IXOFF FLOW\n"));
-
 	/* Turn off auto RTS flow control */
 	ier &= ~(UART_17158_IER_RTSDTR);
 	efr &= ~(UART_17158_EFR_RTSDTR);
@@ -279,8 +271,6 @@ static inline void neo_set_no_input_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_neo_uart->ier);
 	uchar efr = readb(&ch->ch_neo_uart->efr);
 
-	DPR_PARAM(("Unsetting Input FLOW\n"));
-
 	/* Turn off auto RTS flow control */
 	ier &= ~(UART_17158_IER_RTSDTR);
 	efr &= ~(UART_17158_EFR_RTSDTR);
@@ -321,8 +311,6 @@ static inline void neo_set_no_output_flow_control(struct channel_t *ch)
 	uchar ier = readb(&ch->ch_neo_uart->ier);
 	uchar efr = readb(&ch->ch_neo_uart->efr);
 
-	DPR_PARAM(("Unsetting Output FLOW\n"));
-
 	/* Turn off auto CTS flow control */
 	ier &= ~(UART_17158_IER_CTSDSR);
 	efr &= ~(UART_17158_EFR_CTSDSR);
@@ -364,8 +352,6 @@ static inline void neo_set_new_start_stop_chars(struct channel_t *ch)
 	if (ch->ch_digi.digi_flags & (CTSPACE | RTSPACE) || ch->ch_c_cflag & CRTSCTS)
 		return;
 
-	DPR_PARAM(("In new start stop chars\n"));
-
 	/* Tell UART what start/stop chars it should be looking for */
 	writeb(ch->ch_startc, &ch->ch_neo_uart->xonchar1);
 	writeb(0, &ch->ch_neo_uart->xonchar2);
@@ -402,7 +388,6 @@ static inline void neo_clear_break(struct channel_t *ch, int force)
 			neo_pci_posting_flush(ch->ch_bd);
 			ch->ch_flags &= ~(CH_BREAK_SENDING);
 			ch->ch_stop_sending_break = 0;
-			DPR_IOCTL(("Finishing UART_LCR_SBC! finished: %lx\n", jiffies));
 		}
 	}
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
@@ -443,8 +428,6 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 		 */
 		isr &= ~(UART_17158_IIR_FIFO_ENABLED);
 
-		DPR_INTR(("%s:%d isr: %x\n", __FILE__, __LINE__, isr));
-
 		if (isr & (UART_17158_IIR_RDI_TIMEOUT | UART_IIR_RDI)) {
 			/* Read data from uart -> queue */
 			brd->intr_rx++;
@@ -470,8 +453,6 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 		if (isr & UART_17158_IIR_XONXOFF) {
 			cause = readb(&ch->ch_neo_uart->xoffchar1);
 
-			DPR_INTR(("Port %d. Got ISR_XONXOFF: cause:%x\n", port, cause));
-
 			/*
 			 * Since the UART detected either an XON or
 			 * XOFF match, we need to figure out which
@@ -484,15 +465,12 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 					ch->ch_flags &= ~(CH_STOP);
 					DGNC_UNLOCK(ch->ch_lock, lock_flags);
 				}
-				DPR_INTR(("Port %d. XON detected in incoming data\n", port));
 			} else if (cause == UART_17158_XOFF_DETECT) {
 				if (!(brd->channels[port]->ch_flags & CH_STOP)) {
 					DGNC_LOCK(ch->ch_lock, lock_flags);
 					ch->ch_flags |= CH_STOP;
 					DGNC_UNLOCK(ch->ch_lock, lock_flags);
-					DPR_INTR(("Setting CH_STOP\n"));
 				}
-				DPR_INTR(("Port: %d. XOFF detected in incoming data\n", port));
 			}
 		}
 
@@ -529,7 +507,6 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 		}
 
 		/* Parse any modem signal changes */
-		DPR_INTR(("MOD_STAT: sending to parse_modem_sigs\n"));
 		neo_parse_modem(ch, readb(&ch->ch_neo_uart->msr));
 	}
 }
@@ -556,8 +533,6 @@ static inline void neo_parse_lsr(struct dgnc_board *brd, uint port)
 
 	linestatus = readb(&ch->ch_neo_uart->lsr);
 
-	DPR_INTR(("%s:%d port: %d linestatus: %x\n", __FILE__, __LINE__, port, linestatus));
-
 	ch->ch_cached_lsr |= linestatus;
 
 	if (ch->ch_cached_lsr & UART_LSR_DR) {
@@ -571,35 +546,18 @@ static inline void neo_parse_lsr(struct dgnc_board *brd, uint port)
 	}
 
 	/*
-	 * This is a special flag. It indicates that at least 1
-	 * RX error (parity, framing, or break) has happened.
-	 * Mark this in our struct, which will tell me that I have
-	 *to do the special RX+LSR read for this FIFO load.
-	 */
-	if (linestatus & UART_17158_RX_FIFO_DATA_ERROR) {
-		DPR_INTR(("%s:%d Port: %d Got an RX error, need to parse LSR\n",
-			__FILE__, __LINE__, port));
-	}
-
-	/*
 	 * The next 3 tests should *NOT* happen, as the above test
 	 * should encapsulate all 3... At least, thats what Exar says.
 	 */
 
-	if (linestatus & UART_LSR_PE) {
+	if (linestatus & UART_LSR_PE)
 		ch->ch_err_parity++;
-		DPR_INTR(("%s:%d Port: %d. PAR ERR!\n", __FILE__, __LINE__, port));
-	}
 
-	if (linestatus & UART_LSR_FE) {
+	if (linestatus & UART_LSR_FE)
 		ch->ch_err_frame++;
-		DPR_INTR(("%s:%d Port: %d. FRM ERR!\n", __FILE__, __LINE__, port));
-	}
 
-	if (linestatus & UART_LSR_BI) {
+	if (linestatus & UART_LSR_BI)
 		ch->ch_err_break++;
-		DPR_INTR(("%s:%d Port: %d. BRK INTR!\n", __FILE__, __LINE__, port));
-	}
 
 	if (linestatus & UART_LSR_OE) {
 		/*
@@ -609,7 +567,6 @@ static inline void neo_parse_lsr(struct dgnc_board *brd, uint port)
 		 * Probably we should eventually have an orun stat in our driver...
 		 */
 		ch->ch_err_overrun++;
-		DPR_INTR(("%s:%d Port: %d. Rx Overrun!\n", __FILE__, __LINE__, port));
 	}
 
 	if (linestatus & UART_LSR_THRE) {
@@ -665,9 +622,6 @@ static void neo_param(struct tty_struct *tty)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	DPR_PARAM(("param start: tdev: %x cflags: %x oflags: %x iflags: %x\n",
-		ch->ch_tun.un_dev, ch->ch_c_cflag, ch->ch_c_oflag, ch->ch_c_iflag));
-
 	/*
 	 * If baud rate is zero, flush queues, and set mval to drop DTR.
 	 */
@@ -743,13 +697,10 @@ static void neo_param(struct tty_struct *tty)
 
 		jindex = baud;
 
-		if ((iindex >= 0) && (iindex < 4) && (jindex >= 0) && (jindex < 16)) {
+		if ((iindex >= 0) && (iindex < 4) && (jindex >= 0) && (jindex < 16))
 			baud = bauds[iindex][jindex];
-		} else {
-			DPR_IOCTL(("baud indices were out of range (%d)(%d)",
-				iindex, jindex));
+		else
 			baud = 0;
-		}
 
 		if (baud == 0)
 			baud = 9600;
@@ -1012,14 +963,11 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 	 */
 	uart_poll = readl(brd->re_map_membase + UART_17158_POLL_ADDR_OFFSET);
 
-	DPR_INTR(("%s:%d uart_poll: %x\n", __FILE__, __LINE__, uart_poll));
-
 	/*
 	 * If 0, no interrupts pending.
 	 * This can happen if the IRQ is shared among a couple Neo/Classic boards.
 	 */
 	if (!uart_poll) {
-		DPR_INTR(("Kernel interrupted to me, but no pending interrupts...\n"));
 		DGNC_UNLOCK(brd->bd_intr_lock, lock_flags);
 		return IRQ_NONE;
 	}
@@ -1043,14 +991,11 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 			continue;
 		}
 
-		DPR_INTR(("%s:%d port: %x type: %x\n", __FILE__, __LINE__, port, type));
-
 		/* Remove this port + type from uart_poll */
 		uart_poll &= ~(dgnc_offset_table[port]);
 
 		if (!type) {
 			/* If no type, just ignore it, and move onto next port */
-			DPR_INTR(("Interrupt with no type! port: %d\n", port));
 			continue;
 		}
 
@@ -1114,7 +1059,6 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 			 * these once and awhile.
 			 * Its harmless, just ignore it and move on.
 			 */
-			DPR_INTR(("%s:%d Unknown Interrupt type: %x\n", __FILE__, __LINE__, type));
 			continue;
 		}
 	}
@@ -1126,7 +1070,6 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 
 	DGNC_UNLOCK(brd->bd_intr_lock, lock_flags);
 
-	DPR_INTR(("dgnc_intr finish.\n"));
 	return IRQ_HANDLED;
 }
 
@@ -1342,9 +1285,6 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * I hope thats okay with everyone? Yes? Good.
 		 */
 		while (qleft < 1) {
-			DPR_READ(("Queue full, dropping DATA:%x LSR:%x\n",
-				ch->ch_rqueue[tail], ch->ch_equeue[tail]));
-
 			ch->ch_r_tail = tail = (tail + 1) & RQUEUEMASK;
 			ch->ch_err_overrun++;
 			qleft++;
@@ -1354,8 +1294,6 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		ch->ch_equeue[head] = (uchar) linestatus;
 		dgnc_sniff_nowait_nolock(ch, "UART READ", ch->ch_rqueue + head, 1);
 
-		DPR_READ(("DATA/LSR pair: %x %x\n", ch->ch_rqueue[head], ch->ch_equeue[head]));
-
 		/* Ditch any remaining linestatus value. */
 		linestatus = 0;
 
@@ -1398,8 +1336,6 @@ static int neo_drain(struct tty_struct *tty, uint seconds)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return -ENXIO;
 
-	DPR_IOCTL(("%d Drain wait started.\n", __LINE__));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 	un->un_flags |= UN_EMPTY;
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
@@ -1413,11 +1349,6 @@ static int neo_drain(struct tty_struct *tty, uint seconds)
 	rc = wait_event_interruptible(un->un_flags_wait, ((un->un_flags & UN_EMPTY) == 0));
 
 	/* If ret is non-zero, user ctrl-c'ed us */
-	if (rc)
-		DPR_IOCTL(("%d Drain - User ctrl c'ed\n", __LINE__));
-	else
-		DPR_IOCTL(("%d Drain wait finished.\n", __LINE__));
-
 	return rc;
 }
 
@@ -1442,10 +1373,9 @@ static void neo_flush_uart_write(struct channel_t *ch)
 
 		/* Check to see if the UART feels it completely flushed the FIFO. */
 		tmp = readb(&ch->ch_neo_uart->isr_fcr);
-		if (tmp & 4) {
-			DPR_IOCTL(("Still flushing TX UART... i: %d\n", i));
+		if (tmp & 4)
 			udelay(10);
-		} else
+		else
 			break;
 	}
 
@@ -1473,10 +1403,9 @@ static void neo_flush_uart_read(struct channel_t *ch)
 
 		/* Check to see if the UART feels it completely flushed the FIFO. */
 		tmp = readb(&ch->ch_neo_uart->isr_fcr);
-		if (tmp & 2) {
-			DPR_IOCTL(("Still flushing RX UART... i: %d\n", i));
+		if (tmp & 2)
 			udelay(10);
-		} else
+		else
 			break;
 	}
 }
@@ -1544,7 +1473,6 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 			}
 
 			writeb(ch->ch_wqueue[ch->ch_w_tail], &ch->ch_neo_uart->txrx);
-			DPR_WRITE(("Tx data: %x\n", ch->ch_wqueue[ch->ch_w_head]));
 			ch->ch_w_tail++;
 			ch->ch_w_tail &= WQUEUEMASK;
 			ch->ch_txcount++;
@@ -1645,8 +1573,6 @@ static void neo_parse_modem(struct channel_t *ch, uchar signals)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
-	DPR_MSIGS(("neo_parse_modem: port: %d msignals: %x\n", ch->ch_portnum, msignals));
-
 	/*
 	 * Do altpin switching. Altpin switches DCD and DSR.
 	 * This prolly breaks DSRPACE, so we should be more clever here.
@@ -1694,15 +1620,6 @@ static void neo_parse_modem(struct channel_t *ch, uchar signals)
 		ch->ch_mistat |= UART_MSR_CTS;
 	else
 		ch->ch_mistat &= ~UART_MSR_CTS;
-
-	DPR_MSIGS(("Port: %d DTR: %d RTS: %d CTS: %d DSR: %d " "RI: %d CD: %d\n",
-		ch->ch_portnum,
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MCR_DTR),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MCR_RTS),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_CTS),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_DSR),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_RI),
-		!!((ch->ch_mistat | ch->ch_mostat) & UART_MSR_DCD)));
 }
 
 
@@ -1830,7 +1747,6 @@ static void neo_send_break(struct channel_t *ch, int msecs)
 			neo_pci_posting_flush(ch->ch_bd);
 			ch->ch_flags &= ~(CH_BREAK_SENDING);
 			ch->ch_stop_sending_break = 0;
-			DPR_IOCTL(("Finishing UART_LCR_SBC! finished: %lx\n", jiffies));
 		}
 		return;
 	}
@@ -1849,8 +1765,6 @@ static void neo_send_break(struct channel_t *ch, int msecs)
 		writeb((temp | UART_LCR_SBC), &ch->ch_neo_uart->lcr);
 		neo_pci_posting_flush(ch->ch_bd);
 		ch->ch_flags |= (CH_BREAK_SENDING);
-		DPR_IOCTL(("Port %d. Starting UART_LCR_SBC! start: %lx should end: %lx\n",
-			ch->ch_portnum, jiffies, ch->ch_stop_sending_break));
 	}
 }
 
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index 281491a..29d9ba5 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -180,10 +180,8 @@ int dgnc_tty_preinit(void)
 	 */
 	dgnc_TmpWriteBuf = kmalloc(WRITEBUFLEN, GFP_KERNEL);
 
-	if (!dgnc_TmpWriteBuf) {
-		DPR_INIT(("unable to allocate tmp write buf"));
+	if (!dgnc_TmpWriteBuf)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -198,8 +196,6 @@ int dgnc_tty_register(struct dgnc_board *brd)
 {
 	int rc = 0;
 
-	DPR_INIT(("tty_register start\n"));
-
 	brd->SerialDriver.magic = TTY_DRIVER_MAGIC;
 
 	snprintf(brd->SerialName, MAXTTYNAMELEN, "tty_dgnc_%d_", brd->boardnum);
@@ -296,8 +292,6 @@ int dgnc_tty_register(struct dgnc_board *brd)
 	brd->dgnc_Serial_Major = brd->SerialDriver.major;
 	brd->dgnc_TransparentPrint_Major = brd->PrintDriver.major;
 
-	DPR_INIT(("DGNC REGISTER TTY: MAJOR: %d\n", brd->SerialDriver.major));
-
 	return rc;
 }
 
@@ -317,8 +311,6 @@ int dgnc_tty_init(struct dgnc_board *brd)
 	if (!brd)
 		return -ENXIO;
 
-	DPR_INIT(("dgnc_tty_init start\n"));
-
 	/*
 	 * Initialize board structure elements.
 	 */
@@ -339,10 +331,6 @@ int dgnc_tty_init(struct dgnc_board *brd)
 			 * interrupt context, and there are no locks held.
 			 */
 			brd->channels[i] = kzalloc(sizeof(*brd->channels[i]), GFP_KERNEL);
-			if (!brd->channels[i]) {
-				DPR_CORE(("%s:%d Unable to allocate memory for channel struct\n",
-				    __FILE__, __LINE__));
-			}
 		}
 	}
 
@@ -401,8 +389,6 @@ int dgnc_tty_init(struct dgnc_board *brd)
 
 	}
 
-	DPR_INIT(("dgnc_tty_init finish\n"));
-
 	return 0;
 }
 
@@ -678,8 +664,6 @@ void dgnc_input(struct channel_t *ch)
 		return;
 	}
 
-	DPR_READ(("dgnc_input start\n"));
-
 	/*
 	 * If the device is not open, or CREAD is off,
 	 * flush input data and return immediately.
@@ -687,10 +671,6 @@ void dgnc_input(struct channel_t *ch)
 	if (!tp || (tp->magic != TTY_MAGIC) || !(ch->ch_tun.un_flags & UN_ISOPEN) ||
 	    !(tp->termios.c_cflag & CREAD) || (ch->ch_tun.un_flags & UN_CLOSING)) {
 
-		DPR_READ(("input. dropping %d bytes on port %d...\n", data_len, ch->ch_portnum));
-		DPR_READ(("input. tp: %p tp->magic: %x MAGIC:%x ch flags: %x\n",
-			tp, tp ? tp->magic : 0, TTY_MAGIC, ch->ch_tun.un_flags));
-
 		ch->ch_r_head = tail;
 
 		/* Force queue flow control to be released, if needed */
@@ -705,13 +685,9 @@ void dgnc_input(struct channel_t *ch)
 	 */
 	if (ch->ch_flags & CH_FORCED_STOPI) {
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
-		DPR_READ(("Port %d throttled, not reading any data. head: %x tail: %x\n",
-			ch->ch_portnum, head, tail));
 		return;
 	}
 
-	DPR_READ(("dgnc_input start 2\n"));
-
 	flip_len = TTY_FLIPBUF_SIZE;
 
 	/* Chop down the length, if needed */
@@ -823,8 +799,6 @@ void dgnc_input(struct channel_t *ch)
 
 	if (ld)
 		tty_ldisc_deref(ld);
-
-	DPR_READ(("dgnc_input - finish\n"));
 }
 
 
@@ -839,8 +813,6 @@ void dgnc_carrier(struct channel_t *ch)
 	int virt_carrier = 0;
 	int phys_carrier = 0;
 
-	DPR_CARR(("dgnc_carrier called...\n"));
-
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
@@ -849,10 +821,8 @@ void dgnc_carrier(struct channel_t *ch)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	if (ch->ch_mistat & UART_MSR_DCD) {
-		DPR_CARR(("mistat: %x  D_CD: %x\n", ch->ch_mistat, ch->ch_mistat & UART_MSR_DCD));
+	if (ch->ch_mistat & UART_MSR_DCD)
 		phys_carrier = 1;
-	}
 
 	if (ch->ch_digi.digi_flags & DIGI_FORCEDCD)
 		virt_carrier = 1;
@@ -860,8 +830,6 @@ void dgnc_carrier(struct channel_t *ch)
 	if (ch->ch_c_cflag & CLOCAL)
 		virt_carrier = 1;
 
-	DPR_CARR(("DCD: physical: %d virt: %d\n", phys_carrier, virt_carrier));
-
 	/*
 	 * Test for a VIRTUAL carrier transition to HIGH.
 	 */
@@ -872,8 +840,6 @@ void dgnc_carrier(struct channel_t *ch)
 		 * for carrier in the open routine.
 		 */
 
-		DPR_CARR(("carrier: virt DCD rose\n"));
-
 		if (waitqueue_active(&(ch->ch_flags_wait)))
 			wake_up_interruptible(&ch->ch_flags_wait);
 	}
@@ -888,8 +854,6 @@ void dgnc_carrier(struct channel_t *ch)
 		 * for carrier in the open routine.
 		 */
 
-		DPR_CARR(("carrier: physical DCD rose\n"));
-
 		if (waitqueue_active(&(ch->ch_flags_wait)))
 			wake_up_interruptible(&ch->ch_flags_wait);
 	}
@@ -922,15 +886,11 @@ void dgnc_carrier(struct channel_t *ch)
 		if (waitqueue_active(&(ch->ch_flags_wait)))
 			wake_up_interruptible(&ch->ch_flags_wait);
 
-		if (ch->ch_tun.un_open_count > 0) {
-			DPR_CARR(("Sending tty hangup\n"));
+		if (ch->ch_tun.un_open_count > 0)
 			tty_hangup(ch->ch_tun.un_tty);
-		}
 
-		if (ch->ch_pun.un_open_count > 0) {
-			DPR_CARR(("Sending pr hangup\n"));
+		if (ch->ch_pun.un_open_count > 0)
 			tty_hangup(ch->ch_pun.un_tty);
-		}
 	}
 
 	/*
@@ -1040,8 +1000,6 @@ void dgnc_check_queue_flow_control(struct channel_t *ch)
 			if (!(ch->ch_flags & CH_RECEIVER_OFF)) {
 				ch->ch_bd->bd_ops->disable_receiver(ch);
 				ch->ch_flags |= (CH_RECEIVER_OFF);
-				DPR_READ(("Internal queue hit hilevel mark (%d)! Turning off interrupts.\n",
-					qleft));
 			}
 		}
 		/* SWFLOW */
@@ -1049,7 +1007,6 @@ void dgnc_check_queue_flow_control(struct channel_t *ch)
 			if (ch->ch_stops_sent <= MAX_STOPS_SENT) {
 				ch->ch_bd->bd_ops->send_stop_character(ch);
 				ch->ch_stops_sent++;
-				DPR_READ(("Sending stop char!  Times sent: %x\n", ch->ch_stops_sent));
 			}
 		}
 		/* No FLOW */
@@ -1079,15 +1036,12 @@ void dgnc_check_queue_flow_control(struct channel_t *ch)
 			if (ch->ch_flags & CH_RECEIVER_OFF) {
 				ch->ch_bd->bd_ops->enable_receiver(ch);
 				ch->ch_flags &= ~(CH_RECEIVER_OFF);
-				DPR_READ(("Internal queue hit lowlevel mark (%d)! Turning on interrupts.\n",
-					qleft));
 			}
 		}
 		/* SWFLOW */
 		else if (ch->ch_c_iflag & IXOFF && ch->ch_stops_sent) {
 			ch->ch_stops_sent = 0;
 			ch->ch_bd->bd_ops->send_start_character(ch);
-			DPR_READ(("Sending start char!\n"));
 		}
 		/* No FLOW */
 		else {
@@ -1262,7 +1216,6 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 		un->un_type = DGNC_PRINT;
 	} else {
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
-		DPR_OPEN(("%d Unknown TYPE!\n", __LINE__));
 		return -ENXIO;
 	}
 
@@ -1276,10 +1229,8 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 	rc = wait_event_interruptible(ch->ch_flags_wait, ((ch->ch_flags & CH_OPENING) == 0));
 
 	/* If ret is non-zero, user ctrl-c'ed us */
-	if (rc) {
-		DPR_OPEN(("%d User ctrl c'ed\n", __LINE__));
+	if (rc)
 		return -EINTR;
-	}
 
 	/*
 	 * If either unit is in the middle of the fragile part of close,
@@ -1292,10 +1243,8 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 		(((ch->ch_tun.un_flags | ch->ch_pun.un_flags) & UN_CLOSING) == 0));
 
 	/* If ret is non-zero, user ctrl-c'ed us */
-	if (rc) {
-		DPR_OPEN(("%d User ctrl c'ed\n", __LINE__));
+	if (rc)
 		return -EINTR;
-	}
 
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
@@ -1303,10 +1252,6 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 	/* Store our unit into driver_data, so we always have it available. */
 	tty->driver_data = un;
 
-	DPR_OPEN(("Open called. MAJOR: %d MINOR:%d PORT_NUM: %x unit: %p NAME: %s\n",
-		MAJOR(tty_devnum(tty)), MINOR(tty_devnum(tty)), PORT_NUM(minor), un, brd->name));
-
-	DPR_OPEN(("%d: tflag=%x  pflag=%x\n", __LINE__, ch->ch_tun.un_flags, ch->ch_pun.un_flags));
 
 	/*
 	 * Initialize tty's
@@ -1345,8 +1290,6 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 	 */
 	if (!((ch->ch_tun.un_flags | ch->ch_pun.un_flags) & UN_ISOPEN)) {
 
-		DPR_OPEN(("dgnc_open: initializing channel in open...\n"));
-
 		/*
 		 * Flush input queues.
 		 */
@@ -1397,10 +1340,6 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 
 	rc = dgnc_block_til_ready(tty, file, ch);
 
-	if (rc)
-		DPR_OPEN(("dgnc_tty_open returning after dgnc_block_til_ready "
-			"with %d\n", rc));
-
 	/* No going back now, increment our unit and channel counters */
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 	ch->ch_open_count++;
@@ -1408,7 +1347,6 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 	un->un_flags |= (UN_ISOPEN);
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_OPEN(("dgnc_tty_open finished\n"));
 	return rc;
 }
 
@@ -1434,8 +1372,6 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return -ENXIO;
 
-	DPR_OPEN(("dgnc_block_til_ready - before block.\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	ch->ch_wopen++;
@@ -1483,15 +1419,11 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 				break;
 			}
 
-			if (ch->ch_flags & CH_CD) {
-				DPR_OPEN(("%d: ch_flags: %x\n", __LINE__, ch->ch_flags));
+			if (ch->ch_flags & CH_CD)
 				break;
-			}
 
-			if (ch->ch_flags & CH_FCAR) {
-				DPR_OPEN(("%d: ch_flags: %x\n", __LINE__, ch->ch_flags));
+			if (ch->ch_flags & CH_FCAR)
 				break;
-			}
 		} else {
 			sleep_on_un_flags = 1;
 		}
@@ -1502,13 +1434,10 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 		 * Leave loop with error set.
 		 */
 		if (signal_pending(current)) {
-			DPR_OPEN(("%d: signal pending...\n", __LINE__));
 			retval = -ERESTARTSYS;
 			break;
 		}
 
-		DPR_OPEN(("dgnc_block_til_ready - blocking.\n"));
-
 		/*
 		 * Store the flags before we let go of channel lock
 		 */
@@ -1525,9 +1454,6 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-		DPR_OPEN(("Going to sleep on %s flags...\n",
-			(sleep_on_un_flags ? "un" : "ch")));
-
 		/*
 		 * Wait for something in the flags to change from the current value.
 		 */
@@ -1538,8 +1464,6 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 			retval = wait_event_interruptible(ch->ch_flags_wait,
 				(old_flags != ch->ch_flags));
 
-		DPR_OPEN(("After sleep... retval: %x\n", retval));
-
 		/*
 		 * We got woken up for some reason.
 		 * Before looping around, grab our channel lock.
@@ -1551,14 +1475,8 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_OPEN(("dgnc_block_til_ready - after blocking.\n"));
-
-	if (retval) {
-		DPR_OPEN(("dgnc_block_til_ready - done. error. retval: %x\n", retval));
+	if (retval)
 		return retval;
-	}
-
-	DPR_OPEN(("dgnc_block_til_ready - done no error. jiffies: %lu\n", jiffies));
 
 	return 0;
 }
@@ -1580,14 +1498,9 @@ static void dgnc_tty_hangup(struct tty_struct *tty)
 	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return;
 
-	DPR_CLOSE(("dgnc_hangup called. ch->ch_open_count: %d un->un_open_count: %d\n",
-		un->un_ch->ch_open_count, un->un_open_count));
-
 	/* flush the transmit queues */
 	dgnc_tty_flush_buffer(tty);
 
-	DPR_CLOSE(("dgnc_hangup finished. ch->ch_open_count: %d un->un_open_count: %d\n",
-		un->un_ch->ch_open_count, un->un_open_count));
 }
 
 
@@ -1621,8 +1534,6 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 
 	ts = &tty->termios;
 
-	DPR_CLOSE(("Close called\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	/*
@@ -1649,16 +1560,11 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 	ch->ch_open_count--;
 
 	if (ch->ch_open_count && un->un_open_count) {
-		DPR_CLOSE(("dgnc_tty_close: not last close ch: %d un:%d\n",
-			ch->ch_open_count, un->un_open_count));
-
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 		return;
 	}
 
 	/* OK, its the last close on the unit */
-	DPR_CLOSE(("dgnc_tty_close - last close on unit procedures\n"));
-
 	un->un_flags |= UN_CLOSING;
 
 	tty->closing = 1;
@@ -1685,14 +1591,8 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 		/* wait for output to drain */
 		/* This will also return if we take an interrupt */
 
-		DPR_CLOSE(("Calling wait_for_drain\n"));
 		rc = bd->bd_ops->drain(tty, 0);
 
-		DPR_CLOSE(("After calling wait_for_drain\n"));
-
-		if (rc)
-			DPR_BASIC(("dgnc_tty_close - bad return: %d ", rc));
-
 		dgnc_tty_flush_buffer(tty);
 		tty_ldisc_flush(tty);
 
@@ -1704,7 +1604,6 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 		 * If we have HUPCL set, lower DTR and RTS
 		 */
 		if (ch->ch_c_cflag & HUPCL) {
-			DPR_CLOSE(("Close. HUPCL set, dropping DTR/RTS\n"));
 
 			/* Drop RTS/DTR */
 			ch->ch_mostat &= ~(UART_MCR_DTR | UART_MCR_RTS);
@@ -1715,13 +1614,9 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 			 * have been dropped for modems to see it.
 			 */
 			if (ch->ch_close_delay) {
-				DPR_CLOSE(("Close. Sleeping for RTS/DTR drop\n"));
-
 				DGNC_UNLOCK(ch->ch_lock, lock_flags);
 				dgnc_ms_sleep(ch->ch_close_delay);
 				DGNC_LOCK(ch->ch_lock, lock_flags);
-
-				DPR_CLOSE(("Close. After sleeping for RTS/DTR drop\n"));
 			}
 		}
 
@@ -1743,13 +1638,10 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 	un->un_tty = NULL;
 	un->un_flags &= ~(UN_ISOPEN | UN_CLOSING);
 
-	DPR_CLOSE(("Close. Doing wakeups\n"));
 	wake_up_interruptible(&ch->ch_flags_wait);
 	wake_up_interruptible(&un->un_flags_wait);
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_BASIC(("dgnc_tty_close - complete\n"));
 }
 
 
@@ -1799,9 +1691,6 @@ static int dgnc_tty_chars_in_buffer(struct tty_struct *tty)
 			chars = thead - ttail + WQUEUESIZE;
 	}
 
-	DPR_WRITE(("dgnc_tty_chars_in_buffer. Port: %x - %d (head: %d tail: %d)\n",
-		ch->ch_portnum, chars, thead, ttail));
-
 	return chars;
 }
 
@@ -1919,8 +1808,6 @@ static int dgnc_tty_write_room(struct tty_struct *tty)
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_WRITE(("dgnc_tty_write_room - %d tail: %d head: %d\n", ret, tail, head));
-
 	return ret;
 }
 
@@ -1937,7 +1824,6 @@ static int dgnc_tty_put_char(struct tty_struct *tty, unsigned char c)
 	/*
 	 * Simply call tty_write.
 	 */
-	DPR_WRITE(("dgnc_tty_put_char called\n"));
 	dgnc_tty_write(tty, &c, 1);
 	return 1;
 }
@@ -1977,9 +1863,6 @@ static int dgnc_tty_write(struct tty_struct *tty,
 	if (!count)
 		return 0;
 
-	DPR_WRITE(("dgnc_tty_write: Port: %x tty=%p user=%d len=%d\n",
-		ch->ch_portnum, tty, from_user, count));
-
 	/*
 	 * Store original amount of characters passed in.
 	 * This helps to figure out if we should ask the FEP
@@ -1998,9 +1881,6 @@ static int dgnc_tty_write(struct tty_struct *tty,
 	if (bufcount < 0)
 		bufcount += WQUEUESIZE;
 
-	DPR_WRITE(("%d: bufcount: %x count: %x tail: %x head: %x tmask: %x\n",
-		__LINE__, bufcount, count, tail, head, tmask));
-
 	/*
 	 * Limit printer output to maxcps overall, with bursts allowed
 	 * up to bufsize characters.
@@ -2128,8 +2008,6 @@ static int dgnc_tty_write(struct tty_struct *tty,
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 	}
 
-	DPR_WRITE(("Write finished - Write %d bytes of %d.\n", count, orig_count));
-
 	if (count) {
 		/*
 		 * Channel lock is grabbed and then released
@@ -2165,8 +2043,6 @@ static int dgnc_tty_tiocmget(struct tty_struct *tty)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return result;
 
-	DPR_IOCTL(("dgnc_tty_tiocmget start\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	mstat = (ch->ch_mostat | ch->ch_mistat);
@@ -2188,8 +2064,6 @@ static int dgnc_tty_tiocmget(struct tty_struct *tty)
 	if (mstat & UART_MSR_DCD)
 		result |= TIOCM_CD;
 
-	DPR_IOCTL(("dgnc_tty_tiocmget finish\n"));
-
 	return result;
 }
 
@@ -2224,9 +2098,6 @@ static int dgnc_tty_tiocmset(struct tty_struct *tty,
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return ret;
 
-	DPR_IOCTL(("dgnc_tty_tiocmset start\n"));
-
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	if (set & TIOCM_RTS)
@@ -2245,8 +2116,6 @@ static int dgnc_tty_tiocmset(struct tty_struct *tty,
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_IOCTL(("dgnc_tty_tiocmset finish\n"));
-
 	return 0;
 }
 
@@ -2290,16 +2159,12 @@ static int dgnc_tty_send_break(struct tty_struct *tty, int msec)
 		break;
 	}
 
-	DPR_IOCTL(("dgnc_tty_send_break start 1.  %lx\n", jiffies));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	ch->ch_bd->bd_ops->send_break(ch, msec);
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_IOCTL(("dgnc_tty_send_break finish\n"));
-
 	return 0;
 
 }
@@ -2333,10 +2198,7 @@ static void dgnc_tty_wait_until_sent(struct tty_struct *tty, int timeout)
 		return;
 
 	rc = bd->bd_ops->drain(tty, 0);
-	if (rc) {
-		DPR_IOCTL(("dgnc_tty_ioctl - bad return: %d ", rc));
-		return;
-	}
+
 	return;
 }
 
@@ -2368,14 +2230,12 @@ static void dgnc_tty_send_xchar(struct tty_struct *tty, char c)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	DPR_IOCTL(("dgnc_tty_send_xchar start\n"));
 	printk("dgnc_tty_send_xchar start\n");
 
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 	bd->bd_ops->send_immediate_char(ch, c);
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_IOCTL(("dgnc_tty_send_xchar finish\n"));
 	printk("dgnc_tty_send_xchar finish\n");
 	return;
 }
@@ -2392,8 +2252,6 @@ static inline int dgnc_get_mstat(struct channel_t *ch)
 	int result = -EIO;
 	ulong   lock_flags;
 
-	DPR_IOCTL(("dgnc_getmstat start\n"));
-
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return -ENXIO;
 
@@ -2418,8 +2276,6 @@ static inline int dgnc_get_mstat(struct channel_t *ch)
 	if (mstat & UART_MSR_DCD)
 		result |= TIOCM_CD;
 
-	DPR_IOCTL(("dgnc_getmstat finish\n"));
-
 	return result;
 }
 
@@ -2433,8 +2289,6 @@ static int dgnc_get_modem_info(struct channel_t *ch, unsigned int  __user *value
 	int result;
 	int rc;
 
-	DPR_IOCTL(("dgnc_get_modem_info start\n"));
-
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return -ENXIO;
 
@@ -2445,7 +2299,6 @@ static int dgnc_get_modem_info(struct channel_t *ch, unsigned int  __user *value
 
 	rc = put_user(result, value);
 
-	DPR_IOCTL(("dgnc_get_modem_info finish\n"));
 	return rc;
 }
 
@@ -2481,8 +2334,6 @@ static int dgnc_set_modem_info(struct tty_struct *tty, unsigned int command, uns
 
 	ret = 0;
 
-	DPR_IOCTL(("dgnc_set_modem_info() start\n"));
-
 	ret = get_user(arg, value);
 	if (ret)
 		return ret;
@@ -2530,8 +2381,6 @@ static int dgnc_set_modem_info(struct tty_struct *tty, unsigned int command, uns
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_IOCTL(("dgnc_set_modem_info finish\n"));
-
 	return 0;
 }
 
@@ -2594,8 +2443,6 @@ static int dgnc_tty_digiseta(struct tty_struct *tty, struct digi_t __user *new_i
 	struct digi_t new_digi;
 	ulong lock_flags;
 
-	DPR_IOCTL(("DIGI_SETA start\n"));
-
 	if (!tty || tty->magic != TTY_MAGIC)
 		return -EFAULT;
 
@@ -2611,10 +2458,8 @@ static int dgnc_tty_digiseta(struct tty_struct *tty, struct digi_t __user *new_i
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return -EFAULT;
 
-	if (copy_from_user(&new_digi, new_info, sizeof(new_digi))) {
-		DPR_IOCTL(("DIGI_SETA failed copy_from_user\n"));
+	if (copy_from_user(&new_digi, new_info, sizeof(new_digi)))
 		return -EFAULT;
-	}
 
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
@@ -2661,8 +2506,6 @@ static int dgnc_tty_digiseta(struct tty_struct *tty, struct digi_t __user *new_i
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-	DPR_IOCTL(("DIGI_SETA finish\n"));
-
 	return 0;
 }
 
@@ -2725,15 +2568,11 @@ static void dgnc_tty_throttle(struct tty_struct *tty)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
-	DPR_IOCTL(("dgnc_tty_throttle start\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	ch->ch_flags |= (CH_FORCED_STOPI);
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_IOCTL(("dgnc_tty_throttle finish\n"));
 }
 
 
@@ -2754,15 +2593,11 @@ static void dgnc_tty_unthrottle(struct tty_struct *tty)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
-	DPR_IOCTL(("dgnc_tty_unthrottle start\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	ch->ch_flags &= ~(CH_FORCED_STOPI);
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_IOCTL(("dgnc_tty_unthrottle finish\n"));
 }
 
 
@@ -2788,15 +2623,11 @@ static void dgnc_tty_start(struct tty_struct *tty)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	DPR_IOCTL(("dgcn_tty_start start\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	ch->ch_flags &= ~(CH_FORCED_STOP);
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_IOCTL(("dgnc_tty_start finish\n"));
 }
 
 
@@ -2822,15 +2653,11 @@ static void dgnc_tty_stop(struct tty_struct *tty)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	DPR_IOCTL(("dgnc_tty_stop start\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	ch->ch_flags |= (CH_FORCED_STOP);
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_IOCTL(("dgnc_tty_stop finish\n"));
 }
 
 
@@ -2869,15 +2696,11 @@ static void dgnc_tty_flush_chars(struct tty_struct *tty)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	DPR_IOCTL(("dgnc_tty_flush_chars start\n"));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	/* Do something maybe here */
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_IOCTL(("dgnc_tty_flush_chars finish\n"));
 }
 
 
@@ -2904,8 +2727,6 @@ static void dgnc_tty_flush_buffer(struct tty_struct *tty)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
-	DPR_IOCTL(("dgnc_tty_flush_buffer on port: %d start\n", ch->ch_portnum));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	ch->ch_flags &= ~CH_STOP;
@@ -2926,8 +2747,6 @@ static void dgnc_tty_flush_buffer(struct tty_struct *tty)
 	}
 
 	DGNC_UNLOCK(ch->ch_lock, lock_flags);
-
-	DPR_IOCTL(("dgnc_tty_flush_buffer finish\n"));
 }
 
 
@@ -2968,13 +2787,9 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return -ENODEV;
 
-	DPR_IOCTL(("dgnc_tty_ioctl start on port %d - cmd %s (%x), arg %lx\n",
-		ch->ch_portnum, dgnc_ioctl_name(cmd), cmd, arg));
-
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
 	if (un->un_open_count <= 0) {
-		DPR_BASIC(("dgnc_tty_ioctl - unit not open.\n"));
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 		return -EIO;
 	}
@@ -2999,10 +2814,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
 
-		if (rc) {
-			DPR_IOCTL(("dgnc_tty_ioctl - bad return: %d ", rc));
+		if (rc)
 			return -EINTR;
-		}
 
 		DGNC_LOCK(ch->ch_lock, lock_flags);
 
@@ -3012,9 +2825,6 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-		DPR_IOCTL(("dgnc_tty_ioctl finish on port %d - cmd %s (%x), arg %lx\n",
-			ch->ch_portnum, dgnc_ioctl_name(cmd), cmd, arg));
-
 		return 0;
 
 
@@ -3030,10 +2840,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 			return rc;
 
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
-		if (rc) {
-			DPR_IOCTL(("dgnc_tty_ioctl - bad return: %d ", rc));
+		if (rc)
 			return -EINTR;
-		}
 
 		DGNC_LOCK(ch->ch_lock, lock_flags);
 
@@ -3041,9 +2849,6 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-		DPR_IOCTL(("dgnc_tty_ioctl finish on port %d - cmd %s (%x), arg %lx\n",
-			ch->ch_portnum, dgnc_ioctl_name(cmd), cmd, arg));
-
 		return 0;
 
 	case TIOCSBRK:
@@ -3053,10 +2858,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 			return rc;
 
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
-		if (rc) {
-			DPR_IOCTL(("dgnc_tty_ioctl - bad return: %d ", rc));
+		if (rc)
 			return -EINTR;
-		}
 
 		DGNC_LOCK(ch->ch_lock, lock_flags);
 
@@ -3064,9 +2867,6 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-		DPR_IOCTL(("dgnc_tty_ioctl finish on port %d - cmd %s (%x), arg %lx\n",
-			ch->ch_portnum, dgnc_ioctl_name(cmd), cmd, arg));
-
 		return 0;
 
 	case TIOCCBRK:
@@ -3176,13 +2976,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		/* now wait for all the output to drain */
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
-		if (rc) {
-			DPR_IOCTL(("dgnc_tty_ioctl - bad return: %d\n", rc));
+		if (rc)
 			return -EINTR;
-		}
-
-		DPR_IOCTL(("dgnc_tty_ioctl finish on port %d - cmd %s (%x), arg %lx\n",
-			ch->ch_portnum, dgnc_ioctl_name(cmd), cmd, arg));
 
 		/* pretend we didn't recognize this */
 		return -ENOIOCTLCMD;
@@ -3191,10 +2986,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
-		if (rc) {
-			DPR_IOCTL(("dgnc_tty_ioctl - bad return: %d ", rc));
+		if (rc)
 			return -EINTR;
-		}
 
 		/* pretend we didn't recognize this */
 		return -ENOIOCTLCMD;
@@ -3217,10 +3010,10 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 			DGNC_UNLOCK(ch->ch_lock, lock_flags);
 			rc = ch->ch_bd->bd_ops->drain(tty, 0);
-			if (rc) {
-				DPR_IOCTL(("dgnc_tty_ioctl - bad return: %d ", rc));
+
+			if (rc)
 				return -EINTR;
-			}
+
 			DGNC_LOCK(ch->ch_lock, lock_flags);
 		} else {
 			tty_ldisc_flush(tty);
@@ -3411,10 +3204,6 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	default:
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-		DPR_IOCTL(("dgnc_tty_ioctl - in default\n"));
-		DPR_IOCTL(("dgnc_tty_ioctl end - cmd %s (%x), arg %lx\n",
-			dgnc_ioctl_name(cmd), cmd, arg));
-
 		return -ENOIOCTLCMD;
 	}
 }
-- 
1.7.9.5

