Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaDCQUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:20:40 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56082 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbaDCQUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:20:36 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 3/9] crypto: qce: Add dma and sg helpers
Date: Thu,  3 Apr 2014 19:18:00 +0300
Message-Id: <1396541886-10966-4-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds dmaengine and sg-list helper functions used by
other parts of the crypto driver.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/dma.c | 201 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/qce/dma.h |  57 ++++++++++++++
 2 files changed, 258 insertions(+)
 create mode 100644 drivers/crypto/qce/dma.c
 create mode 100644 drivers/crypto/qce/dma.h

diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
new file mode 100644
index 000000000000..1bad958db2f9
--- /dev/null
+++ b/drivers/crypto/qce/dma.c
@@ -0,0 +1,201 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
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
+#include <linux/interrupt.h>
+#include <crypto/algapi.h>
+#include <crypto/scatterwalk.h>
+
+#include "dma.h"
+#include "core.h"
+#include "common.h"
+
+int qce_dma_request(struct device *dev, struct qce_dma_data *dma)
+{
+	unsigned int memsize;
+	void *va;
+	int ret;
+
+	dma->txchan = dma_request_slave_channel_reason(dev, "tx");
+	if (IS_ERR(dma->txchan)) {
+		ret = PTR_ERR(dma->txchan);
+		return ret;
+	}
+
+	dma->rxchan = dma_request_slave_channel_reason(dev, "rx");
+	if (IS_ERR(dma->rxchan)) {
+		ret = PTR_ERR(dma->rxchan);
+		goto error_rx;
+	}
+
+	memsize = QCE_RESULT_BUF_SZ + QCE_IGNORE_BUF_SZ;
+	va = kzalloc(memsize, GFP_KERNEL);
+	if (!va) {
+		ret = -ENOMEM;
+		goto error_nomem;
+	}
+
+	dma->result_buf = va;
+	dma->ignore_buf = dma->result_buf + QCE_RESULT_BUF_SZ;
+
+	return 0;
+error_nomem:
+	if (!IS_ERR(dma->rxchan))
+		dma_release_channel(dma->rxchan);
+error_rx:
+	if (!IS_ERR(dma->txchan))
+		dma_release_channel(dma->txchan);
+	return ret;
+}
+
+void qce_dma_release(struct qce_dma_data *dma)
+{
+	dma_release_channel(dma->txchan);
+	dma_release_channel(dma->rxchan);
+	kfree(dma->result_buf);
+}
+
+int qce_mapsg(struct device *dev, struct scatterlist *sg, unsigned int nents,
+	      enum dma_data_direction dir, bool chained)
+{
+	int err;
+
+	if (chained) {
+		while (sg) {
+			err = dma_map_sg(dev, sg, 1, dir);
+			if (!err)
+				goto error;
+			sg = scatterwalk_sg_next(sg);
+		}
+	} else {
+		err = dma_map_sg(dev, sg, nents, dir);
+		if (!err)
+			goto error;
+	}
+
+	return nents;
+error:
+	return -EFAULT;
+}
+
+void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
+		 enum dma_data_direction dir, bool chained)
+{
+	if (chained)
+		while (sg) {
+			dma_unmap_sg(dev, sg, 1, dir);
+			sg = scatterwalk_sg_next(sg);
+		}
+	else
+		dma_unmap_sg(dev, sg, nents, dir);
+}
+
+int qce_countsg(struct scatterlist *sglist, int nbytes, bool *chained)
+{
+	struct scatterlist *sg = sglist;
+	int sg_nents = 0;
+
+	if (chained)
+		*chained = false;
+
+	while (nbytes > 0 && sg) {
+		sg_nents++;
+		nbytes -= sg->length;
+		if (!sg_is_last(sg) && (sg + 1)->length == 0 && chained)
+			*chained = true;
+		sg = scatterwalk_sg_next(sg);
+	}
+
+	return sg_nents;
+}
+
+struct scatterlist *
+qce_sgtable_add(struct sg_table *sgt, struct scatterlist *new_sgl)
+{
+	struct scatterlist *sg = sgt->sgl, *sg_last = NULL;
+
+	while (sg) {
+		if (!sg_page(sg))
+			break;
+		sg = sg_next(sg);
+	}
+
+	if (!sg)
+		goto error;
+
+	while (new_sgl && sg) {
+		sg_set_page(sg, sg_page(new_sgl), new_sgl->length,
+			    new_sgl->offset);
+		sg_last = sg;
+		sg = sg_next(sg);
+		new_sgl = sg_next(new_sgl);
+	}
+
+	if (new_sgl)
+		goto error;
+
+	return sg_last;
+error:
+	return ERR_PTR(-EINVAL);
+}
+
+static int qce_dma_prep_sg(struct dma_chan *chan, struct scatterlist *sg,
+			   int nents, unsigned long flags,
+			   enum dma_transfer_direction dir,
+			   dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_async_tx_descriptor *desc;
+
+	if (!sg || !nents)
+		return -EINVAL;
+
+	desc = dmaengine_prep_slave_sg(chan, sg, nents, dir, flags);
+	if (!desc)
+		return -EINVAL;
+
+	desc->callback = cb;
+	desc->callback_param = cb_param;
+	dmaengine_submit(desc);
+	return 0;
+}
+
+int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *rx_sg,
+		     int rx_nents, struct scatterlist *tx_sg, int tx_nents,
+		     dma_async_tx_callback cb, void *cb_param)
+{
+	struct dma_chan *rxchan = dma->rxchan;
+	struct dma_chan *txchan = dma->txchan;
+	unsigned long flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
+	int rc;
+
+	rc = qce_dma_prep_sg(rxchan, rx_sg, rx_nents, flags, DMA_MEM_TO_DEV,
+			     NULL, NULL);
+	if (rc)
+		return rc;
+
+	rc = qce_dma_prep_sg(txchan, tx_sg, tx_nents, flags, DMA_DEV_TO_MEM,
+			     cb, cb_param);
+
+	return rc;
+}
+
+void qce_dma_issue_pending(struct qce_dma_data *dma)
+{
+	dma_async_issue_pending(dma->rxchan);
+	dma_async_issue_pending(dma->txchan);
+}
+
+void qce_dma_terminate_all(struct qce_dma_data *dma)
+{
+	dmaengine_terminate_all(dma->rxchan);
+	dmaengine_terminate_all(dma->txchan);
+}
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
new file mode 100644
index 000000000000..932b02fd8f25
--- /dev/null
+++ b/drivers/crypto/qce/dma.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2011-2014, The Linux Foundation. All rights reserved.
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
+#ifndef _DMA_H_
+#define _DMA_H_
+
+#define QCE_AUTHIV_REGS_CNT		16
+#define QCE_AUTH_BYTECOUNT_REGS_CNT	4
+#define QCE_CNTRIV_REGS_CNT		4
+
+/* result dump format */
+struct qce_result_dump {
+	u32 auth_iv[QCE_AUTHIV_REGS_CNT];
+	u32 auth_byte_count[QCE_AUTH_BYTECOUNT_REGS_CNT];
+	u32 encr_cntr_iv[QCE_CNTRIV_REGS_CNT];
+	u32 status;
+	u32 status2;
+};
+
+#define QCE_IGNORE_BUF_SZ	(2 * QCE_BAM_BURST_SIZE)
+#define QCE_RESULT_BUF_SZ	\
+		ALIGN(sizeof(struct qce_result_dump), QCE_BAM_BURST_SIZE)
+
+struct qce_dma_data {
+	struct dma_chan *txchan;
+	struct dma_chan *rxchan;
+	struct qce_result_dump *result_buf;
+	void *ignore_buf;
+};
+
+int qce_dma_request(struct device *dev, struct qce_dma_data *dma);
+void qce_dma_release(struct qce_dma_data *dma);
+int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
+		     int in_ents, struct scatterlist *sg_out, int out_ents,
+		     dma_async_tx_callback cb, void *cb_param);
+int qce_countsg(struct scatterlist *sg_list, int nbytes, bool *chained);
+void qce_unmapsg(struct device *dev, struct scatterlist *sg, int nents,
+		     enum dma_data_direction dir, bool chained);
+int qce_mapsg(struct device *dev, struct scatterlist *sg,
+		  unsigned int nents, enum dma_data_direction dir,
+		  bool chained);
+struct scatterlist *qce_sgtable_add(struct sg_table *sgt,
+				     struct scatterlist *sg_add);
+void qce_dma_issue_pending(struct qce_dma_data *dma);
+void qce_dma_terminate_all(struct qce_dma_data *dma);
+
+#endif /* _DMA_H_ */
-- 
1.8.4.4

