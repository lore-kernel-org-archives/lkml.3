Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965431AbaCUBCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:02:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965412AbaCUAEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 104/149] drm/radeon: fix runpm disabling on non-PX harder
Date: Thu, 20 Mar 2014 17:04:27 -0700
Message-Id: <20140321000440.570433788@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7848865914c6a63ead674f0f5604b77df7d3874f upstream.

Make sure runtime pm is disabled on non-PX hardware.
Should fix powerdown problems without displays attached.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_kms.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_kms.c
+++ b/drivers/gpu/drm/radeon/radeon_kms.c
@@ -33,6 +33,13 @@
 #include <linux/vga_switcheroo.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+
+#if defined(CONFIG_VGA_SWITCHEROO)
+bool radeon_is_px(void);
+#else
+static inline bool radeon_is_px(void) { return false; }
+#endif
+
 /**
  * radeon_driver_unload_kms - Main unload function for KMS.
  *
@@ -130,7 +137,8 @@ int radeon_driver_load_kms(struct drm_de
 				"Error during ACPI methods call\n");
 	}
 
-	if (radeon_runtime_pm != 0) {
+	if ((radeon_runtime_pm == 1) ||
+	    ((radeon_runtime_pm == -1) && radeon_is_px())) {
 		pm_runtime_use_autosuspend(dev->dev);
 		pm_runtime_set_autosuspend_delay(dev->dev, 5000);
 		pm_runtime_set_active(dev->dev);


