Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab3BGOij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:38:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:44678 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758208Ab3BGOie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:38:34 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arnd Bergmann <arnd@arndb.de>, Rob Clark <robdclark@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH] omapdrm: fix the dependency to omapdss
Date: Thu, 7 Feb 2013 16:35:52 +0200
Message-ID: <1360247752-25681-2-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360247752-25681-1-git-send-email-tomi.valkeinen@ti.com>
References: <1360247752-25681-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omapdrm uses "select" in Kconfig to enable omapdss. This doesn't work
correctly, as "select" forces omapdss to be enabled in the config even
if it normally could not be enabled because of missing Kconfig
dependencies.

This causes a build break on ARM, when using allyesconfig:

drivers/video/omap2/dss/dss.c: In function 'dss_calc_clock_div':
drivers/video/omap2/dss/dss.c:572:20: error: 'CONFIG_OMAP2_DSS_MIN_FCK_PER_PCK' undeclared (first use in this function)
drivers/video/omap2/dss/dss.c:572:20: note: each undeclared identifier is reported only once for each function it appears in

Instead of using select, this patch changes omapdrm to use "depend
on".

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 drivers/staging/omapdrm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/omapdrm/Kconfig b/drivers/staging/omapdrm/Kconfig
index b724a41..09f65dc 100644
--- a/drivers/staging/omapdrm/Kconfig
+++ b/drivers/staging/omapdrm/Kconfig
@@ -3,8 +3,8 @@ config DRM_OMAP
 	tristate "OMAP DRM"
 	depends on DRM && !CONFIG_FB_OMAP2
 	depends on ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
+	depends on OMAP2_DSS
 	select DRM_KMS_HELPER
-	select OMAP2_DSS
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
 	select FB_SYS_IMAGEBLIT
-- 
1.7.10.4

