Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965616Ab3E2K14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 06:27:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13505 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965596Ab3E2K1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 06:27:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 May 2013 03:27:40 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <thierry.reding@gmail.com>, <airlied@linux.ie>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <tbergstrom@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: [PATCHv2 3/7] gpu: host1x: Don't reset firewall between gathers
Date: Wed, 29 May 2013 13:26:04 +0300
Message-ID: <1369823168-5396-4-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
References: <1369823168-5396-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Terje Bergstrom <tbergstrom@nvidia.com>

The firewall was reinitialised for each gather. Because the filter
was reinitialised, it did not track the class over gather boundaries.
This allowed the user application to set host1x class to one class
in one gather and use that class in another gather without firewall
having knowledge about that.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/job.c | 73 ++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
index 83804fd..028d2d4 100644
--- a/drivers/gpu/host1x/job.c
+++ b/drivers/gpu/host1x/job.c
@@ -376,69 +376,60 @@ static int check_nonincr(struct host1x_firewall *fw)
 	return 0;
 }
 
-static int validate(struct host1x_job *job, struct device *dev,
-		    struct host1x_job_gather *g)
+static int validate(struct host1x_firewall *fw, struct host1x_job_gather *g)
 {
 	u32 *cmdbuf_base;
 	int err = 0;
-	struct host1x_firewall fw;
-
-	fw.job = job;
-	fw.dev = dev;
-	fw.reloc = job->relocarray;
-	fw.num_relocs = job->num_relocs;
-	fw.cmdbuf_id = g->bo;
-
-	fw.offset = 0;
-	fw.class = 0;
 
-	if (!job->is_addr_reg)
+	if (!fw->job->is_addr_reg)
 		return 0;
 
 	cmdbuf_base = host1x_bo_mmap(g->bo);
 	if (!cmdbuf_base)
 		return -ENOMEM;
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
@@ -453,12 +444,10 @@ static int validate(struct host1x_job *job, struct device *dev,
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
 
@@ -508,8 +497,15 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 	int err;
 	unsigned int i, j;
 	struct host1x *host = dev_get_drvdata(dev->parent);
+	struct host1x_firewall fw;
 	DECLARE_BITMAP(waitchk_mask, host1x_syncpt_nb_pts(host));
 
+	fw.job = job;
+	fw.dev = dev;
+	fw.reloc = job->relocarray;
+	fw.num_relocs = job->num_relocs;
+	fw.class = 0;
+
 	bitmap_zero(waitchk_mask, host1x_syncpt_nb_pts(host));
 	for (i = 0; i < job->num_waitchk; i++) {
 		u32 syncpt_id = job->waitchk[i].syncpt_id;
@@ -543,7 +539,7 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 		err = 0;
 
 		if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL))
-			err = validate(job, dev, g);
+			err = validate(&fw, g);
 
 		if (err)
 			dev_err(dev, "Job invalid (err=%d)\n", err);
@@ -553,7 +549,6 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
 
 		if (!err)
 			err = do_waitchks(job, host, g->bo);
-
 		if (err)
 			break;
 	}
-- 
1.8.1.5

