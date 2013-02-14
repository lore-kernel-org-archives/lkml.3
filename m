Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167Ab3BNX4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:56:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3BNX4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:56:16 -0500
Date: Thu, 14 Feb 2013 15:56:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        brking@linux.vnet.ibm.com, josh.h.morris@us.ibm.com
Subject: Re: [PATCHv2 1/1] block: IBM RamSan 70/80 device driver.
Message-Id: <20130214155614.46726e1a.akpm@linux-foundation.org>
In-Reply-To: <20130201214139.GB6971@oc6784271780.ibm.com>
References: <20130201214139.GB6971@oc6784271780.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013 15:41:39 -0600
"Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com> wrote:

> From: Joshua H Morris <josh.h.morris@us.ibm.com>
> 	Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> 
> This patch includes the device driver for the IBM RamSan family
> of PCI SSD flash storage cards. This driver will inlcude support for the
> RamSan 70 and 80. The driver presents a block device for device I/O.
> 
>
> ...
>
> +static void initialize_config(void *config)
> +{
> +	struct rsxx_card_cfg *cfg = (struct rsxx_card_cfg *) config;

Unneeded and undesirable cast of void*.

> +	cfg->hdr.version = RSXX_CFG_VERSION;
> +
> +	cfg->data.block_size        = RSXX_HW_BLK_SIZE;
> +	cfg->data.stripe_size       = RSXX_HW_BLK_SIZE;
> +	cfg->data.vendor_id         = RSXX_VENDOR_ID_TMS_IBM;
> +	cfg->data.cache_order       = (-1);
> +	cfg->data.intr_coal.mode    = RSXX_INTR_COAL_DISABLED;
> +	cfg->data.intr_coal.count   = 0;
> +	cfg->data.intr_coal.latency = 0;
> +}
> +
>
> ...
>
> +/*----------------- Config Operations ------------------*/
> +int rsxx_save_config(struct rsxx_cardinfo *card)

static

> +{
> +	struct rsxx_card_cfg cfg;
> +	int st;
> +
> +	memcpy(&cfg, &card->config, sizeof(cfg));
> +
> +	if (unlikely(cfg.hdr.version != RSXX_CFG_VERSION)) {
> +		dev_err(CARD_TO_DEV(card),
> +			"Cannot save config with invalid version %d\n",
> +			cfg.hdr.version);
> +		return -EINVAL;
> +	}
> +
> +	/* Convert data to little endian for the CRC calculation. */
> +	config_data_cpu_to_le(&cfg);
> +
> +	cfg.hdr.crc = config_data_crc32(&cfg);
> +
> +	/*
> +	 * Swap the data from little endian to big endian so it can be
> +	 * stored.
> +	 */
> +	config_data_swab(&cfg);
> +	config_hdr_cpu_to_be(&cfg.hdr);
> +
> +	st = rsxx_creg_write(card, CREG_ADD_CONFIG, sizeof(cfg), &cfg, 1);
> +	if (st)
> +		return st;
> +
> +	return 0;
> +}
> +
>
> ...
>
> +void rsxx_disable_ier_and_isr(struct rsxx_cardinfo *card,
> +				  unsigned int intr)
> +{
> +	__disable_intr(&card->isr_mask, intr);
> +	__disable_intr(&card->ier_mask, intr);
> +	iowrite32(card->ier_mask, card->regmap + IER);
> +}
> +
> +irqreturn_t rsxx_isr(int irq, void *pdata)

make static, remove from rsxx_priv.h

