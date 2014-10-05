Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaJEVoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 17:44:06 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:63925 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaJEVoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 17:44:01 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: drm_dp_mst_topology.c:  Fix improper use of strncat.
Date: Sun,  5 Oct 2014 23:46:03 +0200
Message-Id: <1412545563-25411-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have now eliminate the need to use the temporary string,
and therefore also the use of strncat.
And I think this code is clearer and more effective.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index ac3c273..c3f6571 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -997,17 +997,18 @@ static void build_mst_prop_path(struct drm_dp_mst_port *port,
 				struct drm_dp_mst_branch *mstb,
 				char *proppath)
 {
-	int i;
-	char temp[8];
-	snprintf(proppath, 255, "mst:%d", mstb->mgr->conn_base_id);
+	int i, len;
+	static const int proppath_len = 255;
+	memset(proppath, 0, proppath_len);
+	len = snprintf(proppath, proppath_len, "mst:%d", mstb->mgr->conn_base_id);
 	for (i = 0; i < (mstb->lct - 1); i++) {
 		int shift = (i % 2) ? 0 : 4;
 		int port_num = mstb->rad[i / 2] >> shift;
-		snprintf(temp, 8, "-%d", port_num);
-		strncat(proppath, temp, 255);
+		len += snprintf(&proppath[(len < proppath_len ? len : 0)],
+						proppath_len - len, "-%d", port_num);
 	}
-	snprintf(temp, 8, "-%d", port->port_num);
-	strncat(proppath, temp, 255);
+	snprintf(&proppath[(len < proppath_len ? len : 0)], proppath_len - len,
+					"-%d", port->port_num);
 }
 
 static void drm_dp_add_port(struct drm_dp_mst_branch *mstb,
-- 
1.7.10.4

