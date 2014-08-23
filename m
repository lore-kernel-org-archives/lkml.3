Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688AbaHWQKA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 12:10:00 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:40071
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750809AbaHWQJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 12:09:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="76175347"
Date: Sat, 23 Aug 2014 18:09:56 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Josh Triplett <josh@joshtriplett.org>
cc: David Airlie <airlied@linux.ie>, kernel-janitors@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9 v2] drm: use c99 initializers in structures
In-Reply-To: <20140823151648.GA2074@thin>
Message-ID: <alpine.DEB.2.02.1408231808400.2068@localhost6.localdomain6>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr> <1408792831-25615-7-git-send-email-Julia.Lawall@lip6.fr> <20140823151648.GA2074@thin>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use c99 initializers for structures.

Drop 0 initializers in drivers/gpu/drm/sti/sti_vtac.c.  A 0x0 initializer
is left in vtac_mode_aux in drivers/gpu/drm/sti/sti_vtac.c to highlight the
relation to vtac_mode_main.

A simplified version of the semantic match that finds the first problem is
as follows: (http://coccinelle.lip6.fr/)

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

v2: Drop 0 initializers and add trailing commas at the suggestions of Josh
Triplett.

 drivers/gpu/drm/drm_edid.c     |   21 ++++++++++++---------
 drivers/gpu/drm/sti/sti_vtac.c |   12 ++++++++++--
 2 files changed, 22 insertions(+), 11 deletions(-)

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
+	.phyts_per_pixel = VTAC_5_PPP,
+};
+static const struct sti_vtac_mode vtac_mode_aux = {
+	.vid_in_width = 0x1,
+	.phyts_width = 0x0,
+	.phyts_per_pixel = VTAC_17_PPP,
+};
 
 /**
  * VTAC structure
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 1dbf3bc..859ae1c 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -2103,7 +2103,8 @@ static int
 add_inferred_modes(struct drm_connector *connector, struct edid *edid)
 {
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
 	};
 
 	if (version_greater(edid, 1, 0))
@@ -2169,7 +2170,8 @@ add_established_modes(struct drm_connector *connector, struct edid *edid)
 		((edid->established_timings.mfg_rsvd & 0x80) << 9);
 	int i, modes = 0;
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
 	};
 
 	for (i = 0; i <= EDID_EST_TIMINGS; i++) {
@@ -2227,7 +2229,8 @@ add_standard_modes(struct drm_connector *connector, struct edid *edid)
 {
 	int i, modes = 0;
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
 	};
 
 	for (i = 0; i < EDID_STD_TIMINGS; i++) {
@@ -2313,7 +2316,8 @@ static int
 add_cvt_modes(struct drm_connector *connector, struct edid *edid)
 {	
 	struct detailed_mode_closure closure = {
-		connector, edid, 0, 0, 0
+		.connector = connector,
+		.edid = edid,
 	};
 
 	if (version_greater(edid, 1, 2))
@@ -2357,11 +2361,10 @@ add_detailed_modes(struct drm_connector *connector, struct edid *edid,
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
 	};
 
 	if (closure.preferred && !version_greater(edid, 1, 3))
