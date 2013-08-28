Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3H1Klz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 06:41:55 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13324 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3H1KlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 06:41:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Aug 2013 03:38:49 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <thierry.reding@gmail.com>
CC: <tbergstrom@nvidia.com>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 2/5] host1x: hdmi: Detect whether display is connected with HDMI or DVI
Date: Wed, 28 Aug 2013 13:40:56 +0300
Message-ID: <1377686459-16634-3-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
References: <1377686459-16634-1-git-send-email-mperttunen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use EDID data to determine whether the display supports HDMI or just DVI.
This used to be hardcoded to be HDMI, which broke support for DVI displays
that couldn't understand the interspersed audio/other data.

If the EDID data isn't available, default to DVI, which should be a safer
choice.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
 drivers/gpu/host1x/drm/hdmi.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/host1x/drm/hdmi.c b/drivers/gpu/host1x/drm/hdmi.c
index d81fac8..140339b 100644
--- a/drivers/gpu/host1x/drm/hdmi.c
+++ b/drivers/gpu/host1x/drm/hdmi.c
@@ -702,6 +702,14 @@ static int tegra_output_hdmi_enable(struct tegra_output *output)
 	unsigned long value;
 	int retries = 1000;
 	int err;
+	struct drm_property_blob *edid_blob = output->connector.edid_blob_ptr;
+
+	if (edid_blob && edid_blob->data &&
+		drm_detect_hdmi_monitor((struct edid *)edid_blob->data)) {
+		hdmi->dvi = false;
+	} else {
+		hdmi->dvi = true;
+	}
 
 	pclk = mode->clock * 1000;
 	h_sync_width = mode->hsync_end - mode->hsync_start;
-- 
1.8.1.5

