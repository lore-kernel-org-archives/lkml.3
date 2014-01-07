Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbaAGJ6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:58:49 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42651 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551AbaAGJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:58:44 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 3/4] drm/i915: prepare intel_lvds_get_edid() for multiple calls
Date: Tue,  7 Jan 2014 15:28:42 +0530
Message-Id: <1389088723-30959-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.229.g4448466
In-Reply-To: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
References: <1389088723-30959-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_lvds_get_edid() needs to be called when switching GPUs, but it
currently assumes that it will only be called once and that there's
always an LVDS connector present when it's called. Fix this assumptions.

Cc: Andreas Heider <andreas@meetr.de>
Cc: Seth Forshee <seth.forshee@canonical.com>
Original-patch-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 drivers/gpu/drm/i915/intel_lvds.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 6c09617..8275551 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -927,10 +927,18 @@ static bool intel_lvds_get_edid(struct drm_device *dev)
 	struct edid *edid;
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct drm_connector *connector = dev_priv->int_lvds_connector;
-	struct intel_lvds_connector *lvds_connector = to_lvds_connector(connector);
+	struct intel_lvds_connector *lvds_connector;
 	struct drm_display_mode *scan; /* *modes, *bios_mode; */
 	struct drm_display_mode *fixed_mode = NULL;
 
+	if (!connector)
+		return false;
+	lvds_connector = to_lvds_connector(connector);
+
+	/* If we already have an EDID, no need to check again */
+	if (lvds_connector->base.edid)
+		return true;
+
 	/*
 	 * Attempt to get the fixed panel mode from DDC.  Assume that the
 	 * preferred mode is the right one.
-- 
1.8.5.2.229.g4448466

