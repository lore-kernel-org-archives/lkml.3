Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3EQLwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 07:52:22 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11181 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3EQLwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 07:52:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 17 May 2013 04:48:28 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@avionic-design.de>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCH 1/6] gpu: host1x: Fixes to host1x firewall
Date: Fri, 17 May 2013 14:49:43 +0300
Message-ID: <1368791388-31441-2-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Terje Bergstrom <tbergstrom@nvidia.com>

This patch adds several fixes to host1x firewall:
- Host1x firewall does not survive if it expects a reloc, but user
  space didn't pass any relocs. Also it reset the reloc table for
  each gather, whereas they should be reset only per submit. Also
  class does not need to be reset for each class - once per submit
  is enough.
- For INCR opcode the check was not working properly at all.
- The firewall verified gather buffers before copying them. This
  allowed a malicious application to rewrite the buffer content by
  timing the rewrite carefully. This patch makes the buffer
  validation occur after copying the buffers.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/job.c |  120 ++++++++++++++++++++--------------------------
 1 file changed, 53 insertions(+), 67 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index f665d67..4f3c004 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -228,17 +228,15 @@ static unsigned int do_relocs(struct host1x_job *job, struct host1x_bo *cmdbuf)
 	void *cmdbuf_page_addr = NULL;
 
 	/* pin & patch the relocs for one gather */
-	while (i < job->num_relocs) {
+	for (i = 0; i < job->num_relocs; ++i) {
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
@@ -268,15 +263,15 @@ static unsigned int do_relocs(struct host1x_job *job, struct host1x_bo *cmdbuf)
 	return 0;
 }
 
-static int check_reloc(struct host1x_reloc *reloc, struct host1x_bo *cmdbuf,
-		       unsigned int offset)
+static bool check_reloc(struct host1x_reloc *reloc, struct host1x_bo *cmdbuf,
+			unsigned int offset)
 {
 	offset *= sizeof(u32);
 
-	if (reloc->cmdbuf != cmdbuf || reloc->cmdbuf_offset != offset)
-		return -EINVAL;
+	if (!reloc || reloc->cmdbuf != cmdbuf || reloc->cmdbuf_offset != offset)
+		return true;
 
-	return 0;
+	return false;
 }
 
 struct host1x_firewall {
@@ -330,7 +325,7 @@ static int check_incr(struct host1x_firewall *fw)
 	u32 count = fw->count;
 	u32 reg = fw->reg;
 
-	while (fw) {
+	while (count) {
 		if (fw->words == 0)
 			return -EINVAL;
 
@@ -376,69 +371,58 @@ static int check_nonincr(struct host1x_firewall *fw)
 	return 0;
 }
 
-static int validate(struct host1x_job *job, struct device *dev,
-		    struct host1x_job_gather *g)
+static int validate_gather(struct host1x_firewall *fw,
+			   struct host1x_job_gather *g)
 {
-	u32 *cmdbuf_base;
+	u32 *cmdbuf_base = (u32 *)fw->job->gather_copy_mapped + (g->offset / 4);
 	int err = 0;
-	struct host1x_firewall fw;
 
-	fw.job = job;
-	fw.dev = dev;
-	fw.reloc = job->relocarray;
-	fw.num_relocs = job->num_relocs;
-	fw.cmdbuf_id = g->bo;
-
-	fw.offset = 0;
-	fw.class = 0;
-
-	if (!job->is_addr_reg)
+	if (!fw->job->is_addr_reg)
 		return 0;
 
-	cmdbuf_base = host1x_bo_mmap(g->bo);
-	if (!cmdbuf_base)
-		return -ENOMEM;
+	fw->words = g->words;
+	fw->cmdbuf_id = g->bo;
+	fw->offset = 0;
 
-	fw.words = g->words;
-	while (fw.words && !err) {
-		u32 word = cmdbuf_base[fw.offset];
+	while (fw->words && !err) {
+		u32 word = cmdbuf_base[fw->offset];
 		u32 opcode = (word & 0xf0000000) >> 28;
 
-		fw.mask = 0;
-		fw.reg = 0;
-		fw.count = 0;
-		fw.words--;
-		fw.offset++;
+		fw->mask = 0;
+		fw->reg = 0;
+		fw->count = 0;
+		fw->words--;
+		fw->offset++;
 
 		switch (opcode) {
 		case 0:
-			fw.class = word >> 6 & 0x3ff;
-			fw.mask = word & 0x3f;
-			fw.reg = word >> 16 & 0xfff;
-			err = check_mask(&fw);
+			fw->class = word >> 6 & 0x3ff;
+			fw->mask = word & 0x3f;
+			fw->reg = word >> 16 & 0xfff;
+			err = check_mask(fw);
 			if (err)
 				goto out;
 			break;
 		case 1:
-			fw.reg = word >> 16 & 0xfff;
-			fw.count = word & 0xffff;
-			err = check_incr(&fw);
+			fw->reg = word >> 16 & 0xfff;
+			fw->count = word & 0xffff;
+			err = check_incr(fw);
 			if (err)
 				goto out;
 			break;
 
 		case 2:
-			fw.reg = word >> 16 & 0xfff;
-			fw.count = word & 0xffff;
-			err = check_nonincr(&fw);
+			fw->reg = word >> 16 & 0xfff;
+			fw->count = word & 0xffff;
+			err = check_nonincr(fw);
 			if (err)
 				goto out;
 			break;
 
 		case 3:
-			fw.mask = word & 0xffff;
-			fw.reg = word >> 16 & 0xfff;
-			err = check_mask(&fw);
+			fw->mask = word & 0xffff;
+			fw->reg = word >> 16 & 0xfff;
+			err = check_mask(fw);
 			if (err)
 				goto out;
 			break;
@@ -453,21 +437,26 @@ static int validate(struct host1x_job *job, struct device *dev,
 	}
 
 	/* No relocs should remain at this point */
-	if (fw.num_relocs)
+	if (fw->num_relocs)
 		err = -EINVAL;
 
 out:
-	host1x_bo_munmap(g->bo, cmdbuf_base);
-
 	return err;
 }
 
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
@@ -488,14 +477,19 @@ static inline int copy_gathers(struct host1x_job *job, struct device *dev)
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
+		if (validate_gather(&fw, g))
+			return -EINVAL;
 
 		offset += g->words * sizeof(u32);
 	}
@@ -508,6 +502,7 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 	int err;
 	unsigned int i, j;
 	struct host1x *host = dev_get_drvdata(dev->parent);
+
 	DECLARE_BITMAP(waitchk_mask, host1x_syncpt_nb_pts(host));
 
 	bitmap_zero(waitchk_mask, host1x_syncpt_nb_pts(host));
@@ -540,20 +535,11 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 			if (job->gathers[j].bo == g->bo)
 				job->gathers[j].handled = true;
 
-		err = 0;
-
-		if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL))
-			err = validate(job, dev, g);
-
+		err = do_relocs(job, g->bo);
 		if (err)
-			dev_err(dev, "Job invalid (err=%d)\n", err);
-
-		if (!err)
-			err = do_relocs(job, g->bo);
-
-		if (!err)
-			err = do_waitchks(job, host, g->bo);
+			break;
 
+		err = do_waitchks(job, host, g->bo);
 		if (err)
 			break;
 	}
-- 
1.7.9.5

