Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936288Ab3DIJMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:12:14 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:39372 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935498Ab3DIJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:12:11 -0400
Date: Tue, 9 Apr 2013 17:11:36 +0800
From: Wang YanQing <udknight@gmail.com>
To: airlied@redhat.com
Cc: paulo.r.zanoni@intel.com, alexander.deucher@amd.com, ajax@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH]drm: Re-add DMT modes for monitors back
Message-ID: <20130409091136.GA30783@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>, airlied@redhat.com,
	paulo.r.zanoni@intel.com, alexander.deucher@amd.com,
	ajax@redhat.com, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 196e077dc165a307efbd9e7569f81bbdbcf18f65
"drm: don't add inferred modes for monitors that don't support them"

It remove the call add_inferred_modes when DRM_EDID_FEATURE_DEFAULT_GTF
in feature support field is zero, this remove all inferred modes
come from GTF or CVT range information, and also remove DMT modes,
this make me lost some avaiable modes for my TV.
Without this patch I get:
Screen 0: minimum 320 x 200, current 2720 x 1024, maximum 32767 x 32767
VGA1 connected 1440x900+0+0 (normal left inverted right x axis y axis) 414mm x 257mm
   1440x900       75.0*+   59.9
   1400x1050      60.3
   1280x1024      75.0
   1280x800       59.8
   1152x864       75.0
   1280x720       60.0
   1024x768       75.1     70.1     60.0
   832x624        74.6
   800x600        72.2     75.0     60.3
   640x480        72.8     75.0     66.7     60.0
   720x400        70.1
HDMI1 connected 1280x1024+1440+0 (normal left inverted right x axis y axis) 1600mm x 900mm
   1920x1080      60.0 +   50.0
   1920x1080i     30.0     25.0
   1280x1024      60.0*
   1280x720       60.0     50.0
   1440x576i      25.0
   1024x768       60.0
   1440x480i      30.0
   800x600        60.3
   720x576        50.0
   720x480        59.9
   640x480        60.0     59.9
DP1 disconnected (normal left inverted right x axis y axis)

With this patch I get below:
Screen 0: minimum 320 x 200, current 2880 x 900, maximum 32767 x 32767
VGA1 connected 1440x900+0+0 (normal left inverted right x axis y axis) 414mm x 257mm
   1440x900       75.0*+   59.9
   1400x1050      60.3
   1280x1024      75.0
   1280x800       59.8
   1152x864       75.0
   1280x720       60.0
   1024x768       75.1     70.1     60.0
   832x624        74.6
   800x600        72.2     75.0     60.3
   640x480        72.8     75.0     66.7     60.0
   720x400        70.1
HDMI1 connected 1440x900+1440+0 (normal left inverted right x axis y axis) 1600mm x 900mm
   1440x900       59.9*+
   1920x1080      60.0 +   50.0
   1920x1080i     30.0     25.0
   1680x1050      59.9
   1400x1050      59.9
   1280x1024      60.0
   1280x960       60.0
   1360x768       60.0
   1280x800       59.9
   1280x768       60.0
   1280x720       60.0     50.0
   1440x576i      25.0
   1024x768       60.0
   1440x480i      30.0
   800x600        60.3     56.2
   720x576        50.0
   848x480        60.0
   720x480        59.9
   640x480        60.0     59.9
DP1 disconnected (normal left inverted right x axis y axis)

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/gpu/drm/drm_edid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index dfd9ed3..10c2147 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1182,7 +1182,8 @@ do_inferred_modes(struct detailed_timing *timing, void *c)
 						  closure->edid,
 						  timing);
 	
-	if (!version_greater(closure->edid, 1, 1))
+	if (!version_greater(closure->edid, 1, 1) ||
+		!(closure->edid->features & DRM_EDID_FEATURE_DEFAULT_GTF))
 		return; /* GTF not defined yet */
 
 	switch (range->flags) {
@@ -2022,8 +2023,7 @@ int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 	num_modes += add_cvt_modes(connector, edid);
 	num_modes += add_standard_modes(connector, edid);
 	num_modes += add_established_modes(connector, edid);
-	if (edid->features & DRM_EDID_FEATURE_DEFAULT_GTF)
-		num_modes += add_inferred_modes(connector, edid);
+	num_modes += add_inferred_modes(connector, edid);
 	num_modes += add_cea_modes(connector, edid);
 
 	if (quirks & (EDID_QUIRK_PREFER_LARGE_60 | EDID_QUIRK_PREFER_LARGE_75))
-- 
1.7.12.4.dirty
