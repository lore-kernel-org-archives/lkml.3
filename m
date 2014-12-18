Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaLRL6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:58:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47976 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaLRL6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:58:08 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] video/logo: prevent use of logos after they have been freed
Date: Thu, 18 Dec 2014 13:57:22 +0200
Message-ID: <1418903842-22450-2-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1418903842-22450-1-git-send-email-tomi.valkeinen@ti.com>
References: <1418903842-22450-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the probe of an fb driver has been deferred due to missing
dependencies, and the probe is later ran when a module is loaded, the
fbdev framework will try to find a logo to use.

However, the logos are __initdata, and have already been freed. This
causes sometimes page faults, if the logo memory is not mapped,
sometimes other random crashes as the logo data is invalid, and
sometimes nothing, if the fbdev decides to reject the logo (e.g. the
random value depicting the logo's height is too big).

This patch adds a late_initcall function to mark the logos as freed. In
reality the logos are freed later, and fbdev probe may be ran between
this late_initcall and the freeing of the logos. In that case we will
miss drawing the logo, even if it would be possible.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/video/logo/logo.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/video/logo/logo.c b/drivers/video/logo/logo.c
index 940cd196eef5..10fbfd8ab963 100644
--- a/drivers/video/logo/logo.c
+++ b/drivers/video/logo/logo.c
@@ -21,6 +21,21 @@ static bool nologo;
 module_param(nologo, bool, 0);
 MODULE_PARM_DESC(nologo, "Disables startup logo");
 
+/*
+ * Logos are located in the initdata, and will be freed in kernel_init.
+ * Use late_init to mark the logos as freed to prevent any further use.
+ */
+
+static bool logos_freed;
+
+static int __init fb_logo_late_init(void)
+{
+	logos_freed = true;
+	return 0;
+}
+
+late_initcall(fb_logo_late_init);
+
 /* logo's are marked __initdata. Use __init_refok to tell
  * modpost that it is intended that this function uses data
  * marked __initdata.
@@ -29,7 +44,7 @@ const struct linux_logo * __init_refok fb_find_logo(int depth)
 {
 	const struct linux_logo *logo = NULL;
 
-	if (nologo)
+	if (nologo || logos_freed)
 		return NULL;
 
 	if (depth >= 1) {
-- 
2.2.0

