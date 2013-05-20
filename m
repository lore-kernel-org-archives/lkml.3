Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566Ab3ETRiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 13:38:09 -0400
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:44649 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3ETRiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 13:38:08 -0400
X-Greylist: delayed 1440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2013 13:38:08 EDT
From: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH] drm/nouveau/nv84: Fix HDMI audio regression
Date: Mon, 20 May 2013 19:14:00 +0200
Message-Id: <1369070040-26148-1-git-send-email-alexander.stein@informatik.tu-chemnitz.de>
X-Mailer: git-send-email 1.8.2.1
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 154106::1369070044-000004FE-3259BCCB/0-0/0-0
X-Scan-AV: nick.hrz.tu-chemnitz.de;2013-05-20 19:14:04;2df92c5df6a2b3ac564f85f9831f30a3
X-Scan-SA: nick.hrz.tu-chemnitz.de;2013-05-20 19:14:05;35761ed4fd422289c837b76748edee86
X-Spam-Score: -1.0 (-)
X-Spam-Report: --- Textanalyse SpamAssassin 3.3.1 (-1.0 Punkte)
 Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
 * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
 *  0.0 TVD_RCVD_IP TVD_RCVD_IP
 --- Ende Textanalyse
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code refactoring in commit 8e9e3d2deacc460fbb8a4691140318f6e85e6891
(drm/nv84/disp: move hdmi control into core) disabled HDMI audio on my
nv84 by removing too much old code without adding it in the new one.
This patch adds the missing code within the new code layout resulting in
HDMI audio working again.
It should work on any HDMI head, but due to lacking ahrdware I could
only test the (1st) one.
It also might be possible that similar code is needed for nva3, which I
can't test.

Signed-off-by: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
---
This patch should also be added to stable kernels.

 drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c b/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c
index 0d36bdc..7fdade6 100644
--- a/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/hdminv84.c
@@ -55,6 +55,10 @@ nv84_hdmi_ctrl(struct nv50_disp_priv *priv, int head, int or, u32 data)
 	nv_wr32(priv, 0x616510 + hoff, 0x00000000);
 	nv_mask(priv, 0x616500 + hoff, 0x00000001, 0x00000001);
 
+	nv_mask(priv, 0x6165d0 + hoff, 0x00070001, 0x00010001); /* SPARE, HW_CTS */
+	nv_mask(priv, 0x616568 + hoff, 0x00010101, 0x00000000); /* ACR_CTRL, ?? */
+	nv_mask(priv, 0x616578 + hoff, 0x80000000, 0x80000000); /* ACR_0441_ENABLE */
+
 	/* ??? */
 	nv_mask(priv, 0x61733c, 0x00100000, 0x00100000); /* RESETF */
 	nv_mask(priv, 0x61733c, 0x10000000, 0x10000000); /* LOOKUP_EN */
-- 
1.8.2.1

