Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3APAEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:04:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:43256 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758278Ab3AOWet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:34:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Aleksi Torhamo <aleksi@torhamo.net>,
        Sean Santos <quantheory@gmail.com>, Ben Skeggs <bskeggs@redhat.com>
Subject: [ 168/221] drm/nouveau/clock: fix support for more than 2 monitors on nve0
Date: Tue, 15 Jan 2013 10:51:35 -0800
Message-Id: <20130115185010.166509399@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksi Torhamo <aleksi@torhamo.net>

commit d19528a9e4f220519c2cb3f56ef0c84ead3ee440 upstream.

Fixes regression introduced in commit 70790f4f
"drm/nouveau/clock: pull in the implementation from all over the place"

When code was moved from nv50_crtc_set_clock to nvc0_clock_pll_set,
the PLLs it is used for got limited to only the first two VPLLs.

nv50_crtc_set_clock was only called to change VPLLs, so it didn't
limit what it was used for in any way. Since nvc0_clock_pll_set is
used for all PLLs, it has to specify which PLLs the code is used for,
and only listed the first two VPLLs.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=58735

This patch is a -stable candidate for 3.7.

Signed-off-by: Aleksi Torhamo <aleksi@torhamo.net>
Tested-by: Aleksi Torhamo <aleksi@torhamo.net>
Tested-by: Sean Santos <quantheory@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/include/subdev/bios/pll.h |    2 ++
 drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c       |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/core/include/subdev/bios/pll.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/bios/pll.h
@@ -38,6 +38,8 @@ enum nvbios_pll_type {
 	PLL_UNK42  = 0x42,
 	PLL_VPLL0  = 0x80,
 	PLL_VPLL1  = 0x81,
+	PLL_VPLL2  = 0x82,
+	PLL_VPLL3  = 0x83,
 	PLL_MAX    = 0xff
 };
 
--- a/drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/clock/nvc0.c
@@ -52,6 +52,8 @@ nvc0_clock_pll_set(struct nouveau_clock
 	switch (info.type) {
 	case PLL_VPLL0:
 	case PLL_VPLL1:
+	case PLL_VPLL2:
+	case PLL_VPLL3:
 		nv_mask(priv, info.reg + 0x0c, 0x00000000, 0x00000100);
 		nv_wr32(priv, info.reg + 0x04, (P << 16) | (N << 8) | M);
 		nv_wr32(priv, info.reg + 0x10, fN << 16);


