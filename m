Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432Ab3GQWzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56555 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab3GQWzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Osipenko <digetx@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 090/145] dma: tegra: avoid channel lock up after free
Date: Wed, 17 Jul 2013 15:47:02 -0700
Message-Id: <1374101277-7915-91-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <digetx@gmail.com>

commit 7bdc1e272a471062e8f310137c896e2355b46d13 upstream.

Lock scenario: Channel 1 was allocated and prepared as slave_sg, used and freed.
Now preparation of cyclic dma on channel 1 will fail with err "DMA configuration
conflict" because tdc->isr_handler still setted to handle_once_dma_done.

This happens because tegra_dma_abort_all() won't be called on channel freeing
if pending list is empty and channel not busy. We need to clear isr_handler
on channel freeing to avoid locking.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/tegra20-apb-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index 3cad856..b9e32fe 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -1158,6 +1158,7 @@ static void tegra_dma_free_chan_resources(struct dma_chan *dc)
 	list_splice_init(&tdc->free_dma_desc, &dma_desc_list);
 	INIT_LIST_HEAD(&tdc->cb_desc);
 	tdc->config_init = false;
+	tdc->isr_handler = NULL;
 	spin_unlock_irqrestore(&tdc->lock, flags);
 
 	while (!list_empty(&dma_desc_list)) {
-- 
1.8.1.2

