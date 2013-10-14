Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3JNM0Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 08:26:16 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18674 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3JNM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:26:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 14 Oct 2013 05:21:49 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCHv2 2/4] gpu: host1x: Add syncpoint base support
Date: Mon, 14 Oct 2013 15:21:53 +0300
Message-ID: <1381753315-21778-3-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
References: <1381753315-21778-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for hardware syncpoint bases. This creates
a simple mechanism to stall the command FIFO until an operation is
completed.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/dev.h                   |  2 ++
 drivers/gpu/host1x/hw/channel_hw.c         | 19 +++++++++++++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h |  6 ++++
 drivers/gpu/host1x/syncpt.c                | 44 ++++++++++++++++++++++++++++--
 drivers/gpu/host1x/syncpt.h                |  7 +++++
 5 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index bed90a8..516ce0a 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -27,6 +27,7 @@
 #include "job.h"
 
 struct host1x_syncpt;
+struct host1x_syncpt_base;
 struct host1x_channel;
 struct host1x_cdma;
 struct host1x_job;
@@ -102,6 +103,7 @@ struct host1x {
 
 	void __iomem *regs;
 	struct host1x_syncpt *syncpt;
+	struct host1x_syncpt_base *bases;
 	struct device *dev;
 	struct clk *clk;
 
diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
index ee19962..06f44bf 100644
--- a/drivers/gpu/host1x/hw/channel_hw.c
+++ b/drivers/gpu/host1x/hw/channel_hw.c
@@ -67,6 +67,21 @@ static void submit_gathers(struct host1x_job *job)
 	}
 }
 
+static inline void synchronize_syncpt_base(struct host1x_job *job)
+{
+	struct host1x_channel *ch = job->channel;
+	struct host1x *host = dev_get_drvdata(ch->dev->parent);
+	struct host1x_syncpt *sp = host->syncpt + job->syncpt_id;
+	u32 base_id = sp->base->id;
+	u32 base_val = host1x_syncpt_read_max(sp);
+
+	host1x_cdma_push(&ch->cdma,
+			 host1x_opcode_setclass(HOST1X_CLASS_HOST1X,
+				HOST1X_UCLASS_LOAD_SYNCPT_BASE, 1),
+			 HOST1X_UCLASS_LOAD_SYNCPT_BASE_BASE_INDX_F(base_id) |
+			 HOST1X_UCLASS_LOAD_SYNCPT_BASE_VALUE_F(base_val));
+}
+
 static int channel_submit(struct host1x_job *job)
 {
 	struct host1x_channel *ch = job->channel;
@@ -118,6 +133,10 @@ static int channel_submit(struct host1x_job *job)
 					host1x_syncpt_read_max(sp)));
 	}
 
+	/* Synchronize base register to allow using it for relative waiting */
+	if (sp->base)
+		synchronize_syncpt_base(job);
+
 	syncval = host1x_syncpt_incr_max(sp, user_syncpt_incrs);
 
 	job->syncpt_end = syncval;
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
index 42f3ce1..f755359 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
@@ -111,6 +111,12 @@ static inline u32 host1x_uclass_wait_syncpt_base_offset_f(u32 v)
 }
 #define HOST1X_UCLASS_WAIT_SYNCPT_BASE_OFFSET_F(v) \
 	host1x_uclass_wait_syncpt_base_offset_f(v)
+static inline u32 host1x_uclass_load_syncpt_base_r(void)
+{
+	return 0xb;
+}
+#define HOST1X_UCLASS_LOAD_SYNCPT_BASE \
+	host1x_uclass_load_syncpt_base_r()
 static inline u32 host1x_uclass_load_syncpt_base_base_indx_f(u32 v)
 {
 	return (v & 0xff) << 24;
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index d376cd4..b5cb97c 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -30,6 +30,28 @@
 #define SYNCPT_CHECK_PERIOD (2 * HZ)
 #define MAX_STUCK_CHECK_COUNT 15
 
+static struct host1x_syncpt_base *host1x_base_alloc(struct host1x *host)
+{
+	struct host1x_syncpt_base *bases = host->bases;
+	unsigned int i;
+
+	for (i = 0; i < host->info->nb_bases; i++)
+		if (!bases[i].requested)
+			break;
+
+	if (i >= host->info->nb_bases)
+		return NULL;
+
+	bases[i].requested = true;
+	return &bases[i];
+}
+
+static void host1x_syncpt_base_free(struct host1x_syncpt_base *base)
+{
+	if (base)
+		base->requested = false;
+}
+
 static struct host1x_syncpt *host1x_syncpt_alloc(struct host1x *host,
 						 struct device *dev,
 						 unsigned long flags)
@@ -44,6 +66,12 @@ static struct host1x_syncpt *host1x_syncpt_alloc(struct host1x *host,
 	if (i >= host->info->nb_pts)
 		return NULL;
 
+	if (flags & HOST1X_SYNCPT_HAS_BASE) {
+		sp->base = host1x_base_alloc(host);
+		if (!sp->base)
+			return NULL;
+	}
+
 	name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
 			dev ? dev_name(dev) : NULL);
 	if (!name)
@@ -304,19 +332,29 @@ int host1x_syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr)
 int host1x_syncpt_init(struct host1x *host)
 {
 	struct host1x_syncpt *syncpt;
+	struct host1x_syncpt_base *bases;
 	int i;
 
 	syncpt = devm_kzalloc(host->dev, sizeof(*syncpt) * host->info->nb_pts,
-		GFP_KERNEL);
+			      GFP_KERNEL);
 	if (!syncpt)
 		return -ENOMEM;
 
-	for (i = 0; i < host->info->nb_pts; ++i) {
+	bases = devm_kzalloc(host->dev, sizeof(*bases) * host->info->nb_bases,
+			     GFP_KERNEL);
+	if (!bases)
+		return -ENOMEM;
+
+	for (i = 0; i < host->info->nb_pts; i++) {
 		syncpt[i].id = i;
 		syncpt[i].host = host;
 	}
 
+	for (i = 0; i < host->info->nb_bases; i++)
+		bases[i].id = i;
+
 	host->syncpt = syncpt;
+	host->bases = bases;
 
 	host1x_syncpt_restore(host);
 
@@ -340,7 +378,9 @@ void host1x_syncpt_free(struct host1x_syncpt *sp)
 	if (!sp)
 		return;
 
+	host1x_syncpt_base_free(sp->base);
 	kfree(sp->name);
+	sp->base = NULL;
 	sp->dev = NULL;
 	sp->name = NULL;
 	sp->client_managed = false;
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index 1de7b58..28ec886 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -30,6 +30,11 @@ struct host1x;
 /* Reserved for replacing an expired wait with a NOP */
 #define HOST1X_SYNCPT_RESERVED			0
 
+struct host1x_syncpt_base {
+	unsigned int id;
+	bool requested;
+};
+
 struct host1x_syncpt {
 	int id;
 	atomic_t min_val;
@@ -39,6 +44,7 @@ struct host1x_syncpt {
 	bool client_managed;
 	struct host1x *host;
 	struct device *dev;
+	struct host1x_syncpt_base *base;
 
 	/* interrupt data */
 	struct host1x_syncpt_intr intr;
@@ -154,6 +160,7 @@ u32 host1x_syncpt_id(struct host1x_syncpt *sp);
 
 /* Allocate a sync point for a device. */
 #define HOST1X_SYNCPT_CLIENT_MANAGED	(1 << 0)
+#define HOST1X_SYNCPT_HAS_BASE		(1 << 1)
 struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
 					    unsigned long flags);
 
-- 
1.8.1.5

