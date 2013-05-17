Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3EQLw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:52:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18205 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755837Ab3EQLwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:52:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 17 May 2013 04:48:38 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCH 5/6] gpu: host1x: Rework CPU syncpoint increment
Date: Fri, 17 May 2013 14:49:47 +0300
Message-ID: <1368791388-31441-6-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch merges host1x_syncpt_cpu_incr to host1x_syncpt_incr() as
they are in practise doing the same thing. host1x_syncpt_incr() is also
modified to return error codes.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/dev.h          |    8 ++++----
 drivers/gpu/host1x/hw/cdma_hw.c   |    2 +-
 drivers/gpu/host1x/hw/syncpt_hw.c |   12 +++++-------
 drivers/gpu/host1x/syncpt.c       |   15 ++-------------
 drivers/gpu/host1x/syncpt.h       |    7 ++-----
 5 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index a1607d6..790ddf1 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -73,7 +73,7 @@ struct host1x_syncpt_ops {
 	void (*restore_wait_base)(struct host1x_syncpt *syncpt);
 	void (*load_wait_base)(struct host1x_syncpt *syncpt);
 	u32 (*load)(struct host1x_syncpt *syncpt);
-	void (*cpu_incr)(struct host1x_syncpt *syncpt);
+	int (*cpu_incr)(struct host1x_syncpt *syncpt);
 	int (*patch_wait)(struct host1x_syncpt *syncpt, void *patch_addr);
 };
 
@@ -157,10 +157,10 @@ static inline u32 host1x_hw_syncpt_load(struct host1x *host,
 	return host->syncpt_op->load(sp);
 }
 
-static inline void host1x_hw_syncpt_cpu_incr(struct host1x *host,
-					     struct host1x_syncpt *sp)
+static inline int host1x_hw_syncpt_cpu_incr(struct host1x *host,
+					    struct host1x_syncpt *sp)
 {
-	host->syncpt_op->cpu_incr(sp);
+	return host->syncpt_op->cpu_incr(sp);
 }
 
 static inline int host1x_hw_syncpt_patch_wait(struct host1x *host,
diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 590b69d..2ee4ad5 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -44,7 +44,7 @@ static void cdma_timeout_cpu_incr(struct host1x_cdma *cdma, u32 getptr,
 	u32 i;
 
 	for (i = 0; i < syncpt_incrs; i++)
-		host1x_syncpt_cpu_incr(cdma->timeout.syncpt);
+		host1x_syncpt_incr(cdma->timeout.syncpt);
 
 	/* after CPU incr, ensure shadow is up to date */
 	host1x_syncpt_load(cdma->timeout.syncpt);
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index 6117499..0cf6095 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -77,21 +77,19 @@ static u32 syncpt_load(struct host1x_syncpt *sp)
  * Write a cpu syncpoint increment to the hardware, without touching
  * the cache.
  */
-static void syncpt_cpu_incr(struct host1x_syncpt *sp)
+static int syncpt_cpu_incr(struct host1x_syncpt *sp)
 {
 	struct host1x *host = sp->host;
 	u32 reg_offset = sp->id / 32;
 
 	if (!host1x_syncpt_client_managed(sp) &&
-	    host1x_syncpt_idle(sp)) {
-		dev_err(host->dev, "Trying to increment syncpoint id %d beyond max\n",
-			sp->id);
-		host1x_debug_dump(sp->host);
-		return;
-	}
+	    host1x_syncpt_idle(sp))
+		return -EINVAL;
 	host1x_sync_writel(host, BIT_MASK(sp->id),
 			   HOST1X_SYNC_SYNCPT_CPU_INCR(reg_offset));
 	wmb();
+
+	return 0;
 }
 
 /* remove a wait pointed to by patch_addr */
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index e560d67..afb631a 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -128,22 +128,11 @@ u32 host1x_syncpt_load_wait_base(struct host1x_syncpt *sp)
 }
 
 /*
- * Write a cpu syncpoint increment to the hardware, without touching
- * the cache. Caller is responsible for host being powered.
- */
-void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp)
-{
-	host1x_hw_syncpt_cpu_incr(sp->host, sp);
-}
-
-/*
  * Increment syncpoint value from cpu, updating cache
  */
-void host1x_syncpt_incr(struct host1x_syncpt *sp)
+int host1x_syncpt_incr(struct host1x_syncpt *sp)
 {
-	if (host1x_syncpt_client_managed(sp))
-		host1x_syncpt_incr_max(sp, 1);
-	host1x_syncpt_cpu_incr(sp);
+	return host1x_hw_syncpt_cpu_incr(sp->host, sp);
 }
 
 /*
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index d00e758..267c0b9 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -115,9 +115,6 @@ static inline bool host1x_syncpt_idle(struct host1x_syncpt *sp)
 /* Return pointer to struct denoting sync point id. */
 struct host1x_syncpt *host1x_syncpt_get(struct host1x *host, u32 id);
 
-/* Request incrementing a sync point. */
-void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp);
-
 /* Load current value from hardware to the shadow register. */
 u32 host1x_syncpt_load(struct host1x_syncpt *sp);
 
@@ -133,8 +130,8 @@ void host1x_syncpt_restore(struct host1x *host);
 /* Read current wait base value into shadow register and return it. */
 u32 host1x_syncpt_load_wait_base(struct host1x_syncpt *sp);
 
-/* Increment sync point and its max. */
-void host1x_syncpt_incr(struct host1x_syncpt *sp);
+/* Request incrementing a sync point. */
+int host1x_syncpt_incr(struct host1x_syncpt *sp);
 
 /* Indicate future operations by incrementing the sync point max. */
 u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs);
-- 
1.7.9.5

