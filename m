Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaI0BLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 21:11:15 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44846 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaI0BLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 21:11:12 -0400
From: Behan Webster <behanw@converseincode.com>
To: plagnioj@jcrosoft.com, tomi.valkeinen@ti.com
Cc: behanw@converseincode.com, archit@ti.com, daniel.vetter@ffwll.ch,
        geert@linux-m68k.org, laurent.pinchart@ideasonboard.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, robdclark@gmail.com,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] arm, fbdev, omap2, LLVMLinux: Remove nested function from omap2 dss
Date: Fri, 26 Sep 2014 18:10:52 -0700
Message-Id: <1411780253-4492-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
References: <1411780253-4492-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the use of nested functions where a normal function will suffice.

Nested functions are not liked by upstream kernel developers in general. Their
use breaks the use of clang as a compiler, and doesn't make the code any
better.

This code now works for both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 drivers/video/fbdev/omap2/dss/dispc-compat.c  |  9 +++++----
 drivers/video/fbdev/omap2/dss/manager-sysfs.c | 16 +++++++++-------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/video/fbdev/omap2/dss/dispc-compat.c b/drivers/video/fbdev/omap2/dss/dispc-compat.c
index 83779c2..633c461 100644
--- a/drivers/video/fbdev/omap2/dss/dispc-compat.c
+++ b/drivers/video/fbdev/omap2/dss/dispc-compat.c
@@ -634,13 +634,14 @@ void dispc_mgr_disable_sync(enum omap_channel channel)
 		WARN_ON(1);
 }
 
+static inline void dispc_irq_wait_handler(void *data, u32 mask)
+{
+	complete((struct completion *)data);
+}
+
 int omap_dispc_wait_for_irq_interruptible_timeout(u32 irqmask,
 		unsigned long timeout)
 {
-	void dispc_irq_wait_handler(void *data, u32 mask)
-	{
-		complete((struct completion *)data);
-	}
 
 	int r;
 	DECLARE_COMPLETION_ONSTACK(completion);
diff --git a/drivers/video/fbdev/omap2/dss/manager-sysfs.c b/drivers/video/fbdev/omap2/dss/manager-sysfs.c
index 37b59fe..a7414fb 100644
--- a/drivers/video/fbdev/omap2/dss/manager-sysfs.c
+++ b/drivers/video/fbdev/omap2/dss/manager-sysfs.c
@@ -44,6 +44,13 @@ static ssize_t manager_display_show(struct omap_overlay_manager *mgr, char *buf)
 			dssdev->name : "<none>");
 }
 
+static int manager_display_match(struct omap_dss_device *dssdev, void *data)
+{
+	const char *str = data;
+
+	return sysfs_streq(dssdev->name, str);
+}
+
 static ssize_t manager_display_store(struct omap_overlay_manager *mgr,
 		const char *buf, size_t size)
 {
@@ -52,17 +59,12 @@ static ssize_t manager_display_store(struct omap_overlay_manager *mgr,
 	struct omap_dss_device *dssdev = NULL;
 	struct omap_dss_device *old_dssdev;
 
-	int match(struct omap_dss_device *dssdev, void *data)
-	{
-		const char *str = data;
-		return sysfs_streq(dssdev->name, str);
-	}
-
 	if (buf[size-1] == '\n')
 		--len;
 
 	if (len > 0)
-		dssdev = omap_dss_find_device((void *)buf, match);
+		dssdev = omap_dss_find_device((void *)buf,
+			manager_display_match);
 
 	if (len > 0 && dssdev == NULL)
 		return -EINVAL;
-- 
1.9.1

