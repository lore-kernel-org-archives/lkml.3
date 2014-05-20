Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaETRtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:49:03 -0400
Received: from mailout.micron.com ([137.201.242.129]:54144 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaETRs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:48:59 -0400
Message-ID: <537B9588.2000306@micron.com>
Date: Tue, 20 May 2014 10:48:56 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH] mtip32xx: move error handling to service thread
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20706.000
X-TM-AS-Result: No--17.643500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move error handling to service thread, and use mtip_set_timeout()
to set timeouts for HDIO_DRIVE_TASK and HDIO_DRIVE_CMD IOCTL commands.

Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   71 +++++++++++++++++++++++++------------
 drivers/block/mtip32xx/mtip32xx.h |    8 +++--
 2 files changed, 53 insertions(+), 26 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 4efc676..6124aa4 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -620,7 +620,6 @@ static void mtip_handle_tfe(struct driver_data *dd)
 
 	port = dd->port;
 
-	/* Stop the timer to prevent command timeouts. */
 	set_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
 
 	if (test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags) &&
@@ -855,8 +854,6 @@ static inline void mtip_process_legacy(struct driver_data *dd, u32 port_stat)
  */
 static inline void mtip_process_errors(struct driver_data *dd, u32 port_stat)
 {
-	if (likely(port_stat & (PORT_IRQ_TF_ERR | PORT_IRQ_IF_ERR)))
-		mtip_handle_tfe(dd);
 
 	if (unlikely(port_stat & PORT_IRQ_CONNECT)) {
 		dev_warn(&dd->pdev->dev,
@@ -874,6 +871,12 @@ static inline void mtip_process_errors(struct driver_data *dd, u32 port_stat)
 		dev_warn(&dd->pdev->dev,
 			"Port stat errors %x unhandled\n",
 			(port_stat & ~PORT_IRQ_HANDLED));
+		if (mtip_check_surprise_removal(dd->pdev))
+			return;
+	}
+	if (likely(port_stat & (PORT_IRQ_TF_ERR | PORT_IRQ_IF_ERR))) {
+		set_bit(MTIP_PF_EH_ACTIVE_BIT, &dd->port->flags);
+		wake_up_interruptible(&dd->port->svc_wait);
 	}
 }
 
@@ -1040,8 +1043,13 @@ static int mtip_quiesce_io(struct mtip_port *port, unsigned long timeout)
 			msleep(20);
 			continue; /* svc thd is actively issuing commands */
 		}
+
+		msleep(100);
+		if (mtip_check_surprise_removal(port->dd->pdev))
+			goto err_fault;
 		if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &port->dd->dd_flag))
 			goto err_fault;
+
 		/*
 		 * Ignore s_active bit 0 of array element 0.
 		 * This bit will always be set
@@ -1052,8 +1060,6 @@ static int mtip_quiesce_io(struct mtip_port *port, unsigned long timeout)
 
 		if (!active)
 			break;
-
-		msleep(20);
 	} while (time_before(jiffies, to));
 
 	blk_mq_start_stopped_hw_queues(port->dd->queue, true);
@@ -1113,7 +1119,8 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	if (atomic == GFP_KERNEL) {
 		if (fis->command != ATA_CMD_STANDBYNOW1) {
 			/* wait for io to complete if non atomic */
-			if (mtip_quiesce_io(port, 5000) < 0) {
+			if (mtip_quiesce_io(port,
+					MTIP_QUIESCE_IO_TIMEOUT_MS) < 0) {
 				dev_warn(&dd->pdev->dev,
 					"Failed to quiesce IO\n");
 				mtip_put_int_command(dd, int_cmd);
@@ -1161,9 +1168,9 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 
 	if (atomic == GFP_KERNEL) {
 		/* Wait for the command to complete or timeout. */
-		if (wait_for_completion_interruptible_timeout(
+		if ((rv = wait_for_completion_interruptible_timeout(
 				&wait,
-				msecs_to_jiffies(timeout)) <= 0) {
+				msecs_to_jiffies(timeout))) <= 0) {
 			if (rv == -ERESTARTSYS) { /* interrupted */
 				dev_err(&dd->pdev->dev,
 					"Internal command [%02X] was interrupted after %lu ms\n",
@@ -1299,7 +1306,7 @@ static void mtip_set_timeout(struct driver_data *dd,
 		*timeout = 15000;  /* 15 seconds */
 		break;
 	default:
-		*timeout = MTIP_IOCTL_COMMAND_TIMEOUT_MS;
+		*timeout = MTIP_IOCTL_CMD_TIMEOUT_MS;
 		break;
 	}
 }
@@ -1351,7 +1358,7 @@ static int mtip_get_identify(struct mtip_port *port, void __user *user_buffer)
 				sizeof(u16) * ATA_ID_WORDS,
 				0,
 				GFP_KERNEL,
-				MTIP_INTERNAL_COMMAND_TIMEOUT_MS)
+				MTIP_INT_CMD_TIMEOUT_MS)
 				< 0) {
 		rv = -1;
 		goto out;
@@ -1483,7 +1490,7 @@ static int mtip_read_log_page(struct mtip_port *port, u8 page, u16 *buffer,
 					sectors * ATA_SECT_SIZE,
 					0,
 					GFP_ATOMIC,
-					MTIP_INTERNAL_COMMAND_TIMEOUT_MS);
+					MTIP_INT_CMD_TIMEOUT_MS);
 }
 
 /*
@@ -1776,6 +1783,7 @@ static int exec_drive_task(struct mtip_port *port, u8 *command)
 {
 	struct host_to_dev_fis	fis;
 	struct host_to_dev_fis *reply = (port->rxfis + RX_FIS_D2H_REG);
+	unsigned int to;
 
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
@@ -1789,6 +1797,8 @@ static int exec_drive_task(struct mtip_port *port, u8 *command)
 	fis.cyl_hi	= command[5];
 	fis.device	= command[6] & ~0x10; /* Clear the dev bit*/
 
+	mtip_set_timeout(port->dd, &fis, &to, 0);
+
 	dbg_printk(MTIP_DRV_NAME " %s: User Command: cmd %x, feat %x, nsect %x, sect %x, lcyl %x, hcyl %x, sel %x\n",
 		__func__,
 		command[0],
@@ -1807,7 +1817,7 @@ static int exec_drive_task(struct mtip_port *port, u8 *command)
 				 0,
 				 0,
 				 GFP_KERNEL,
-				 MTIP_IOCTL_COMMAND_TIMEOUT_MS) < 0) {
+				 to) < 0) {
 		return -1;
 	}
 