> +{
> +	struct rsxx_cardinfo *card = (struct rsxx_cardinfo *) pdata;

cast of void*

> +	unsigned int isr;
> +	int handled = 0;
> +	int reread_isr;
> +	int i;
> +
> +	spin_lock(&card->irq_lock);
> +
> +	do {
> +		reread_isr = 0;
> +
> +		isr = ioread32(card->regmap + ISR);
> +		if (isr == 0xffffffff) {
> +			/*
> +			 * A few systems seem to have an intermittent issue
> +			 * where PCI reads return all Fs, but retrying the read
> +			 * a little later will return as expected.
> +			 */
> +			dev_info(CARD_TO_DEV(card),
> +				"ISR = 0xFFFFFFFF, retrying later\n");
> +			break;
> +		}
> +
> +		isr &= card->isr_mask;
> +		if (!isr)
> +			break;
> +
> +		for (i = 0; i < card->n_targets; i++) {
> +			if (isr & CR_INTR_DMA(i)) {
> +				if (card->ier_mask & CR_INTR_DMA(i)) {
> +					rsxx_disable_ier(card, CR_INTR_DMA(i));
> +					reread_isr = 1;
> +				}
> +				queue_work(card->ctrl[i].done_wq,
> +					   &card->ctrl[i].dma_done_work);
> +				handled++;
> +			}
> +		}
> +
> +		if (isr & CR_INTR_CREG) {
> +			schedule_work(&card->creg_ctrl.done_work);
> +			handled++;
> +		}
> +
> +		if (isr & CR_INTR_EVENT) {
> +			schedule_work(&card->event_work);
> +			rsxx_disable_ier_and_isr(card, CR_INTR_EVENT);
> +			handled++;
> +		}
> +	} while (reread_isr);
> +
> +	spin_unlock(&card->irq_lock);
> +	return handled ? IRQ_HANDLED : IRQ_NONE;
> +}
>
> ...
>
> +char *rsxx_card_state_to_str(unsigned int state)

static

