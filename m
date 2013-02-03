Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3BCBWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:40 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:55395 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab3BCBWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:37 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 42/62] remoteproc: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:43 -0800
Message-Id: <1359854463-2538-43-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/remoteproc/remoteproc_core.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 634d367..29387df 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -199,11 +199,6 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	/* actual size of vring (in bytes) */
 	size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 
-	if (!idr_pre_get(&rproc->notifyids, GFP_KERNEL)) {
-		dev_err(dev, "idr_pre_get failed\n");
-		return -ENOMEM;
-	}
-
 	/*
 	 * Allocate non-cacheable memory for the vring. In the future
 	 * this call will also configure the IOMMU for us
@@ -221,12 +216,13 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	 * TODO: let the rproc know the notifyid of this vring
 	 * TODO: support predefined notifyids (via resource table)
 	 */
-	ret = idr_get_new(&rproc->notifyids, rvring, &notifyid);
+	ret = idr_alloc(&rproc->notifyids, rvring, 0, 0, GFP_KERNEL);
 	if (ret) {
-		dev_err(dev, "idr_get_new failed: %d\n", ret);
+		dev_err(dev, "idr_alloc failed: %d\n", ret);
 		dma_free_coherent(dev->parent, size, va, dma);
 		return ret;
 	}
+	notifyid = ret;
 
 	/* Store largest notifyid */
 	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
-- 
1.8.1

