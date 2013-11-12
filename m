Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3KLRjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:39:39 -0500
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:27284
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756601Ab3KLRjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:39:32 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097h84d07hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5VNS-08-4UF-02
X-M-MSG: 
Subject: [PATCH 03/10] crypto: CCP device driver and interface support
To: <davem@davemloft.net>, <linux-crytpo@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:39:18 -0600
Message-ID: <20131112173918.18862.58573.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131112173900.18862.68623.stgit@tlendack-t1.amdoffice.net>
References: <20131112173900.18862.68623.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines provide the device driver support for the AMD
Cryptographic Coprocessor (CCP).

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |  582 ++++++++++++
 drivers/crypto/ccp/ccp-dev.h |  272 ++++++
 drivers/crypto/ccp/ccp-ops.c | 2020 ++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-pci.c |  360 +++++++
 include/linux/ccp.h          |  525 +++++++++++
 5 files changed, 3759 insertions(+)
 create mode 100644 drivers/crypto/ccp/ccp-dev.c
 create mode 100644 drivers/crypto/ccp/ccp-dev.h
 create mode 100644 drivers/crypto/ccp/ccp-ops.c
 create mode 100644 drivers/crypto/ccp/ccp-pci.c
 create mode 100644 include/linux/ccp.h

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
new file mode 100644
index 0000000..de59df9
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -0,0 +1,582 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/hw_random.h>
+#include <linux/cpu.h>
+#include <asm/cpu_device_id.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0.0");
+MODULE_DESCRIPTION("AMD Cryptographic Coprocessor driver");
+
+
+static struct ccp_device *ccp_dev;
+static inline struct ccp_device *ccp_get_device(void)
+{
+	return ccp_dev;
+}
+
+static inline void ccp_add_device(struct ccp_device *ccp)
+{
+	ccp_dev = ccp;
+}
+
+static inline void ccp_del_device(struct ccp_device *ccp)
+{
+	ccp_dev = NULL;
+}
+
+/**
+ * ccp_enqueue_cmd - queue an operation for processing by the CCP
+ *
+ * @cmd: ccp_cmd struct to be processed
+ *
+ * Queue a cmd to be processed by the CCP. If queueing the cmd
+ * would exceed the defined length of the cmd queue the cmd will
+ * only be queued if the CCP_CMD_MAY_BACKLOG flag is set and will
+ * result in a return code of -EBUSY.
+ *
+ * The callback routine specified in the ccp_cmd struct will be
+ * called to notify the caller of completion (if the cmd was not
+ * backlogged) or advancement out of the backlog. If the cmd has
+ * advanced out of the backlog the "err" value of the callback
+ * will be -EINPROGRESS. Any other "err" value during callback is
+ * the result of the operation.
+ *
+ * The cmd has been successfully queued if:
+ *   the return code is -EINPROGRESS or
+ *   the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
+ */
+int ccp_enqueue_cmd(struct ccp_cmd *cmd)
+{
+	struct ccp_device *ccp = ccp_get_device();
+	unsigned long flags;
+	unsigned int i;
+	int ret;
+
+	if (!ccp)
+		return -ENODEV;
+
+	/* Caller must supply a callback routine */
+	if (!cmd->callback)
+		return -EINVAL;
+
+	cmd->ccp = ccp;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	i = ccp->cmd_q_count;
+
+	if (ccp->cmd_count >= MAX_CMD_QLEN) {
+		ret = -EBUSY;
+		if (cmd->flags & CCP_CMD_MAY_BACKLOG)
+			list_add_tail(&cmd->entry, &ccp->backlog);
+	} else {
+		ret = -EINPROGRESS;
+		ccp->cmd_count++;
+		list_add_tail(&cmd->entry, &ccp->cmd);
+
+		/* Find an idle queue */
+		if (!ccp->suspending) {
+			for (i = 0; i < ccp->cmd_q_count; i++) {
+				if (ccp->cmd_q[i].active)
+					continue;
+
+				break;
+			}
+		}
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* If we found an idle queue, wake it up */
+	if (i < ccp->cmd_q_count)
+		wake_up_process(ccp->cmd_q[i].kthread);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ccp_enqueue_cmd);
+
+static void ccp_do_cmd_backlog(struct work_struct *work)
+{
+	struct ccp_cmd *cmd = container_of(work, struct ccp_cmd, work);
+	struct ccp_device *ccp = cmd->ccp;
+	unsigned long flags;
+	unsigned int i;
+
+	cmd->callback(cmd->data, -EINPROGRESS);
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->cmd_count++;
+	list_add_tail(&cmd->entry, &ccp->cmd);
+
+	/* Find an idle queue */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		if (ccp->cmd_q[i].active)
+			continue;
+
+		break;
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* If we found an idle queue, wake it up */
+	if (i < ccp->cmd_q_count)
+		wake_up_process(ccp->cmd_q[i].kthread);
+}
+
+static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
+{
+	struct ccp_device *ccp = cmd_q->ccp;
+	struct ccp_cmd *cmd = NULL;
+	struct ccp_cmd *backlog = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	cmd_q->active = 0;
+
+	if (ccp->suspending) {
+		cmd_q->suspended = 1;
+
+		spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+		wake_up_interruptible(&ccp->suspend_queue);
+
+		return NULL;
+	}
+
+	if (ccp->cmd_count) {
+		cmd_q->active = 1;
+
+		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
+		list_del(&cmd->entry);
+
+		ccp->cmd_count--;
+	}
+
+	if (!list_empty(&ccp->backlog)) {
+		backlog = list_first_entry(&ccp->backlog, struct ccp_cmd,
+					   entry);
+		list_del(&backlog->entry);
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	if (backlog) {
+		INIT_WORK(&backlog->work, ccp_do_cmd_backlog);
+		schedule_work(&backlog->work);
+	}
+
+	return cmd;
+}
+
+static void ccp_do_cmd_complete(struct work_struct *work)
+{
+	struct ccp_cmd *cmd = container_of(work, struct ccp_cmd, work);
+
+	cmd->callback(cmd->data, cmd->ret);
+}
+
+static int ccp_cmd_queue_thread(void *data)
+{
+	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
+	struct ccp_cmd *cmd;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+
+		set_current_state(TASK_INTERRUPTIBLE);
+
+		cmd = ccp_dequeue_cmd(cmd_q);
+		if (!cmd)
+			continue;
+
+		__set_current_state(TASK_RUNNING);
+
+		/* Execute the command */
+		cmd->ret = ccp_run_cmd(cmd_q, cmd);
+
+		/* Schedule the completion callback */
+		INIT_WORK(&cmd->work, ccp_do_cmd_complete);
+		schedule_work(&cmd->work);
+	}
+
+	__set_current_state(TASK_RUNNING);
+
+	return 0;
+}
+
+static int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
+{
+	struct ccp_device *ccp = container_of(rng, struct ccp_device, hwrng);
+	u32 trng_value;
+	int len = min_t(int, sizeof(trng_value), max);
+
+	/*
+	 * Locking is provided by the caller so we can update device
+	 * hwrng-related fields safely
+	 */
+	trng_value = ioread32(ccp->io_regs + TRNG_OUT_REG);
+	if (!trng_value) {
+		/* Zero is returned if not data is available or if a
+		 * bad-entropy error is present. Assume an error if
+		 * we exceed TRNG_RETRIES reads of zero.
+		 */
+		if (ccp->hwrng_retries++ > TRNG_RETRIES)
+			return -EIO;
+
+		return 0;
+	}
+
+	/* Reset the counter and save the rng value */
+	ccp->hwrng_retries = 0;
+	memcpy(data, &trng_value, len);
+
+	return len;
+}
+
+/**
+ * ccp_alloc_struct - allocate and initialize the ccp_device struct
+ *
+ * @dev: device struct of the CCP
+ */
+struct ccp_device *ccp_alloc_struct(struct device *dev)
+{
+	struct ccp_device *ccp;
+
+	ccp = kzalloc(sizeof(*ccp), GFP_KERNEL);
+	if (ccp == NULL) {
+		dev_err(dev, "unable to allocate device struct\n");
+		return NULL;
+	}
+	ccp->dev = dev;
+
+	INIT_LIST_HEAD(&ccp->cmd);
+	INIT_LIST_HEAD(&ccp->backlog);
+
+	spin_lock_init(&ccp->cmd_lock);
+	mutex_init(&ccp->req_mutex);
+	mutex_init(&ccp->ksb_mutex);
+	ccp->ksb_count = KSB_COUNT;
+	ccp->ksb_start = 0;
+
+	return ccp;
+}
+
+/**
+ * ccp_init - initialize the CCP device
+ *
+ * @ccp: ccp_device struct
+ */
+int ccp_init(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct ccp_cmd_queue *cmd_q;
+	struct dma_pool *dma_pool;
+	char dma_pool_name[MAX_DMAPOOL_NAME_LEN];
+	unsigned int qmr, qim, i;
+	int ret;
+
+	/* Find available queues */
+	qim = 0;
+	qmr = ioread32(ccp->io_regs + Q_MASK_REG);
+	for (i = 0; i < MAX_HW_QUEUES; i++) {
+		if (!(qmr & (1 << i)))
+			continue;
+
+		/* Allocate a dma pool for this queue */
+		snprintf(dma_pool_name, sizeof(dma_pool_name), "ccp_q%d", i);
+		dma_pool = dma_pool_create(dma_pool_name, dev,
+					   CCP_DMAPOOL_MAX_SIZE,
+					   CCP_DMAPOOL_ALIGN, 0);
+		if (!dma_pool) {
+			dev_err(dev, "unable to allocate dma pool\n");
+			ret = -ENOMEM;
+			goto e_pool;
+		}
+
+		cmd_q = &ccp->cmd_q[ccp->cmd_q_count];
+		ccp->cmd_q_count++;
+
+		cmd_q->ccp = ccp;
+		cmd_q->id = i;
+		cmd_q->dma_pool = dma_pool;
+
+		/* Reserve 2 KSB regions for the queue */
+		cmd_q->ksb_key = KSB_START + ccp->ksb_start++;
+		cmd_q->ksb_ctx = KSB_START + ccp->ksb_start++;
+		ccp->ksb_count -= 2;
+
+		/* Preset some register values and masks that are queue
+		 * number dependent
+		 */
+		cmd_q->reg_status = ccp->io_regs + CMD_Q_STATUS_BASE +
+				    (CMD_Q_STATUS_INCR * i);
+		cmd_q->reg_int_status = ccp->io_regs + CMD_Q_INT_STATUS_BASE +
+					(CMD_Q_STATUS_INCR * i);
+		cmd_q->int_ok = 1 << (i * 2);
+		cmd_q->int_err = 1 << ((i * 2) + 1);
+
+		cmd_q->free_slots = CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
+
+		init_waitqueue_head(&cmd_q->int_queue);
+
+		/* Build queue interrupt mask (two interrupts per queue) */
+		qim |= cmd_q->int_ok | cmd_q->int_err;
+
+		dev_dbg(dev, "queue #%u available\n", i);
+	}
+	if (ccp->cmd_q_count == 0) {
+		dev_notice(dev, "no command queues available\n");
+		ret = -EIO;
+		goto e_pool;
+	}
+	dev_notice(dev, "%u command queues available\n", ccp->cmd_q_count);
+
+	/* Disable and clear interrupts until ready */
+	iowrite32(0x00, ccp->io_regs + IRQ_MASK_REG);
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		ioread32(cmd_q->reg_int_status);
+		ioread32(cmd_q->reg_status);
+	}
+	iowrite32(qim, ccp->io_regs + IRQ_STATUS_REG);
+
+	/* Request an irq */
+	ret = ccp->get_irq(ccp);
+	if (ret) {
+		dev_err(dev, "unable to allocate an IRQ\n");
+		goto e_pool;
+	}
+
+	/* Initialize the queues used to wait for KSB space and suspend */
+	init_waitqueue_head(&ccp->ksb_queue);
+	init_waitqueue_head(&ccp->suspend_queue);
+
+	/* Create a kthread for each queue */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		struct task_struct *kthread;
+
+		cmd_q = &ccp->cmd_q[i];
+
+		kthread = kthread_create(ccp_cmd_queue_thread, cmd_q,
+					 "ccp-q%u", cmd_q->id);
+		if (IS_ERR(kthread)) {
+			dev_err(dev, "error creating queue thread (%ld)\n",
+				PTR_ERR(kthread));
+			ret = PTR_ERR(kthread);
+			goto e_kthread;
+		}
+
+		cmd_q->kthread = kthread;
+		wake_up_process(kthread);
+	}
+
+	/* Register the RNG */
+	ccp->hwrng.name = "ccp-rng";
+	ccp->hwrng.read = ccp_trng_read;
+	ret = hwrng_register(&ccp->hwrng);
+	if (ret) {
+		dev_err(dev, "error registering hwrng (%d)\n", ret);
+		goto e_kthread;
+	}
+
+	/* Make the device struct available before enabling interrupts */
+	ccp_add_device(ccp);
+
+	/* Enable interrupts */
+	iowrite32(qim, ccp->io_regs + IRQ_MASK_REG);
+
+	return 0;
+
+e_kthread:
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].kthread)
+			kthread_stop(ccp->cmd_q[i].kthread);
+
+	ccp->free_irq(ccp);
+
+e_pool:
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
+
+	return ret;
+}
+
+/**
+ * ccp_destroy - tear down the CCP device
+ *
+ * @ccp: ccp_device struct
+ */
+void ccp_destroy(struct ccp_device *ccp)
+{
+	struct ccp_cmd_queue *cmd_q;
+	struct ccp_cmd *cmd;
+	unsigned int qim, i;
+
+	/* Remove general access to the device struct */
+	ccp_del_device(ccp);
+
+	/* Unregister the RNG */
+	hwrng_unregister(&ccp->hwrng);
+
+	/* Stop the queue kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].kthread)
+			kthread_stop(ccp->cmd_q[i].kthread);
+
+	/* Build queue interrupt mask (two interrupt masks per queue) */
+	qim = 0;
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+		qim |= cmd_q->int_ok | cmd_q->int_err;
+	}
+
+	/* Disable and clear interrupts */
+	iowrite32(0x00, ccp->io_regs + IRQ_MASK_REG);
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		ioread32(cmd_q->reg_int_status);
+		ioread32(cmd_q->reg_status);
+	}
+	iowrite32(qim, ccp->io_regs + IRQ_STATUS_REG);
+
+	ccp->free_irq(ccp);
+
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		dma_pool_destroy(ccp->cmd_q[i].dma_pool);
+
+	/* Flush the cmd and backlog queue */
+	while (!list_empty(&ccp->cmd)) {
+		/* Invoke the callback directly with an error code */
+		cmd = list_first_entry(&ccp->cmd, struct ccp_cmd, entry);
+		list_del(&cmd->entry);
+		cmd->callback(cmd->data, -ENODEV);
+	}
+	while (!list_empty(&ccp->backlog)) {
+		/* Invoke the callback directly with an error code */
+		cmd = list_first_entry(&ccp->backlog, struct ccp_cmd, entry);
+		list_del(&cmd->entry);
+		cmd->callback(cmd->data, -ENODEV);
+	}
+}
+
+/**
+ * ccp_irq_handler - handle interrupts generated by the CCP device
+ *
+ * @irq: the irq associated with the interrupt
+ * @data: the data value supplied when the irq was created
+ */
+irqreturn_t ccp_irq_handler(int irq, void *data)
+{
+	struct device *dev = data;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	struct ccp_cmd_queue *cmd_q;
+	u32 q_int, status;
+	unsigned int i;
+
+	status = ioread32(ccp->io_regs + IRQ_STATUS_REG);
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		cmd_q = &ccp->cmd_q[i];
+
+		q_int = status & (cmd_q->int_ok | cmd_q->int_err);
+		if (q_int) {
+			cmd_q->int_status = status;
+			cmd_q->q_status = ioread32(cmd_q->reg_status);
+			cmd_q->q_int_status = ioread32(cmd_q->reg_int_status);
+
+			/* On error, only save the first error value */
+			if ((q_int & cmd_q->int_err) && !cmd_q->cmd_error)
+				cmd_q->cmd_error = CMD_Q_ERROR(cmd_q->q_status);
+
+			cmd_q->int_rcvd = 1;
+
+			/* Acknowledge the interrupt and wake the kthread */
+			iowrite32(q_int, ccp->io_regs + IRQ_STATUS_REG);
+			wake_up_interruptible(&cmd_q->int_queue);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_PM
+bool ccp_queues_suspended(struct ccp_device *ccp)
+{
+	unsigned int suspended = 0;
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		if (ccp->cmd_q[i].suspended)
+			suspended++;
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	return ccp->cmd_q_count == suspended;
+}
+#endif
+
+static const struct x86_cpu_id ccp_support[] = {
+	{ X86_VENDOR_AMD, 22, },
+};
+
+static int __init ccp_mod_init(void)
+{
+	struct cpuinfo_x86 *cpuinfo = &boot_cpu_data;
+
+	if (!x86_match_cpu(ccp_support))
+		return -ENODEV;
+
+	switch (cpuinfo->x86) {
+	case 22:
+		if ((cpuinfo->x86_model < 48) || (cpuinfo->x86_model > 63))
+			return -ENODEV;
+		return ccp_pci_init();
+		break;
+	};
+
+	return -ENODEV;
+}
+
+static void __exit ccp_mod_exit(void)
+{
+	struct cpuinfo_x86 *cpuinfo = &boot_cpu_data;
+
+	switch (cpuinfo->x86) {
+	case 22:
+		ccp_pci_exit();
+		break;
+	};
+}
+
+module_init(ccp_mod_init);
+module_exit(ccp_mod_exit);
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
new file mode 100644
index 0000000..7ec536e
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -0,0 +1,272 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __CCP_DEV_H__
+#define __CCP_DEV_H__
+
+#include <linux/device.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/dmapool.h>
+#include <linux/hw_random.h>
+
+
+#define IO_OFFSET			0x20000
+
+#define MAX_DMAPOOL_NAME_LEN		32
+
+#define MAX_HW_QUEUES			5
+#define MAX_CMD_QLEN			100
+
+#define TRNG_RETRIES			10
+
+
+/****** Register Mappings ******/
+#define Q_MASK_REG			0x000
+#define TRNG_OUT_REG			0x00c
+#define IRQ_MASK_REG			0x040
+#define IRQ_STATUS_REG			0x200
+
+#define DEL_CMD_Q_JOB			0x124
+#define DEL_Q_ACTIVE			0x00000200
+#define DEL_Q_ID_SHIFT			6
+
+#define CMD_REQ0			0x180
+#define CMD_REQ_INCR			0x04
+
+#define CMD_Q_STATUS_BASE		0x210
+#define CMD_Q_INT_STATUS_BASE		0x214
+#define CMD_Q_STATUS_INCR		0x20
+
+#define CMD_Q_CACHE			0x228
+#define CMD_Q_CACHE_INC			0x20
+
+#define CMD_Q_ERROR(__qs)		((__qs) & 0x0000003f);
+#define CMD_Q_DEPTH(__qs)		(((__qs) >> 12) & 0x0000000f);
+
+/****** REQ0 Related Values ******/
+#define REQ0_WAIT_FOR_WRITE		0x00000004
+#define REQ0_INT_ON_COMPLETE		0x00000002
+#define REQ0_STOP_ON_COMPLETE		0x00000001
+
+#define REQ0_CMD_Q_SHIFT		9
+#define REQ0_JOBID_SHIFT		3
+
+/****** REQ1 Related Values ******/
+#define REQ1_PROTECT_SHIFT		27
+#define REQ1_ENGINE_SHIFT		23
+#define REQ1_KEY_KSB_SHIFT		2
+
+#define REQ1_EOM			0x00000002
+#define REQ1_INIT			0x00000001
+
+/* AES Related Values */
+#define REQ1_AES_TYPE_SHIFT		21
+#define REQ1_AES_MODE_SHIFT		18
+#define REQ1_AES_ACTION_SHIFT		17
+#define REQ1_AES_CFB_SIZE_SHIFT		10
+
+/* XTS-AES Related Values */
+#define REQ1_XTS_AES_SIZE_SHIFT		10
+
+/* SHA Related Values */
+#define REQ1_SHA_TYPE_SHIFT		21
+
+/* RSA Related Values */
+#define REQ1_RSA_MOD_SIZE_SHIFT		10
+
+/* Pass-Through Related Values */
+#define REQ1_PT_BW_SHIFT		12
+#define REQ1_PT_BS_SHIFT		10
+
+/* ECC Related Values */
+#define REQ1_ECC_AFFINE_CONVERT		0x00200000
+#define REQ1_ECC_FUNCTION_SHIFT		18
+
+/****** REQ4 Related Values ******/
+#define REQ4_KSB_SHIFT			18
+#define REQ4_MEMTYPE_SHIFT		16
+
+/****** REQ6 Related Values ******/
+#define REQ6_MEMTYPE_SHIFT		16
+
+
+/****** Key Storage Block ******/
+#define KSB_START			77
+#define KSB_END				127
+#define KSB_COUNT			(KSB_END - KSB_START + 1)
+#define CCP_KSB_BITS			256
+#define CCP_KSB_BYTES			32
+
+#define CCP_JOBID_MASK			0x0000003f
+
+#define CCP_DMAPOOL_MAX_SIZE		64
+#define CCP_DMAPOOL_ALIGN		(1 << 5)
+
+#define CCP_REVERSE_BUF_SIZE		64
+
+#define CCP_AES_KEY_KSB_COUNT		1
+#define CCP_AES_CTX_KSB_COUNT		1
+
+#define CCP_XTS_AES_KEY_KSB_COUNT	1
+#define CCP_XTS_AES_CTX_KSB_COUNT	1
+
+#define CCP_SHA_KSB_COUNT		1
+
+#define CCP_RSA_MAX_WIDTH		4096
+
+#define CCP_PASSTHRU_BLOCKSIZE		256
+#define CCP_PASSTHRU_MASKSIZE		32
+#define CCP_PASSTHRU_KSB_COUNT		1
+
+#define CCP_ECC_MODULUS_BYTES		48      /* 384-bits */
+#define CCP_ECC_MAX_OPERANDS		6
+#define CCP_ECC_MAX_OUTPUTS		3
+#define CCP_ECC_SRC_BUF_SIZE		448
+#define CCP_ECC_DST_BUF_SIZE		192
+#define CCP_ECC_OPERAND_SIZE		64
+#define CCP_ECC_OUTPUT_SIZE		64
+#define CCP_ECC_RESULT_OFFSET		60
+#define CCP_ECC_RESULT_SUCCESS		0x0001
+
+
+struct ccp_device;
+struct ccp_cmd;
+
+struct ccp_cmd_queue {
+	struct ccp_device *ccp;
+
+	/* Queue identifier */
+	u32 id;
+
+	/* Queue dma pool */
+	struct dma_pool *dma_pool;
+
+	/* Queue reserved KSB regions */
+	u32 ksb_key;
+	u32 ksb_ctx;
+
+	/* Queue processing thread */
+	struct task_struct *kthread;
+	unsigned int active;
+	unsigned int suspended;
+
+	/* Number of free command slots available */
+	unsigned int free_slots;
+
+	/* Interrupt masks */
+	u32 int_ok;
+	u32 int_err;
+
+	/* Register addresses for queue */
+	void __iomem *reg_status;
+	void __iomem *reg_int_status;
+
+	/* Status values from job */
+	u32 int_status;
+	u32 q_status;
+	u32 q_int_status;
+	u32 cmd_error;
+
+	/* Interrupt wait queue */
+	wait_queue_head_t int_queue;
+	unsigned int int_rcvd;
+} ____cacheline_aligned;
+
+struct ccp_device {
+	struct device *dev;
+
+	/*
+	 * Bus specific device information
+	 */
+	void *dev_specific;
+	int (*get_irq)(struct ccp_device *ccp);
+	void (*free_irq)(struct ccp_device *ccp);
+
+	/*
+	 * I/O area used for device communication. The register mapping
+	 * starts at an offset into the mapped bar.
+	 *   The CMD_REQx registers and the Delete_Cmd_Queue_Job register
+	 *   need to be protected while a command queue thread is accessing
+	 *   them.
+	 */
+	struct mutex req_mutex ____cacheline_aligned;
+	void __iomem *io_map;
+	void __iomem *io_regs;
+
+	/*
+	 * Master lists that all cmds are queued on. Because there can be
+	 * more than one CCP command queue that can process a cmd a separate
+	 * backlog list is neeeded so that the backlog completion call
+	 * completes before the cmd is available for execution.
+	 */
+	spinlock_t cmd_lock ____cacheline_aligned;
+	unsigned int cmd_count;
+	struct list_head cmd;
+	struct list_head backlog;
+
+	/*
+	 * The command queues. These represent the queues available on the
+	 * CCP that are available for processing cmds
+	 */
+	struct ccp_cmd_queue cmd_q[MAX_HW_QUEUES];
+	unsigned int cmd_q_count;
+
+	/*
+	 * Support for the CCP True RNG
+	 */
+	struct hwrng hwrng;
+	unsigned int hwrng_retries;
+
+	/*
+	 * A counter used to generate job-ids for cmds submitted to the CCP
+	 */
+	atomic_t current_id ____cacheline_aligned;
+
+	/*
+	 * The CCP uses key storage blocks (KSB) to maintain context for certain
+	 * operations. To prevent multiple cmds from using the same KSB range
+	 * a command queue reserves a KSB range for the duration of the cmd.
+	 * Each queue, will however, reserve 2 KSB blocks for operations that
+	 * only require single KSB entries (eg. AES context/iv and key) in order
+	 * to avoid allocation contention.  This will reserve at most 10 KSB
+	 * entries, leaving 40 KSB entries available for dynamic allocation.
+	 */
+	struct mutex ksb_mutex ____cacheline_aligned;
+	DECLARE_BITMAP(ksb, KSB_COUNT);
+	wait_queue_head_t ksb_queue;
+	unsigned int ksb_avail;
+	unsigned int ksb_count;
+	u32 ksb_start;
+
+	/* Suspend support */
+	unsigned int suspending;
+	wait_queue_head_t suspend_queue;
+};
+
+
+int ccp_pci_init(void);
+void ccp_pci_exit(void);
+
+struct ccp_device *ccp_alloc_struct(struct device *dev);
+int ccp_init(struct ccp_device *ccp);
+void ccp_destroy(struct ccp_device *ccp);
+bool ccp_queues_suspended(struct ccp_device *ccp);
+
+irqreturn_t ccp_irq_handler(int irq, void *data);
+
+int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd);
+
+#endif
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
new file mode 100644
index 0000000..4be0910
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -0,0 +1,2020 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/delay.h>
+#include <linux/ccp.h>
+#include <linux/scatterlist.h>
+#include <crypto/scatterwalk.h>
+
+#include "ccp-dev.h"
+
+
+enum ccp_memtype {
+	CCP_MEMTYPE_SYSTEM = 0,
+	CCP_MEMTYPE_KSB,
+	CCP_MEMTYPE_LOCAL,
+	CCP_MEMTYPE__LAST,
+};
+
+struct ccp_dma_info {
+	dma_addr_t address;
+	unsigned int offset;
+	unsigned int length;
+	enum dma_data_direction dir;
+};
+
+struct ccp_dm_workarea {
+	struct device *dev;
+	struct dma_pool *dma_pool;
+	unsigned int length;
+
+	u8 *address;
+	struct ccp_dma_info dma;
+};
+
+struct ccp_sg_workarea {
+	struct scatterlist *sg;
+	unsigned int nents;
+	unsigned int length;
+
+	struct scatterlist *dma_sg;
+	struct device *dma_dev;
+	unsigned int dma_count;
+	enum dma_data_direction dma_dir;
+
+	u32 sg_used;
+
+	u32 bytes_left;
+};
+
+struct ccp_data {
+	struct ccp_sg_workarea sg_wa;
+	struct ccp_dm_workarea dm_wa;
+};
+
+struct ccp_mem {
+	enum ccp_memtype type;
+	union {
+		struct ccp_dma_info dma;
+		u32 ksb;
+	} u;
+};
+
+struct ccp_aes_op {
+	enum ccp_aes_type type;
+	enum ccp_aes_mode mode;
+	enum ccp_aes_action action;
+};
+
+struct ccp_xts_aes_op {
+	enum ccp_aes_action action;
+	enum ccp_xts_aes_unit_size unit_size;
+};
+
+struct ccp_sha_op {
+	enum ccp_sha_type type;
+	u64 msg_bits;
+};
+
+struct ccp_rsa_op {
+	u32 mod_size;
+	u32 input_len;
+};
+
+struct ccp_passthru_op {
+	enum ccp_passthru_bitwise bit_mod;
+	enum ccp_passthru_byteswap byte_swap;
+};
+
+struct ccp_ecc_op {
+	enum ccp_ecc_function function;
+};
+
+struct ccp_op {
+	struct ccp_cmd_queue *cmd_q;
+
+	u32 jobid;
+	u32 ioc;
+	u32 soc;
+	u32 ksb_key;
+	u32 ksb_ctx;
+	u32 init;
+	u32 eom;
+
+	struct ccp_mem src;
+	struct ccp_mem dst;
+
+	union {
+		struct ccp_aes_op aes;
+		struct ccp_xts_aes_op xts;
+		struct ccp_sha_op sha;
+		struct ccp_rsa_op rsa;
+		struct ccp_passthru_op passthru;
+		struct ccp_ecc_op ecc;
+	} u;
+};
+
+/* The CCP cannot perform zero-length sha operations so the caller
+ * is required to buffer data for the final operation.  However, a
+ * sha operation for a message with a total length of zero is valid
+ * so known values are required to supply the result.
+ */
+static const u8 ccp_sha1_zero[CCP_SHA_CTXSIZE] = {
+	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
+	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
+	0xaf, 0xd8, 0x07, 0x09, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ccp_sha224_zero[CCP_SHA_CTXSIZE] = {
+	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9,
+	0x47, 0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4,
+	0x15, 0xa2, 0xb0, 0x1f, 0x82, 0x8e, 0xa6, 0x2a,
+	0xc5, 0xb3, 0xe4, 0x2f, 0x00, 0x00, 0x00, 0x00,
+};
+
+static const u8 ccp_sha256_zero[CCP_SHA_CTXSIZE] = {
+	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
+	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
+	0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
+	0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55,
+};
+
+static u32 ccp_addr_lo(struct ccp_dma_info *info)
+{
+	return lower_32_bits(info->address + info->offset);
+}
+
+static u32 ccp_addr_hi(struct ccp_dma_info *info)
+{
+	return upper_32_bits(info->address + info->offset) & 0x0000ffff;
+}
+
+static int ccp_do_cmd(struct ccp_op *op, u32 *cr, unsigned int cr_count)
+{
+	struct ccp_cmd_queue *cmd_q = op->cmd_q;
+	struct ccp_device *ccp = cmd_q->ccp;
+	void __iomem *cr_addr;
+	u32 cr0, cmd;
+	unsigned int i;
+	int ret = 0;
+
+	/* We could read a status register to see how many free slots
+	 * are actually available, but reading that register resets it
+	 * and you could lose some error information.
+	 */
+	cmd_q->free_slots--;
+
+	cr0 = (cmd_q->id << REQ0_CMD_Q_SHIFT)
+	      | (op->jobid << REQ0_JOBID_SHIFT)
+	      | REQ0_WAIT_FOR_WRITE;
+
+	if (op->soc)
+		cr0 |= REQ0_STOP_ON_COMPLETE
+		       | REQ0_INT_ON_COMPLETE;
+
+	if (op->ioc || !cmd_q->free_slots)
+		cr0 |= REQ0_INT_ON_COMPLETE;
+
+	/* Start at CMD_REQ1 */
+	cr_addr = ccp->io_regs + CMD_REQ0 + CMD_REQ_INCR;
+
+	mutex_lock(&ccp->req_mutex);
+
+	/* Write CMD_REQ1 through CMD_REQx first */
+	for (i = 0; i < cr_count; i++, cr_addr += CMD_REQ_INCR)
+		iowrite32(*(cr + i), cr_addr);
+
+	/* Tell the CCP to start */
+	wmb();
+	iowrite32(cr0, ccp->io_regs + CMD_REQ0);
+
+	mutex_unlock(&ccp->req_mutex);
+
+	if (cr0 & REQ0_INT_ON_COMPLETE) {
+		/* Wait for the job to complete */
+		ret = wait_event_interruptible(cmd_q->int_queue,
+					       cmd_q->int_rcvd);
+		if (ret || cmd_q->cmd_error) {
+			/* On error delete all related jobs from the queue */
+			cmd = (cmd_q->id << DEL_Q_ID_SHIFT)
+			      | op->jobid;
+
+			iowrite32(cmd, ccp->io_regs + DEL_CMD_Q_JOB);
+
+			if (!ret)
+				ret = -EIO;
+		} else if (op->soc) {
+			/* Delete just head job from the queue on SoC */
+			cmd = DEL_Q_ACTIVE
+			      | (cmd_q->id << DEL_Q_ID_SHIFT)
+			      | op->jobid;
+
+			iowrite32(cmd, ccp->io_regs + DEL_CMD_Q_JOB);
+		}
+
+		cmd_q->free_slots = CMD_Q_DEPTH(cmd_q->q_status);
+
+		cmd_q->int_rcvd = 0;
+	}
+
+	return ret;
+}
+
+static int ccp_perform_aes(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_AES << REQ1_ENGINE_SHIFT)
+		| (op->u.aes.type << REQ1_AES_TYPE_SHIFT)
+		| (op->u.aes.mode << REQ1_AES_MODE_SHIFT)
+		| (op->u.aes.action << REQ1_AES_ACTION_SHIFT)
+		| (op->ksb_key << REQ1_KEY_KSB_SHIFT);
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	if (op->u.aes.mode == CCP_AES_MODE_CFB)
+		cr[0] |= ((0x7f) << REQ1_AES_CFB_SIZE_SHIFT);
+
+	if (op->eom)
+		cr[0] |= REQ1_EOM;
+
+	if (op->init)
+		cr[0] |= REQ1_INIT;
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_xts_aes(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_XTS_AES_128 << REQ1_ENGINE_SHIFT)
+		| (op->u.xts.action << REQ1_AES_ACTION_SHIFT)
+		| (op->u.xts.unit_size << REQ1_XTS_AES_SIZE_SHIFT)
+		| (op->ksb_key << REQ1_KEY_KSB_SHIFT);
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	if (op->eom)
+		cr[0] |= REQ1_EOM;
+
+	if (op->init)
+		cr[0] |= REQ1_INIT;
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_sha(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_SHA << REQ1_ENGINE_SHIFT)
+		| (op->u.sha.type << REQ1_SHA_TYPE_SHIFT)
+		| REQ1_INIT;
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+
+	if (op->eom) {
+		cr[0] |= REQ1_EOM;
+		cr[4] = lower_32_bits(op->u.sha.msg_bits);
+		cr[5] = upper_32_bits(op->u.sha.msg_bits);
+	} else {
+		cr[4] = 0;
+		cr[5] = 0;
+	}
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_rsa(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_RSA << REQ1_ENGINE_SHIFT)
+		| (op->u.rsa.mod_size << REQ1_RSA_MOD_SIZE_SHIFT)
+		| (op->ksb_key << REQ1_KEY_KSB_SHIFT)
+		| REQ1_EOM;
+	cr[1] = op->u.rsa.input_len - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (op->ksb_ctx << REQ4_KSB_SHIFT)
+		| (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_passthru(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = (CCP_ENGINE_PASSTHRU << REQ1_ENGINE_SHIFT)
+		| (op->u.passthru.bit_mod << REQ1_PT_BW_SHIFT)
+		| (op->u.passthru.byte_swap << REQ1_PT_BS_SHIFT);
+
+	if (op->src.type == CCP_MEMTYPE_SYSTEM)
+		cr[1] = op->src.u.dma.length - 1;
+	else
+		cr[1] = op->dst.u.dma.length - 1;
+
+	if (op->src.type == CCP_MEMTYPE_SYSTEM) {
+		cr[2] = ccp_addr_lo(&op->src.u.dma);
+		cr[3] = (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+			| ccp_addr_hi(&op->src.u.dma);
+
+		if (op->u.passthru.bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
+			cr[3] |= (op->ksb_key << REQ4_KSB_SHIFT);
+	} else {
+		cr[2] = op->src.u.ksb * CCP_KSB_BYTES;
+		cr[3] = (CCP_MEMTYPE_KSB << REQ4_MEMTYPE_SHIFT);
+	}
+
+	if (op->dst.type == CCP_MEMTYPE_SYSTEM) {
+		cr[4] = ccp_addr_lo(&op->dst.u.dma);
+		cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+			| ccp_addr_hi(&op->dst.u.dma);
+	} else {
+		cr[4] = op->dst.u.ksb * CCP_KSB_BYTES;
+		cr[5] = (CCP_MEMTYPE_KSB << REQ6_MEMTYPE_SHIFT);
+	}
+
+	if (op->eom)
+		cr[0] |= REQ1_EOM;
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static int ccp_perform_ecc(struct ccp_op *op)
+{
+	u32 cr[6];
+
+	/* Fill out the register contents for REQ1 through REQ6 */
+	cr[0] = REQ1_ECC_AFFINE_CONVERT
+		| (CCP_ENGINE_ECC << REQ1_ENGINE_SHIFT)
+		| (op->u.ecc.function << REQ1_ECC_FUNCTION_SHIFT)
+		| REQ1_EOM;
+	cr[1] = op->src.u.dma.length - 1;
+	cr[2] = ccp_addr_lo(&op->src.u.dma);
+	cr[3] = (CCP_MEMTYPE_SYSTEM << REQ4_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->src.u.dma);
+	cr[4] = ccp_addr_lo(&op->dst.u.dma);
+	cr[5] = (CCP_MEMTYPE_SYSTEM << REQ6_MEMTYPE_SHIFT)
+		| ccp_addr_hi(&op->dst.u.dma);
+
+	return ccp_do_cmd(op, cr, ARRAY_SIZE(cr));
+}
+
+static u32 ccp_alloc_ksb(struct ccp_device *ccp, unsigned int count)
+{
+	int start;
+
+	for (;;) {
+		mutex_lock(&ccp->ksb_mutex);
+
+		start = (u32)bitmap_find_next_zero_area(ccp->ksb,
+							ccp->ksb_count,
+							ccp->ksb_start,
+							count, 0);
+		if (start <= ccp->ksb_count) {
+			bitmap_set(ccp->ksb, start, count);
+
+			mutex_unlock(&ccp->ksb_mutex);
+			break;
+		}
+
+		ccp->ksb_avail = 0;
+
+		mutex_unlock(&ccp->ksb_mutex);
+
+		/* Wait for KSB entries to become available */
+		if (wait_event_interruptible(ccp->ksb_queue, ccp->ksb_avail))
+			return 0;
+	}
+
+	return KSB_START + start;
+}
+
+static void ccp_free_ksb(struct ccp_device *ccp, unsigned int start,
+			 unsigned int count)
+{
+	if (!start)
+		return;
+
+	mutex_lock(&ccp->ksb_mutex);
+
+	bitmap_clear(ccp->ksb, start - KSB_START, count);
+
+	ccp->ksb_avail = 1;
+
+	mutex_unlock(&ccp->ksb_mutex);
+
+	wake_up_interruptible_all(&ccp->ksb_queue);
+}
+
+static u32 ccp_gen_jobid(struct ccp_device *ccp)
+{
+	return atomic_inc_return(&ccp->current_id) & CCP_JOBID_MASK;
+}
+
+static void ccp_sg_free(struct ccp_sg_workarea *wa)
+{
+	if (wa->dma_count)
+		dma_unmap_sg(wa->dma_dev, wa->dma_sg, wa->nents, wa->dma_dir);
+
+	wa->dma_count = 0;
+}
+
+static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
+				struct scatterlist *sg, unsigned int len,
+				enum dma_data_direction dma_dir)
+{
+	memset(wa, 0, sizeof(*wa));
+
+	wa->sg = sg;
+	if (!sg)
+		return 0;
+
+	wa->nents = sg_nents(sg);
+	wa->length = sg->length;
+	wa->bytes_left = len;
+	wa->sg_used = 0;
+
+	if (len == 0)
+		return 0;
+
+	if (dma_dir == DMA_NONE)
+		return 0;
+
+	wa->dma_sg = sg;
+	wa->dma_dev = dev;
+	wa->dma_dir = dma_dir;
+	wa->dma_count = dma_map_sg(dev, sg, wa->nents, dma_dir);
+	if (!wa->dma_count)
+		return -ENOMEM;
+
+
+	return 0;
+}
+
+static void ccp_update_sg_workarea(struct ccp_sg_workarea *wa, unsigned int len)
+{
+	unsigned int nbytes = min(len, wa->bytes_left);
+
+	if (!wa->sg)
+		return;
+
+	wa->sg_used += nbytes;
+	wa->bytes_left -= nbytes;
+	if (wa->sg_used == wa->sg->length) {
+		wa->sg = sg_next(wa->sg);
+		wa->sg_used = 0;
+	}
+}
+
+static void ccp_dm_free(struct ccp_dm_workarea *wa)
+{
+	if (wa->length <= CCP_DMAPOOL_MAX_SIZE) {
+		if (wa->address)
+			dma_pool_free(wa->dma_pool, wa->address,
+				      wa->dma.address);
+	} else {
+		if (wa->dma.address)
+			dma_unmap_single(wa->dev, wa->dma.address, wa->length,
+					 wa->dma.dir);
+		kfree(wa->address);
+	}
+
+	wa->address = NULL;
+	wa->dma.address = 0;
+}
+
+static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
+				struct ccp_cmd_queue *cmd_q,
+				unsigned int len,
+				enum dma_data_direction dir)
+{
+	memset(wa, 0, sizeof(*wa));
+
+	if (!len)
+		return 0;
+
+	wa->dev = cmd_q->ccp->dev;
+	wa->length = len;
+
+	if (len <= CCP_DMAPOOL_MAX_SIZE) {
+		wa->dma_pool = cmd_q->dma_pool;
+
+		wa->address = dma_pool_alloc(wa->dma_pool, GFP_KERNEL,
+					     &wa->dma.address);
+		if (!wa->address)
+			return -ENOMEM;
+
+		wa->dma.length = CCP_DMAPOOL_MAX_SIZE;
+
+		memset(wa->address, 0, CCP_DMAPOOL_MAX_SIZE);
+	} else {
+		wa->address = kzalloc(len, GFP_KERNEL);
+		if (!wa->address)
+			return -ENOMEM;
+
+		wa->dma.address = dma_map_single(wa->dev, wa->address, len,
+						 dir);
+		if (!wa->dma.address)
+			return -ENOMEM;
+
+		wa->dma.length = len;
+	}
+	wa->dma.dir = dir;
+
+	return 0;
+}
+
+static void ccp_set_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
+			    struct scatterlist *sg, unsigned int sg_offset,
+			    unsigned int len)
+{
+	WARN_ON(!wa->address);
+
+	scatterwalk_map_and_copy(wa->address + wa_offset, sg, sg_offset, len,
+				 0);
+}
+
+static void ccp_get_dm_area(struct ccp_dm_workarea *wa, unsigned int wa_offset,
+			    struct scatterlist *sg, unsigned int sg_offset,
+			    unsigned int len)
+{
+	WARN_ON(!wa->address);
+
+	scatterwalk_map_and_copy(wa->address + wa_offset, sg, sg_offset, len,
+				 1);
+}
+
+static void ccp_reverse_set_dm_area(struct ccp_dm_workarea *wa,
+				    struct scatterlist *sg,
+				    unsigned int len, unsigned int se_len,
+				    bool sign_extend)
+{
+	unsigned int nbytes, sg_offset, dm_offset, ksb_len, i;
+	u8 buffer[CCP_REVERSE_BUF_SIZE];
+
+	BUG_ON(se_len > sizeof(buffer));
+
+	sg_offset = len;
+	dm_offset = 0;
+	nbytes = len;
+	while (nbytes) {
+		ksb_len = min_t(unsigned int, nbytes, se_len);
+		sg_offset -= ksb_len;
+
+		scatterwalk_map_and_copy(buffer, sg, sg_offset, ksb_len, 0);
+		for (i = 0; i < ksb_len; i++)
+			wa->address[dm_offset + i] = buffer[ksb_len - i - 1];
+
+		dm_offset += ksb_len;
+		nbytes -= ksb_len;
+
+		if ((ksb_len != se_len) && sign_extend) {
+			/* Must sign-extend to nearest sign-extend length */
+			if (wa->address[dm_offset - 1] & 0x80)
+				memset(wa->address + dm_offset, 0xff,
+				       se_len - ksb_len);
+		}
+	}
+}
+
+static void ccp_reverse_get_dm_area(struct ccp_dm_workarea *wa,
+				    struct scatterlist *sg,
+				    unsigned int len)
+{
+	unsigned int nbytes, sg_offset, dm_offset, ksb_len, i;
+	u8 buffer[CCP_REVERSE_BUF_SIZE];
+
+	sg_offset = 0;
+	dm_offset = len;
+	nbytes = len;
+	while (nbytes) {
+		ksb_len = min_t(unsigned int, nbytes, sizeof(buffer));
+		dm_offset -= ksb_len;
+
+		for (i = 0; i < ksb_len; i++)
+			buffer[ksb_len - i - 1] = wa->address[dm_offset + i];
+		scatterwalk_map_and_copy(buffer, sg, sg_offset, ksb_len, 1);
+
+		sg_offset += ksb_len;
+		nbytes -= ksb_len;
+	}
+}
+
+static void ccp_free_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q)
+{
+	ccp_dm_free(&data->dm_wa);
+	ccp_sg_free(&data->sg_wa);
+}
+
+static int ccp_init_data(struct ccp_data *data, struct ccp_cmd_queue *cmd_q,
+			 struct scatterlist *sg, unsigned int sg_len,
+			 unsigned int dm_len,
+			 enum dma_data_direction dir)
+{
+	int ret;
+
+	memset(data, 0, sizeof(*data));
+
+	ret = ccp_init_sg_workarea(&data->sg_wa, cmd_q->ccp->dev, sg, sg_len,
+				   dir);
+	if (ret)
+		goto e_err;
+
+	ret = ccp_init_dm_workarea(&data->dm_wa, cmd_q, dm_len, dir);
+	if (ret)
+		goto e_err;
+
+	return 0;
+
+e_err:
+	ccp_free_data(data, cmd_q);
+
+	return ret;
+}
+
+static unsigned int ccp_queue_buf(struct ccp_data *data, unsigned int from)
+{
+	struct ccp_sg_workarea *sg_wa = &data->sg_wa;
+	struct ccp_dm_workarea *dm_wa = &data->dm_wa;
+	unsigned int buf_count, nbytes;
+
+	/* Clear the buffer if setting it */
+	if (!from)
+		memset(dm_wa->address, 0, dm_wa->length);
+
+	if (!sg_wa->sg)
+		return 0;
+
+	/* Perform the copy operation */
+	nbytes = min(sg_wa->bytes_left, dm_wa->length);
+	scatterwalk_map_and_copy(dm_wa->address, sg_wa->sg, sg_wa->sg_used,
+				 nbytes, from);
+
+	/* Update the structures and generate the count */
+	buf_count = 0;
+	while (sg_wa->bytes_left && (buf_count < dm_wa->length)) {
+		nbytes = min3(sg_wa->sg->length - sg_wa->sg_used,
+			      dm_wa->length - buf_count,
+			      sg_wa->bytes_left);
+
+		buf_count += nbytes;
+		ccp_update_sg_workarea(sg_wa, nbytes);
+	}
+
+	return buf_count;
+}
+
+static unsigned int ccp_fill_queue_buf(struct ccp_data *data)
+{
+	return ccp_queue_buf(data, 0);
+}
+
+static unsigned int ccp_empty_queue_buf(struct ccp_data *data)
+{
+	return ccp_queue_buf(data, 1);
+}
+
+static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
+			     struct ccp_op *op, unsigned int block_size,
+			     bool blocksize_op)
+{
+	unsigned int sg_src_len, sg_dst_len, op_len;
+
+	/* The CCP can only DMA from/to one address each per operation. This
+	 * requires that we find the smallest DMA area between the source
+	 * and destination.
+	 */
+	sg_src_len = min(sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used,
+			 src->sg_wa.bytes_left);
+
+	if (dst) {
+		sg_dst_len = min(sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used,
+				 src->sg_wa.bytes_left);
+		op_len = min(sg_src_len, sg_dst_len);
+	} else
+		op_len = sg_src_len;
+
+	/* The data operation length will be at least block_size in length
+	 * or the smaller of available sg room remaining for the source or
+	 * the destination
+	 */
+	op_len = max(op_len, block_size);
+
+	/* Unless we have to buffer data, there's no reason to wait */
+	op->soc = 0;
+
+	if (sg_src_len < block_size) {
+		/* Not enough data in the sg element, so it
+		 * needs to be buffered into a blocksize chunk
+		 */
+		int cp_len = ccp_fill_queue_buf(src);
+
+		op->soc = 1;
+		op->src.u.dma.address = src->dm_wa.dma.address;
+		op->src.u.dma.offset = 0;
+		op->src.u.dma.length = (blocksize_op) ? block_size : cp_len;
+	} else {
+		/* Enough data in the sg element, but we need to
+		 * adjust for any previously copied data
+		 */
+		op->src.u.dma.address = sg_dma_address(src->sg_wa.sg);
+		op->src.u.dma.offset = src->sg_wa.sg_used;
+		op->src.u.dma.length = op_len & ~(block_size - 1);
+
+		ccp_update_sg_workarea(&src->sg_wa, op->src.u.dma.length);
+	}
+
+	if (dst) {
+		if (sg_dst_len < block_size) {
+			/* Not enough room in the sg element or we're on the
+			 * last piece of data (when using padding), so the
+			 * output needs to be buffered into a blocksize chunk
+			 */
+			op->soc = 1;
+			op->dst.u.dma.address = dst->dm_wa.dma.address;
+			op->dst.u.dma.offset = 0;
+			op->dst.u.dma.length = op->src.u.dma.length;
+		} else {
+			/* Enough room in the sg element, but we need to
+			 * adjust for any previously used area
+			 */
+			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.sg);
+			op->dst.u.dma.offset = dst->sg_wa.sg_used;
+			op->dst.u.dma.length = op->src.u.dma.length;
+		}
+	}
+}
+
+static void ccp_process_data(struct ccp_data *src, struct ccp_data *dst,
+			     struct ccp_op *op)
+{
+	op->init = 0;
+
+	if (dst) {
+		if (op->dst.u.dma.address == dst->dm_wa.dma.address)
+			ccp_empty_queue_buf(dst);
+		else
+			ccp_update_sg_workarea(&dst->sg_wa,
+					       op->dst.u.dma.length);
+	}
+}
+
+static int ccp_copy_to_from_ksb(struct ccp_cmd_queue *cmd_q,
+				struct ccp_dm_workarea *wa, u32 jobid, u32 ksb,
+				u32 byte_swap, bool from)
+{
+	struct ccp_op op;
+
+	memset(&op, 0, sizeof(op));
+
+	op.cmd_q = cmd_q;
+	op.jobid = jobid;
+	op.eom = 1;
+
+	if (from) {
+		op.soc = 1;
+		op.src.type = CCP_MEMTYPE_KSB;
+		op.src.u.ksb = ksb;
+		op.dst.type = CCP_MEMTYPE_SYSTEM;
+		op.dst.u.dma.address = wa->dma.address;
+		op.dst.u.dma.length = wa->length;
+	} else {
+		op.src.type = CCP_MEMTYPE_SYSTEM;
+		op.src.u.dma.address = wa->dma.address;
+		op.src.u.dma.length = wa->length;
+		op.dst.type = CCP_MEMTYPE_KSB;
+		op.dst.u.ksb = ksb;
+	}
+
+	op.u.passthru.byte_swap = byte_swap;
+
+	return ccp_perform_passthru(&op);
+}
+
+static int ccp_copy_to_ksb(struct ccp_cmd_queue *cmd_q,
+			   struct ccp_dm_workarea *wa, u32 jobid, u32 ksb,
+			   u32 byte_swap)
+{
+	return ccp_copy_to_from_ksb(cmd_q, wa, jobid, ksb, byte_swap, false);
+}
+
+static int ccp_copy_from_ksb(struct ccp_cmd_queue *cmd_q,
+			     struct ccp_dm_workarea *wa, u32 jobid, u32 ksb,
+			     u32 byte_swap)
+{
+	return ccp_copy_to_from_ksb(cmd_q, wa, jobid, ksb, byte_swap, true);
+}
+
+static int ccp_run_aes_cmac_cmd(struct ccp_cmd_queue *cmd_q,
+				struct ccp_cmd *cmd)
+{
+	struct ccp_aes_engine *aes = &cmd->u.aes;
+	struct ccp_dm_workarea key, ctx;
+	struct ccp_data src;
+	struct ccp_op op;
+	unsigned int dm_offset;
+	int ret;
+
+	if (!((aes->key_len == AES_KEYSIZE_128) ||
+	      (aes->key_len == AES_KEYSIZE_192) ||
+	      (aes->key_len == AES_KEYSIZE_256)))
+		return -EINVAL;
+
+	if (aes->src_len & (AES_BLOCK_SIZE - 1))
+		return -EINVAL;
+
+	if (aes->iv_len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (!aes->key || !aes->iv || !aes->src)
+		return -EINVAL;
+
+	if (aes->cmac_final) {
+		if (aes->cmac_key_len != AES_BLOCK_SIZE)
+			return -EINVAL;
+
+		if (!aes->cmac_key)
+			return -EINVAL;
+	}
+
+	BUILD_BUG_ON(CCP_AES_KEY_KSB_COUNT != 1);
+	BUILD_BUG_ON(CCP_AES_CTX_KSB_COUNT != 1);
+
+	ret = -EIO;
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.ksb_key = cmd_q->ksb_key;
+	op.ksb_ctx = cmd_q->ksb_ctx;
+	op.init = 1;
+	op.u.aes.type = aes->type;
+	op.u.aes.mode = aes->mode;
+	op.u.aes.action = aes->action;
+
+	/* All supported key sizes fit in a single (32-byte) KSB entry
+	 * and must be in little endian format. Use the 256-bit byte
+	 * swap passthru option to convert from big endian to little
+	 * endian.
+	 */
+	ret = ccp_init_dm_workarea(&key, cmd_q,
+				   CCP_AES_KEY_KSB_COUNT * CCP_KSB_BYTES,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	dm_offset = CCP_KSB_BYTES - aes->key_len;
+	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_copy_to_ksb(cmd_q, &key, op.jobid, op.ksb_key,
+			      CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_key;
+	}
+
+	/* The AES context fits in a single (32-byte) KSB entry and
+	 * must be in little endian format. Use the 256-bit byte swap
+	 * passthru option to convert from big endian to little endian.
+	 */
+	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+				   CCP_AES_CTX_KSB_COUNT * CCP_KSB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_key;
+
+	dm_offset = CCP_KSB_BYTES - AES_BLOCK_SIZE;
+	ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	ret = ccp_copy_to_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+			      CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_ctx;
+	}
+
+	/* Send data to the CCP AES engine */
+	ret = ccp_init_data(&src, cmd_q, aes->src, aes->src_len,
+			    AES_BLOCK_SIZE, DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, NULL, &op, AES_BLOCK_SIZE, true);
+		if (aes->cmac_final && !src.sg_wa.bytes_left) {
+			op.eom = 1;
+
+			/* Push the K1/K2 key to the CCP now */
+			ret = ccp_copy_from_ksb(cmd_q, &ctx, op.jobid,
+						op.ksb_ctx,
+						CCP_PASSTHRU_BYTESWAP_256BIT);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_src;
+			}
+
+			ccp_set_dm_area(&ctx, 0, aes->cmac_key, 0,
+					aes->cmac_key_len);
+			ret = ccp_copy_to_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+					      CCP_PASSTHRU_BYTESWAP_256BIT);
+			if (ret) {
+				cmd->engine_error = cmd_q->cmd_error;
+				goto e_src;
+			}
+		}
+
+		ret = ccp_perform_aes(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_src;
+		}
+
+		ccp_process_data(&src, NULL, &op);
+	}
+
+	/* Retrieve the AES context - convert from LE to BE using
+	 * 32-byte (256-bit) byteswapping
+	 */
+	ret = ccp_copy_from_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+				CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_src;
+	}
+
+	/* ...but we only need AES_BLOCK_SIZE bytes */
+	dm_offset = CCP_KSB_BYTES - AES_BLOCK_SIZE;
+	ccp_get_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+e_key:
+	ccp_dm_free(&key);
+
+	return ret;
+}
+
+static int ccp_run_aes_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_aes_engine *aes = &cmd->u.aes;
+	struct ccp_dm_workarea key, ctx;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	unsigned int dm_offset;
+	bool in_place = false;
+	int ret;
+
+	if (aes->mode == CCP_AES_MODE_CMAC)
+		return ccp_run_aes_cmac_cmd(cmd_q, cmd);
+
+	if (!((aes->key_len == AES_KEYSIZE_128) ||
+	      (aes->key_len == AES_KEYSIZE_192) ||
+	      (aes->key_len == AES_KEYSIZE_256)))
+		return -EINVAL;
+
+	if (((aes->mode == CCP_AES_MODE_ECB) ||
+	     (aes->mode == CCP_AES_MODE_CBC) ||
+	     (aes->mode == CCP_AES_MODE_CFB)) &&
+	    (aes->src_len & (AES_BLOCK_SIZE - 1)))
+		return -EINVAL;
+
+	if (!aes->key || !aes->src || !aes->dst)
+		return -EINVAL;
+
+	if (aes->mode != CCP_AES_MODE_ECB) {
+		if (aes->iv_len != AES_BLOCK_SIZE)
+			return -EINVAL;
+
+		if (!aes->iv)
+			return -EINVAL;
+	}
+
+	BUILD_BUG_ON(CCP_AES_KEY_KSB_COUNT != 1);
+	BUILD_BUG_ON(CCP_AES_CTX_KSB_COUNT != 1);
+
+	ret = -EIO;
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.ksb_key = cmd_q->ksb_key;
+	op.ksb_ctx = cmd_q->ksb_ctx;
+	op.init = (aes->mode == CCP_AES_MODE_ECB) ? 0 : 1;
+	op.u.aes.type = aes->type;
+	op.u.aes.mode = aes->mode;
+	op.u.aes.action = aes->action;
+
+	/* All supported key sizes fit in a single (32-byte) KSB entry
+	 * and must be in little endian format. Use the 256-bit byte
+	 * swap passthru option to convert from big endian to little
+	 * endian.
+	 */
+	ret = ccp_init_dm_workarea(&key, cmd_q,
+				   CCP_AES_KEY_KSB_COUNT * CCP_KSB_BYTES,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	dm_offset = CCP_KSB_BYTES - aes->key_len;
+	ccp_set_dm_area(&key, dm_offset, aes->key, 0, aes->key_len);
+	ret = ccp_copy_to_ksb(cmd_q, &key, op.jobid, op.ksb_key,
+			      CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_key;
+	}
+
+	/* The AES context fits in a single (32-byte) KSB entry and
+	 * must be in little endian format. Use the 256-bit byte swap
+	 * passthru option to convert from big endian to little endian.
+	 */
+	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+				   CCP_AES_CTX_KSB_COUNT * CCP_KSB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_key;
+
+	if (aes->mode != CCP_AES_MODE_ECB) {
+		/* Load the AES context - conver to LE */
+		dm_offset = CCP_KSB_BYTES - AES_BLOCK_SIZE;
+		ccp_set_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+		ret = ccp_copy_to_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+				      CCP_PASSTHRU_BYTESWAP_256BIT);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_ctx;
+		}
+	}
+
+	/* Prepare the input and output data workareas. For in-place
+	 * operations we need to set the dma direction to BIDIRECTIONAL
+	 * and copy the src workarea to the dst workarea.
+	 */
+	if (sg_virt(aes->src) == sg_virt(aes->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, aes->src, aes->src_len,
+			    AES_BLOCK_SIZE,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	if (in_place)
+		dst = src;
+	else {
+		ret = ccp_init_data(&dst, cmd_q, aes->dst, aes->src_len,
+				    AES_BLOCK_SIZE, DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* Send data to the CCP AES engine */
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, &dst, &op, AES_BLOCK_SIZE, true);
+		if (!src.sg_wa.bytes_left) {
+			op.eom = 1;
+
+			/* Since we don't retrieve the AES context in ECB
+			 * mode we have to wait for the operation to complete
+			 * on the last piece of data
+			 */
+			if (aes->mode == CCP_AES_MODE_ECB)
+				op.soc = 1;
+		}
+
+		ret = ccp_perform_aes(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		ccp_process_data(&src, &dst, &op);
+	}
+
+	if (aes->mode != CCP_AES_MODE_ECB) {
+		/* Retrieve the AES context - convert from LE to BE using
+		 * 32-byte (256-bit) byteswapping
+		 */
+		ret = ccp_copy_from_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+					CCP_PASSTHRU_BYTESWAP_256BIT);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		/* ...but we only need AES_BLOCK_SIZE bytes */
+		dm_offset = CCP_KSB_BYTES - AES_BLOCK_SIZE;
+		ccp_get_dm_area(&ctx, dm_offset, aes->iv, 0, aes->iv_len);
+	}
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+e_key:
+	ccp_dm_free(&key);
+
+	return ret;
+}
+
+static int ccp_run_xts_aes_cmd(struct ccp_cmd_queue *cmd_q,
+			       struct ccp_cmd *cmd)
+{
+	struct ccp_xts_aes_engine *xts = &cmd->u.xts;
+	struct ccp_dm_workarea key, ctx;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	unsigned int unit_size, dm_offset;
+	bool in_place = false;
+	int ret;
+
+	switch (xts->unit_size) {
+	case CCP_XTS_AES_UNIT_SIZE_16:
+		unit_size = 16;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_512:
+		unit_size = 512;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_1024:
+		unit_size = 1024;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_2048:
+		unit_size = 2048;
+		break;
+	case CCP_XTS_AES_UNIT_SIZE_4096:
+		unit_size = 4096;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	if (xts->key_len != AES_KEYSIZE_128)
+		return -EINVAL;
+
+	if (!xts->final && (xts->src_len & (AES_BLOCK_SIZE - 1)))
+		return -EINVAL;
+
+	if (xts->iv_len != AES_BLOCK_SIZE)
+		return -EINVAL;
+
+	if (!xts->key || !xts->iv || !xts->src || !xts->dst)
+		return -EINVAL;
+
+	BUILD_BUG_ON(CCP_XTS_AES_KEY_KSB_COUNT != 1);
+	BUILD_BUG_ON(CCP_XTS_AES_CTX_KSB_COUNT != 1);
+
+	ret = -EIO;
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.ksb_key = cmd_q->ksb_key;
+	op.ksb_ctx = cmd_q->ksb_ctx;
+	op.init = 1;
+	op.u.xts.action = xts->action;
+	op.u.xts.unit_size = xts->unit_size;
+
+	/* All supported key sizes fit in a single (32-byte) KSB entry
+	 * and must be in little endian format. Use the 256-bit byte
+	 * swap passthru option to convert from big endian to little
+	 * endian.
+	 */
+	ret = ccp_init_dm_workarea(&key, cmd_q,
+				   CCP_XTS_AES_KEY_KSB_COUNT * CCP_KSB_BYTES,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	dm_offset = CCP_KSB_BYTES - AES_KEYSIZE_128;
+	ccp_set_dm_area(&key, dm_offset, xts->key, 0, xts->key_len);
+	ccp_set_dm_area(&key, 0, xts->key, dm_offset, xts->key_len);
+	ret = ccp_copy_to_ksb(cmd_q, &key, op.jobid, op.ksb_key,
+			      CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_key;
+	}
+
+	/* The AES context fits in a single (32-byte) KSB entry and
+	 * for XTS is already in little endian format so no byte swapping
+	 * is needed.
+	 */
+	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+				   CCP_XTS_AES_CTX_KSB_COUNT * CCP_KSB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		goto e_key;
+
+	ccp_set_dm_area(&ctx, 0, xts->iv, 0, xts->iv_len);
+	ret = ccp_copy_to_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+			      CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_ctx;
+	}
+
+	/* Prepare the input and output data workareas. For in-place
+	 * operations we need to set the dma direction to BIDIRECTIONAL
+	 * and copy the src workarea to the dst workarea.
+	 */
+	if (sg_virt(xts->src) == sg_virt(xts->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, xts->src, xts->src_len,
+			    unit_size,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	if (in_place)
+		dst = src;
+	else {
+		ret = ccp_init_data(&dst, cmd_q, xts->dst, xts->src_len,
+				    unit_size, DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* Send data to the CCP AES engine */
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, &dst, &op, unit_size, true);
+		if (!src.sg_wa.bytes_left)
+			op.eom = 1;
+
+		ret = ccp_perform_xts_aes(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		ccp_process_data(&src, &dst, &op);
+	}
+
+	/* Retrieve the AES context - convert from LE to BE using
+	 * 32-byte (256-bit) byteswapping
+	 */
+	ret = ccp_copy_from_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+				CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	/* ...but we only need AES_BLOCK_SIZE bytes */
+	dm_offset = CCP_KSB_BYTES - AES_BLOCK_SIZE;
+	ccp_get_dm_area(&ctx, dm_offset, xts->iv, 0, xts->iv_len);
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+e_key:
+	ccp_dm_free(&key);
+
+	return ret;
+}
+
+static int ccp_run_sha_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_sha_engine *sha = &cmd->u.sha;
+	struct ccp_dm_workarea ctx;
+	struct ccp_data src;
+	struct ccp_op op;
+	int ret;
+
+	if (sha->ctx_len != CCP_SHA_CTXSIZE)
+		return -EINVAL;
+
+	if (!sha->ctx)
+		return -EINVAL;
+
+	if (!sha->final && (sha->src_len & (CCP_SHA_BLOCKSIZE - 1)))
+		return -EINVAL;
+
+	if (!sha->src_len) {
+		const u8 *sha_zero;
+
+		/* Not final, just return */
+		if (!sha->final)
+			return 0;
+
+		/* CCP can't do a zero length sha operation so the caller
+		 * must buffer the data.
+		 */
+		if (sha->msg_bits)
+			return -EINVAL;
+
+		/* A sha operation for a message with a total length of zero,
+		 * return known result.
+		 */
+		switch (sha->type) {
+		case CCP_SHA_TYPE_1:
+			sha_zero = ccp_sha1_zero;
+			break;
+		case CCP_SHA_TYPE_224:
+			sha_zero = ccp_sha224_zero;
+			break;
+		case CCP_SHA_TYPE_256:
+			sha_zero = ccp_sha256_zero;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		scatterwalk_map_and_copy((void *)sha_zero, sha->ctx, 0,
+					 sha->ctx_len, 1);
+
+		return 0;
+	}
+
+	if (!sha->src)
+		return -EINVAL;
+
+	BUILD_BUG_ON(CCP_SHA_KSB_COUNT != 1);
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.ksb_ctx = cmd_q->ksb_ctx;
+	op.u.sha.type = sha->type;
+	op.u.sha.msg_bits = sha->msg_bits;
+
+	/* The SHA context fits in a single (32-byte) KSB entry and
+	 * must be in little endian format. Use the 256-bit byte swap
+	 * passthru option to convert from big endian to little endian.
+	 */
+	ret = ccp_init_dm_workarea(&ctx, cmd_q,
+				   CCP_SHA_KSB_COUNT * CCP_KSB_BYTES,
+				   DMA_BIDIRECTIONAL);
+	if (ret)
+		return ret;
+
+	ccp_set_dm_area(&ctx, 0, sha->ctx, 0, sha->ctx_len);
+	ret = ccp_copy_to_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+			      CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_ctx;
+	}
+
+	/* Send data to the CCP SHA engine */
+	ret = ccp_init_data(&src, cmd_q, sha->src, sha->src_len,
+			    CCP_SHA_BLOCKSIZE, DMA_TO_DEVICE);
+	if (ret)
+		goto e_ctx;
+
+	while (src.sg_wa.bytes_left) {
+		ccp_prepare_data(&src, NULL, &op, CCP_SHA_BLOCKSIZE, false);
+		if (sha->final && !src.sg_wa.bytes_left)
+			op.eom = 1;
+
+		ret = ccp_perform_sha(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_data;
+		}
+
+		ccp_process_data(&src, NULL, &op);
+	}
+
+	/* Retrieve the SHA context - convert from LE to BE using
+	 * 32-byte (256-bit) byteswapping to BE
+	 */
+	ret = ccp_copy_from_ksb(cmd_q, &ctx, op.jobid, op.ksb_ctx,
+				CCP_PASSTHRU_BYTESWAP_256BIT);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_data;
+	}
+
+	ccp_get_dm_area(&ctx, 0, sha->ctx, 0, sha->ctx_len);
+
+e_data:
+	ccp_free_data(&src, cmd_q);
+
+e_ctx:
+	ccp_dm_free(&ctx);
+
+	return ret;
+}
+
+static int ccp_run_rsa_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_rsa_engine *rsa = &cmd->u.rsa;
+	struct ccp_dm_workarea exp, src;
+	struct ccp_data dst;
+	struct ccp_op op;
+	unsigned int ksb_count, i_len, o_len;
+	int ret;
+
+	if (rsa->key_size > CCP_RSA_MAX_WIDTH)
+		return -EINVAL;
+
+	if (!rsa->exp || !rsa->mod || !rsa->src || !rsa->dst)
+		return -EINVAL;
+
+	/* The RSA modulus must precede the message being acted upon, so
+	 * it must be copied to a DMA area where the message and the
+	 * modulus can be concatenated.  Therefore the input buffer
+	 * length required is twice the output buffer length (which
+	 * must be a multiple of 256-bits).
+	 */
+	o_len = ((rsa->key_size + 255) / 256) * 32;
+	i_len = o_len * 2;
+
+	ksb_count = o_len / CCP_KSB_BYTES;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+	op.ksb_key = ccp_alloc_ksb(cmd_q->ccp, ksb_count);
+	if (!op.ksb_key)
+		return -EIO;
+
+	/* The RSA exponent may span multiple (32-byte) KSB entries and must
+	 * be in little endian format. Reverse copy each 32-byte chunk
+	 * of the exponent (En chunk to E0 chunk, E(n-1) chunk to E1 chunk)
+	 * and each byte within that chunk and do not perform any byte swap
+	 * operations on the passthru operation.
+	 */
+	ret = ccp_init_dm_workarea(&exp, cmd_q, o_len, DMA_TO_DEVICE);
+	if (ret)
+		goto e_ksb;
+
+	ccp_reverse_set_dm_area(&exp, rsa->exp, rsa->exp_len, CCP_KSB_BYTES,
+				true);
+	ret = ccp_copy_to_ksb(cmd_q, &exp, op.jobid, op.ksb_key,
+			      CCP_PASSTHRU_BYTESWAP_NOOP);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_exp;
+	}
+
+	/* Concatenate the modulus and the message. Both the modulus and
+	 * the operands must be in little endian format.  Since the input
+	 * is in big endian format it must be converted.
+	 */
+	ret = ccp_init_dm_workarea(&src, cmd_q, i_len, DMA_TO_DEVICE);
+	if (ret)
+		goto e_exp;
+
+	ccp_reverse_set_dm_area(&src, rsa->mod, rsa->mod_len, CCP_KSB_BYTES,
+				true);
+	src.address += o_len;	/* Adjust the address for the copy operation */
+	ccp_reverse_set_dm_area(&src, rsa->src, rsa->src_len, CCP_KSB_BYTES,
+				true);
+	src.address -= o_len;	/* Reset the address to original value */
+
+	/* Prepare the output area for the operation */
+	ret = ccp_init_data(&dst, cmd_q, rsa->dst, rsa->mod_len,
+			    o_len, DMA_FROM_DEVICE);
+	if (ret)
+		goto e_src;
+
+	op.soc = 1;
+	op.src.u.dma.address = src.dma.address;
+	op.src.u.dma.offset = 0;
+	op.src.u.dma.length = i_len;
+	op.dst.u.dma.address = dst.dm_wa.dma.address;
+	op.dst.u.dma.offset = 0;
+	op.dst.u.dma.length = o_len;
+
+	op.u.rsa.mod_size = rsa->key_size;
+	op.u.rsa.input_len = i_len;
+
+	ret = ccp_perform_rsa(&op);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	ccp_reverse_get_dm_area(&dst.dm_wa, rsa->dst, rsa->mod_len);
+
+e_dst:
+	ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_dm_free(&src);
+
+e_exp:
+	ccp_dm_free(&exp);
+
+e_ksb:
+	ccp_free_ksb(cmd_q->ccp, op.ksb_key, ksb_count);
+
+	return ret;
+}
+
+static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
+				struct ccp_cmd *cmd)
+{
+	struct ccp_passthru_engine *pt = &cmd->u.passthru;
+	struct ccp_dm_workarea mask;
+	struct ccp_data src, dst;
+	struct ccp_op op;
+	bool in_place = false;
+	unsigned int i;
+	int ret;
+
+	if (!pt->final && (pt->src_len & (CCP_PASSTHRU_BLOCKSIZE - 1)))
+		return -EINVAL;
+
+	if (!pt->src || !pt->dst)
+		return -EINVAL;
+
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
+		if (pt->mask_len != CCP_PASSTHRU_MASKSIZE)
+			return -EINVAL;
+		if (!pt->mask)
+			return -EINVAL;
+	}
+
+	BUILD_BUG_ON(CCP_PASSTHRU_KSB_COUNT != 1);
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP) {
+		/* Load the mask */
+		op.ksb_key = cmd_q->ksb_key;
+
+		ret = ccp_init_dm_workarea(&mask, cmd_q,
+					   CCP_PASSTHRU_KSB_COUNT *
+					   CCP_KSB_BYTES,
+					   DMA_TO_DEVICE);
+		if (ret)
+			return ret;
+
+		ccp_set_dm_area(&mask, 0, pt->mask, 0, pt->mask_len);
+		ret = ccp_copy_to_ksb(cmd_q, &mask, op.jobid, op.ksb_key,
+				      CCP_PASSTHRU_BYTESWAP_NOOP);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_mask;
+		}
+	}
+
+	/* Prepare the input and output data workareas. For in-place
+	 * operations we need to set the dma direction to BIDIRECTIONAL
+	 * and copy the src workarea to the dst workarea.
+	 */
+	if (sg_virt(pt->src) == sg_virt(pt->dst))
+		in_place = true;
+
+	ret = ccp_init_data(&src, cmd_q, pt->src, pt->src_len,
+			    CCP_PASSTHRU_MASKSIZE,
+			    in_place ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	if (ret)
+		goto e_mask;
+
+	if (in_place)
+		dst = src;
+	else {
+		ret = ccp_init_data(&dst, cmd_q, pt->dst, pt->src_len,
+				    CCP_PASSTHRU_MASKSIZE, DMA_FROM_DEVICE);
+		if (ret)
+			goto e_src;
+	}
+
+	/* Send data to the CCP Passthru engine
+	 *   Because the CCP engine works on a single source and destination
+	 *   dma address at a time, each entry in the source scatterlist
+	 *   (after the dma_map_sg call) must be less than or equal to the
+	 *   (remaining) length in the destination scatterlist entry and the
+	 *   length must be a multiple of CCP_PASSTHRU_BLOCKSIZE
+	 */
+	dst.sg_wa.sg_used = 0;
+	for (i = 1; i <= src.sg_wa.dma_count; i++) {
+		if (!dst.sg_wa.sg ||
+		    (dst.sg_wa.sg->length < src.sg_wa.sg->length)) {
+			ret = -EINVAL;
+			goto e_dst;
+		}
+
+		if (i == src.sg_wa.dma_count) {
+			op.eom = 1;
+			op.soc = 1;
+		}
+
+		op.src.type = CCP_MEMTYPE_SYSTEM;
+		op.src.u.dma.address = sg_dma_address(src.sg_wa.sg);
+		op.src.u.dma.offset = 0;
+		op.src.u.dma.length = sg_dma_len(src.sg_wa.sg);
+
+		op.dst.type = CCP_MEMTYPE_SYSTEM;
+		op.dst.u.dma.address = sg_dma_address(dst.sg_wa.sg);
+		op.src.u.dma.offset = dst.sg_wa.sg_used;
+		op.src.u.dma.length = op.src.u.dma.length;
+
+		ret = ccp_perform_passthru(&op);
+		if (ret) {
+			cmd->engine_error = cmd_q->cmd_error;
+			goto e_dst;
+		}
+
+		dst.sg_wa.sg_used += src.sg_wa.sg->length;
+		if (dst.sg_wa.sg_used == dst.sg_wa.sg->length) {
+			dst.sg_wa.sg = sg_next(dst.sg_wa.sg);
+			dst.sg_wa.sg_used = 0;
+		}
+		src.sg_wa.sg = sg_next(src.sg_wa.sg);
+	}
+
+e_dst:
+	if (!in_place)
+		ccp_free_data(&dst, cmd_q);
+
+e_src:
+	ccp_free_data(&src, cmd_q);
+
+e_mask:
+	if (pt->bit_mod != CCP_PASSTHRU_BITWISE_NOOP)
+		ccp_dm_free(&mask);
+
+	return ret;
+}
+
+static int ccp_run_ecc_mm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
+	struct ccp_dm_workarea src, dst;
+	struct ccp_op op;
+	int ret;
+	u8 *save;
+
+	if (!ecc->u.mm.operand_1 ||
+	    (ecc->u.mm.operand_1_len > CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT)
+		if (!ecc->u.mm.operand_2 ||
+		    (ecc->u.mm.operand_2_len > CCP_ECC_MODULUS_BYTES))
+			return -EINVAL;
+
+	if (!ecc->u.mm.result ||
+	    (ecc->u.mm.result_len < CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+
+	/* Concatenate the modulus and the operands. Both the modulus and
+	 * the operands must be in little endian format.  Since the input
+	 * is in big endian format it must be converted and placed in a
+	 * fixed length buffer.
+	 */
+	ret = ccp_init_dm_workarea(&src, cmd_q, CCP_ECC_SRC_BUF_SIZE,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	/* Save the workarea address since it is updated in order to perform
+	 * the concatenation
+	 */
+	save = src.address;
+
+	/* Copy the ECC modulus */
+	ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
+				CCP_ECC_OPERAND_SIZE, true);
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	/* Copy the first operand */
+	ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_1,
+				ecc->u.mm.operand_1_len,
+				CCP_ECC_OPERAND_SIZE, true);
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	if (ecc->function != CCP_ECC_FUNCTION_MINV_384BIT) {
+		/* Copy the second operand */
+		ccp_reverse_set_dm_area(&src, ecc->u.mm.operand_2,
+					ecc->u.mm.operand_2_len,
+					CCP_ECC_OPERAND_SIZE, true);
+		src.address += CCP_ECC_OPERAND_SIZE;
+	}
+
+	/* Restore the workarea address */
+	src.address = save;
+
+	/* Prepare the output area for the operation */
+	ret = ccp_init_dm_workarea(&dst, cmd_q, CCP_ECC_DST_BUF_SIZE,
+				   DMA_FROM_DEVICE);
+	if (ret)
+		goto e_src;
+
+	op.soc = 1;
+	op.src.u.dma.address = src.dma.address;
+	op.src.u.dma.offset = 0;
+	op.src.u.dma.length = src.length;
+	op.dst.u.dma.address = dst.dma.address;
+	op.dst.u.dma.offset = 0;
+	op.dst.u.dma.length = dst.length;
+
+	op.u.ecc.function = cmd->u.ecc.function;
+
+	ret = ccp_perform_ecc(&op);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	ecc->ecc_result = le16_to_cpup(
+		(const __le16 *)(dst.address + CCP_ECC_RESULT_OFFSET));
+	if (!(ecc->ecc_result & CCP_ECC_RESULT_SUCCESS)) {
+		ret = -EIO;
+		goto e_dst;
+	}
+
+	/* Save the ECC result */
+	ccp_reverse_get_dm_area(&dst, ecc->u.mm.result, CCP_ECC_MODULUS_BYTES);
+
+e_dst:
+	ccp_dm_free(&dst);
+
+e_src:
+	ccp_dm_free(&src);
+
+	return ret;
+}
+
+static int ccp_run_ecc_pm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
+	struct ccp_dm_workarea src, dst;
+	struct ccp_op op;
+	int ret;
+	u8 *save;
+
+	if (!ecc->u.pm.point_1.x ||
+	    (ecc->u.pm.point_1.x_len > CCP_ECC_MODULUS_BYTES) ||
+	    !ecc->u.pm.point_1.y ||
+	    (ecc->u.pm.point_1.y_len > CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
+		if (!ecc->u.pm.point_2.x ||
+		    (ecc->u.pm.point_2.x_len > CCP_ECC_MODULUS_BYTES) ||
+		    !ecc->u.pm.point_2.y ||
+		    (ecc->u.pm.point_2.y_len > CCP_ECC_MODULUS_BYTES))
+			return -EINVAL;
+	} else {
+		if (!ecc->u.pm.domain_a ||
+		    (ecc->u.pm.domain_a_len > CCP_ECC_MODULUS_BYTES))
+			return -EINVAL;
+
+		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT)
+			if (!ecc->u.pm.scalar ||
+			    (ecc->u.pm.scalar_len > CCP_ECC_MODULUS_BYTES))
+				return -EINVAL;
+	}
+
+	if (!ecc->u.pm.result.x ||
+	    (ecc->u.pm.result.x_len < CCP_ECC_MODULUS_BYTES) ||
+	    !ecc->u.pm.result.y ||
+	    (ecc->u.pm.result.y_len < CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	memset(&op, 0, sizeof(op));
+	op.cmd_q = cmd_q;
+	op.jobid = ccp_gen_jobid(cmd_q->ccp);
+
+	/* Concatenate the modulus and the operands. Both the modulus and
+	 * the operands must be in little endian format.  Since the input
+	 * is in big endian format it must be converted and placed in a
+	 * fixed length buffer.
+	 */
+	ret = ccp_init_dm_workarea(&src, cmd_q, CCP_ECC_SRC_BUF_SIZE,
+				   DMA_TO_DEVICE);
+	if (ret)
+		return ret;
+
+	/* Save the workarea address since it is updated in order to perform
+	 * the concatenation
+	 */
+	save = src.address;
+
+	/* Copy the ECC modulus */
+	ccp_reverse_set_dm_area(&src, ecc->mod, ecc->mod_len,
+				CCP_ECC_OPERAND_SIZE, true);
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	/* Copy the first point X and Y coordinate */
+	ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.x,
+				ecc->u.pm.point_1.x_len,
+				CCP_ECC_OPERAND_SIZE, true);
+	src.address += CCP_ECC_OPERAND_SIZE;
+	ccp_reverse_set_dm_area(&src, ecc->u.pm.point_1.y,
+				ecc->u.pm.point_1.y_len,
+				CCP_ECC_OPERAND_SIZE, true);
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	/* Set the first point Z coordianate to 1 */
+	*(src.address) = 0x01;
+	src.address += CCP_ECC_OPERAND_SIZE;
+
+	if (ecc->function == CCP_ECC_FUNCTION_PADD_384BIT) {
+		/* Copy the second point X and Y coordinate */
+		ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.x,
+					ecc->u.pm.point_2.x_len,
+					CCP_ECC_OPERAND_SIZE, true);
+		src.address += CCP_ECC_OPERAND_SIZE;
+		ccp_reverse_set_dm_area(&src, ecc->u.pm.point_2.y,
+					ecc->u.pm.point_2.y_len,
+					CCP_ECC_OPERAND_SIZE, true);
+		src.address += CCP_ECC_OPERAND_SIZE;
+
+		/* Set the second point Z coordianate to 1 */
+		*(src.address) = 0x01;
+		src.address += CCP_ECC_OPERAND_SIZE;
+	} else {
+		/* Copy the Domain "a" parameter */
+		ccp_reverse_set_dm_area(&src, ecc->u.pm.domain_a,
+					ecc->u.pm.domain_a_len,
+					CCP_ECC_OPERAND_SIZE, true);
+		src.address += CCP_ECC_OPERAND_SIZE;
+
+		if (ecc->function == CCP_ECC_FUNCTION_PMUL_384BIT) {
+			/* Copy the scalar value */
+			ccp_reverse_set_dm_area(&src, ecc->u.pm.scalar,
+						ecc->u.pm.scalar_len,
+						CCP_ECC_OPERAND_SIZE, true);
+			src.address += CCP_ECC_OPERAND_SIZE;
+		}
+	}
+
+	/* Restore the workarea address */
+	src.address = save;
+
+	/* Prepare the output area for the operation */
+	ret = ccp_init_dm_workarea(&dst, cmd_q, CCP_ECC_DST_BUF_SIZE,
+				   DMA_FROM_DEVICE);
+	if (ret)
+		goto e_src;
+
+	op.soc = 1;
+	op.src.u.dma.address = src.dma.address;
+	op.src.u.dma.offset = 0;
+	op.src.u.dma.length = src.length;
+	op.dst.u.dma.address = dst.dma.address;
+	op.dst.u.dma.offset = 0;
+	op.dst.u.dma.length = dst.length;
+
+	op.u.ecc.function = cmd->u.ecc.function;
+
+	ret = ccp_perform_ecc(&op);
+	if (ret) {
+		cmd->engine_error = cmd_q->cmd_error;
+		goto e_dst;
+	}
+
+	ecc->ecc_result = le16_to_cpup(
+		(const __le16 *)(dst.address + CCP_ECC_RESULT_OFFSET));
+	if (!(ecc->ecc_result & CCP_ECC_RESULT_SUCCESS)) {
+		ret = -EIO;
+		goto e_dst;
+	}
+
+	/* Save the workarea address since it is updated as we walk through
+	 * to copy the point math result
+	 */
+	save = dst.address;
+
+	/* Save the ECC result X and Y coordinates */
+	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.x,
+				CCP_ECC_MODULUS_BYTES);
+	dst.address += CCP_ECC_OUTPUT_SIZE;
+	ccp_reverse_get_dm_area(&dst, ecc->u.pm.result.y,
+				CCP_ECC_MODULUS_BYTES);
+	dst.address += CCP_ECC_OUTPUT_SIZE;
+
+	/* Restore the workarea address */
+	dst.address = save;
+
+e_dst:
+	ccp_dm_free(&dst);
+
+e_src:
+	ccp_dm_free(&src);
+
+	return ret;
+}
+
+static int ccp_run_ecc_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	struct ccp_ecc_engine *ecc = &cmd->u.ecc;
+
+	ecc->ecc_result = 0;
+
+	if (!ecc->mod ||
+	    (ecc->mod_len > CCP_ECC_MODULUS_BYTES))
+		return -EINVAL;
+
+	switch (ecc->function) {
+	case CCP_ECC_FUNCTION_MMUL_384BIT:
+	case CCP_ECC_FUNCTION_MADD_384BIT:
+	case CCP_ECC_FUNCTION_MINV_384BIT:
+		return ccp_run_ecc_mm_cmd(cmd_q, cmd);
+
+	case CCP_ECC_FUNCTION_PADD_384BIT:
+	case CCP_ECC_FUNCTION_PMUL_384BIT:
+	case CCP_ECC_FUNCTION_PDBL_384BIT:
+		return ccp_run_ecc_pm_cmd(cmd_q, cmd);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+int ccp_run_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
+{
+	int ret;
+
+	cmd->engine_error = 0;
+	cmd_q->cmd_error = 0;
+	cmd_q->int_rcvd = 0;
+	cmd_q->free_slots = CMD_Q_DEPTH(ioread32(cmd_q->reg_status));
+
+	switch (cmd->engine) {
+	case CCP_ENGINE_AES:
+		ret = ccp_run_aes_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_XTS_AES_128:
+		ret = ccp_run_xts_aes_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_SHA:
+		ret = ccp_run_sha_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_RSA:
+		ret = ccp_run_rsa_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_PASSTHRU:
+		ret = ccp_run_passthru_cmd(cmd_q, cmd);
+		break;
+	case CCP_ENGINE_ECC:
+		ret = ccp_run_ecc_cmd(cmd_q, cmd);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
new file mode 100644
index 0000000..1fbeaf1
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -0,0 +1,360 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/kthread.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/delay.h>
+#include <linux/ccp.h>
+
+#include "ccp-dev.h"
+
+#define IO_BAR				2
+#define MSIX_VECTORS			2
+
+struct ccp_msix {
+	u32 vector;
+	char name[16];
+};
+
+struct ccp_pci {
+	int msix_count;
+	struct ccp_msix msix[MSIX_VECTORS];
+};
+
+static int ccp_get_msix_irqs(struct ccp_device *ccp)
+{
+	struct ccp_pci *ccp_pci = ccp->dev_specific;
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	struct msix_entry msix_entry[MSIX_VECTORS];
+	unsigned int name_len = sizeof(ccp_pci->msix[0].name) - 1;
+	int v, ret;
+
+	for (v = 0; v < ARRAY_SIZE(msix_entry); v++)
+		msix_entry[v].entry = v;
+
+	while ((ret = pci_enable_msix(pdev, msix_entry, v)) > 0)
+		v = ret;
+	if (ret)
+		return ret;
+
+	ccp_pci->msix_count = v;
+	for (v = 0; v < ccp_pci->msix_count; v++) {
+		/* Set the interrupt names and request the irqs */
+		snprintf(ccp_pci->msix[v].name, name_len, "ccp-%u", v);
+		ccp_pci->msix[v].vector = msix_entry[v].vector;
+		ret = request_irq(ccp_pci->msix[v].vector, ccp_irq_handler,
+				  0, ccp_pci->msix[v].name, dev);
+		if (ret) {
+			dev_notice(dev, "unable to allocate MSI-X IRQ (%d)\n",
+				   ret);
+			goto e_irq;
+		}
+	}
+
+	return 0;
+
+e_irq:
+	while (v--)
+		free_irq(ccp_pci->msix[v].vector, dev);
+
+	pci_disable_msix(pdev);
+
+	ccp_pci->msix_count = 0;
+
+	return ret;
+}
+
+static int ccp_get_msi_irq(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	int ret;
+
+	ret = pci_enable_msi(pdev);
+	if (ret)
+		return ret;
+
+	ret = request_irq(pdev->irq, ccp_irq_handler, 0, "ccp", dev);
+	if (ret) {
+		dev_notice(dev, "unable to allocate MSI IRQ (%d)\n", ret);
+		goto e_msi;
+	}
+
+	return 0;
+
+e_msi:
+	pci_disable_msi(pdev);
+
+	return ret;
+}
+
+static int ccp_get_irqs(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	int ret;
+
+	ret = ccp_get_msix_irqs(ccp);
+	if (!ret)
+		return 0;
+
+	/* Couldn't get MSI-X vectors, try MSI */
+	dev_notice(dev, "could not enable MSI-X (%d), trying MSI\n", ret);
+	ret = ccp_get_msi_irq(ccp);
+	if (!ret)
+		return 0;
+
+	/* Couldn't get MSI interrupt */
+	dev_notice(dev, "could not enable MSI (%d)\n", ret);
+
+	return ret;
+}
+
+static void ccp_free_irqs(struct ccp_device *ccp)
+{
+	struct ccp_pci *ccp_pci = ccp->dev_specific;
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+
+	if (ccp_pci->msix_count) {
+		while (ccp_pci->msix_count--)
+			free_irq(ccp_pci->msix[ccp_pci->msix_count].vector,
+				 dev);
+		pci_disable_msix(pdev);
+	} else {
+		free_irq(pdev->irq, dev);
+		pci_disable_msi(pdev);
+	}
+}
+
+static int ccp_find_mmio_area(struct ccp_device *ccp)
+{
+	struct device *dev = ccp->dev;
+	struct pci_dev *pdev = container_of(dev, struct pci_dev, dev);
+	resource_size_t io_len;
+	unsigned long io_flags;
+	int bar;
+
+	io_flags = pci_resource_flags(pdev, IO_BAR);
+	io_len = pci_resource_len(pdev, IO_BAR);
+	if ((io_flags & IORESOURCE_MEM) && (io_len >= (IO_OFFSET + 0x800)))
+		return IO_BAR;
+
+	for (bar = 0; bar < PCI_STD_RESOURCE_END; bar++) {
+		io_flags = pci_resource_flags(pdev, bar);
+		io_len = pci_resource_len(pdev, bar);
+		if ((io_flags & IORESOURCE_MEM) &&
+		    (io_len >= (IO_OFFSET + 0x800)))
+			return bar;
+	}
+
+	return -EIO;
+}
+
+static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct ccp_device *ccp;
+	struct ccp_pci *ccp_pci;
+	struct device *dev = &pdev->dev;
+	unsigned int bar;
+	int ret;
+
+	ret = -ENOMEM;
+	ccp = ccp_alloc_struct(dev);
+	if (!ccp)
+		goto e_err;
+
+	ccp_pci = kzalloc(sizeof(*ccp_pci), GFP_KERNEL);
+	if (!ccp_pci) {
+		ret = -ENOMEM;
+		goto e_free1;
+	}
+	ccp->dev_specific = ccp_pci;
+	ccp->get_irq = ccp_get_irqs;
+	ccp->free_irq = ccp_free_irqs;
+
+	ret = pci_request_regions(pdev, "ccp");
+	if (ret) {
+		dev_err(dev, "pci_request_regions failed (%d)\n", ret);
+		goto e_free2;
+	}
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(dev, "pci_enable_device failed (%d)\n", ret);
+		goto e_regions;
+	}
+
+	pci_set_master(pdev);
+
+	ret = ccp_find_mmio_area(ccp);
+	if (ret < 0)
+		goto e_device;
+	bar = ret;
+
+	ret = -EIO;
+	ccp->io_map = pci_iomap(pdev, bar, 0);
+	if (ccp->io_map == NULL) {
+		dev_err(dev, "pci_iomap failed\n");
+		goto e_device;
+	}
+	ccp->io_regs = ccp->io_map + IO_OFFSET;
+
+	ret = dma_set_mask(dev, DMA_BIT_MASK(48));
+	if (ret == 0) {
+		ret = dma_set_coherent_mask(dev, DMA_BIT_MASK(48));
+		if (ret) {
+			dev_err(dev,
+				"pci_set_consistent_dma_mask failed (%d)\n",
+				ret);
+			goto e_bar0;
+		}
+	} else {
+		ret = dma_set_mask(dev, DMA_BIT_MASK(32));
+		if (ret) {
+			dev_err(dev, "pci_set_dma_mask failed (%d)\n", ret);
+			goto e_bar0;
+		}
+	}
+
+	dev_set_drvdata(dev, ccp);
+
+	ret = ccp_init(ccp);
+	if (ret)
+		goto e_bar0;
+
+	dev_notice(dev, "enabled\n");
+
+	return 0;
+
+e_bar0:
+	pci_iounmap(pdev, ccp->io_map);
+
+e_device:
+	pci_disable_device(pdev);
+	dev_set_drvdata(dev, NULL);
+
+e_regions:
+	pci_release_regions(pdev);
+
+e_free2:
+	kfree(ccp_pci);
+
+e_free1:
+	kfree(ccp);
+
+e_err:
+	dev_notice(dev, "initialization failed\n");
+	return ret;
+}
+
+static void ccp_pci_remove(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+
+	ccp_destroy(ccp);
+
+	pci_iounmap(pdev, ccp->io_map);
+
+	pci_disable_device(pdev);
+	dev_set_drvdata(dev, NULL);
+
+	pci_release_regions(pdev);
+
+	kfree(ccp);
+
+	dev_notice(dev, "disabled\n");
+}
+
+#ifdef CONFIG_PM
+static int ccp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 1;
+
+	/* Wake all the queue kthreads to prepare for suspend */
+	for (i = 0; i < ccp->cmd_q_count; i++)
+		wake_up_process(ccp->cmd_q[i].kthread);
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	/* Wait for all queue kthreads to say they're done */
+	while (!ccp_queues_suspended(ccp))
+		wait_event_interruptible(ccp->suspend_queue,
+					 ccp_queues_suspended(ccp));
+
+	return 0;
+}
+
+static int ccp_pci_resume(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ccp_device *ccp = dev_get_drvdata(dev);
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&ccp->cmd_lock, flags);
+
+	ccp->suspending = 0;
+
+	/* Wake up all the kthreads */
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		ccp->cmd_q[i].suspended = 0;
+		wake_up_process(ccp->cmd_q[i].kthread);
+	}
+
+	spin_unlock_irqrestore(&ccp->cmd_lock, flags);
+
+	return 0;
+}
+#endif
+
+static DEFINE_PCI_DEVICE_TABLE(ccp_pci_table) = {
+	{ PCI_VDEVICE(AMD, 0x1537), },
+	/* Last entry must be zero */
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, ccp_pci_table);
+
+static struct pci_driver ccp_pci_driver = {
+	.name = "AMD Cryptographic Coprocessor",
+	.id_table = ccp_pci_table,
+	.probe = ccp_pci_probe,
+	.remove = ccp_pci_remove,
+#ifdef CONFIG_PM
+	.suspend = ccp_pci_suspend,
+	.resume = ccp_pci_resume,
+#endif
+};
+
+int ccp_pci_init(void)
+{
+	return pci_register_driver(&ccp_pci_driver);
+}
+
+void ccp_pci_exit(void)
+{
+	pci_unregister_driver(&ccp_pci_driver);
+}
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
new file mode 100644
index 0000000..e8c2349
--- /dev/null
+++ b/include/linux/ccp.h
@@ -0,0 +1,525 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) driver
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __CPP_H__
+#define __CPP_H__
+
+#include <linux/scatterlist.h>
+#include <linux/workqueue.h>
+#include <linux/list.h>
+#include <crypto/aes.h>
+#include <crypto/sha.h>
+
+
+struct ccp_device;
+struct ccp_cmd;
+
+/**
+ * ccp_enqueue_cmd - queue an operation for processing by the CCP
+ *
+ * @cmd: ccp_cmd struct to be processed
+ *
+ * Refer to the ccp_cmd struct below for required fields.
+ *
+ * Queue a cmd to be processed by the CCP. If queueing the cmd
+ * would exceed the defined length of the cmd queue the cmd will
+ * only be queued if the CCP_CMD_MAY_BACKLOG flag is set and will
+ * result in a return code of -EBUSY.
+ *
+ * The callback routine specified in the ccp_cmd struct will be
+ * called to notify the caller of completion (if the cmd was not
+ * backlogged) or advancement out of the backlog. If the cmd has
+ * advanced out of the backlog the "err" value of the callback
+ * will be -EINPROGRESS. Any other "err" value during callback is
+ * the result of the operation.
+ *
+ * The cmd has been successfully queued if:
+ *   the return code is -EINPROGRESS or
+ *   the return code is -EBUSY and CCP_CMD_MAY_BACKLOG flag is set
+ */
+int ccp_enqueue_cmd(struct ccp_cmd *cmd);
+
+
+/***** AES engine *****/
+/**
+ * ccp_aes_type - AES key size
+ *
+ * @CCP_AES_TYPE_128: 128-bit key
+ * @CCP_AES_TYPE_192: 192-bit key
+ * @CCP_AES_TYPE_256: 256-bit key
+ */
+enum ccp_aes_type {
+	CCP_AES_TYPE_128 = 0,
+	CCP_AES_TYPE_192,
+	CCP_AES_TYPE_256,
+	CCP_AES_TYPE__LAST,
+};
+
+/**
+ * ccp_aes_mode - AES operation mode
+ *
+ * @CCP_AES_MODE_ECB: ECB mode
+ * @CCP_AES_MODE_CBC: CBC mode
+ * @CCP_AES_MODE_OFB: OFB mode
+ * @CCP_AES_MODE_CFB: CFB mode
+ * @CCP_AES_MODE_CTR: CTR mode
+ * @CCP_AES_MODE_CMAC: CMAC mode
+ */
+enum ccp_aes_mode {
+	CCP_AES_MODE_ECB = 0,
+	CCP_AES_MODE_CBC,
+	CCP_AES_MODE_OFB,
+	CCP_AES_MODE_CFB,
+	CCP_AES_MODE_CTR,
+	CCP_AES_MODE_CMAC,
+	CCP_AES_MODE__LAST,
+};
+
+/**
+ * ccp_aes_mode - AES operation mode
+ *
+ * @CCP_AES_ACTION_DECRYPT: AES decrypt operation
+ * @CCP_AES_ACTION_ENCRYPT: AES encrypt operation
+ */
+enum ccp_aes_action {
+	CCP_AES_ACTION_DECRYPT = 0,
+	CCP_AES_ACTION_ENCRYPT,
+	CCP_AES_ACTION__LAST,
+};
+
+/**
+ * struct ccp_aes_engine - CCP AES operation
+ * @type: AES operation key size
+ * @mode: AES operation mode
+ * @action: AES operation (decrypt/encrypt)
+ * @key: key to be used for this AES operation
+ * @key_len: length in bytes of key
+ * @iv: IV to be used for this AES operation
+ * @iv_len: length in bytes of iv
+ * @src: data to be used for this operation
+ * @dst: data produced by this operation
+ * @src_len: length in bytes of data used for this operation
+ * @cmac_final: indicates final operation when running in CMAC mode
+ * @cmac_key: K1/K2 key used in final CMAC operation
+ * @cmac_key_len: length in bytes of cmac_key
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - type, mode, action, key, key_len, src, dst, src_len
+ *   - iv, iv_len for any mode other than ECB
+ *   - cmac_final for CMAC mode
+ *   - cmac_key, cmac_key_len for CMAC mode if cmac_final is non-zero
+ *
+ * The iv variable is used as both input and output. On completion of the
+ * AES operation the new IV overwrites the old IV.
+ */
+struct ccp_aes_engine {
+	enum ccp_aes_type type;
+	enum ccp_aes_mode mode;
+	enum ccp_aes_action action;
+
+	struct scatterlist *key;
+	u32 key_len;		/* In bytes */
+
+	struct scatterlist *iv;
+	u32 iv_len;		/* In bytes */
+
+	struct scatterlist *src, *dst;
+	u32 src_len;		/* In bytes */
+
+	u32 cmac_final;		/* Indicates final cmac cmd */
+	struct scatterlist *cmac_key;	/* K1/K2 cmac key required for
+					 * final cmac cmd */
+	u32 cmac_key_len;	/* In bytes */
+};
+
+/***** XTS-AES engine *****/
+/**
+ * ccp_xts_aes_unit_size - XTS unit size
+ *
+ * @CCP_XTS_AES_UNIT_SIZE_16: Unit size of 16 bytes
+ * @CCP_XTS_AES_UNIT_SIZE_512: Unit size of 512 bytes
+ * @CCP_XTS_AES_UNIT_SIZE_1024: Unit size of 1024 bytes
+ * @CCP_XTS_AES_UNIT_SIZE_2048: Unit size of 2048 bytes
+ * @CCP_XTS_AES_UNIT_SIZE_4096: Unit size of 4096 bytes
+ */
+enum ccp_xts_aes_unit_size {
+	CCP_XTS_AES_UNIT_SIZE_16 = 0,
+	CCP_XTS_AES_UNIT_SIZE_512,
+	CCP_XTS_AES_UNIT_SIZE_1024,
+	CCP_XTS_AES_UNIT_SIZE_2048,
+	CCP_XTS_AES_UNIT_SIZE_4096,
+	CCP_XTS_AES_UNIT_SIZE__LAST,
+};
+
+/**
+ * struct ccp_xts_aes_engine - CCP XTS AES operation
+ * @action: AES operation (decrypt/encrypt)
+ * @unit_size: unit size of the XTS operation
+ * @key: key to be used for this XTS AES operation
+ * @key_len: length in bytes of key
+ * @iv: IV to be used for this XTS AES operation
+ * @iv_len: length in bytes of iv
+ * @src: data to be used for this operation
+ * @dst: data produced by this operation
+ * @src_len: length in bytes of data used for this operation
+ * @final: indicates final XTS operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - action, unit_size, key, key_len, iv, iv_len, src, dst, src_len, final
+ *
+ * The iv variable is used as both input and output. On completion of the
+ * AES operation the new IV overwrites the old IV.
+ */
+struct ccp_xts_aes_engine {
+	enum ccp_aes_action action;
+	enum ccp_xts_aes_unit_size unit_size;
+
+	struct scatterlist *key;
+	u32 key_len;		/* In bytes */
+
+	struct scatterlist *iv;
+	u32 iv_len;		/* In bytes */
+
+	struct scatterlist *src, *dst;
+	u32 src_len;		/* In bytes */
+
+	u32 final;
+};
+
+/***** SHA engine *****/
+#define CCP_SHA_BLOCKSIZE               SHA256_BLOCK_SIZE
+#define CCP_SHA_CTXSIZE                 SHA256_DIGEST_SIZE
+
+/**
+ * ccp_sha_type - type of SHA operation
+ *
+ * @CCP_SHA_TYPE_1: SHA-1 operation
+ * @CCP_SHA_TYPE_224: SHA-224 operation
+ * @CCP_SHA_TYPE_256: SHA-256 operation
+ */
+enum ccp_sha_type {
+	CCP_SHA_TYPE_1 = 1,
+	CCP_SHA_TYPE_224,
+	CCP_SHA_TYPE_256,
+	CCP_SHA_TYPE__LAST,
+};
+
+/**
+ * struct ccp_sha_engine - CCP SHA operation
+ * @type: Type of SHA operation
+ * @ctx: current hash value
+ * @ctx_len: length in bytes of hash value
+ * @src: data to be used for this operation
+ * @src_len: length in bytes of data used for this operation
+ * @final: indicates final SHA operation
+ * @msg_bits: total length of the message in bits used in final SHA operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - type, ctx, ctx_len, src, src_len, final
+ *   - msg_bits if final is non-zero
+ *
+ * The ctx variable is used as both input and output. On completion of the
+ * SHA operation the new hash value overwrites the old hash value.
+ */
+struct ccp_sha_engine {
+	enum ccp_sha_type type;
+
+	struct scatterlist *ctx;
+	u32 ctx_len;		/* In bytes */
+
+	struct scatterlist *src;
+	u32 src_len;		/* In bytes */
+
+	u32 final;		/* Indicates final sha cmd */
+	u64 msg_bits;		/* Message length in bits required for
+				 * final sha cmd */
+};
+
+/***** RSA engine *****/
+/**
+ * struct ccp_rsa_engine - CCP RSA operation
+ * @key_size: length in bits of RSA key
+ * @exp: RSA exponent
+ * @exp_len: length in bytes of exponent
+ * @mod: RSA modulus
+ * @mod_len: length in bytes of modulus
+ * @src: data to be used for this operation
+ * @dst: data produced by this operation
+ * @src_len: length in bytes of data used for this operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - key_size, exp, exp_len, mod, mod_len, src, dst, src_len
+ */
+struct ccp_rsa_engine {
+	u32 key_size;		/* In bits */
+
+	struct scatterlist *exp;
+	u32 exp_len;		/* In bytes */
+
+	struct scatterlist *mod;
+	u32 mod_len;		/* In bytes */
+
+	struct scatterlist *src, *dst;
+	u32 src_len;		/* In bytes */
+};
+
+/***** Passthru engine *****/
+/**
+ * ccp_passthru_bitwise - type of bitwise passthru operation
+ *
+ * @CCP_PASSTHRU_BITWISE_NOOP: no bitwise operation performed
+ * @CCP_PASSTHRU_BITWISE_AND: perform bitwise AND of src with mask
+ * @CCP_PASSTHRU_BITWISE_OR: perform bitwise OR of src with mask
+ * @CCP_PASSTHRU_BITWISE_XOR: perform bitwise XOR of src with mask
+ * @CCP_PASSTHRU_BITWISE_MASK: overwrite with mask
+ */
+enum ccp_passthru_bitwise {
+	CCP_PASSTHRU_BITWISE_NOOP = 0,
+	CCP_PASSTHRU_BITWISE_AND,
+	CCP_PASSTHRU_BITWISE_OR,
+	CCP_PASSTHRU_BITWISE_XOR,
+	CCP_PASSTHRU_BITWISE_MASK,
+	CCP_PASSTHRU_BITWISE__LAST,
+};
+
+/**
+ * ccp_passthru_byteswap - type of byteswap passthru operation
+ *
+ * @CCP_PASSTHRU_BYTESWAP_NOOP: no byte swapping performed
+ * @CCP_PASSTHRU_BYTESWAP_32BIT: swap bytes within 32-bit words
+ * @CCP_PASSTHRU_BYTESWAP_256BIT: swap bytes within 256-bit words
+ */
+enum ccp_passthru_byteswap {
+	CCP_PASSTHRU_BYTESWAP_NOOP = 0,
+	CCP_PASSTHRU_BYTESWAP_32BIT,
+	CCP_PASSTHRU_BYTESWAP_256BIT,
+	CCP_PASSTHRU_BYTESWAP__LAST,
+};
+
+/**
+ * struct ccp_passthru_engine - CCP pass-through operation
+ * @bit_mod: bitwise operation to perform
+ * @byte_swap: byteswap operation to perform
+ * @mask: mask to be applied to data
+ * @mask_len: length in bytes of mask
+ * @src: data to be used for this operation
+ * @dst: data produced by this operation
+ * @src_len: length in bytes of data used for this operation
+ * @final: indicate final pass-through operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - bit_mod, byte_swap, src, dst, src_len
+ *   - mask, mask_len if bit_mod is not CCP_PASSTHRU_BITWISE_NOOP
+ */
+struct ccp_passthru_engine {
+	enum ccp_passthru_bitwise bit_mod;
+	enum ccp_passthru_byteswap byte_swap;
+
+	struct scatterlist *mask;
+	u32 mask_len;		/* In bytes */
+
+	struct scatterlist *src, *dst;
+	u32 src_len;		/* In bytes */
+
+	u32 final;
+};
+
+/***** ECC engine *****/
+#define CCP_ECC_MODULUS_BYTES	48	/* 384-bits */
+#define CCP_ECC_MAX_OPERANDS	6
+#define CCP_ECC_MAX_OUTPUTS	3
+
+/**
+ * ccp_ecc_function - type of ECC function
+ *
+ * @CCP_ECC_FUNCTION_MMUL_384BIT: 384-bit modular multiplication
+ * @CCP_ECC_FUNCTION_MADD_384BIT: 384-bit modular addition
+ * @CCP_ECC_FUNCTION_MINV_384BIT: 384-bit multiplicative inverse
+ * @CCP_ECC_FUNCTION_PADD_384BIT: 384-bit point addition
+ * @CCP_ECC_FUNCTION_PMUL_384BIT: 384-bit point multiplication
+ * @CCP_ECC_FUNCTION_PDBL_384BIT: 384-bit point doubling
+ */
+enum ccp_ecc_function {
+	CCP_ECC_FUNCTION_MMUL_384BIT = 0,
+	CCP_ECC_FUNCTION_MADD_384BIT,
+	CCP_ECC_FUNCTION_MINV_384BIT,
+	CCP_ECC_FUNCTION_PADD_384BIT,
+	CCP_ECC_FUNCTION_PMUL_384BIT,
+	CCP_ECC_FUNCTION_PDBL_384BIT,
+};
+
+/**
+ * struct ccp_ecc_modular_math - CCP ECC modular math parameters
+ * @operand_1: first operand for the modular math operation
+ * @operand_1_len: length of the first operand
+ * @operand_2: second operand for the modular math operation
+ *	       (not used for CCP_ECC_FUNCTION_MINV_384BIT)
+ * @operand_2_len: length of the second operand
+ *	       (not used for CCP_ECC_FUNCTION_MINV_384BIT)
+ * @result: result of the modular math operation
+ * @result_len: length of the supplied result buffer
+ */
+struct ccp_ecc_modular_math {
+	struct scatterlist *operand_1;
+	unsigned int operand_1_len;	/* In bytes */
+
+	struct scatterlist *operand_2;
+	unsigned int operand_2_len;	/* In bytes */
+
+	struct scatterlist *result;
+	unsigned int result_len;	/* In bytes */
+};
+
+/**
+ * struct ccp_ecc_point - CCP ECC point definition
+ * @x: the x coordinate of the ECC point
+ * @x_len: the length of the x coordinate
+ * @y: the y coordinate of the ECC point
+ * @y_len: the length of the y coordinate
+ */
+struct ccp_ecc_point {
+	struct scatterlist *x;
+	unsigned int x_len;	/* In bytes */
+
+	struct scatterlist *y;
+	unsigned int y_len;	/* In bytes */
+};
+
+/**
+ * struct ccp_ecc_point_math - CCP ECC point math parameters
+ * @point_1: the first point of the ECC point math operation
+ * @point_2: the second point of the ECC point math operation
+ *	     (only used for CCP_ECC_FUNCTION_PADD_384BIT)
+ * @domain_a: the a parameter of the ECC curve
+ * @domain_a_len: the length of the a parameter
+ * @scalar: the scalar parameter for the point match operation
+ *	    (only used for CCP_ECC_FUNCTION_PMUL_384BIT)
+ * @scalar_len: the length of the scalar parameter
+ *		(only used for CCP_ECC_FUNCTION_PMUL_384BIT)
+ * @result: the point resulting from the point math operation
+ */
+struct ccp_ecc_point_math {
+	struct ccp_ecc_point point_1;
+	struct ccp_ecc_point point_2;
+
+	struct scatterlist *domain_a;
+	unsigned int domain_a_len;	/* In bytes */
+
+	struct scatterlist *scalar;
+	unsigned int scalar_len;	/* In bytes */
+
+	struct ccp_ecc_point result;
+};
+
+/**
+ * struct ccp_ecc_engine - CCP ECC operation
+ * @function: ECC function to perform
+ * @mod: ECC modulus
+ * @mod_len: length in bytes of modulus
+ * @mm: module math parameters
+ * @pm: point math parameters
+ * @ecc_result: result of the ECC operation
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - function, mod, mod_len
+ *   - operand, operand_len, operand_count, output, output_len, output_count
+ *   - ecc_result
+ */
+struct ccp_ecc_engine {
+	enum ccp_ecc_function function;
+
+	struct scatterlist *mod;
+	u32 mod_len;		/* In bytes */
+
+	union {
+		struct ccp_ecc_modular_math mm;
+		struct ccp_ecc_point_math pm;
+	} u;
+
+	u16 ecc_result;
+};
+
+
+/**
+ * ccp_engine - CCP operation identifiers
+ *
+ * @CCP_ENGINE_AES: AES operation
+ * @CCP_ENGINE_XTS_AES: 128-bit XTS AES operation
+ * @CCP_ENGINE_RSVD1: unused
+ * @CCP_ENGINE_SHA: SHA operation
+ * @CCP_ENGINE_RSA: RSA operation
+ * @CCP_ENGINE_PASSTHRU: pass-through operation
+ * @CCP_ENGINE_ZLIB_DECOMPRESS: unused
+ * @CCP_ENGINE_ECC: ECC operation
+ */
+enum ccp_engine {
+	CCP_ENGINE_AES = 0,
+	CCP_ENGINE_XTS_AES_128,
+	CCP_ENGINE_RSVD1,
+	CCP_ENGINE_SHA,
+	CCP_ENGINE_RSA,
+	CCP_ENGINE_PASSTHRU,
+	CCP_ENGINE_ZLIB_DECOMPRESS,
+	CCP_ENGINE_ECC,
+	CCP_ENGINE__LAST,
+};
+
+/* Flag values for flags member of ccp_cmd */
+#define CCP_CMD_MAY_BACKLOG	0x00000001
+
+/**
+ * struct ccp_cmd - CPP operation request
+ * @entry: list element (ccp driver use only)
+ * @work: work element used for callbacks (ccp driver use only)
+ * @ccp: CCP device to be run on (ccp driver use only)
+ * @ret: operation return code (ccp driver use only)
+ * @flags: cmd processing flags
+ * @engine: CCP operation to perform
+ * @engine_error: CCP engine return code
+ * @u: engine specific structures, refer to specific engine struct below
+ * @callback: operation completion callback function
+ * @data: parameter value to be supplied to the callback function
+ *
+ * Variables required to be set when calling ccp_enqueue_cmd():
+ *   - engine, callback
+ *   - See the operation structures below for what is required for each
+ *     operation.
+ */
+struct ccp_cmd {
+	/* The list_head, work_struct, ccp and ret variables are for use
+	 * by the CCP driver only.
+	 */
+	struct list_head entry;
+	struct work_struct work;
+	struct ccp_device *ccp;
+	int ret;
+
+	u32 flags;
+
+	enum ccp_engine engine;
+	u32 engine_error;
+
+	union {
+		struct ccp_aes_engine aes;
+		struct ccp_xts_aes_engine xts;
+		struct ccp_sha_engine sha;
+		struct ccp_rsa_engine rsa;
+		struct ccp_passthru_engine passthru;
+		struct ccp_ecc_engine ecc;
+	} u;
+
+	/* Completion callback support */
+	void (*callback)(void *data, int err);
+	void *data;
+};
+
+#endif