> +{
> +	static char *state_strings[] = {
> +		"Unknown", "Shutdown", "Starting", "Formatting",
> +		"Uninitialized", "Good", "Shutting Down",
> +		"Fault", "Read Only Fault", "dStroying"
> +	};
> +
> +	return state_strings[ffs(state)];
> +}
>
> ...
>
> +static int rsxx_compatibility_check(struct rsxx_cardinfo *card)
> +{
> +	unsigned char pci_rev;
> +
> +	pci_read_config_byte(card->dev, PCI_REVISION_ID, &pci_rev);
> +
> +	if (pci_rev > RS70_PCI_REV_SUPPORTED)
> +		return -1;
> +	return 0;
> +}
> +
> +static int __devinit rsxx_pci_probe(struct pci_dev *dev,

__devexit and __devinit are obsolete.

> +					const struct pci_device_id *id)
> +{
> +	struct rsxx_cardinfo *card;
> +	unsigned long flags;
> +	int st;
> +
> +	dev_info(&dev->dev, "PCI-Flash SSD discovered\n");
> +
> +	card = kzalloc(sizeof(*card), GFP_KERNEL);
> +	if (!card)
> +		return -ENOMEM;
> +
> +	card->dev = dev;
> +	pci_set_drvdata(dev, card);
> +
> +	do {
> +		if (!ida_pre_get(&rsxx_disk_ida, GFP_KERNEL)) {
> +			st = -ENOMEM;
> +			goto failed_ida_get;
> +		}
> +
> +		spin_lock(&rsxx_ida_lock);
> +		st = ida_get_new(&rsxx_disk_ida, &card->disk_id);
> +		spin_unlock(&rsxx_ida_lock);
> +	} while (st == -EAGAIN);
> +
> +	if (st)
> +		goto failed_ida_get;
> +
> +	st = pci_enable_device(dev);
> +	if (st)
> +		goto failed_enable;
> +
> +	pci_set_master(dev);
> +	pci_set_dma_max_seg_size(dev, RSXX_HW_BLK_SIZE);
> +
> +	st = pci_set_dma_mask(dev, DMA_BIT_MASK(64));
> +	if (st) {
> +		dev_err(CARD_TO_DEV(card),
> +			"No usable DMA configuration,aborting\n");
> +		goto failed_dma_mask;
> +	}
> +
> +	st = pci_request_regions(dev, DRIVER_NAME);
> +	if (st) {
> +		dev_err(CARD_TO_DEV(card),
> +			"Failed to request memory region\n");
> +		goto failed_request_regions;
> +	}
> +
> +	if (pci_resource_len(dev, 0) == 0) {
> +		dev_err(CARD_TO_DEV(card), "BAR0 has length 0!\n");
> +		st = -ENOMEM;
> +		goto failed_iomap;
> +	}
> +
> +	card->regmap = pci_iomap(dev, 0, 0);
> +	if (!card->regmap) {
> +		dev_err(CARD_TO_DEV(card), "Failed to map BAR0\n");
> +		st = -ENOMEM;
> +		goto failed_iomap;
> +	}
> +
> +	spin_lock_init(&card->irq_lock);
> +	card->halt = 0;
> +
> +	spin_lock_irqsave(&card->irq_lock, flags);

Can use plain old spin_lock_irq() in a probe function.

> +	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
> +	spin_unlock_irqrestore(&card->irq_lock, flags);
> +
> +	if (!force_legacy) {
> +		st = pci_enable_msi(dev);
> +		if (st)
> +			dev_warn(CARD_TO_DEV(card),
> +				"Failed to enable MSI\n");
> +	}
> +
> +	st = request_irq(dev->irq, rsxx_isr, IRQF_DISABLED | IRQF_SHARED,
> +			 DRIVER_NAME, card);
> +	if (st) {
> +		dev_err(CARD_TO_DEV(card),
> +			"Failed requesting IRQ%d\n", dev->irq);
> +		goto failed_irq;
> +	}
> +
> +	/************* Setup Processor Command Interface *************/
> +	rsxx_creg_setup(card);
> +
> +	spin_lock_irqsave(&card->irq_lock, flags);

Ditto(es)

> +	rsxx_enable_ier_and_isr(card, CR_INTR_CREG);
> +	spin_unlock_irqrestore(&card->irq_lock, flags);
> +
> +	st = rsxx_compatibility_check(card);
> +	if (st) {
> +		dev_warn(CARD_TO_DEV(card),
> +			"Incompatible driver detected. Please update the driver.\n");
> +		st = -EINVAL;
> +		goto failed_compatiblity_check;
> +	}
> +
> +	/************* Load Card Config *************/
> +	st = rsxx_load_config(card);
> +	if (st)
> +		dev_err(CARD_TO_DEV(card),
> +			"Failed loading card config\n");
> +
> +	/************* Setup DMA Engine *************/
> +	st = rsxx_get_num_targets(card, &card->n_targets);
> +	if (st)
> +		dev_info(CARD_TO_DEV(card),
> +			"Failed reading the number of DMA targets\n");
> +
> +	card->ctrl = kzalloc(card->n_targets * sizeof(*card->ctrl), GFP_KERNEL);
> +	if (!card->ctrl) {
> +		st = -ENOMEM;
> +		goto failed_dma_setup;
> +	}
> +
> +	st = rsxx_dma_setup(card);
> +	if (st) {
> +		dev_info(CARD_TO_DEV(card),
> +			"Failed to setup DMA engine\n");
> +		goto failed_dma_setup;
> +	}
> +
> +	/************* Setup Card Event Handler *************/
> +	INIT_WORK(&card->event_work, card_event_handler);
> +
> +	st = rsxx_setup_dev(card);
> +	if (st)
> +		goto failed_create_dev;
> +
> +	rsxx_get_card_state(card, &card->state);
> +
> +	dev_info(CARD_TO_DEV(card),
> +		"card state: %s\n",
> +		rsxx_card_state_to_str(card->state));
> +
> +	/*
> +	 * Now that the DMA Engine and devices have been setup,
> +	 * we can enable the event interrupt(it kicks off actions in
> +	 * those layers so we couldn't enable it right away.)
> +	 */
> +	spin_lock_irqsave(&card->irq_lock, flags);
> +	rsxx_enable_ier_and_isr(card, CR_INTR_EVENT);
> +	spin_unlock_irqrestore(&card->irq_lock, flags);
> +
> +	if (card->state == CARD_STATE_SHUTDOWN) {
> +		st = rsxx_issue_card_cmd(card, CARD_CMD_STARTUP);
> +		if (st)
> +			dev_crit(CARD_TO_DEV(card),
> +				"Failed issuing card startup\n");
> +	} else if (card->state == CARD_STATE_GOOD ||
> +		   card->state == CARD_STATE_RD_ONLY_FAULT) {
> +		st = rsxx_get_card_size8(card, &card->size8);
> +		if (st)
> +			card->size8 = 0;
> +	}
> +
> +	rsxx_attach_dev(card);
> +
> +	return 0;
> +
> +failed_create_dev:
> +	rsxx_dma_destroy(card);
> +failed_dma_setup:
> +failed_compatiblity_check:
> +	spin_lock_irqsave(&card->irq_lock, flags);
> +	rsxx_disable_ier_and_isr(card, CR_INTR_ALL);
> +	spin_unlock_irqrestore(&card->irq_lock, flags);
> +	free_irq(dev->irq, card);
> +	if (!force_legacy)
> +		pci_disable_msi(dev);
> +failed_irq:
> +	pci_iounmap(dev, card->regmap);
> +failed_iomap:
> +	pci_release_regions(dev);
> +failed_request_regions:
> +failed_dma_mask:
> +	pci_disable_device(dev);
> +failed_enable:
> +	spin_lock(&rsxx_ida_lock);
> +	ida_remove(&rsxx_disk_ida, card->disk_id);
> +	spin_unlock(&rsxx_ida_lock);
> +failed_ida_get:
> +	kfree(card);
> +
> +	return st;
> +}
>
> ...
>
> +#if defined(__LITTLE_ENDIAN)
> +#define LITTLE_ENDIAN 1
> +#elif defined(__BIG_ENDIAN)
> +#define LITTLE_ENDIAN 0
> +#else
> +#error Unknown endianess!!! Aborting...
> +#endif

