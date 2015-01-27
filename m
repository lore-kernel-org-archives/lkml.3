Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbbA0Mwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:52:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758028AbbA0MQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:16:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 007/126] video/logo: prevent use of logos after they have been freed
Date: Tue, 27 Jan 2015 12:15:12 +0000
Message-Id: <1422361031-19364-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 92b004d1aa9f367c372511ca0330f58216b25703 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
2.1.4

