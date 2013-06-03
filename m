Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644Ab3FCWUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:20:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23918 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab3FCWMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:09 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=z_sPhABLsS0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=F--5JshdJuoA:10 a=6zZ5Uxn1AAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=KmqCZUEVAza2QQZapJAA:9 a=QwnTS9JGZEsA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=TtEOPA0o8PXBGpZC:21 a=_L3K2Xh6OEcGpk7P:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221157.212819719@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:10:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christopher Harvey <charvey@matrox.com>,
        Mathieu Larouche <mathieu.larouche@matrox.com>,
        Julia Lemire <jlemire@matrox.com>, Dave Airlie <airlied@redhat.com>
Subject: [28/65] drm/mgag200: Fix framebuffer base address programming
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0028-drm-mgag200-Fix-framebuffer-base-address-programming.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christopher Harvey <charvey@matrox.com>

[ Upstream commit 9f1d036648c1c5ed81b0e98d7a06d55df972701e ]

Higher bits of the base address of framebuffers weren't being
programmed properly. This caused framebuffers that didn't happen to be
allocated at a low enough address to not be displayed properly.

Signed-off-by: Christopher Harvey <charvey@matrox.com>
Signed-off-by: Mathieu Larouche <mathieu.larouche@matrox.com>
Acked-by: Julia Lemire <jlemire@matrox.com>
Tested-by: Julia Lemire <jlemire@matrox.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/mgag200/mgag200_mode.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mgag200/mgag200_mode.c b/drivers/gpu/drm/mgag200/mgag200_mode.c
index 26518cc..85ef6cc 100644
--- a/drivers/gpu/drm/mgag200/mgag200_mode.c
+++ b/drivers/gpu/drm/mgag200/mgag200_mode.c
@@ -658,12 +658,26 @@ static void mga_g200wb_commit(struct drm_crtc *crtc)
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
@@ -671,10 +685,17 @@ void mga_set_start_address(struct drm_crtc *crtc, unsigned offset)
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
1.7.10.4