Can we nuke all this stuff and use cpu_to_be32() and friends?

>
> ...
>
> +static void creg_issue_cmd(struct rsxx_cardinfo *card, struct creg_cmd *cmd)
> +{
> +	iowrite32(cmd->addr, card->regmap + CREG_ADD);
> +	iowrite32(cmd->cnt8, card->regmap + CREG_CNT);
> +
> +	if (cmd->op == CREG_OP_WRITE) {
> +		if (cmd->buf)
> +			copy_to_creg_data(card, cmd->cnt8,
> +					  cmd->buf, cmd->stream);
> +	}
> +
> +	/* Data copy must complete before initiating the command. */
> +	wmb();

I don't think a wmb() is the way to ensure that an iowrite() has
completed.  I forget the rules here - I unreliably recall that an
iowrite() is synchronous.

> +	/* Setting the valid bit will kick off the command. */
> +	iowrite32(cmd->op, card->regmap + CREG_CMD);
> +}
> +
> +static void creg_kick_queue(struct rsxx_cardinfo *card)
> +{
> +	if (card->creg_ctrl.active || list_empty(&card->creg_ctrl.queue))
> +		return;
> +
> +	card->creg_ctrl.active = 1;
> +	card->creg_ctrl.active_cmd = list_first_entry(&card->creg_ctrl.queue,
> +						      struct creg_cmd, list);
> +	list_del(&card->creg_ctrl.active_cmd->list);
> +	card->creg_ctrl.q_depth--;
> +
> +	/*
> +	 * We have to set the timer before we push the new command. Otherwise,
> +	 * we could create a race condition that would occur if the timer
> +	 * was not canceled, and expired after the new command was pushed,
> +	 * but before the command was issued to hardware.
> +	 */
> +	mod_timer(&card->creg_ctrl.cmd_timer,
> +				jiffies + msecs_to_jiffies(CREG_TIMEOUT_MSEC));
> +
> +	creg_issue_cmd(card, card->creg_ctrl.active_cmd);
> +}

The function should document its caller-imposed locking rules.  Most
callers hold mutex_lock(&card->creg_ctrl.lock), but
creg_cmd_timed_out() does not and cannot.  Looks buggy.

