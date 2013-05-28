Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab3E1VYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:24:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59621 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3E1VYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:24:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Harvey <charvey@matrox.com>,
        Mathieu Larouche <mathieu.larouche@matrox.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 40/78] drm/mgag200: Fix framebuffer base address programming
Date: Tue, 28 May 2013 14:19:49 -0700
Message-Id: <1369776027-17859-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

commit 9f1d036648c1c5ed81b0e98d7a06d55df972701e upstream.

Higher bits of the base address of framebuffers weren't being
programmed properly. This caused framebuffers that didn't happen to be
allocated at a low enough address to not be displayed properly.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Signed-off-by: Mathieu Larouche <mathieu.larouche@matrox.com>
Acked-by: Julia Lemire <jlemire@matrox.com>
Tested-by: Julia Lemire <jlemire@matrox.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 91d7859..7e2c361 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -657,12 +657,26 @@ static void mga_g200wb_commit(struct drm_crtc *crtc)
 	WREG_DAC(MGA1064_GEN_IO_DATA, tmp);
 }
 
-
+/*
+   This is how the framebuffer base address is stored in g200 cards:
+   * Assume @offset is the gpu_addr variable of the framebuffer object
+   * Then addr is the number of _pixels_ (not bytes) from the start of
+     VRAM to the first pixel we want to display. (divided by 2 for 32bit
+     framebuffers)
+   * addr is stored in the CRTCEXT0, CRTCC and CRTCD registers
+   addr<20> -> CRTCEXT0<6>
+   addr<19-16> -> CRTCEXT0<3-0>
+   addr<15-8> -> CRTCC<7-0>
+   addr<7-0> -> CRTCD<7-0>
+   CRTCEXT0 has to be programmed last to trigger an update and make the
+   new addr variable take effect.
+ */
 void mga_set_start_address(struct drm_crtc *crtc, unsigned offset)
 {
 	struct mga_device *mdev = crtc->dev->dev_private;
 	u32 addr;
 	int count;
+	u8 crtcext0;
 
 	while (RREG8(0x1fda) & 0x08);
 	while (!(RREG8(0x1fda) & 0x08));
@@ -670,10 +684,17 @@ void mga_set_start_address(struct drm_crtc *crtc, unsigned offset)
 	count = RREG8(MGAREG_VCOUNT) + 2;
 	while (RREG8(MGAREG_VCOUNT) < count);
 
-	addr = offset >> 2;
+	WREG8(MGAREG_CRTCEXT_INDEX, 0);
+	crtcext0 = RREG8(MGAREG_CRTCEXT_DATA);
+	crtcext0 &= 0xB0;
+	addr = offset / 8;
+	/* Can't store addresses any higher than that...
+	   but we also don't have more than 16MB of memory, so it should be fine. */
+	WARN_ON(addr > 0x1fffff);
+	crtcext0 |= (!!(addr & (1<<20)))<<6;
 	WREG_CRT(0x0d, (u8)(addr & 0xff));
 	WREG_CRT(0x0c, (u8)(addr >> 8) & 0xff);
-	WREG_CRT(0xaf, (u8)(addr >> 16) & 0xf);
+	WREG_ECRT(0x0, ((u8)(addr >> 16) & 0xf) | crtcext0);
 }
 
 
-- 
1.8.1.2

