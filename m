Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab3BSQtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 11:49:20 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55545 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758541Ab3BSQtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 11:49:03 -0500
Date: Tue, 19 Feb 2013 10:48:11 -0600
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com,
        josh.h.morris@us.ibm.com
Subject: [PATCHv2 1/1] block: IBM RamSan 70/80 driver fixes.
Message-ID: <20130219164811.GA21104@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021916-7182-0000-0000-000005525572
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>

This patch include a few driver fixes for the IBM RamSan 70/80 driver.

Signed-off-by: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
---------------------------------------------------------------------
NOTE: This patch is built off of Jen's for-next branch.

This patch include the previous changes of:
o Changed the creg_ctrl lock from a mutex to a spinlock.
o Added a count check for ioctl calls.
o Removed unnecessary casting of void pointers.
o Made every function static that needed to be.
o Added comments to explain things more thoroughly.

As well of changes that include:
o Removal of wmb()
o Changed void * into actually structure.


diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/config.c linux-block/drivers/block/rsxx/config.c
--- linux-block-vanilla/drivers/block/rsxx/config.c	2013-02-12 11:25:37.756352070 -0600
+++ linux-block/drivers/block/rsxx/config.c	2013-02-19 09:45:47.994763636 -0600
@@ -29,10 +29,8 @@
 #include "rsxx_priv.h"
 #include "rsxx_cfg.h"
 
