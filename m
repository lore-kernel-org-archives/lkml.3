Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab3DCOXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:23:16 -0400
Received: from masquerade.micron.com ([137.201.242.130]:2861 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab3DCOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:23:14 -0400
Message-ID: <515C3B4B.7050303@micron.com>
Date: Wed, 3 Apr 2013 19:53:07 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sam Bradshaw" <sbradshaw@micron.com>
Subject: [PATCH 1/3] mtip32xx: recovery from command timeout
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19764.007
X-TM-AS-Result: No--12.767800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To recover from command timeouts, reset the device. In addition
to that improved timeout handling of PIO commands.

Signed-off-by: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |  177 ++++++++++++++++++-------------------
 1 files changed, 87 insertions(+), 90 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 11cc952..5becdaa 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -243,40 +243,31 @@ static inline void release_slot(struct mtip_port *port, int tag)
 /*
  * Reset the HBA (without sleeping)
  *
- * Just like hba_reset, except does not call sleep, so can be
- * run from interrupt/tasklet context.
- *
  * @dd Pointer to the driver data structure.
  *
  * return value
  *	0	The reset was successful.
  *	-1	The HBA Reset bit did not clear.
  */
-static int hba_reset_nosleep(struct driver_data *dd)
+static int mtip_hba_reset(struct driver_data *dd)
 {
 	unsigned long timeout;
 
-	/* Chip quirk: quiesce any chip function */
-	mdelay(10);
-
 	/* Set the reset bit */
 	writel(HOST_RESET, dd->mmio + HOST_CTL);
 
 	/* Flush */
 	readl(dd->mmio + HOST_CTL);
 
-	/*
-	 * Wait 10ms then spin for up to 1 second
-	 * waiting for reset acknowledgement
-	 */
-	timeout = jiffies + msecs_to_jiffies(1000);
-	mdelay(10);
-	while ((readl(dd->mmio + HOST_CTL) & HOST_RESET)
-		 && time_before(jiffies, timeout))
-		mdelay(1);
+	/* Spin for up to 2 seconds, waiting for reset acknowledgement */
+	timeout = jiffies + msecs_to_jiffies(2000);
+	do {
+		mdelay(10);
+		if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag))
+			return -1;
 
-	if (test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag))
-		return -1;
+	} while ((readl(dd->mmio + HOST_CTL) & HOST_RESET)
+		 && time_before(jiffies, timeout));
 
 	if (readl(dd->mmio + HOST_CTL) & HOST_RESET)
 		return -1;
@@ -481,7 +472,7 @@ static void mtip_restart_port(struct mtip_port *port)
 		dev_warn(&port->dd->pdev->dev,
 			"PxCMD.CR not clear, escalating reset\n");
 
-		if (hba_reset_nosleep(port->dd))
+		if (mtip_hba_reset(port->dd))
 			dev_err(&port->dd->pdev->dev,
 				"HBA reset escalation failed.\n");
 
@@ -527,6 +518,26 @@ static void mtip_restart_port(struct mtip_port *port)
 
 }
 
+static int mtip_device_reset(struct driver_data *dd)
+{
+	int rv = 0;
+
+	if (mtip_check_surprise_removal(dd->pdev))
+		return 0;
+
+	if (mtip_hba_reset(dd) < 0)
+		rv = -EFAULT;
+
+	mdelay(1);
+	mtip_init_port(dd->port);
+	mtip_start_port(dd->port);
+
+	/* Enable interrupts on the HBA. */
+	writel(readl(dd->mmio + HOST_CTL) | HOST_IRQ_EN,
+					dd->mmio + HOST_CTL);
+	return rv;
+}
+
 /*
  * Helper function for tag logging
  */
@@ -632,7 +643,7 @@ static void mtip_timeout_function(unsigned long int data)
 	if (cmdto_cnt) {
 		print_tags(port->dd, "timed out", tagaccum, cmdto_cnt);
 		if (!test_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags)) {
-			mtip_restart_port(port);
+			mtip_device_reset(port->dd);
 			wake_up_interruptible(&port->svc_wait);
 		}
 		clear_bit(MTIP_PF_EH_ACTIVE_BIT, &port->flags);
@@ -1283,11 +1294,11 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	int rv = 0, ready2go = 1;
 	struct mtip_cmd *int_cmd = &port->commands[MTIP_TAG_INTERNAL];
 	unsigned long to;
