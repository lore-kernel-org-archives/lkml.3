Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbaHWLZa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:25:30 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21752 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbaHWLY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:58 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829921"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] drm: use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:28 +0200
Message-Id: <1408792831-25615-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use c99 initializers for structures.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

 drivers/gpu/drm/sti/sti_vtac.c |   12 ++++++++++--
 drivers/gpu/drm/drm_edid.c     |   34 +++++++++++++++++++++++++---------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_vtac.c b/drivers/gpu/drm/sti/sti_vtac.c
index 82a51d4..4576536 100644
--- a/drivers/gpu/drm/sti/sti_vtac.c
+++ b/drivers/gpu/drm/sti/sti_vtac.c
@@ -56,8 +56,16 @@ struct sti_vtac_mode {
 	u32 phyts_per_pixel;
 };
 
-static const struct sti_vtac_mode vtac_mode_main = {0x2, 0x2, VTAC_5_PPP};
-static const struct sti_vtac_mode vtac_mode_aux = {0x1, 0x0, VTAC_17_PPP};
+static const struct sti_vtac_mode vtac_mode_main = {
+	.vid_in_width = 0x2,
+	.phyts_width = 0x2,
+	.phyts_per_pixel = VTAC_5_PPP
+};
+static const struct sti_vtac_mode vtac_mode_aux = {
+	.vid_in_width = 0x1,
+	.phyts_width = 0x0,
+	.phyts_per_pixel = VTAC_17_PPP
+};
 
 /**
  * VTAC structure
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 1dbf3bc..a28c330 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2103,7 +2103,11 @@ static int
 add_inferred_modes(struct drm_connector *connector, struct edid *edid)
 {
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
+		.preferred = 0,
+		.quirks = 0,
+		.modes = 0
 	};
 
 	if (version_greater(edid, 1, 0))
@@ -2169,7 +2173,11 @@ add_established_modes(struct drm_connector *connector, struct edid *edid)
 		((edid->established_timings.mfg_rsvd & 0x80) << 9);
 	int i, modes = 0;
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
+		.preferred = 0,
+		.quirks = 0,
+		.modes = 0
 	};
 
 	for (i = 0; i <= EDID_EST_TIMINGS; i++) {
@@ -2227,7 +2235,11 @@ add_standard_modes(struct drm_connector *connector, struct edid *edid)
 {
 	int i, modes = 0;
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
+		.preferred = 0,
+		.quirks = 0,
+		.modes = 0
 	};
 
 	for (i = 0; i < EDID_STD_TIMINGS; i++) {
@@ -2313,7 +2325,11 @@ static int
 add_cvt_modes(struct drm_connector *connector, struct edid *edid)
 {	
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
+		.preferred = 0,
+		.quirks = 0,
+		.modes = 0
 	};
 
 	if (version_greater(edid, 1, 2))
@@ -2357,11 +2373,11 @@ add_detailed_modes(struct drm_connector *connector, struct edid *edid,
 		   u32 quirks)
 {
 	struct detailed_mode_closure closure = {
-		connector,
-		edid,
-		1,
-		quirks,
-		0
+		.connector = connector,
+		.edid = edid,
+		.preferred = 1,
+		.quirks = quirks,
+		.modes = 0
 	};
 
 	if (closure.preferred && !version_greater(edid, 1, 3))