-static void initialize_config(void *config)
+static void initialize_config(struct rsxx_card_cfg *cfg)
 {
-	struct rsxx_card_cfg *cfg = (struct rsxx_card_cfg *) config;
-
 	cfg->hdr.version = RSXX_CFG_VERSION;
 
 	cfg->data.block_size        = RSXX_HW_BLK_SIZE;
@@ -97,7 +95,7 @@ static void config_data_cpu_to_le(struct
 
 
 /*----------------- Config Operations ------------------*/
-int rsxx_save_config(struct rsxx_cardinfo *card)
+static int rsxx_save_config(struct rsxx_cardinfo *card)
 {
 	struct rsxx_card_cfg cfg;
 	int st;
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
--- linux-block-vanilla/drivers/block/rsxx/core.c	2013-02-12 11:25:37.761352160 -0600
+++ linux-block/drivers/block/rsxx/core.c	2013-02-17 18:43:52.134011606 -0600
@@ -102,9 +102,9 @@ void rsxx_disable_ier_and_isr(struct rsx
 	iowrite32(card->ier_mask, card->regmap + IER);
 }
 
-irqreturn_t rsxx_isr(int irq, void *pdata)
+static irqreturn_t rsxx_isr(int irq, void *pdata)
 {
-	struct rsxx_cardinfo *card = (struct rsxx_cardinfo *) pdata;
+	struct rsxx_cardinfo *card = pdata;
 	unsigned int isr;
 	int handled = 0;
 	int reread_isr;
@@ -161,6 +161,17 @@ irqreturn_t rsxx_isr(int irq, void *pdat
 }
 
 /*----------------- Card Event Handler -------------------*/
+static char *rsxx_card_state_to_str(unsigned int state)
+{
+	static char *state_strings[] = {
+		"Unknown", "Shutdown", "Starting", "Formatting",
+		"Uninitialized", "Good", "Shutting Down",
+		"Fault", "Read Only Fault", "dStroying"
+	};
+
+	return state_strings[ffs(state)];
+}
+
 static void card_state_change(struct rsxx_cardinfo *card,
 			      unsigned int new_state)
 {
@@ -251,18 +262,6 @@ static void card_event_handler(struct wo
 		rsxx_read_hw_log(card);
 }
 
-
-char *rsxx_card_state_to_str(unsigned int state)
-{
-	static char *state_strings[] = {
-		"Unknown", "Shutdown", "Starting", "Formatting",
-		"Uninitialized", "Good", "Shutting Down",
-		"Fault", "Read Only Fault", "dStroying"
-	};
-
-	return state_strings[ffs(state)];
-}
-
 /*----------------- Card Operations -------------------*/
 static int card_shutdown(struct rsxx_cardinfo *card)
 {
@@ -323,7 +322,6 @@ static int rsxx_pci_probe(struct pci_dev
 					const struct pci_device_id *id)
 {
 	struct rsxx_cardinfo *card;
-	unsigned long flags;
 	int st;
 
 	dev_info(&dev->dev, "PCI-Flash SSD discovered\n");
@@ -386,9 +384,9 @@ static int rsxx_pci_probe(struct pci_dev
 	spin_lock_init(&card->irq_lock);
 	card->halt = 0;
 
-	spin_lock_irqsave(&card->irq_lock, flags);
+	spin_lock_irq(&card->irq_lock);
 	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
-	spin_unlock_irqrestore(&card->irq_lock, flags);
+	spin_unlock_irq(&card->irq_lock);
 
 	if (!force_legacy) {
 		st = pci_enable_msi(dev);
@@ -408,9 +406,9 @@ static int rsxx_pci_probe(struct pci_dev
 	/************* Setup Processor Command Interface *************/
 	rsxx_creg_setup(card);
 
-	spin_lock_irqsave(&card->irq_lock, flags);
+	spin_lock_irq(&card->irq_lock);
 	rsxx_enable_ier_and_isr(card, CR_INTR_CREG);
-	spin_unlock_irqrestore(&card->irq_lock, flags);
+	spin_unlock_irq(&card->irq_lock);
 
 	st = rsxx_compatibility_check(card);
 	if (st) {
@@ -463,9 +461,9 @@ static int rsxx_pci_probe(struct pci_dev
 	 * we can enable the event interrupt(it kicks off actions in
 	 * those layers so we couldn't enable it right away.)
 	 */
-	spin_lock_irqsave(&card->irq_lock, flags);
+	spin_lock_irq(&card->irq_lock);
 	rsxx_enable_ier_and_isr(card, CR_INTR_EVENT);
-	spin_unlock_irqrestore(&card->irq_lock, flags);
+	spin_unlock_irq(&card->irq_lock);
 
 	if (card->state == CARD_STATE_SHUTDOWN) {
 		st = rsxx_issue_card_cmd(card, CARD_CMD_STARTUP);
@@ -487,9 +485,9 @@ failed_create_dev:
 	rsxx_dma_destroy(card);
 failed_dma_setup:
 failed_compatiblity_check:
-	spin_lock_irqsave(&card->irq_lock, flags);
+	spin_lock_irq(&card->irq_lock);
 	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
-	spin_unlock_irqrestore(&card->irq_lock, flags);
+	spin_unlock_irq(&card->irq_lock);
 	free_irq(dev->irq, card);
 	if (!force_legacy)
 		pci_disable_msi(dev);
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/cregs.c linux-block/drivers/block/rsxx/cregs.c
--- linux-block-vanilla/drivers/block/rsxx/cregs.c	2013-02-12 11:25:37.766352109 -0600
+++ linux-block/drivers/block/rsxx/cregs.c	2013-02-19 09:47:36.298762956 -0600
@@ -107,10 +107,10 @@ static struct creg_cmd *pop_active_cmd(s
 	 * Spin lock is needed because this can be called in atomic/interrupt
 	 * context.
 	 */
-	spin_lock_bh(&card->creg_ctrl.pop_lock);
+	spin_lock_bh(&card->creg_ctrl.lock);
 	cmd = card->creg_ctrl.active_cmd;
 	card->creg_ctrl.active_cmd = NULL;
-	spin_unlock_bh(&card->creg_ctrl.pop_lock);
+	spin_unlock_bh(&card->creg_ctrl.lock);
 
 	return cmd;
 }
@@ -126,9 +126,6 @@ static void creg_issue_cmd(struct rsxx_c
 					  cmd->buf, cmd->stream);
 	}
 
-	/* Data copy must complete before initiating the command. */
-	wmb();
-
 	/* Setting the valid bit will kick off the command. */
 	iowrite32(cmd->op, card->regmap + CREG_CMD);
 }
@@ -192,11 +189,11 @@ static int creg_queue_cmd(struct rsxx_ca
 	cmd->cb_private = cb_private;
 	cmd->status	= 0;
 
-	mutex_lock(&card->creg_ctrl.lock);
+	spin_lock(&card->creg_ctrl.lock);
 	list_add_tail(&cmd->list, &card->creg_ctrl.queue);
 	card->creg_ctrl.q_depth++;
 	creg_kick_queue(card);
-	mutex_unlock(&card->creg_ctrl.lock);
+	spin_unlock(&card->creg_ctrl.lock);
 
 	return 0;
 }
@@ -219,10 +216,11 @@ static void creg_cmd_timed_out(unsigned 
 
 	kmem_cache_free(creg_cmd_pool, cmd);
 
-	spin_lock(&card->creg_ctrl.pop_lock);
+
+	spin_lock(&card->creg_ctrl.lock);
 	card->creg_ctrl.active = 0;
 	creg_kick_queue(card);
-	spin_unlock(&card->creg_ctrl.pop_lock);
+	spin_unlock(&card->creg_ctrl.lock);
 }
 
 
@@ -291,10 +289,10 @@ creg_done:
 
 	kmem_cache_free(creg_cmd_pool, cmd);
 
-	mutex_lock(&card->creg_ctrl.lock);
+	spin_lock(&card->creg_ctrl.lock);
 	card->creg_ctrl.active = 0;
 	creg_kick_queue(card);
-	mutex_unlock(&card->creg_ctrl.lock);
+	spin_unlock(&card->creg_ctrl.lock);
 }
 
 static void creg_reset(struct rsxx_cardinfo *card)
@@ -303,6 +301,10 @@ static void creg_reset(struct rsxx_cardi
 	struct creg_cmd *tmp;
 	unsigned long flags;
 
+	/*
+	 * mutex_trylock is used here because if reset_lock is taken then a
+	 * reset is already happening. So, we can just go ahead and return.
+	 */
 	if (!mutex_trylock(&card->creg_ctrl.reset_lock))
 		return;
 
@@ -315,7 +317,7 @@ static void creg_reset(struct rsxx_cardi
 		"Resetting creg interface for recovery\n");
 
 	/* Cancel outstanding commands */
-	mutex_lock(&card->creg_ctrl.lock);
+	spin_lock(&card->creg_ctrl.lock);
 	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
 		list_del(&cmd->list);
 		card->creg_ctrl.q_depth--;
@@ -336,7 +338,7 @@ static void creg_reset(struct rsxx_cardi
 
 		card->creg_ctrl.active = 0;
 	}
-	mutex_unlock(&card->creg_ctrl.lock);
+	spin_unlock(&card->creg_ctrl.lock);
 
 	card->creg_ctrl.reset = 0;
 	spin_lock_irqsave(&card->irq_lock, flags);
@@ -359,7 +361,7 @@ static void creg_cmd_done_cb(struct rsxx
 {
 	struct creg_completion *cmd_completion;
 
-	cmd_completion = (struct creg_completion *)cmd->cb_private;
+	cmd_completion = cmd->cb_private;
 	BUG_ON(!cmd_completion);
 
 	cmd_completion->st = st;
@@ -380,7 +382,6 @@ static int __issue_creg_rw(struct rsxx_c
 	unsigned long timeout;
 	int st;
 
-	INIT_COMPLETION(cmd_done);
 	completion.cmd_done = &cmd_done;
 	completion.st = 0;
 	completion.creg_status = 0;
@@ -390,8 +391,13 @@ static int __issue_creg_rw(struct rsxx_c
 	if (st)
 		return st;
 
+	/*
+	 * This timeout is neccessary for unresponsive hardware. The additional
+	 * 20 seconds to used to guarantee that each cregs requests has time to
+	 * complete.
+	 */
 	timeout = msecs_to_jiffies((CREG_TIMEOUT_MSEC *
-				    card->creg_ctrl.q_depth) + 20000);
+				card->creg_ctrl.q_depth) + 20000);
 
 	/*
 	 * The creg interface is guaranteed to complete. It has a timeout
@@ -443,7 +449,7 @@ static int issue_creg_rw(struct rsxx_car
 		if (st)
 			return st;
 
-		data   = (void *)((char *)data + xfer);
+		data   = (char *)data + xfer;
 		addr  += xfer;
 		size8 -= xfer;
 	} while (size8);
@@ -558,9 +564,9 @@ static void hw_log_msg(struct rsxx_cardi
 }
 
 /*
- * The substrncpy() function copies to string(up to count bytes) point to by src
- * (including the terminating '\0' character) to dest. Returns the number of
- * bytes copied to dest.
+ * The substrncpy function copies the src string (which includes the
+ * terminating '\0' character), up to the count into the dest pointer.
+ * Returns the number of bytes copied to dest.
  */
 static int substrncpy(char *dest, const char *src, int count)
 {
@@ -657,6 +663,9 @@ int rsxx_reg_access(struct rsxx_cardinfo
 	if (st)
 		return -EFAULT;
 
+	if (cmd.cnt > RSXX_MAX_REG_CNT)
+		return -EFAULT;
+
 	st = issue_reg_cmd(card, &cmd, read);
 	if (st)
 		return st;
@@ -682,8 +691,7 @@ int rsxx_creg_setup(struct rsxx_cardinfo
 	INIT_WORK(&card->creg_ctrl.done_work, creg_cmd_done);
 	mutex_init(&card->creg_ctrl.reset_lock);
 	INIT_LIST_HEAD(&card->creg_ctrl.queue);
-	mutex_init(&card->creg_ctrl.lock);
-	spin_lock_init(&card->creg_ctrl.pop_lock);
+	spin_lock_init(&card->creg_ctrl.lock);
 	setup_timer(&card->creg_ctrl.cmd_timer, creg_cmd_timed_out,
 		    (unsigned long) card);
 
@@ -697,7 +705,7 @@ void rsxx_creg_destroy(struct rsxx_cardi
 	int cnt = 0;
 
 	/* Cancel outstanding commands */
-	mutex_lock(&card->creg_ctrl.lock);
+	spin_lock(&card->creg_ctrl.lock);
 	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
 		list_del(&cmd->list);
 		if (cmd->cb)
@@ -722,7 +730,7 @@ void rsxx_creg_destroy(struct rsxx_cardi
 			"Canceled active creg command\n");
 		kmem_cache_free(creg_cmd_pool, cmd);
 	}
-	mutex_unlock(&card->creg_ctrl.lock);
+	spin_unlock(&card->creg_ctrl.lock);
 
 	cancel_work_sync(&card->creg_ctrl.done_work);
 }
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dev.c linux-block/drivers/block/rsxx/dev.c
--- linux-block-vanilla/drivers/block/rsxx/dev.c	2013-02-12 11:25:37.771353809 -0600
+++ linux-block/drivers/block/rsxx/dev.c	2013-02-17 18:16:41.678012619 -0600
@@ -149,7 +149,7 @@ static void bio_dma_done_cb(struct rsxx_
 			    void *cb_data,
 			    unsigned int error)
 {
-	struct rsxx_bio_meta *meta = (struct rsxx_bio_meta *)cb_data;
+	struct rsxx_bio_meta *meta = cb_data;
 
 	if (error)
 		atomic_set(&meta->error, 1);
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/dma.c linux-block/drivers/block/rsxx/dma.c
--- linux-block-vanilla/drivers/block/rsxx/dma.c	2013-02-12 11:25:37.776353543 -0600
+++ linux-block/drivers/block/rsxx/dma.c	2013-02-19 10:05:46.661074802 -0600
@@ -102,7 +102,7 @@ struct dma_tracker_list {
 
 
 /*----------------- Misc Utility Functions -------------------*/
-unsigned int rsxx_addr8_to_laddr(u64 addr8, struct rsxx_cardinfo *card)
+static unsigned int rsxx_addr8_to_laddr(u64 addr8, struct rsxx_cardinfo *card)
 {
 	unsigned long long tgt_addr8;
 
@@ -113,7 +113,7 @@ unsigned int rsxx_addr8_to_laddr(u64 add
 	return tgt_addr8;
 }
 
-unsigned int rsxx_get_dma_tgt(struct rsxx_cardinfo *card, u64 addr8)
+static unsigned int rsxx_get_dma_tgt(struct rsxx_cardinfo *card, u64 addr8)
 {
 	unsigned int tgt;
 
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
@@ -757,7 +747,7 @@ static int rsxx_dma_ctrl_init(struct pci
 	INIT_LIST_HEAD(&ctrl->queue);
 
 	setup_timer(&ctrl->activity_timer, dma_engine_stalled,
-		    (unsigned long)ctrl);
+					(unsigned long)ctrl);
 
 	ctrl->issue_wq = alloc_ordered_workqueue(DRIVER_NAME"_issue", 0);
 	if (!ctrl->issue_wq)
@@ -798,12 +788,10 @@ static int rsxx_dma_ctrl_init(struct pci
 	iowrite32(ctrl->cmd.idx, ctrl->regmap + HW_CMD_IDX);
 	iowrite32(ctrl->cmd.idx, ctrl->regmap + SW_CMD_IDX);
 
-	wmb();
-
 	return 0;
 }
 
-int rsxx_dma_stripe_setup(struct rsxx_cardinfo *card,
+static int rsxx_dma_stripe_setup(struct rsxx_cardinfo *card,
 			      unsigned int stripe_size8)
 {
 	if (!is_power_of_2(stripe_size8)) {
@@ -834,7 +822,7 @@ int rsxx_dma_stripe_setup(struct rsxx_ca
 	return 0;
 }
 
-int rsxx_dma_configure(struct rsxx_cardinfo *card)
+static int rsxx_dma_configure(struct rsxx_cardinfo *card)
 {
 	u32 intr_coal;
 
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx.h linux-block/drivers/block/rsxx/rsxx.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx.h	2013-02-12 11:25:37.780170779 -0600
+++ linux-block/drivers/block/rsxx/rsxx.h	2013-02-19 10:06:20.935007835 -0600
@@ -27,14 +27,18 @@
 
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
 
+#define RSXX_MAX_REG_CNT	(RSXX_MAX_DATA * (sizeof(__u32)))
+
 #define RSXX_IOC_MAGIC 'r'
 
 #define RSXX_GETREG _IOWR(RSXX_IOC_MAGIC, 0x20, struct rsxx_reg_access)
diff -uprN -X linux-block-vanilla/Documentation/dontdiff linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h linux-block/drivers/block/rsxx/rsxx_priv.h
--- linux-block-vanilla/drivers/block/rsxx/rsxx_priv.h	2013-02-12 11:25:37.788352026 -0600
+++ linux-block/drivers/block/rsxx/rsxx_priv.h	2013-02-17 18:30:11.343948441 -0600
@@ -127,7 +127,7 @@ struct rsxx_cardinfo {
 
 	/* Embedded CPU Communication */
 	struct {
-		struct mutex		lock;
+		spinlock_t		lock;
 		bool			active;
 		struct creg_cmd		*active_cmd;
 		struct work_struct	done_work;
@@ -141,7 +141,6 @@ struct rsxx_cardinfo {
 		} creg_stats;
 		struct timer_list	cmd_timer;
 		struct mutex		reset_lock;
-		spinlock_t		pop_lock;
 		int			reset;
 	} creg_ctrl;
 
@@ -336,7 +335,6 @@ static inline unsigned int CREG_DATA(int
 
 /***** config.c *****/
 int rsxx_load_config(struct rsxx_cardinfo *card);
-int rsxx_save_config(struct rsxx_cardinfo *card);
 
 /***** core.c *****/
 void rsxx_enable_ier(struct rsxx_cardinfo *card, unsigned int intr);
@@ -345,8 +343,6 @@ void rsxx_enable_ier_and_isr(struct rsxx
 				 unsigned int intr);
 void rsxx_disable_ier_and_isr(struct rsxx_cardinfo *card,
 				  unsigned int intr);
-char *rsxx_card_state_to_str(unsigned int state);
-irqreturn_t rsxx_isr(int irq, void *pdata);
 
 /***** dev.c *****/
 int rsxx_attach_dev(struct rsxx_cardinfo *card);
@@ -364,16 +360,11 @@ int rsxx_dma_setup(struct rsxx_cardinfo 
 void rsxx_dma_destroy(struct rsxx_cardinfo *card);
 int rsxx_dma_init(void);
 void rsxx_dma_cleanup(void);
-int rsxx_dma_configure(struct rsxx_cardinfo *card);
 int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 			   struct bio *bio,
 			   atomic_t *n_dmas,
 			   rsxx_dma_cb cb,
 			   void *cb_data);
-int rsxx_dma_stripe_setup(struct rsxx_cardinfo *card,
-			      unsigned int stripe_size8);
-unsigned int rsxx_get_dma_tgt(struct rsxx_cardinfo *card, u64 addr8);
-unsigned int rsxx_addr8_to_laddr(u64 addr8, struct rsxx_cardinfo *card);
 
 /***** cregs.c *****/
 int rsxx_creg_write(struct rsxx_cardinfo *card, u32 addr,

