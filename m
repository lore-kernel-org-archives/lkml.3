Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbbAYTTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:19:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbbAYSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 3.14 45/98] video/logo: prevent use of logos after they have been freed
Date: Sun, 25 Jan 2015 10:07:03 -0800
Message-Id: <20150125180714.823554924@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/logo/logo.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

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
@@ -29,7 +44,7 @@ const struct linux_logo * __init_refok f
 {
 	const struct linux_logo *logo = NULL;
 
-	if (nologo)
+	if (nologo || logos_freed)
 		return NULL;
 
 	if (depth >= 1) {


