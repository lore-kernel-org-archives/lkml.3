Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926Ab3JIL7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:59:34 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10146 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3JIL6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:58:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 09 Oct 2013 04:58:47 -0700
From: Arto Merilainen <amerilainen@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@gmail.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>
Subject: [PATCH 1/3] gpu: host1x: Add syncpoint base support
Date: Wed, 9 Oct 2013 14:54:08 +0300
Message-ID: <1381319650-9799-2-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com>
References: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for hardware syncpoint bases. This creates
a simple mechanism for waiting an operation to complete in the middle
of the command buffer.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/gpu/host1x/dev.h                   |  2 ++
 drivers/gpu/host1x/hw/channel_hw.c         | 19 +++++++++++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h |  6 ++++
 drivers/gpu/host1x/syncpt.c                | 55 +++++++++++++++++++++++++++---
 drivers/gpu/host1x/syncpt.h                | 10 ++++++
 5 files changed, 87 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index bed90a8..89a3c1e 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -26,6 +26,7 @@
 #include "cdma.h"
 #include "job.h"
 
+struct host1x_base;
 struct host1x_syncpt;
 struct host1x_channel;
 struct host1x_cdma;
@@ -102,6 +103,7 @@ struct host1x {
 
 	void __iomem *regs;
 	struct host1x_syncpt *syncpt;
+	struct host1x_base *bases;
 	struct device *dev;
 	struct clk *clk;
 
diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
index ee19962..5f9f735 100644
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
+				host1x_uclass_load_syncpt_base_r(), 1),
+			 host1x_uclass_load_syncpt_base_base_indx_f(base_id) |
+			 host1x_uclass_load_syncpt_base_value_f(base_val));
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
index 409745b..48927b1 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -30,9 +30,32 @@
 #define SYNCPT_CHECK_PERIOD (2 * HZ)
 #define MAX_STUCK_CHECK_COUNT 15
 
+static struct host1x_base *host1x_base_alloc(struct host1x *host)
+{
+	struct host1x_base *base = host->bases;
+	int i;
+
+	for (i = 0; i < host->info->nb_bases && base->reserved; i++, base++)
+		;
+
+	if (i >= host->info->nb_bases)
+		return NULL;
+
+	base->reserved = true;
+	return base;
+}
+
+static void host1x_base_free(struct host1x_base *base)
+{
+	if (!base)
+		return;
+	base->reserved = false;
+}
+
 static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
 						  struct device *dev,
-						  bool client_managed)
+						  bool client_managed,
+						  bool support_base)
 {
 	int i;
 	struct host1x_syncpt *sp = host->syncpt;
@@ -44,6 +67,12 @@ static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
 	if (i >= host->info->nb_pts)
 		return NULL;
 
+	if (support_base) {
+		sp->base = host1x_base_alloc(host);
+		if (!sp->base)
+			return NULL;
+	}
+
 	name = kasprintf(GFP_KERNEL, "%02d-%s", sp->id,
 			dev ? dev_name(dev) : NULL);
 	if (!name)
@@ -304,24 +333,31 @@ int host1x_syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr)
 int host1x_syncpt_init(struct host1x *host)
 {
 	struct host1x_syncpt *syncpt;
+	struct host1x_base *bases;
 	int i;
 
+	bases = devm_kzalloc(host->dev, sizeof(*bases) * host->info->nb_bases,
+		GFP_KERNEL);
 	syncpt = devm_kzalloc(host->dev, sizeof(*syncpt) * host->info->nb_pts,
 		GFP_KERNEL);
-	if (!syncpt)
+	if (!syncpt || !bases)
 		return -ENOMEM;
 
-	for (i = 0; i < host->info->nb_pts; ++i) {
+	for (i = 0; i < host->info->nb_bases; i++)
+		bases[i].id = i;
+
+	for (i = 0; i < host->info->nb_pts; i++) {
 		syncpt[i].id = i;
 		syncpt[i].host = host;
 	}
 
 	host->syncpt = syncpt;
+	host->bases = bases;
 
 	host1x_syncpt_restore(host);
 
 	/* Allocate sync point to use for clearing waits for expired fences */
-	host->nop_sp = _host1x_syncpt_alloc(host, NULL, false);
+	host->nop_sp = _host1x_syncpt_alloc(host, NULL, false, false);
 	if (!host->nop_sp)
 		return -ENOMEM;
 
@@ -332,7 +368,14 @@ struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
 					    bool client_managed)
 {
 	struct host1x *host = dev_get_drvdata(dev->parent);
-	return _host1x_syncpt_alloc(host, dev, client_managed);
+	return _host1x_syncpt_alloc(host, dev, client_managed, false);
+}
+
+struct host1x_syncpt *host1x_syncpt_request_based(struct device *dev,
+						  bool client_managed)
+{
+	struct host1x *host = dev_get_drvdata(dev->parent);
+	return _host1x_syncpt_alloc(host, dev, client_managed, true);
 }
 
 void host1x_syncpt_free(struct host1x_syncpt *sp)
@@ -340,7 +383,9 @@ void host1x_syncpt_free(struct host1x_syncpt *sp)
 	if (!sp)
 		return;
 
+	host1x_base_free(sp->base);
 	kfree(sp->name);
+	sp->base = NULL;
 	sp->dev = NULL;
 	sp->name = NULL;
 	sp->client_managed = false;
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index 267c0b9..852dc76 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -30,6 +30,11 @@ struct host1x;
 /* Reserved for replacing an expired wait with a NOP */
 #define HOST1X_SYNCPT_RESERVED			0
 
+struct host1x_base {
+	u8 id;
+	bool reserved;
+};
+
 struct host1x_syncpt {
 	int id;
 	atomic_t min_val;
@@ -39,6 +44,7 @@ struct host1x_syncpt {
 	bool client_managed;
 	struct host1x *host;
 	struct device *dev;
+	struct host1x_base *base;
 
 	/* interrupt data */
 	struct host1x_syncpt_intr intr;
@@ -156,6 +162,10 @@ u32 host1x_syncpt_id(struct host1x_syncpt *sp);
 struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
 					    bool client_managed);
 
+/* Allocate a sync point and a base for a device */
+struct host1x_syncpt *host1x_syncpt_request_based(struct device *dev,
+						  bool client_managed);
+
 /* Free a sync point. */
 void host1x_syncpt_free(struct host1x_syncpt *sp);
 
-- 
1.8.1.5

