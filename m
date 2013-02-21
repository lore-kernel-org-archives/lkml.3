Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab3BURQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:16:40 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:64751 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab3BURQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:16:38 -0500
From: sjur.brandeland@stericsson.com
To: Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: [PATCHv2 10/10] remoteproc: Set vring addresses in resource table
Date: Thu, 21 Feb 2013 18:15:40 +0100
Message-Id: <1361466940-6813-11-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

Set the vring addresses in the resource table so that
the remote device can read the actual addresses used.

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
---
 drivers/remoteproc/remoteproc_core.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 93529e3..63f3d07 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -194,6 +194,7 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	struct rproc *rproc = rvdev->rproc;
 	struct device *dev = &rproc->dev;
 	struct rproc_vring *rvring = &rvdev->vring[i];
+	struct fw_rsc_vdev *rsc;
 	dma_addr_t dma;
 	void *va;
 	int ret, size, notifyid;
@@ -209,7 +210,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/*
 	 * Allocate non-cacheable memory for the vring. In the future
 	 * this call will also configure the IOMMU for us
-	 * TODO: let the rproc know the da of this vring
 	 */
 	va = dma_alloc_coherent(dev->parent, size, &dma, GFP_KERNEL);
 	if (!va) {
@@ -220,7 +220,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/*
 	 * Assign an rproc-wide unique index for this vring
 	 * TODO: assign a notifyid for rvdev updates as well
-	 * TODO: let the rproc know the notifyid of this vring
 	 * TODO: support predefined notifyids (via resource table)
 	 */
 	ret = idr_get_new(&rproc->notifyids, rvring, &notifyid);
@@ -237,6 +236,15 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	rvring->dma = dma;
 	rvring->notifyid = notifyid;
 
+	/*
+	 * Let the rproc know the notifyid and da of this vring.
+	 * Not all platforms use dma_alloc_coherent to automatically
+	 * set up the iommu. In this case the device address (da) will
+	 * hold the physical address and not the device address.
+	 */
+	rsc = (void *)rproc->rsc + rvdev->rsc_offset;
+	rsc->vring[i].da = dma;
+	rsc->vring[i].notifyid = notifyid;
 	return 0;
 }
 
@@ -275,9 +283,16 @@ void rproc_free_vring(struct rproc_vring *rvring)
 {
 	int size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 	struct rproc *rproc = rvring->rvdev->rproc;
+	int idx = rvring->rvdev->vring - rvring;
+	struct fw_rsc_vdev *rsc;
 
 	dma_free_coherent(rproc->dev.parent, size, rvring->va, rvring->dma);
 	idr_remove(&rproc->notifyids, rvring->notifyid);
+
+	/* reset resource entry info */
+	rsc = (void *)rproc->rsc + rvring->rvdev->rsc_offset;
+	rsc->vring[idx].da = 0;
+	rsc->vring[idx].notifyid = -1;
 }
 
 /**
-- 
1.7.5.4

