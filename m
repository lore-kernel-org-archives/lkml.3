Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaJJIg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:36:56 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:61693 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaJJIgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:36:51 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ALSA: au88x0: added reference of vortex_t
Date: Fri, 10 Oct 2014 14:06:38 +0530
Message-Id: <1412930199-24797-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added a pointer of the vortex in the following functions :

vortex_alsafmt_aspfmt
vortex_Vort3D_InitializeSource
a3dsrc_ZeroStateA3D

so that we can have a reference of the vortex in the function.
this reference of the vortex will actually be used in a later patch
to convert the pr_* macro to dev_*.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

no change from v1.

 sound/pci/au88x0/au88x0.h      | 4 ++--
 sound/pci/au88x0/au88x0_a3d.c  | 6 +++---
 sound/pci/au88x0/au88x0_core.c | 5 +++--
 sound/pci/au88x0/au88x0_pcm.c  | 2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index 466a5c8..3a8fefe 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -243,7 +243,7 @@ static int vortex_core_init(vortex_t * card);
 static int vortex_core_shutdown(vortex_t * card);
 static void vortex_enable_int(vortex_t * card);
 static irqreturn_t vortex_interrupt(int irq, void *dev_id);
-static int vortex_alsafmt_aspfmt(int alsafmt);
+static int vortex_alsafmt_aspfmt(int alsafmt, vortex_t *v);
 
 /* Connection  stuff. */
 static void vortex_connect_default(vortex_t * vortex, int en);
@@ -278,7 +278,7 @@ static void vortex_mix_setvolumebyte(vortex_t * vortex, unsigned char mix,
 static void vortex_Vort3D_enable(vortex_t * v);
 static void vortex_Vort3D_disable(vortex_t * v);
 static void vortex_Vort3D_connect(vortex_t * vortex, int en);
-static void vortex_Vort3D_InitializeSource(a3dsrc_t * a, int en);
+static void vortex_Vort3D_InitializeSource(a3dsrc_t *a, int en, vortex_t *v);
 #endif
 
 /* Driver stuff. */
diff --git a/sound/pci/au88x0/au88x0_a3d.c b/sound/pci/au88x0/au88x0_a3d.c
index 30f760e..bc9cda3a 100644
--- a/sound/pci/au88x0/au88x0_a3d.c
+++ b/sound/pci/au88x0/au88x0_a3d.c
@@ -484,7 +484,7 @@ static void a3dsrc_ZeroState(a3dsrc_t * a)
 }
 
 /* Reset entire A3D engine */
-static void a3dsrc_ZeroStateA3D(a3dsrc_t * a)
+static void a3dsrc_ZeroStateA3D(a3dsrc_t *a, vortex_t *v)
 {
 	int i, var, var2;
 
@@ -601,7 +601,7 @@ static void vortex_Vort3D_enable(vortex_t *v)
 	Vort3DRend_Initialize(v, XT_HEADPHONE);
 	for (i = 0; i < NR_A3D; i++) {
 		vortex_A3dSourceHw_Initialize(v, i % 4, i >> 2);
-		a3dsrc_ZeroStateA3D(&(v->a3d[0]));
+		a3dsrc_ZeroStateA3D(&v->a3d[0], v);
 	}
 	/* Register ALSA controls */
 	vortex_a3d_register_controls(v);
@@ -676,7 +676,7 @@ static void vortex_Vort3D_connect(vortex_t * v, int en)
 }
 
 /* Initialize one single A3D source. */
-static void vortex_Vort3D_InitializeSource(a3dsrc_t * a, int en)
+static void vortex_Vort3D_InitializeSource(a3dsrc_t *a, int en, vortex_t *v)
 {
 	if (a->vortex == NULL) {
 		pr_warn
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 72e8128..00e2096 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -2177,7 +2177,8 @@ vortex_adb_allocroute(vortex_t *vortex, int dma, int nr_ch, int dir,
 				return -EBUSY;
 			}
 			/* (De)Initialize A3D hardware source. */
-			vortex_Vort3D_InitializeSource(&(vortex->a3d[a3d]), en);
+			vortex_Vort3D_InitializeSource(&vortex->a3d[a3d], en,
+						       vortex);
 		}
 		/* Make SPDIF out exclusive to "spdif" device when in use. */
 		if ((stream->type == VORTEX_PCM_SPDIF) && (en)) {
@@ -2765,7 +2766,7 @@ static int vortex_core_shutdown(vortex_t * vortex)
 
 /* Alsa support. */
 
-static int vortex_alsafmt_aspfmt(int alsafmt)
+static int vortex_alsafmt_aspfmt(int alsafmt, vortex_t *v)
 {
 	int fmt;
 
diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index 5adc6b9..bdde182 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -332,7 +332,7 @@ static int snd_vortex_pcm_prepare(struct snd_pcm_substream *substream)
 		dir = 1;
 	else
 		dir = 0;
-	fmt = vortex_alsafmt_aspfmt(runtime->format);
+	fmt = vortex_alsafmt_aspfmt(runtime->format, chip);
 	spin_lock_irq(&chip->lock);
 	if (VORTEX_PCM_TYPE(substream->pcm) != VORTEX_PCM_WT) {
 		vortex_adbdma_setmode(chip, dma, 1, dir, fmt,
-- 
1.8.1.2

