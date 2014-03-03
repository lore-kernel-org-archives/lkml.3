Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaCCTKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:10:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:44538 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaCCTKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:10:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: <airlied@linux.ie>
CC: <airlied@redhat.com>, <robdclark@gmail.com>, <bparrot@ti.com>,
        <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: [PATCH] drm/tilcdc: restore correct display mode and contents on pm resume
Date: Mon, 3 Mar 2014 13:08:56 -0600
Message-ID: <1393873736-26867-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Etheridge <detheridge@ti.com>

On resume the screen contents were not being restored properly.  Looking at
other DRM drivers it seems a call to drm_helper_resume_force_mode() is needed
in the resume handler to force restoration of the mode and framebuffer data.

Signed-off-by: Darren Etheridge <detheridge@ti.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 171a820..1a5ddfa 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -563,6 +563,13 @@ static int tilcdc_pm_resume(struct device *dev)
 		if (registers[i].save && (priv->rev >= registers[i].rev))
 			tilcdc_write(ddev, registers[i].reg, priv->saved_register[n++]);
 
+	/*
+	 * if this call isn't here, the display is blank on return from
+	 * suspend.  With this call here the contents of the framebuffer
+	 * during suspend are restored correctly.
+	 */
+	drm_helper_resume_force_mode(ddev);
+
 	drm_kms_helper_poll_enable(ddev);
 
 	return 0;
-- 
1.9.0

