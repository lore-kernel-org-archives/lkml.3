Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296AbaJKWA3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 18:00:29 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:44702 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaJKWA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 18:00:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] gpu: drm: drm_dp_mst_topology.c:  Fix improper use of strncat
Date: Sun, 12 Oct 2014 00:02:32 +0200
Message-Id: <1413064952-10466-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed wrong usage of strncat, switched to strlcpy.
While sending the string size to function to reduce
the potential for misuse in future.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index ac3c273..2a146d1 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -995,19 +995,20 @@ static void drm_dp_check_port_guid(struct drm_dp_mst_branch *mstb,
 
 static void build_mst_prop_path(struct drm_dp_mst_port *port,
 				struct drm_dp_mst_branch *mstb,
-				char *proppath)
+				char *proppath,
+				size_t proppath_size)
 {
 	int i;
 	char temp[8];
-	snprintf(proppath, 255, "mst:%d", mstb->mgr->conn_base_id);
+	snprintf(proppath, proppath_size, "mst:%d", mstb->mgr->conn_base_id);
 	for (i = 0; i < (mstb->lct - 1); i++) {
 		int shift = (i % 2) ? 0 : 4;
 		int port_num = mstb->rad[i / 2] >> shift;
-		snprintf(temp, 8, "-%d", port_num);
-		strncat(proppath, temp, 255);
+		snprintf(temp, sizeof(temp), "-%d", port_num);
+		strlcat(proppath, temp, proppath_size);
 	}
-	snprintf(temp, 8, "-%d", port->port_num);
-	strncat(proppath, temp, 255);
+	snprintf(temp, sizeof(temp), "-%d", port->port_num);
+	strlcat(proppath, temp, proppath_size);
 }
 
 static void drm_dp_add_port(struct drm_dp_mst_branch *mstb,
@@ -1078,7 +1079,7 @@ static void drm_dp_add_port(struct drm_dp_mst_branch *mstb,
 
 	if (created && !port->input) {
 		char proppath[255];
-		build_mst_prop_path(port, mstb, proppath);
+		build_mst_prop_path(port, mstb, proppath, sizeof(proppath));
 		port->connector = (*mstb->mgr->cbs->add_connector)(mstb->mgr, port, proppath);
 	}
 
-- 
1.7.10.4