@@ -1847,6 +1857,7 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 	u8 *buf = NULL;
 	dma_addr_t dma_addr = 0;
 	int rv = 0, xfer_sz = command[3];
+	unsigned int to;
 
 	if (xfer_sz) {
 		if (!user_buffer)
@@ -1878,6 +1889,8 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 		fis.cyl_hi	= 0xC2;
 	}
 
+	mtip_set_timeout(port->dd, &fis, &to, 0);
+
 	if (xfer_sz)
 		reply = (port->rxfis + RX_FIS_PIO_SETUP);
 	else
@@ -1900,7 +1913,7 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 				 (xfer_sz ? ATA_SECT_SIZE * xfer_sz : 0),
 				 0,
 				 GFP_KERNEL,
-				 MTIP_IOCTL_COMMAND_TIMEOUT_MS)
+				 to)
 				 < 0) {
 		rv = -EFAULT;
 		goto exit_drive_command;
@@ -2956,6 +2969,11 @@ static int mtip_service_thread(void *data)
 	int ret;
 
 	while (1) {
+		if (kthread_should_stop() ||
+			test_bit(MTIP_PF_SVC_THD_STOP_BIT, &port->flags))
+			goto st_out;
+		clear_bit(MTIP_PF_SVC_THD_ACTIVE_BIT, &port->flags);
+
 		/*
 		 * the condition is to check neither an internal command is
 		 * is in progress nor error handling is active
@@ -2963,11 +2981,12 @@ static int mtip_service_thread(void *data)
 		wait_event_interruptible(port->svc_wait, (port->flags) &&
 			!(port->flags & MTIP_PF_PAUSE_IO));
 
-		if (kthread_should_stop())
-			goto st_out;
-
 		set_bit(MTIP_PF_SVC_THD_ACTIVE_BIT, &port->flags);
 
+		if (kthread_should_stop() ||
+			test_bit(MTIP_PF_SVC_THD_STOP_BIT, &port->flags))
+			goto st_out;
+
 		/* If I am an orphan, start self cleanup */
 		if (test_bit(MTIP_PF_SR_CLEANUP_BIT, &port->flags))
 			break;
@@ -2976,6 +2995,16 @@ static int mtip_service_thread(void *data)
 				&dd->dd_flag)))
 			goto st_out;
 
+restart_eh:
+		/* Demux bits: start with error handling */
+		if (test_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags)) {
+			mtip_handle_tfe(dd);
+			clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
+		}
+
+		if (test_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags))
+			goto restart_eh;
+
 		if (test_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags)) {
 			slot = 1;
 			/* used to restrict the loop to one iteration */
@@ -3005,16 +3034,14 @@ static int mtip_service_thread(void *data)
 			}
 
 			clear_bit(MTIP_PF_ISSUE_CMDS_BIT, &port->flags);
-		} else if (test_bit(MTIP_PF_REBUILD_BIT, &port->flags)) {
+		}
+
+		if (test_bit(MTIP_PF_REBUILD_BIT, &port->flags)) {
 			if (mtip_ftl_rebuild_poll(dd) < 0)
 				set_bit(MTIP_DDF_REBUILD_FAILED_BIT,
 							&dd->dd_flag);
 			clear_bit(MTIP_PF_REBUILD_BIT, &port->flags);
 		}
-		clear_bit(MTIP_PF_SVC_THD_ACTIVE_BIT, &port->flags);
-
-		if (test_bit(MTIP_PF_SVC_THD_STOP_BIT, &port->flags))
-			goto st_out;
 	}
 
 	/* wait for pci remove to exit */
@@ -4499,8 +4526,6 @@ static void mtip_pci_remove(struct pci_dev *pdev)
 
 	pcim_iounmap_regions(pdev, 1 << MTIP_ABAR);
 	pci_set_drvdata(pdev, NULL);
-	pci_dev_put(pdev);
-
 }
 
 /*
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 982a88f..4b9b554 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -40,9 +40,11 @@
 #define MTIP_MAX_RETRIES	2
 
 /* Various timeout values in ms */
-#define MTIP_NCQ_COMMAND_TIMEOUT_MS       5000
-#define MTIP_IOCTL_COMMAND_TIMEOUT_MS     5000
-#define MTIP_INTERNAL_COMMAND_TIMEOUT_MS  5000
+#define MTIP_NCQ_CMD_TIMEOUT_MS      15000
+#define MTIP_IOCTL_CMD_TIMEOUT_MS    5000
+#define MTIP_INT_CMD_TIMEOUT_MS      5000
+#define MTIP_QUIESCE_IO_TIMEOUT_MS   (MTIP_NCQ_CMD_TIMEOUT_MS * \
+				     (MTIP_MAX_RETRIES + 1))
 
 /* check for timeouts every 500ms */
 #define MTIP_TIMEOUT_CHECK_PERIOD	500
-- 
1.7.1

