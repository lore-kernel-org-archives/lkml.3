Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab3BYSaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:30:09 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48820 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3BYSaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:30:04 -0500
Date: Mon, 25 Feb 2013 12:27:46 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: [PATCH 1/4] block: IBM RamSan 70/80 trivial changes.
Message-ID: <20130225182746.GA7415@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022518-5806-0000-0000-000020136C44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch includes trivial changes that were recommended by
different members of the Linux Community.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
-------------------------------------------------------------------------------
This was built from Jen's for-next branch.

Changes include:
o Removing the redundant wmb().
o Formatting
o Various other little things.


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/config.c linux-block/drivers/block/rsxx/config.c
--- linux-block-vanilla/drivers/block/rsxx/config.c	2013-02-25 11:53:40.891299171 -0600
+++ linux-block/drivers/block/rsxx/config.c	2013-02-25 11:57:32.944194401 -0600
@@ -29,10 +29,8 @@
 #include "rsxx_priv.h"
 #include "rsxx_cfg.h"
 
-static void initialize_config(void *config)
+static void initialize_config(struct rsxx_card_cfg *cfg)
 {
-	struct rsxx_card_cfg *cfg = config;
-
 	cfg->hdr.version = RSXX_CFG_VERSION;
 
 	cfg->data.block_size        = RSXX_HW_BLK_SIZE;
@@ -181,7 +179,7 @@ int rsxx_load_config(struct rsxx_cardinf
 	} else {
 		dev_info(CARD_TO_DEV(card),
 			"Initializing card configuration.\n");
-		initialize_config(card);
+		initialize_config(&card->config);
 		st = rsxx_save_config(card);
 		if (st)
 			return st;
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/core.c linux-block/drivers/block/rsxx/core.c
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-02-25 11:53:40.896495173 -0600
+++ linux-block/drivers/block/rsxx/core.c	2013-02-25 12:05:13.567185446 -0600
@@ -161,9 +161,9 @@ static irqreturn_t rsxx_isr(int irq, voi
 }
 
 /*----------------- Card Event Handler -------------------*/
-static char *rsxx_card_state_to_str(unsigned int state)
+static const char * const rsxx_card_state_to_str(unsigned int state)
 {
-	static char *state_strings[] = {
+	static const char * const state_strings[] = {
 		"Unknown", "Shutdown", "Starting", "Formatting",
 		"Uninitialized", "Good", "Shutting Down",
 		"Fault", "Read Only Fault", "dStroying"
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/cregs.c linux-block/drivers/block/rsxx/cregs.c
--- linux-block-vanilla/drivers/block/rsxx/cregs.c	2013-02-25 11:53:40.901473091 -0600
+++ linux-block/drivers/block/rsxx/cregs.c	2013-02-25 11:57:32.958184534 -0600
@@ -126,13 +126,6 @@ static void creg_issue_cmd(struct rsxx_c
 					  cmd->buf, cmd->stream);
 	}
 
-	/*
-	 * Data copy must complete before initiating the command. This is
-	 * needed for weakly ordered processors (i.e. PowerPC), so that all
-	 * neccessary registers are written before we kick the hardware.
-	 */
-	wmb();
-
 	/* Setting the valid bit will kick off the command. */
 	iowrite32(cmd->op, card->regmap + CREG_CMD);
 }
@@ -399,12 +392,12 @@ static int __issue_creg_rw(struct rsxx_c
 		return st;
 
 	/*
-	 * This timeout is neccessary for unresponsive hardware. The additional
+	 * This timeout is necessary for unresponsive hardware. The additional
 	 * 20 seconds to used to guarantee that each cregs requests has time to
 	 * complete.
 	 */
-	timeout = msecs_to_jiffies((CREG_TIMEOUT_MSEC *
-				card->creg_ctrl.q_depth) + 20000);
+	timeout = msecs_to_jiffies(CREG_TIMEOUT_MSEC *
+				   card->creg_ctrl.q_depth + 20000);
 
 	/*
 	 * The creg interface is guaranteed to complete. It has a timeout
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-02-25 11:53:40.906245893 -0600
+++ linux-block/drivers/block/rsxx/dma.c	2013-02-25 11:57:32.964183930 -0600
@@ -432,16 +432,6 @@ static void rsxx_issue_dmas(struct work_
 
 	/* Let HW know we've queued commands. */
 	if (cmds_pending) {
-		/*
-		 * We must guarantee that the CPU writes to 'ctrl->cmd.buf'
-		 * (which is in PCI-consistent system-memory) from the loop
-		 * above make it into the coherency domain before the
-		 * following PIO "trigger" updating the cmd.idx.  A WMB is
-		 * sufficient. We need not explicitly CPU cache-flush since
-		 * the memory is a PCI-consistent (ie; coherent) mapping.
-		 */
-		wmb();
-
 		atomic_add(cmds_pending, &ctrl->stats.hw_q_depth);
 		mod_timer(&ctrl->activity_timer,
 			  jiffies + DMA_ACTIVITY_TIMEOUT);
@@ -798,8 +788,6 @@ static int rsxx_dma_ctrl_init(struct pci
 	iowrite32(ctrl->cmd.idx, ctrl->regmap + HW_CMD_IDX);
 	iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
 
-	wmb();
-
 	return 0;
 }
 
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx.h linux-block/drivers/block/rsxx/rsxx.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx.h	2013-02-25 11:53:40.911245445 -0600
+++ linux-block/drivers/block/rsxx/rsxx.h	2013-02-25 11:57:32.970182625 -0600
@@ -27,15 +27,17 @@
 
 /*----------------- IOCTL Definitions -------------------*/
 
+#define RSXX_MAX_DATA 8
+
 struct rsxx_reg_access {
 	__u32 addr;
 	__u32 cnt;
 	__u32 stat;
 	__u32 stream;
-	__u32 data[8];
+	__u32 data[RSXX_MAX_DATA];
 };
 
-#define RSXX_MAX_REG_CNT	(8 * (sizeof(__u32)))
+#define RSXX_MAX_REG_CNT	(RSXX_MAX_DATA * (sizeof(__u32)))
 
 #define RSXX_IOC_MAGIC 'r'
 

