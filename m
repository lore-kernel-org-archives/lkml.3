Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653AbbA2JBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:01:38 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44743 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757531AbbA2JBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 093/176] video/logo: prevent use of logos after they have been freed
Date: Wed, 28 Jan 2015 15:28:43 +0100
Message-Id: <8871196bc148ee2e2e731a541666acdcf21609e4.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/logo/logo.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/video/logo/logo.c b/drivers/video/logo/logo.c
index 080c35b34bbb..cc5dbb5b2f71 100644
--- a/drivers/video/logo/logo.c
+++ b/drivers/video/logo/logo.c
@@ -25,6 +25,21 @@ static bool nologo;
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
@@ -33,7 +48,7 @@ const struct linux_logo * __init_refok fb_find_logo(int depth)
 {
 	const struct linux_logo *logo = NULL;
 
-	if (nologo)
+	if (nologo || logos_freed)
 		return NULL;
 
 	if (depth >= 1) {
-- 
2.2.2

