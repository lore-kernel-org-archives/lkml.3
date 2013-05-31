Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3EaVWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:22:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36352 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab3EaVV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:21:59 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <linux-kernel@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCH 3/3] remoteproc: free carveout memories only after unmapping them
Date: Fri, 31 May 2013 16:16:24 -0500
Message-ID: <1370034984-29636-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not preferable to have the allocated pages for carveout
memories freed before they are unmapped. The code that deals
with the cleanup of carveout memories is therefore moved after
the corresponding mapping entries were cleaned up.

This is mostly a no-op since the remote processors are already
stopped when the cleanup function is called, but this will make
the cleanup code follow the exact reverse path of allocation.

Signed-off-by: Suman Anna <s-anna@ti.com>
---
 drivers/remoteproc/remoteproc_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index bc078c0..1ea7460 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -762,14 +762,6 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 		kfree(entry);
 	}
 
-	/* clean up carveout allocations */
-	list_for_each_entry_safe(entry, tmp, &rproc->carveouts, node) {
-		dma_free_coherent(dev->parent, entry->len, entry->va,
-								entry->dma);
-		list_del(&entry->node);
-		kfree(entry);
-	}
-
 	/* clean up iommu mapping entries */
 	list_for_each_entry_safe(entry, tmp, &rproc->mappings, node) {
 		size_t unmapped;
@@ -784,6 +776,14 @@ static void rproc_resource_cleanup(struct rproc *rproc)
 		list_del(&entry->node);
 		kfree(entry);
 	}
+
+	/* clean up carveout allocations */
+	list_for_each_entry_safe(entry, tmp, &rproc->carveouts, node) {
+		dma_free_coherent(dev->parent, entry->len, entry->va,
+								entry->dma);
+		list_del(&entry->node);
+		kfree(entry);
+	}
 }
 
 /*
-- 
1.8.2

