Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaKRRuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:50:13 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:36071 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbaKRRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:50:06 -0500
From: Stephane Viau <sviau@codeaurora.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        robdclark@gmail.com, Stephane Viau <sviau@codeaurora.org>
Subject: [PATCH 1/3] drm/msm/mdp5: make SMP module dynamically configurable
Date: Tue, 18 Nov 2014 12:49:47 -0500
Message-Id: <1416332989-685-2-git-send-email-sviau@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1416332989-685-1-git-send-email-sviau@codeaurora.org>
References: <1416332989-685-1-git-send-email-sviau@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Shared Memory Pool (SMP) has its own limitation, features and
state. Some examples are:
 - the number of Memory Macro Block (MMB) and their size
 - the number of lines that can be fetched
 - the state of MMB currently allocated
 - the computation of number of blocks required per plane
 - client IDs ...

In order to avoid private data to be overwritten by other modules,
let's make these private to the SMP module.

Some of these depend on the hardware configuration, let's add them
to the mdp5_config struct.

In some hw configurations, some MMBs are statically tied to RGB
pipes and cannot be re-allocated dynamically. This change
introduces the concept of MMB static usage and makes sure that
dynamic MMB requests are dimensioned accordingly.

A note on passing a pipe pointer, instead of client IDs:
Client IDs are SMP-related information. Passing PIPE information
to SMP lets SMP module to find out which SMP client(s) are used.
This allows the SMP module to access the PIPE pointer, which can
be used for FIFO watermark configuration.
By the way, even though REG_MDP5_PIPE_REQPRIO_FIFO_WM_* registers
are part of the PIPE registers, their functionality is to reflect
the behavior of the SMP block. These registers access is now
restricted to the SMP module.

Signed-off-by: Stephane Viau <sviau@codeaurora.org>
---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c   |  28 +++-
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h   |  34 ++---
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c |  92 ++----------
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c   | 242 +++++++++++++++++++++++++-----
 drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h   |  22 +--
 5 files changed, 265 insertions(+), 153 deletions(-)

diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
index f2c15bd..0d6306d 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.c
@@ -30,6 +30,10 @@ const struct mdp5_config *mdp5_cfg;
 
 static const struct mdp5_config msm8x74_config = {
 	.name = "msm8x74",
+	.smp = {
+		.mmb_count = 22,
+		.mmb_size = 4096,
+	},
 	.ctl = {
 		.count = 5,
 		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
@@ -67,6 +71,15 @@ static const struct mdp5_config msm8x74_config = {
 
 static const struct mdp5_config apq8084_config = {
 	.name = "apq8084",
+	.smp = {
+		.mmb_count = 44,
+		.mmb_size = 8192,
+		.reserved_state[0] = GENMASK(7, 0),	/* first 8 MMBs */
+		.reserved[CID_RGB0] = 2,
+		.reserved[CID_RGB1] = 2,
+		.reserved[CID_RGB2] = 2,
+		.reserved[CID_RGB3] = 2,
+	},
 	.ctl = {
 		.count = 5,
 		.base = { 0x00600, 0x00700, 0x00800, 0x00900, 0x00a00 },
@@ -222,11 +235,15 @@ static void mdp5_destroy(struct msm_kms *kms)
 {
 	struct mdp5_kms *mdp5_kms = to_mdp5_kms(to_mdp_kms(kms));
 	struct msm_mmu *mmu = mdp5_kms->mmu;
+	void *smp = mdp5_kms->smp_priv;
 
 	if (mmu) {
 		mmu->funcs->detach(mmu, iommu_ports, ARRAY_SIZE(iommu_ports));
 		mmu->funcs->destroy(mmu);
 	}
+	if (smp)
+		mdp5_smp_destroy(smp);
+
 	kfree(mdp5_kms);
 }
 
@@ -363,6 +380,7 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	struct mdp5_kms *mdp5_kms;
 	struct msm_kms *kms = NULL;
 	struct msm_mmu *mmu;
+	void *priv;
 	int i, ret;
 
 	mdp5_kms = kzalloc(sizeof(*mdp5_kms), GFP_KERNEL);
@@ -377,7 +395,6 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	kms = &mdp5_kms->base.base;
 
 	mdp5_kms->dev = dev;
-	mdp5_kms->smp_blk_cnt = config->smp_blk_cnt;
 
 	mdp5_kms->mmio = msm_ioremap(pdev, "mdp_phys", "MDP5");
 	if (IS_ERR(mdp5_kms->mmio)) {
@@ -429,6 +446,13 @@ struct msm_kms *mdp5_kms_init(struct drm_device *dev)
 	/* TODO: compute core clock rate at runtime */
 	clk_set_rate(mdp5_kms->src_clk, mdp5_kms->hw_cfg->max_clk);
 
+	priv = mdp5_smp_init(mdp5_kms->dev, &mdp5_kms->hw_cfg->smp);
+	if (IS_ERR(priv)) {
+		ret = PTR_ERR(priv);
+		goto fail;
+	}
+	mdp5_kms->smp_priv = priv;
+
 	/* make sure things are off before attaching iommu (bootloader could
 	 * have left things on, in which case we'll start getting faults if
 	 * we don't disable):
@@ -489,8 +513,6 @@ static struct mdp5_platform_config *mdp5_get_config(struct platform_device *dev)
 	/* TODO */
 #endif
 	config.iommu = iommu_domain_alloc(&platform_bus_type);
-	/* TODO get from DT: */
-	config.smp_blk_cnt = 22;
 
 	return &config;
 }
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
index bdbdcda..753659b 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_kms.h
@@ -23,12 +23,22 @@
 #include "mdp/mdp_kms.h"
 /* dynamic offsets used by mdp5.xml.h (initialized in mdp5_kms.c) */
 #define MDP5_MAX_BASES		8
+#define MAX_SMP_BLOCKS		44
+#define MAX_CLIENTS		32
+typedef DECLARE_BITMAP(mdp5_smp_state_t, MAX_SMP_BLOCKS);
 struct mdp5_sub_block {
 	int	count;
 	uint32_t base[MDP5_MAX_BASES];
 };
+struct mdp5_smp_block {
+	int mmb_count;			/* number of SMP MMBs */
+	int mmb_size;			/* MMB: size in bytes */
+	mdp5_smp_state_t reserved_state;/* SMP MMBs statically allocated */
+	int reserved[MAX_CLIENTS];	/* # of MMBs reserved per client */
+};
 struct mdp5_config {
 	char  *name;
+	struct mdp5_smp_block smp;
 	struct mdp5_sub_block ctl;
 	struct mdp5_sub_block pipe_vig;
 	struct mdp5_sub_block pipe_rgb;
@@ -56,10 +66,7 @@ struct mdp5_kms {
 	int id;
 	struct msm_mmu *mmu;
 
-	/* for tracking smp allocation amongst pipes: */
-	mdp5_smp_state_t smp_state;
-	struct mdp5_client_smp_state smp_client_state[CID_MAX];
-	int smp_blk_cnt;
+	void *smp_priv;
 
 	/* io/register spaces: */
 	void __iomem *mmio, *vbif;
@@ -80,7 +87,6 @@ struct mdp5_kms {
 /* platform config data (ie. from DT, or pdata) */
 struct mdp5_platform_config {
 	struct iommu_domain *iommu;
-	int smp_blk_cnt;
 };
 
 static inline void mdp5_write(struct mdp5_kms *mdp5_kms, u32 reg, u32 data)
@@ -136,24 +142,6 @@ static inline int pipe2nclients(enum mdp5_pipe pipe)
 	}
 }
 
-static inline enum mdp5_client_id pipe2client(enum mdp5_pipe pipe, int plane)
-{
-	WARN_ON(plane >= pipe2nclients(pipe));
-	switch (pipe) {
-	case SSPP_VIG0: return CID_VIG0_Y + plane;
-	case SSPP_VIG1: return CID_VIG1_Y + plane;
-	case SSPP_VIG2: return CID_VIG2_Y + plane;
-	case SSPP_RGB0: return CID_RGB0;
-	case SSPP_RGB1: return CID_RGB1;
-	case SSPP_RGB2: return CID_RGB2;
-	case SSPP_DMA0: return CID_DMA0_Y + plane;
-	case SSPP_DMA1: return CID_DMA1_Y + plane;
-	case SSPP_VIG3: return CID_VIG3_Y + plane;
-	case SSPP_RGB3: return CID_RGB3;
-	default:        return CID_UNUSED;
-	}
-}
-
 static inline uint32_t mixer2flush(int lm)
 {
 	switch (lm) {
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
index f3daec4..633ca08 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_plane.c
@@ -63,13 +63,13 @@ static int mdp5_plane_disable(struct drm_plane *plane)
 	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
 	enum mdp5_pipe pipe = mdp5_plane->pipe;
-	int i;
 
 	DBG("%s: disable", mdp5_plane->name);
 
-	/* update our SMP request to zero (release all our blks): */
-	for (i = 0; i < pipe2nclients(pipe); i++)
-		mdp5_smp_request(mdp5_kms, pipe2client(pipe, i), 0);
+	if (mdp5_kms) {
+		/* Release the memory we requested earlier from the SMP: */
+		mdp5_smp_release(mdp5_kms->smp_priv, pipe);
+	}
 
 	/* TODO detaching now will cause us not to get the last
 	 * vblank and mdp5_smp_commit().. so other planes will
@@ -149,68 +149,6 @@ void mdp5_plane_set_scanout(struct drm_plane *plane,
 	plane->fb = fb;
 }
 
-/* NOTE: looks like if horizontal decimation is used (if we supported that)
- * then the width used to calculate SMP block requirements is the post-
- * decimated width.  Ie. SMP buffering sits downstream of decimation (which
- * presumably happens during the dma from scanout buffer).
- */
-static int request_smp_blocks(struct drm_plane *plane, uint32_t format,
-		uint32_t nplanes, uint32_t width)
-{
-	struct drm_device *dev = plane->dev;
-	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
-	struct mdp5_kms *mdp5_kms = get_kms(plane);
-	enum mdp5_pipe pipe = mdp5_plane->pipe;
-	int i, hsub, nlines, nblks, ret;
-
-	hsub = drm_format_horz_chroma_subsampling(format);
-
-	/* different if BWC (compressed framebuffer?) enabled: */
-	nlines = 2;
-
-	for (i = 0, nblks = 0; i < nplanes; i++) {
-		int n, fetch_stride, cpp;
-
-		cpp = drm_format_plane_cpp(format, i);
-		fetch_stride = width * cpp / (i ? hsub : 1);
-
-		n = DIV_ROUND_UP(fetch_stride * nlines, SMP_BLK_SIZE);
-
-		/* for hw rev v1.00 */
-		if (mdp5_kms->rev == 0)
-			n = roundup_pow_of_two(n);
-
-		DBG("%s[%d]: request %d SMP blocks", mdp5_plane->name, i, n);
-		ret = mdp5_smp_request(mdp5_kms, pipe2client(pipe, i), n);
-		if (ret) {
-			dev_err(dev->dev, "Could not allocate %d SMP blocks: %d\n",
-					n, ret);
-			return ret;
-		}
-
-		nblks += n;
-	}
-
-	/* in success case, return total # of blocks allocated: */
-	return nblks;
-}
-
-static void set_fifo_thresholds(struct drm_plane *plane, int nblks)
-{
-	struct mdp5_plane *mdp5_plane = to_mdp5_plane(plane);
-	struct mdp5_kms *mdp5_kms = get_kms(plane);
-	enum mdp5_pipe pipe = mdp5_plane->pipe;
-	uint32_t val;
-
-	/* 1/4 of SMP pool that is being fetched */
-	val = (nblks * SMP_ENTRIES_PER_BLK) / 4;
-
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_REQPRIO_FIFO_WM_0(pipe), val * 1);
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_REQPRIO_FIFO_WM_1(pipe), val * 2);
-	mdp5_write(mdp5_kms, REG_MDP5_PIPE_REQPRIO_FIFO_WM_2(pipe), val * 3);
-
-}
-
 int mdp5_plane_mode_set(struct drm_plane *plane,
 		struct drm_crtc *crtc, struct drm_framebuffer *fb,
 		int crtc_x, int crtc_y,
@@ -225,7 +163,7 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 	uint32_t nplanes, config = 0;
 	uint32_t phasex_step = 0, phasey_step = 0;
 	uint32_t hdecm = 0, vdecm = 0;
-	int i, nblks;
+	int ret;
 
 	nplanes = drm_format_num_planes(fb->pixel_format);
 
@@ -243,12 +181,11 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 			fb->base.id, src_x, src_y, src_w, src_h,
 			crtc->base.id, crtc_x, crtc_y, crtc_w, crtc_h);
 
-	/*
-	 * Calculate and request required # of smp blocks:
-	 */
-	nblks = request_smp_blocks(plane, fb->pixel_format, nplanes, src_w);
-	if (nblks < 0)
-		return nblks;
+	/* Request some memory from the SMP: */
+	ret = mdp5_smp_request(mdp5_kms->smp_priv,
+			mdp5_plane->pipe, fb->pixel_format, src_w);
+	if (ret)
+		return ret;
 
 	/*
 	 * Currently we update the hw for allocations/requests immediately,
@@ -256,8 +193,7 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 	 * would move into atomic->check_plane_state(), while updating the
 	 * hw would remain here:
 	 */
-	for (i = 0; i < pipe2nclients(pipe); i++)
-		mdp5_smp_configure(mdp5_kms, pipe2client(pipe, i));
+	mdp5_smp_configure(mdp5_kms->smp_priv, pipe);
 
 	if (src_w != crtc_w) {
 		config |= MDP5_PIPE_SCALE_CONFIG_SCALEX_EN;
@@ -330,8 +266,6 @@ int mdp5_plane_mode_set(struct drm_plane *plane,
 			MDP5_PIPE_SCALE_CONFIG_SCALEX_MAX_FILTER(SCALE_FILTER_NEAREST) |
 			MDP5_PIPE_SCALE_CONFIG_SCALEY_MAX_FILTER(SCALE_FILTER_NEAREST));
 
-	set_fifo_thresholds(plane, nblks);
-
 	/* TODO detach from old crtc (if we had more than one) */
 	mdp5_crtc_attach(crtc, plane);
 
@@ -342,10 +276,8 @@ void mdp5_plane_complete_flip(struct drm_plane *plane)
 {
 	struct mdp5_kms *mdp5_kms = get_kms(plane);
 	enum mdp5_pipe pipe = to_mdp5_plane(plane)->pipe;
-	int i;
 
-	for (i = 0; i < pipe2nclients(pipe); i++)
-		mdp5_smp_commit(mdp5_kms, pipe2client(pipe, i));
+	mdp5_smp_commit(mdp5_kms->smp_priv, pipe);
 }
 
 enum mdp5_pipe mdp5_plane_pipe(struct drm_plane *plane)
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
index 2d0236b..e61e1cf 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -29,8 +30,11 @@
  * Based on the size of the attached scanout buffer, a certain # of
  * blocks must be allocated to that client out of the shared pool.
  *
- * For each block, it can be either free, or pending/in-use by a
- * client.  The updates happen in three steps:
+ * In some hw, some blocks are statically allocated for certain pipes
+ * and CANNOT be re-allocated (eg: MMB0 and MMB1 both tied to RGB0).
+ *
+ * For each block that can be dynamically allocated, it can be either
+ * free, or pending/in-use by a client. The updates happen in three steps:
  *
  *  1) mdp5_smp_request():
  *     When plane scanout is setup, calculate required number of
@@ -61,21 +65,64 @@
  * inuse and pending state of all clients..
  */
 
-static DEFINE_SPINLOCK(smp_lock);
+struct mdp5_smp {
+	struct drm_device *dev;
+
+	int blk_cnt;
+	int blk_size;
+
+	spinlock_t state_lock;
+	mdp5_smp_state_t state; /* to track smp allocation amongst pipes: */
+
+	struct mdp5_client_smp_state client_state[CID_MAX];
+};
 
+static inline
+struct mdp5_kms *get_kms(struct mdp5_smp *smp)
+{
+	struct msm_drm_private *priv = smp->dev->dev_private;
+
+	return to_mdp5_kms(to_mdp_kms(priv->kms));
+}
+
+static inline enum mdp5_client_id pipe2client(enum mdp5_pipe pipe, int plane)
+{
+	WARN_ON(plane >= pipe2nclients(pipe));
+	switch (pipe) {
+	case SSPP_VIG0: return CID_VIG0_Y + plane;
+	case SSPP_VIG1: return CID_VIG1_Y + plane;
+	case SSPP_VIG2: return CID_VIG2_Y + plane;
+	case SSPP_RGB0: return CID_RGB0;
+	case SSPP_RGB1: return CID_RGB1;
+	case SSPP_RGB2: return CID_RGB2;
+	case SSPP_DMA0: return CID_DMA0_Y + plane;
+	case SSPP_DMA1: return CID_DMA1_Y + plane;
+	case SSPP_VIG3: return CID_VIG3_Y + plane;
+	case SSPP_RGB3: return CID_RGB3;
+	default:        return CID_UNUSED;
+	}
+}
 
 /* step #1: update # of blocks pending for the client: */
-int mdp5_smp_request(struct mdp5_kms *mdp5_kms,
+static int smp_request_block(struct mdp5_smp *smp,
 		enum mdp5_client_id cid, int nblks)
 {
-	struct mdp5_client_smp_state *ps = &mdp5_kms->smp_client_state[cid];
-	int i, ret, avail, cur_nblks, cnt = mdp5_kms->smp_blk_cnt;
+	struct mdp5_kms *mdp5_kms = get_kms(smp);
+	struct mdp5_client_smp_state *ps = &smp->client_state[cid];
+	int i, ret, avail, cur_nblks, cnt = smp->blk_cnt;
+	int reserved = mdp5_kms->hw_cfg->smp.reserved[cid];
 	unsigned long flags;
 
-	spin_lock_irqsave(&smp_lock, flags);
+	spin_lock_irqsave(&smp->state_lock, flags);
+
+	nblks -= reserved;
+	if (reserved)
+		DBG("%d MMBs allocated (%d reserved)", nblks, reserved);
 
-	avail = cnt - bitmap_weight(mdp5_kms->smp_state, cnt);
+	avail = cnt - bitmap_weight(smp->state, cnt);
 	if (nblks > avail) {
+		dev_err(mdp5_kms->dev->dev, "out of blks (req=%d > avail=%d)\n",
+				nblks, avail);
 		ret = -ENOSPC;
 		goto fail;
 	}
@@ -84,9 +131,9 @@ int mdp5_smp_request(struct mdp5_kms *mdp5_kms,
 	if (nblks > cur_nblks) {
 		/* grow the existing pending reservation: */
 		for (i = cur_nblks; i < nblks; i++) {
-			int blk = find_first_zero_bit(mdp5_kms->smp_state, cnt);
+			int blk = find_first_zero_bit(smp->state, cnt);
 			set_bit(blk, ps->pending);
-			set_bit(blk, mdp5_kms->smp_state);
+			set_bit(blk, smp->state);
 		}
 	} else {
 		/* shrink the existing pending reservation: */
@@ -98,15 +145,89 @@ int mdp5_smp_request(struct mdp5_kms *mdp5_kms,
 	}
 
 fail:
-	spin_unlock_irqrestore(&smp_lock, flags);
+	spin_unlock_irqrestore(&smp->state_lock, flags);
+	return 0;
+}
+
+static void set_fifo_thresholds(struct mdp5_smp *smp,
+		enum mdp5_pipe pipe, int nblks)
+{
+	struct mdp5_kms *mdp5_kms = get_kms(smp);
+	u32 smp_entries_per_blk = smp->blk_size / (128 / BITS_PER_BYTE);
+	u32 val;
+
+	/* 1/4 of SMP pool that is being fetched */
+	val = (nblks * smp_entries_per_blk) / 4;
+
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_REQPRIO_FIFO_WM_0(pipe), val * 1);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_REQPRIO_FIFO_WM_1(pipe), val * 2);
+	mdp5_write(mdp5_kms, REG_MDP5_PIPE_REQPRIO_FIFO_WM_2(pipe), val * 3);
+}
+
+/*
+ * NOTE: looks like if horizontal decimation is used (if we supported that)
+ * then the width used to calculate SMP block requirements is the post-
+ * decimated width.  Ie. SMP buffering sits downstream of decimation (which
+ * presumably happens during the dma from scanout buffer).
+ */
+int mdp5_smp_request(void *handler, enum mdp5_pipe pipe, u32 fmt, u32 width)
+{
+	struct mdp5_smp *smp = handler;
+	struct mdp5_kms *mdp5_kms = get_kms(smp);
+	struct drm_device *dev = mdp5_kms->dev;
+	int i, hsub, nplanes, nlines, nblks, ret;
+
+	nplanes = drm_format_num_planes(fmt);
+	hsub = drm_format_horz_chroma_subsampling(fmt);
+
+	/* different if BWC (compressed framebuffer?) enabled: */
+	nlines = 2;
+
+	for (i = 0, nblks = 0; i < nplanes; i++) {
+		int n, fetch_stride, cpp;
+
+		cpp = drm_format_plane_cpp(fmt, i);
+		fetch_stride = width * cpp / (i ? hsub : 1);
+
+		n = DIV_ROUND_UP(fetch_stride * nlines, smp->blk_size);
+
+		/* for hw rev v1.00 */
+		if (mdp5_kms->rev == 0)
+			n = roundup_pow_of_two(n);
+
+		DBG("%s[%d]: request %d SMP blocks", pipe2name(pipe), i, n);
+		ret = smp_request_block(smp, pipe2client(pipe, i), n);
+		if (ret) {
+			dev_err(dev->dev, "Cannot allocate %d SMP blocks: %d\n",
+					n, ret);
+			return ret;
+		}
+
+		nblks += n;
+	}
+
+	set_fifo_thresholds(smp, pipe, nblks);
+
 	return 0;
 }
 
-static void update_smp_state(struct mdp5_kms *mdp5_kms,
+/* Release SMP blocks for all clients of the pipe */
+void mdp5_smp_release(void *handler, enum mdp5_pipe pipe)
+{
+	struct mdp5_smp *smp = handler;
+	int i, nblks;
+
+	for (i = 0, nblks = 0; i < pipe2nclients(pipe); i++)
+		smp_request_block(smp, pipe2client(pipe, i), 0);
+	set_fifo_thresholds(smp, pipe, 0);
+}
+
+static void update_smp_state(struct mdp5_smp *smp,
 		enum mdp5_client_id cid, mdp5_smp_state_t *assigned)
 {
-	int cnt = mdp5_kms->smp_blk_cnt;
-	uint32_t blk, val;
+	struct mdp5_kms *mdp5_kms = get_kms(smp);
+	int cnt = smp->blk_cnt;
+	u32 blk, val;
 
 	for_each_set_bit(blk, *assigned, cnt) {
 		int idx = blk / 3;
@@ -135,39 +256,84 @@ static void update_smp_state(struct mdp5_kms *mdp5_kms,
 }
 
 /* step #2: configure hw for union(pending, inuse): */
-void mdp5_smp_configure(struct mdp5_kms *mdp5_kms, enum mdp5_client_id cid)
+void mdp5_smp_configure(void *handler, enum mdp5_pipe pipe)
 {
-	struct mdp5_client_smp_state *ps = &mdp5_kms->smp_client_state[cid];
-	int cnt = mdp5_kms->smp_blk_cnt;
+	struct mdp5_smp *smp = handler;
+	int cnt = smp->blk_cnt;
 	mdp5_smp_state_t assigned;
+	int i;
+
+	for (i = 0; i < pipe2nclients(pipe); i++) {
+		enum mdp5_client_id cid = pipe2client(pipe, i);
+		struct mdp5_client_smp_state *ps = &smp->client_state[cid];
 
-	bitmap_or(assigned, ps->inuse, ps->pending, cnt);
-	update_smp_state(mdp5_kms, cid, &assigned);
+		bitmap_or(assigned, ps->inuse, ps->pending, cnt);
+		update_smp_state(smp, cid, &assigned);
+	}
 }
 
 /* step #3: after vblank, copy pending -> inuse: */
-void mdp5_smp_commit(struct mdp5_kms *mdp5_kms, enum mdp5_client_id cid)
+void mdp5_smp_commit(void *handler, enum mdp5_pipe pipe)
 {
-	struct mdp5_client_smp_state *ps = &mdp5_kms->smp_client_state[cid];
-	int cnt = mdp5_kms->smp_blk_cnt;
+	struct mdp5_smp *smp = handler;
+	int cnt = smp->blk_cnt;
 	mdp5_smp_state_t released;
+	int i;
+
+	for (i = 0; i < pipe2nclients(pipe); i++) {
+		enum mdp5_client_id cid = pipe2client(pipe, i);
+		struct mdp5_client_smp_state *ps = &smp->client_state[cid];
+
+		/*
+		 * Figure out if there are any blocks we where previously
+		 * using, which can be released and made available to other
+		 * clients:
+		 */
+		if (bitmap_andnot(released, ps->inuse, ps->pending, cnt)) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&smp->state_lock, flags);
+			/* clear released blocks: */
+			bitmap_andnot(smp->state, smp->state, released, cnt);
+			spin_unlock_irqrestore(&smp->state_lock, flags);
+
+			update_smp_state(smp, CID_UNUSED, &released);
+		}
 
-	/*
-	 * Figure out if there are any blocks we where previously
-	 * using, which can be released and made available to other
-	 * clients:
-	 */
-	if (bitmap_andnot(released, ps->inuse, ps->pending, cnt)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&smp_lock, flags);
-		/* clear released blocks: */
-		bitmap_andnot(mdp5_kms->smp_state, mdp5_kms->smp_state,
-				released, cnt);
-		spin_unlock_irqrestore(&smp_lock, flags);
-
-		update_smp_state(mdp5_kms, CID_UNUSED, &released);
+		bitmap_copy(ps->inuse, ps->pending, cnt);
 	}
+}
+
+void mdp5_smp_destroy(void *handler)
+{
+	struct mdp5_smp *smp = handler;
+
+	kfree(smp);
+}
+
+void *mdp5_smp_init(struct drm_device *dev, const struct mdp5_smp_block *cfg)
+{
+	struct mdp5_smp *smp = NULL;
+	int ret;
+
+	smp = kzalloc(sizeof(*smp), GFP_KERNEL);
+	if (unlikely(!smp)) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	smp->dev = dev;
+	smp->blk_cnt = cfg->mmb_count;
+	smp->blk_size = cfg->mmb_size;
+
+	/* statically tied MMBs cannot be re-allocated: */
+	bitmap_copy(smp->state, cfg->reserved_state, smp->blk_cnt);
+	spin_lock_init(&smp->state_lock);
+
+	return smp;
+fail:
+	if (smp)
+		mdp5_smp_destroy(smp);
 
-	bitmap_copy(ps->inuse, ps->pending, cnt);
+	return ERR_PTR(ret);
 }
diff --git a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h
index 0ab739e..3e3c753 100644
--- a/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h
+++ b/drivers/gpu/drm/msm/mdp/mdp5/mdp5_smp.h
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
  *
@@ -20,12 +21,6 @@
 
 #include "msm_drv.h"
 
-#define MAX_SMP_BLOCKS  22
-#define SMP_BLK_SIZE    4096
-#define SMP_ENTRIES_PER_BLK (SMP_BLK_SIZE / 16)
-
-typedef DECLARE_BITMAP(mdp5_smp_state_t, MAX_SMP_BLOCKS);
-
 struct mdp5_client_smp_state {
 	mdp5_smp_state_t inuse;
 	mdp5_smp_state_t pending;
@@ -33,9 +28,18 @@ struct mdp5_client_smp_state {
 
 struct mdp5_kms;
 
-int mdp5_smp_request(struct mdp5_kms *mdp5_kms, enum mdp5_client_id cid, int nblks);
-void mdp5_smp_configure(struct mdp5_kms *mdp5_kms, enum mdp5_client_id cid);
-void mdp5_smp_commit(struct mdp5_kms *mdp5_kms, enum mdp5_client_id cid);
+/*
+ * SMP module prototypes:
+ * mdp5_smp_init() returns a SMP @handler,
+ * which is then used to call the other mdp5_smp_*(handler, ...) functions.
+ */
+
+void *mdp5_smp_init(struct drm_device *dev, const struct mdp5_smp_block *cfg);
+void  mdp5_smp_destroy(void *handler);
 
+int  mdp5_smp_request(void *handler, enum mdp5_pipe pipe, u32 fmt, u32 width);
+void mdp5_smp_configure(void *handler, enum mdp5_pipe pipe);
+void mdp5_smp_commit(void *handler, enum mdp5_pipe pipe);
+void mdp5_smp_release(void *handler, enum mdp5_pipe pipe);
 
 #endif /* __MDP5_SMP_H__ */
-- 
Qualcomm Innovation Center, Inc.

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

