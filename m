Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaDCQTa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:19:30 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56012 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbaDCQT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:19:26 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/9] crypto: qce: Add core driver implementation
Date: Thu,  3 Apr 2014 19:17:58 +0300
Message-Id: <1396541886-10966-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds core driver files. The core part is implementing a
platform driver probe and remove callbaks, the probe enables
clocks, checks crypto version, initialize and request dma
channels, create done tasklet and work queue and finally
register the algorithms into crypto subsystem.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/core.c | 333 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/core.h |  69 ++++++++++
 2 files changed, 402 insertions(+)
 create mode 100644 drivers/crypto/qce/core.c
 create mode 100644 drivers/crypto/qce/core.h

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
new file mode 100644
index 000000000000..240b9983e9b9
--- /dev/null
+++ b/drivers/crypto/qce/core.c
@@ -0,0 +1,333 @@
+/*
+ * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <crypto/sha.h>
+
+#include "dma.h"
+#include "core.h"
+#include "common.h"
+#include "cipher.h"
+#include "sha.h"
+#include "regs-v5.h"
+
+#define QCE_MAJOR_VERSION5	0x05
+#define QCE_QUEUE_LENGTH	50
+
+static int qce_async_request_queue(struct qce_device *qce,
+				   struct crypto_async_request *req)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&qce->lock, flags);
+	ret = crypto_enqueue_request(&qce->queue, req);
+	spin_unlock_irqrestore(&qce->lock, flags);
+
+	queue_work(qce->queue_wq, &qce->queue_work);
+
+	return ret;
+}
+
+static void qce_async_request_done(struct qce_device *qce, int ret)
+{
+	qce->result = ret;
+	tasklet_schedule(&qce->done_tasklet);
+}
+
+static struct qce_algo_ops qce_ops[] = {
+	{
+		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
+		.register_alg = qce_ablkcipher_register,
+	},
+	{
+		.type = CRYPTO_ALG_TYPE_AHASH,
+		.register_alg = qce_ahash_register,
+	},
+};
+
+static void qce_unregister_algs(struct qce_device *qce)
+{
+	struct qce_alg_template *tmpl, *n;
+
+	list_for_each_entry_safe(tmpl, n, &qce->alg_list, entry) {
+		if (tmpl->crypto_alg_type == CRYPTO_ALG_TYPE_AHASH)
+			crypto_unregister_ahash(&tmpl->alg.ahash);
+		else
+			crypto_unregister_alg(&tmpl->alg.crypto);
+
+		list_del(&tmpl->entry);
+		kfree(tmpl);
+	}
+}
+
+static int qce_register_algs(struct qce_device *qce)
+{
+	struct qce_algo_ops *ops;
+	int i, rc = -ENODEV;
+
+	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
+		ops = &qce_ops[i];
+		ops->async_req_queue = qce_async_request_queue;
+		ops->async_req_done = qce_async_request_done;
+		rc = ops->register_alg(qce, ops);
+		if (rc)
+			break;
+	}
+
+	if (rc)
+		qce_unregister_algs(qce);
+
+	return rc;
+}
+
+static int qce_handle_request(struct crypto_async_request *async_req)
+{
+	int ret = -EINVAL, i;
+	struct qce_algo_ops *ops;
+	u32 type = crypto_tfm_alg_type(async_req->tfm);
+
+	for (i = 0; i < ARRAY_SIZE(qce_ops); i++) {
+		ops = &qce_ops[i];
+		if (type != ops->type)
+			continue;
+		ret = ops->async_req_handle(async_req);
+		break;
+	}
+
+	return ret;
+}
+
+static void qce_reqqueue_handler(struct work_struct *work)
+{
+	struct qce_device *qce =
+			container_of(work, struct qce_device, queue_work);
+	struct crypto_async_request *async_req = NULL, *backlog = NULL;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&qce->lock, flags);
+	if (!qce->req) {
+		backlog = crypto_get_backlog(&qce->queue);
+		async_req = crypto_dequeue_request(&qce->queue);
+		qce->req = async_req;
+	}
+	spin_unlock_irqrestore(&qce->lock, flags);
+
+	if (!async_req)
+		return;
+
+	if (backlog)
+		backlog->complete(backlog, -EINPROGRESS);
+
+	ret = qce_handle_request(async_req);
+	if (ret) {
+		spin_lock_irqsave(&qce->lock, flags);
+		qce->req = NULL;
+		spin_unlock_irqrestore(&qce->lock, flags);
+
+		async_req->complete(async_req, ret);
+	}
+}
+
+static void qce_tasklet_req_done(unsigned long data)
+{
+	struct qce_device *qce = (struct qce_device *)data;
+	struct crypto_async_request *areq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&qce->lock, flags);
+	areq = qce->req;
+	qce->req = NULL;
+	spin_unlock_irqrestore(&qce->lock, flags);
+
+	if (areq)
+		areq->complete(areq, qce->result);
+
+	queue_work(qce->queue_wq, &qce->queue_work);
+}
+
+static int qce_get_version(struct qce_device *qce)
+{
+	u32 major, minor, step;
+	u32 val;
+
+	val = readl(qce->base + REG_VERSION);
+	major = (val & CORE_MAJOR_REV_MASK) >> CORE_MAJOR_REV;
+	minor = (val & CORE_MINOR_REV_MASK) >> CORE_MINOR_REV;
+	step = (val & CORE_STEP_REV_MASK) >> CORE_STEP_REV;
+
+	/*
+	 * the driver does not support v5 with minor 0 because it has special
+	 * alignment requirements.
+	 */
+	if (major < QCE_MAJOR_VERSION5 && minor == 0)
+		return -ENODEV;
+
+	qce->burst_size = QCE_BAM_BURST_SIZE;
+	qce->pipe_pair_index = 1;
+
+	dev_info(qce->dev, "Crypto device found, version %d.%d.%d\n",
+		 major, minor, step);
+
+	return 0;
+}
+
+static int qce_clks_get(struct qce_device *qce)
+{
+	struct clk *clk;
+	int rc = 0;
+	int i;
+
+	for (i = 0; i < QCE_CLKS_NUM; i++) {
+		clk = devm_clk_get(qce->dev, clk_names[i]);
+		if (IS_ERR(clk)) {
+			rc = PTR_ERR(clk);
+			break;
+		}
+		qce->clks[i] = clk;
+	}
+
+	return rc;
+}
+
+static int qce_clks_enable(struct qce_device *qce, int enable)
+{
+	int rc = 0;
+	int i;
+
+	for (i = 0; i < QCE_CLKS_NUM; i++) {
+		if (enable)
+			rc = clk_prepare_enable(qce->clks[i]);
+		else
+			clk_disable_unprepare(qce->clks[i]);
+
+		if (rc)
+			break;
+	}
+
+	if (rc)
+		do
+			clk_disable_unprepare(qce->clks[i]);
+		while (--i >= 0);
+
+	return rc;
+}
+
+static int qce_crypto_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct qce_device *qce;
+	struct resource *res;
+	int rc;
+
+	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
+	if (!qce)
+		return -ENOMEM;
+
+	qce->dev = dev;
+	platform_set_drvdata(pdev, qce);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	qce->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(qce->base))
+		return PTR_ERR(qce->base);
+
+	rc = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (rc < 0)
+		return rc;
+
+	rc = qce_clks_get(qce);
+	if (rc)
+		return rc;
+
+	rc = qce_clks_enable(qce, 1);
+	if (rc)
+		return rc;
+
+	rc = qce_dma_request(qce->dev, &qce->dma);
+	if (rc)
+		goto error_clks;
+
+	rc = qce_get_version(qce);
+	if (rc)
+		goto error_clks;
+
+	INIT_LIST_HEAD(&qce->alg_list);
+	spin_lock_init(&qce->lock);
+	tasklet_init(&qce->done_tasklet, qce_tasklet_req_done,
+		     (unsigned long)qce);
+
+	qce->queue_wq = alloc_workqueue("qce_wq", WQ_HIGHPRI | WQ_UNBOUND, 1);
+	if (!qce->queue_wq) {
+		rc = -ENOMEM;
+		goto error_dma;
+	}
+
+	INIT_WORK(&qce->queue_work, qce_reqqueue_handler);
+
+	crypto_init_queue(&qce->queue, QCE_QUEUE_LENGTH);
+
+	rc = qce_register_algs(qce);
+	if (rc)
+		goto error_dma;
+
+	return 0;
+error_dma:
+	qce_dma_release(&qce->dma);
+error_clks:
+	qce_clks_enable(qce, 0);
+	return rc;
+}
+
+static int qce_crypto_remove(struct platform_device *pdev)
+{
+	struct qce_device *qce = platform_get_drvdata(pdev);
+
+	cancel_work_sync(&qce->queue_work);
+	destroy_workqueue(qce->queue_wq);
+	tasklet_kill(&qce->done_tasklet);
+	qce_unregister_algs(qce);
+	qce_dma_release(&qce->dma);
+	qce_clks_enable(qce, 0);
+
+	return 0;
+}
+
+static const struct of_device_id qce_crypto_of_match[] = {
+	{ .compatible = "qcom,crypto-v5.1", },
+	{}
+};
+
+static struct platform_driver qce_crypto_driver = {
+	.probe = qce_crypto_probe,
+	.remove = qce_crypto_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = KBUILD_MODNAME,
+		.of_match_table = qce_crypto_of_match,
+	},
+};
+module_platform_driver(qce_crypto_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Qualcomm crypto engine driver");
+MODULE_ALIAS("platform:" KBUILD_MODNAME);
+MODULE_AUTHOR("The Linux Foundation");
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
new file mode 100644
index 000000000000..bd6b648276b2
--- /dev/null
+++ b/drivers/crypto/qce/core.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2010-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CORE_H_
+#define _CORE_H_
+
+static const char * const clk_names[] = {
+	"core",		/* GCC_CE_CLK */
+	"iface",	/* GCC_CE_AHB_CLK */
+	"bus",		/* GCC_CE_AXI_CLK */
+};
+
+#define QCE_CLKS_NUM	ARRAY_SIZE(clk_names)
+
+/*
+ * Crypto engine device structure
+ *
+ * @alg_list: list of registered algorithms
+ * @queue: request queue
+ * @lock: the lock protects queue and req
+ * @done_tasklet: done tasklet object
+ * @queue_wq: queue workqueue
+ * @queue_work: queue work
+ * @req: current active request
+ * @result: result of transform
+ * @base: virtual IO base
+ * @dev: pointer to device
+ * @clks: array of device clocks
+ * @dma: pointer to dma data
+ * @burst_size: the crypto burst size
+ * @pipe_pair_index: which pipe pair the device using
+ */
+struct qce_device {
+	struct list_head alg_list;
+	struct crypto_queue queue;
+	spinlock_t lock;
+	struct tasklet_struct done_tasklet;
+	struct workqueue_struct *queue_wq;
+	struct work_struct queue_work;
+	struct crypto_async_request *req;
+	int result;
+	void __iomem *base;
+	struct device *dev;
+	struct clk *clks[QCE_CLKS_NUM];
+	struct qce_dma_data dma;
+	int burst_size;
+	unsigned int pipe_pair_index;
+};
+
+struct qce_algo_ops {
+	u32 type;
+	int (*register_alg)(struct qce_device *qce, struct qce_algo_ops *ops);
+	int (*async_req_queue)(struct qce_device *qce,
+			       struct crypto_async_request *req);
+	void (*async_req_done)(struct qce_device *qce, int ret);
+	int (*async_req_handle)(struct crypto_async_request *async_req);
+};
+
+#endif /* _CORE_H_ */
-- 
1.8.4.4

