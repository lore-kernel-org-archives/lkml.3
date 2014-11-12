Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaKLB1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:27:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaKLB04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH 3.17 111/319] drm/gt214-/kms: fix hda eld regression
Date: Wed, 12 Nov 2014 10:14:09 +0900
Message-Id: <20141112011010.919974314@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit d889c52427d48c05f163f2f39b2cfc12e17e5266 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nv50_display.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -1653,15 +1653,17 @@ nv50_audio_mode_set(struct drm_encoder *
 	struct nouveau_encoder *nv_encoder = nouveau_encoder(encoder);
 	struct nouveau_connector *nv_connector;
 	struct nv50_disp *disp = nv50_disp(encoder->dev);
-	struct {
-		struct nv50_disp_mthd_v1 base;
-		struct nv50_disp_sor_hda_eld_v0 eld;
+	struct __packed {
+		struct {
+			struct nv50_disp_mthd_v1 mthd;
+			struct nv50_disp_sor_hda_eld_v0 eld;
+		} base;
 		u8 data[sizeof(nv_connector->base.eld)];
 	} args = {
-		.base.version = 1,
-		.base.method  = NV50_DISP_MTHD_V1_SOR_HDA_ELD,
-		.base.hasht   = nv_encoder->dcb->hasht,
-		.base.hashm   = nv_encoder->dcb->hashm,
+		.base.mthd.version = 1,
+		.base.mthd.method  = NV50_DISP_MTHD_V1_SOR_HDA_ELD,
+		.base.mthd.hasht   = nv_encoder->dcb->hasht,
+		.base.mthd.hashm   = nv_encoder->dcb->hashm,
 	};
 
 	nv_connector = nouveau_encoder_connector_get(nv_encoder);
@@ -1671,7 +1673,7 @@ nv50_audio_mode_set(struct drm_encoder *
 	drm_edid_to_eld(&nv_connector->base, nv_connector->edid);
 	memcpy(args.data, nv_connector->base.eld, sizeof(args.data));
 
-	nvif_mthd(disp->disp, 0, &args, sizeof(args));
+	nvif_mthd(disp->disp, 0, &args, sizeof(args.base) + args.data[2] * 4);
 }
 
 static void