+	struct driver_data *dd = port->dd;
 
 	/* Make sure the buffer is 8 byte aligned. This is asic specific. */
 	if (buffer & 0x00000007) {
-		dev_err(&port->dd->pdev->dev,
-			"SG buffer is not 8 byte aligned\n");
+		dev_err(&dd->pdev->dev, "SG buffer is not 8 byte aligned\n");
 		return -EFAULT;
 	}
 
@@ -1300,23 +1311,21 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 		mdelay(100);
 	} while (time_before(jiffies, to));
 	if (!ready2go) {
-		dev_warn(&port->dd->pdev->dev,
+		dev_warn(&dd->pdev->dev,
 			"Internal cmd active. new cmd [%02X]\n", fis->command);
 		return -EBUSY;
 	}
 	set_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags);
 	port->ic_pause_timer = 0;
 
-	if (fis->command == ATA_CMD_SEC_ERASE_UNIT)
-		clear_bit(MTIP_PF_SE_ACTIVE_BIT, &port->flags);
-	else if (fis->command == ATA_CMD_DOWNLOAD_MICRO)
-		clear_bit(MTIP_PF_DM_ACTIVE_BIT, &port->flags);
+	clear_bit(MTIP_PF_SE_ACTIVE_BIT, &port->flags);
+	clear_bit(MTIP_PF_DM_ACTIVE_BIT, &port->flags);
 
 	if (atomic == GFP_KERNEL) {
 		if (fis->command != ATA_CMD_STANDBYNOW1) {
 			/* wait for io to complete if non atomic */
 			if (mtip_quiesce_io(port, 5000) < 0) {
-				dev_warn(&port->dd->pdev->dev,
+				dev_warn(&dd->pdev->dev,
 					"Failed to quiesce IO\n");
 				release_slot(port, MTIP_TAG_INTERNAL);
 				clear_bit(MTIP_PF_IC_ACTIVE_BIT, &port->flags);
@@ -1361,58 +1370,84 @@ static int mtip_exec_internal_command(struct mtip_port *port,
 	/* Issue the command to the hardware */
 	mtip_issue_non_ncq_command(port, MTIP_TAG_INTERNAL);
 
-	/* Poll if atomic, wait_for_completion otherwise */
 	if (atomic == GFP_KERNEL) {
 		/* Wait for the command to complete or timeout. */
-		if (wait_for_completion_timeout(
+		if (wait_for_completion_interruptible_timeout(
 				&wait,
-				msecs_to_jiffies(timeout)) == 0) {
-			dev_err(&port->dd->pdev->dev,
-				"Internal command did not complete [%d] "
-				"within timeout of  %lu ms\n",
-				atomic, timeout);
-			if (mtip_check_surprise_removal(port->dd->pdev) ||
+				msecs_to_jiffies(timeout)) <= 0) {
+			if (rv == -ERESTARTSYS) { /* interrupted */
+				dev_err(&dd->pdev->dev,
+					"Internal command [%02X] was interrupted after %lu ms\n",
+					fis->command, timeout);
+				rv = -EINTR;
+				goto exec_ic_exit;
+			} else if (rv == 0) /* timeout */
+				dev_err(&dd->pdev->dev,
+					"Internal command did not complete [%02X] within timeout of  %lu ms\n",
+					fis->command, timeout);
+			else
+				dev_err(&dd->pdev->dev,
+					"Internal command [%02X] wait returned code [%d] after %lu ms - unhandled\n",
+					fis->command, rv, timeout);
+
+			if (mtip_check_surprise_removal(dd->pdev) ||
 				test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
-						&port->dd->dd_flag)) {
+						&dd->dd_flag)) {
+				dev_err(&dd->pdev->dev,
+					"Internal command [%02X] wait returned due to SR\n",
+					fis->command);
 				rv = -ENXIO;
 				goto exec_ic_exit;
 			}
+			mtip_device_reset(dd); /* recover from timeout issue */
 			rv = -EAGAIN;
+			goto exec_ic_exit;
 		}
 	} else {
+		u32 hba_stat, port_stat;
+
 		/* Spin for <timeout> checking if command still outstanding */
 		timeout = jiffies + msecs_to_jiffies(timeout);
 		while ((readl(port->cmd_issue[MTIP_TAG_INTERNAL])
 				& (1 << MTIP_TAG_INTERNAL))
 				&& time_before(jiffies, timeout)) {
-			if (mtip_check_surprise_removal(port->dd->pdev)) {
+			if (mtip_check_surprise_removal(dd->pdev)) {
 				rv = -ENXIO;
 				goto exec_ic_exit;
 			}
 			if ((fis->command != ATA_CMD_STANDBYNOW1) &&
 				test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
-						&port->dd->dd_flag)) {
+						&dd->dd_flag)) {
 				rv = -ENXIO;
 				goto exec_ic_exit;
 			}
-			if (readl(port->mmio + PORT_IRQ_STAT) & PORT_IRQ_ERR) {
-				atomic_inc(&int_cmd->active); /* error */
-				break;
+			port_stat = readl(port->mmio + PORT_IRQ_STAT);
+			if (!port_stat)
+				continue;
+
+			if (port_stat & PORT_IRQ_ERR) {
+				dev_err(&dd->pdev->dev,
+					"Internal command [%02X] failed\n",
+					fis->command);
+				mtip_device_reset(dd);
+				rv = -EIO;
+				goto exec_ic_exit;
+			} else {
+				writel(port_stat, port->mmio + PORT_IRQ_STAT);
+				hba_stat = readl(dd->mmio + HOST_IRQ_STAT);
+				if (hba_stat)
+					writel(hba_stat,
+						dd->mmio + HOST_IRQ_STAT);
 			}
+			break;
 		}
 	}
 
-	if (atomic_read(&int_cmd->active) > 1) {
-		dev_err(&port->dd->pdev->dev,
-			"Internal command [%02X] failed\n", fis->command);
-		rv = -EIO;
-	}
 	if (readl(port->cmd_issue[MTIP_TAG_INTERNAL])
 			& (1 << MTIP_TAG_INTERNAL)) {
 		rv = -ENXIO;
-		if (!test_bit(MTIP_DDF_REMOVE_PENDING_BIT,
-					&port->dd->dd_flag)) {
-			mtip_restart_port(port);
+		if (!test_bit(MTIP_DDF_REMOVE_PENDING_BIT, &dd->dd_flag)) {
+			mtip_device_reset(dd);
 			rv = -EAGAIN;
 		}
 	}
@@ -1724,7 +1759,8 @@ static int mtip_get_smart_attr(struct mtip_port *port, unsigned int id,
  *      -EINVAL		Invalid parameters passed in, trim not supported
  *      -EIO		Error submitting trim request to hw
  */
-static int mtip_send_trim(struct driver_data *dd, unsigned int lba, unsigned int len)
+static int mtip_send_trim(struct driver_data *dd, unsigned int lba,
+				unsigned int len)
 {
 	int i, rv = 0;
 	u64 tlba, tlen, sect_left;
@@ -1811,45 +1847,6 @@ static bool mtip_hw_get_capacity(struct driver_data *dd, sector_t *sectors)
 }
 
 /*
- * Reset the HBA.
- *
- * Resets the HBA by setting the HBA Reset bit in the Global
- * HBA Control register. After setting the HBA Reset bit the
- * function waits for 1 second before reading the HBA Reset
- * bit to make sure it has cleared. If HBA Reset is not clear
- * an error is returned. Cannot be used in non-blockable
- * context.
- *
- * @dd Pointer to the driver data structure.
- *
- * return value
- *	0  The reset was successful.
- *	-1 The HBA Reset bit did not clear.
- */
-static int mtip_hba_reset(struct driver_data *dd)
-{
-	mtip_deinit_port(dd->port);
-
-	/* Set the reset bit */
-	writel(HOST_RESET, dd->mmio + HOST_CTL);
-
-	/* Flush */
-	readl(dd->mmio + HOST_CTL);
-
-	/* Wait for reset to clear */
-	ssleep(1);
-
-	/* Check the bit has cleared */
-	if (readl(dd->mmio + HOST_CTL) & HOST_RESET) {
-		dev_err(&dd->pdev->dev,
-			"Reset bit did not clear.\n");
-		return -1;
-	}
-
-	return 0;
-}
-
-/*
  * Display the identify command data.
  *
  * @port Pointer to the port data structure.
-- 
1.7.1