>
> ...
>
> +static void creg_reset(struct rsxx_cardinfo *card)
> +{
> +	struct creg_cmd *cmd = NULL;
> +	struct creg_cmd *tmp;
> +	unsigned long flags;
> +
> +	if (!mutex_trylock(&card->creg_ctrl.reset_lock))
> +		return;

mutex_trylock() is ugly, and is always obscure.  This site should have
a code comment explaining why we're doing this extraordinary thing, and
why it is acceptable to simply bail out if the attempt failed.  

> +	card->creg_ctrl.reset = 1;
> +	spin_lock_irqsave(&card->irq_lock, flags);
> +	rsxx_disable_ier_and_isr(card, CR_INTR_CREG | CR_INTR_EVENT);
> +	spin_unlock_irqrestore(&card->irq_lock, flags);
> +
> +	dev_warn(CARD_TO_DEV(card),
> +		"Resetting creg interface for recovery\n");
> +
> +	/* Cancel outstanding commands */
> +	mutex_lock(&card->creg_ctrl.lock);
> +	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
> +		list_del(&cmd->list);
> +		card->creg_ctrl.q_depth--;
> +		if (cmd->cb)
> +			cmd->cb(card, cmd, -ECANCELED);
> +		kmem_cache_free(creg_cmd_pool, cmd);
> +	}
> +
> +	cmd = card->creg_ctrl.active_cmd;
> +	card->creg_ctrl.active_cmd = NULL;
> +	if (cmd) {
> +		if (timer_pending(&card->creg_ctrl.cmd_timer))
> +			del_timer_sync(&card->creg_ctrl.cmd_timer);
> +
> +		if (cmd->cb)
> +			cmd->cb(card, cmd, -ECANCELED);
> +		kmem_cache_free(creg_cmd_pool, cmd);
> +
> +		card->creg_ctrl.active = 0;
> +	}
> +	mutex_unlock(&card->creg_ctrl.lock);
> +
> +	card->creg_ctrl.reset = 0;
> +	spin_lock_irqsave(&card->irq_lock, flags);
> +	rsxx_enable_ier_and_isr(card, CR_INTR_CREG | CR_INTR_EVENT);
> +	spin_unlock_irqrestore(&card->irq_lock, flags);
> +
> +	mutex_unlock(&card->creg_ctrl.reset_lock);
> +}
> +
> +/* Used for synchronous accesses */
> +struct creg_completion {
> +	struct completion	*cmd_done;
> +	int			st;
> +	u32			creg_status;
> +};
> +
> +static void creg_cmd_done_cb(struct rsxx_cardinfo *card,
> +			     struct creg_cmd *cmd,
> +			     int st)
> +{
> +	struct creg_completion *cmd_completion;
> +
> +	cmd_completion = (struct creg_completion *)cmd->cb_private;

unneeded cast of void*.

> +	BUG_ON(!cmd_completion);
> +
> +	cmd_completion->st = st;
> +	cmd_completion->creg_status = cmd->status;
> +	complete(cmd_completion->cmd_done);
> +}
> +
> +static int __issue_creg_rw(struct rsxx_cardinfo *card,
> +			   unsigned int op,
> +			   unsigned int addr,
> +			   unsigned int cnt8,
> +			   void *buf,
> +			   int stream,
> +			   unsigned int *hw_stat)
> +{
> +	DECLARE_COMPLETION_ONSTACK(cmd_done);
> +	struct creg_completion completion;
> +	unsigned long timeout;
> +	int st;
> +
> +	INIT_COMPLETION(cmd_done);

DECLARE_COMPLETION_ONSTACK() already did that?

> +	completion.cmd_done = &cmd_done;
> +	completion.st = 0;
> +	completion.creg_status = 0;
> +
> +	st = creg_queue_cmd(card, op, addr, cnt8, buf, stream, creg_cmd_done_cb,
> +			    &completion);
> +	if (st)
> +		return st;
> +
> +	timeout = msecs_to_jiffies((CREG_TIMEOUT_MSEC *
> +				    card->creg_ctrl.q_depth) + 20000);

This is, what?  A minute?  That sounds nutty.  Chances are the user has
hit the big red button before this expires.

> +	/*
> +	 * The creg interface is guaranteed to complete. It has a timeout
> +	 * mechanism that will kick in if hardware does not respond.
> +	 */
> +	st = wait_for_completion_timeout(completion.cmd_done, timeout);
> +	if (st == 0) {
> +		/*
> +		 * This is really bad, because the kernel timer did not
> +		 * expire and notify us of a timeout!
> +		 */
> +		dev_crit(CARD_TO_DEV(card),
> +			"cregs timer failed\n");
> +		creg_reset(card);
> +		return -EIO;
> +	}
> +
> +	*hw_stat = completion.creg_status;
> +
> +	if (completion.st) {
> +		dev_warn(CARD_TO_DEV(card),
> +			"creg command failed(%d x%08x)\n",
> +			completion.st, addr);
> +		return completion.st;
> +	}
> +
> +	return 0;
> +}
> +
> +static int issue_creg_rw(struct rsxx_cardinfo *card,
> +			 u32 addr,
> +			 unsigned int size8,
> +			 void *data,
> +			 int stream,
> +			 int read)
> +{
> +	unsigned int hw_stat;
> +	unsigned int xfer;
> +	unsigned int op;
> +	int st;
> +
> +	op = read ? CREG_OP_READ : CREG_OP_WRITE;
> +
> +	do {
> +		xfer = min_t(unsigned int, size8, MAX_CREG_DATA8);
> +
> +		st = __issue_creg_rw(card, op, addr, xfer,
> +				     data, stream, &hw_stat);
> +		if (st)
> +			return st;
> +
> +		data   = (void *)((char *)data + xfer);

unneeded cast to void*.

> +		addr  += xfer;
> +		size8 -= xfer;
> +	} while (size8);
> +
> +	return 0;
> +}
> +
>
> ...
>
> +static void hw_log_msg(struct rsxx_cardinfo *card, const char *str, int len)
> +{
> +	static char level;
> +
> +	/*
> +	 * New messages start with "<#>", where # is the log level. Messages
> +	 * that extend past the log buffer will use the previous level
> +	 */
> +	if ((len > 3) && (str[0] == '<') && (str[2] == '>')) {
> +		level = str[1];
> +		str += 3; /* Skip past the log level. */
> +		len -= 3;
> +	}

hm, what's going on here?  We're translating log messages which were
read from the controller into kernel printk form?

If so, OK.

If not, the recent change from <n> to \001n broke things.

> +	switch (level) {
> +	case '0':
> +		dev_emerg(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	case '1':
> +		dev_alert(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	case '2':
> +		dev_crit(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	case '3':
> +		dev_err(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	case '4':
> +		dev_warn(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	case '5':
> +		dev_notice(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	case '6':
> +		dev_info(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	case '7':
> +		dev_dbg(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	default:
> +		dev_info(CARD_TO_DEV(card), "HW: %.*s", len, str);
> +		break;
> +	}
> +}
> +
> +/*
> + * The substrncpy() function copies to string(up to count bytes) point to by src
> + * (including the terminating '\0' character) to dest. Returns the number of
> + * bytes copied to dest.
> + */

This description isn't very grammatical.

> +static int substrncpy(char *dest, const char *src, int count)
> +{
> +	int max_cnt = count;
> +
> +	while (count) {
> +		count--;
> +		*dest = *src;
> +		if (*dest == '\0')
> +			break;
> +		src++;
> +		dest++;
> +	}
> +	return max_cnt - count;
> +}

Does this really need to exist?  You're sure none of the standard
facilities suit?

>
> ...
>
> +int rsxx_reg_access(struct rsxx_cardinfo *card,
> +			struct rsxx_reg_access __user *ucmd,
> +			int read)
> +{
> +	struct rsxx_reg_access cmd;
> +	int st;
> +
> +	st = copy_from_user(&cmd, ucmd, sizeof(cmd));
> +	if (st)
> +		return -EFAULT;
> +
> +	st = issue_reg_cmd(card, &cmd, read);
> +	if (st)
> +		return st;
> +
> +	st = put_user(cmd.stat, &ucmd->stat);
> +	if (st)
> +		return -EFAULT;
> +
> +	if (read) {
> +		st = copy_to_user(ucmd->data, cmd.data, cmd.cnt);

I think we just handed the user a way of reading unlimited amounts of
kernel memory.

> +		if (st)
> +			return -EFAULT;
> +	}
> +
> +	return 0;
> +}
> +
> +/*------------ Initialization & Setup --------------*/
> +int rsxx_creg_setup(struct rsxx_cardinfo *card)
> +{
> +	card->creg_ctrl.active_cmd = NULL;
> +
> +	INIT_WORK(&card->creg_ctrl.done_work, creg_cmd_done);
> +	mutex_init(&card->creg_ctrl.reset_lock);
> +	INIT_LIST_HEAD(&card->creg_ctrl.queue);
> +	mutex_init(&card->creg_ctrl.lock);
> +	spin_lock_init(&card->creg_ctrl.pop_lock);
> +	setup_timer(&card->creg_ctrl.cmd_timer, creg_cmd_timed_out,
> +		    (unsigned long) card);
> +
> +	return 0;
> +}
> +
> +void rsxx_creg_destroy(struct rsxx_cardinfo *card)
> +{
> +	struct creg_cmd *cmd;
> +	struct creg_cmd *tmp;
> +	int cnt = 0;
> +
> +	/* Cancel outstanding commands */
> +	mutex_lock(&card->creg_ctrl.lock);
> +	list_for_each_entry_safe(cmd, tmp, &card->creg_ctrl.queue, list) {
> +		list_del(&cmd->list);
> +		if (cmd->cb)
> +			cmd->cb(card, cmd, -ECANCELED);
> +		kmem_cache_free(creg_cmd_pool, cmd);
> +		cnt++;
> +	}
> +
> +	if (cnt)
> +		dev_info(CARD_TO_DEV(card),
> +			"Canceled %d queue creg commands\n", cnt);
> +
> +	cmd = card->creg_ctrl.active_cmd;
> +	card->creg_ctrl.active_cmd = NULL;
> +	if (cmd) {
> +		if (timer_pending(&card->creg_ctrl.cmd_timer))
> +			del_timer_sync(&card->creg_ctrl.cmd_timer);
> +
> +		if (cmd->cb)
> +			cmd->cb(card, cmd, -ECANCELED);
> +		dev_info(CARD_TO_DEV(card),
> +			"Canceled active creg command\n");
> +		kmem_cache_free(creg_cmd_pool, cmd);
> +	}
> +	mutex_unlock(&card->creg_ctrl.lock);
> +
> +	cancel_work_sync(&card->creg_ctrl.done_work);
> +}
> +
> +
> +int rsxx_creg_init(void)
> +{
> +	creg_cmd_pool = KMEM_CACHE(creg_cmd, SLAB_HWCACHE_ALIGN);
> +	if (!creg_cmd_pool)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +void rsxx_creg_cleanup(void)
> +{
> +	kmem_cache_destroy(creg_cmd_pool);
> +}
> diff -uprN -X linux-3.7.5-vanilla/Documentation/dontdiff linux-3.7.5-vanilla/drivers/block/rsxx/dev.c linux-3.7.5/drivers/block/rsxx/dev.c
> --- linux-3.7.5-vanilla/drivers/block/rsxx/dev.c	1969-12-31 18:00:00.000000000 -0600
> +++ linux-3.7.5/drivers/block/rsxx/dev.c	2013-01-29 13:12:20.507255959 -0600
> @@ -0,0 +1,367 @@
> +/*
> +* Filename: dev.c
> +*
> +*
> +* Authors: Joshua Morris <josh.h.morris@us.ibm.com>
> +*	Philip Kelleher <pjk1939@linux.vnet.ibm.com>
> +*
> +* (C) Copyright 2013 IBM Corporation
> +*
> +* This program is free software; you can redistribute it and/or
> +* modify it under the terms of the GNU General Public License as
> +* published by the Free Software Foundation; either version 2 of the
> +* License, or (at your option) any later version.
> +*
> +* This program is distributed in the hope that it will be useful, but
> +* WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> +* General Public License for more details.
> +*
> +* You should have received a copy of the GNU General Public License
> +* along with this program; if not, write to the Free Software Foundation,
> +* Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> +*/
> +
> +#include <linux/kernel.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/slab.h>
> +
> +#include <linux/hdreg.h>
> +#include <linux/genhd.h>
> +#include <linux/blkdev.h>
> +#include <linux/bio.h>
> +
> +#include <linux/fs.h>
> +
> +#include "rsxx_priv.h"
> +
> +static unsigned int blkdev_minors = 64;
> +module_param(blkdev_minors, uint, 0444);
> +MODULE_PARM_DESC(blkdev_minors, "Number of minors(partitions)");
> +
> +/*
> + * For now I'm making this tweakable in case any applications hit this limit.
> + * If you see a "bio too big" error in the log you will need to raise this
> + * value.
> + */
> +static unsigned int blkdev_max_hw_sectors = 1024;
> +module_param(blkdev_max_hw_sectors, uint, 0444);
> +MODULE_PARM_DESC(blkdev_max_hw_sectors, "Max hw sectors for a single BIO");
> +
> +static unsigned int enable_blkdev = 1;
> +module_param(enable_blkdev , uint, 0444);
> +MODULE_PARM_DESC(enable_blkdev, "Enable block device interfaces");
> +
> +
> +struct rsxx_bio_meta {
> +	struct bio	*bio;
> +	atomic_t	pending_dmas;
> +	atomic_t	error;
> +	unsigned long	start_time;
> +};
> +
> +static struct kmem_cache *bio_meta_pool;
> +
> +/*----------------- Block Device Operations -----------------*/
> +static int rsxx_blkdev_ioctl(struct block_device *bdev,
> +				 fmode_t mode,
> +				 unsigned int cmd,
> +				 unsigned long arg)
> +{
> +	struct rsxx_cardinfo *card = bdev->bd_disk->private_data;
> +
> +	switch (cmd) {
> +	case RSXX_GETREG:
> +		return rsxx_reg_access(card, (void __user *)arg, 1);
> +	case RSXX_SETREG:
> +		return rsxx_reg_access(card, (void __user *)arg, 0);
> +	}
> +
> +	return -ENOTTY;
> +}

<attention span expired 48% of the way through, sorry>
