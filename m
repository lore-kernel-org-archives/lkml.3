Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965658Ab3E2K2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:28:51 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12065 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965604Ab3E2K1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:27:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 29 May 2013 03:27:55 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@gmail.com>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <tbergstrom@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCHv2 4/7] gpu: host1x: Copy gathers before verification
Date: Wed, 29 May 2013 13:26:05 +0300
Message-ID: <1369823168-5396-5-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The firewall verified gather buffers before copying them. This
allowed a malicious application to rewrite the buffer content by
timing the rewrite carefully.

This patch makes the buffer validation occur after copying the
buffers.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/job.c | 50 +++++++++++++++++++-----------------------------
 1 file changed, 20 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 028d2d4..cc80766 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -228,17 +228,15 @@ static unsigned int do_relocs(struct host1x_job *job, struct host1x_bo *cmdbuf)
 	void *cmdbuf_page_addr = NULL;
 
 	/* pin & patch the relocs for one gather */
-	while (i < job->num_relocs) {
+	for (i = 0; i < job->num_relocs; i++) {
 		struct host1x_reloc *reloc = &job->relocarray[i];
 		u32 reloc_addr = (job->reloc_addr_phys[i] +
 			reloc->target_offset) >> reloc->shift;
 		u32 *target;
 
 		/* skip all other gathers */
-		if (!(reloc->cmdbuf && cmdbuf == reloc->cmdbuf)) {
-			i++;
+		if (cmdbuf != reloc->cmdbuf)
 			continue;
-		}
 
 		if (last_page != reloc->cmdbuf_offset >> PAGE_SHIFT) {
 			if (cmdbuf_page_addr)
@@ -257,9 +255,6 @@ static unsigned int do_relocs(struct host1x_job *job, struct host1x_bo *cmdbuf)
 
 		target = cmdbuf_page_addr + (reloc->cmdbuf_offset & ~PAGE_MASK);
 		*target = reloc_addr;
-
-		/* mark this gather as handled */
-		reloc->cmdbuf = 0;
 	}
 
 	if (cmdbuf_page_addr)
@@ -378,15 +373,13 @@ static int check_nonincr(struct host1x_firewall *fw)
 
 static int validate(struct host1x_firewall *fw, struct host1x_job_gather *g)
 {
-	u32 *cmdbuf_base;
+	u32 *cmdbuf_base = (u32 *)fw->job->gather_copy_mapped +
+		(g->offset / sizeof(u32));
 	int err = 0;
 
 	if (!fw->job->is_addr_reg)
 		return 0;
 
-	cmdbuf_base = host1x_bo_mmap(g->bo);
-	if (!cmdbuf_base)
-		return -ENOMEM;
 	fw->words = g->words;
 	fw->cmdbuf_id = g->bo;
 	fw->offset = 0;
@@ -453,10 +446,17 @@ out:
 
 static inline int copy_gathers(struct host1x_job *job, struct device *dev)
 {
+	struct host1x_firewall fw;
 	size_t size = 0;
 	size_t offset = 0;
 	int i;
 
+	fw.job = job;
+	fw.dev = dev;
+	fw.reloc = job->relocarray;
+	fw.num_relocs = job->num_relocs;
+	fw.class = 0;
+
 	for (i = 0; i < job->num_gathers; i++) {
 		struct host1x_job_gather *g = &job->gathers[i];
 		size += g->words * sizeof(u32);
@@ -477,14 +477,19 @@ static inline int copy_gathers(struct host1x_job *job, struct device *dev)
 		struct host1x_job_gather *g = &job->gathers[i];
 		void *gather;
 
+		/* Copy the gather */
 		gather = host1x_bo_mmap(g->bo);
 		memcpy(job->gather_copy_mapped + offset, gather + g->offset,
 		       g->words * sizeof(u32));
 		host1x_bo_munmap(g->bo, gather);
 
+		/* Store the location in the buffer */
 		g->base = job->gather_copy;
 		g->offset = offset;
-		g->bo = NULL;
+
+		/* Validate the job */
+		if (validate(&fw, g))
+			return -EINVAL;
 
 		offset += g->words * sizeof(u32);
 	}
@@ -497,15 +502,8 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 	int err;
 	unsigned int i, j;
 	struct host1x *host = dev_get_drvdata(dev->parent);
-	struct host1x_firewall fw;
 	DECLARE_BITMAP(waitchk_mask, host1x_syncpt_nb_pts(host));
 
-	fw.job = job;
-	fw.dev = dev;
-	fw.reloc = job->relocarray;
-	fw.num_relocs = job->num_relocs;
-	fw.class = 0;
-
 	bitmap_zero(waitchk_mask, host1x_syncpt_nb_pts(host));
 	for (i = 0; i < job->num_waitchk; i++) {
 		u32 syncpt_id = job->waitchk[i].syncpt_id;
@@ -536,19 +534,11 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 			if (job->gathers[j].bo == g->bo)
 				job->gathers[j].handled = true;
 
-		err = 0;
-
-		if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL))
-			err = validate(&fw, g);
-
+		err = do_relocs(job, g->bo);
 		if (err)
-			dev_err(dev, "Job invalid (err=%d)\n", err);
-
-		if (!err)
-			err = do_relocs(job, g->bo);
+			break;
 
-		if (!err)
-			err = do_waitchks(job, host, g->bo);
+		err = do_waitchks(job, host, g->bo);
 		if (err)
 			break;
 	}
-- 
1.8.1.5

