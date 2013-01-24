Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3AXDcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:32:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44422 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab3AXDb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 61/74] udldrmfb: Fix EDID not working with monitors with EDID extension blocks
Date: Thu, 24 Jan 2013 01:27:13 -0200
Message-Id: <1358998046-613-62-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit c930812fe5ebe725760422c9c351d1f6fde1502d upstream.

udldrmfb only reads the main EDID block, and if that advertises extensions
the drm_edid code expects them to be present, and starts reading beyond the
buffer udldrmfb passes it.

Although it may be possible to read more EDID info with the udl we simpy don't
know how, and even if trial and error gets it working on one device, that is
no guarantee it will work on other revisions. So this patch does a simple fix
in the form of patching the EDID info to report 0 extension blocks, this
fixes udldrmfb only doing 1024x768 on monitors with EDID extension blocks.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/udl/udl_connector.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/udl/udl_connector.c b/drivers/gpu/drm/udl/udl_connector.c
index 8d9dc44..1230bc0 100644
--- a/drivers/gpu/drm/udl/udl_connector.c
+++ b/drivers/gpu/drm/udl/udl_connector.c
@@ -59,6 +59,14 @@ static int udl_get_modes(struct drm_connector *connector)
 
 	connector->display_info.raw_edid = (char *)edid;
 
+	/*
+	 * We only read the main block, but if the monitor reports extension
+	 * blocks then the drm edid code expects them to be present, so patch
+	 * the extension count to 0.
+	 */
+	edid->checksum += edid->extensions;
+	edid->extensions = 0;
+
 	drm_mode_connector_update_edid_property(connector, edid);
 	ret = drm_add_edid_modes(connector, edid);
 	connector->display_info.raw_edid = NULL;
-- 
1.7.9.5

