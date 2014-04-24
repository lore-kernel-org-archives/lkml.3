Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbaDXMfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:35:31 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:36101 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbaDXMf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:35:27 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        Raphael Assenat <raph@8d.com>, Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH 05/13] video/mbx: fix building debugfs support
Date: Thu, 24 Apr 2014 13:28:21 +0100
Message-Id: <1398342509-10243-6-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
References: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The mbx framebuffer debugfs support apparently hasn't been able
to build for a long time, at least since 2006 when the u.generic_ip
field in the inode was removed. This fixes the obvious bug, and
also makes it possible to build the driver as a module when
debugfs support is enabled, by simply including the C file.
It's ugly, but it won't make the driver any worse than it
already is, and doesn't require a more invasive change that
might break it further.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
Cc: Raphael Assenat <raph@8d.com>
Cc: Mike Rapoport <mike@compulab.co.il>
---
 drivers/video/fbdev/mbx/Makefile     |    3 +--
 drivers/video/fbdev/mbx/mbxdebugfs.c |    2 +-
 drivers/video/fbdev/mbx/mbxfb.c      |    2 ++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/video/fbdev/mbx/Makefile b/drivers/video/fbdev/mbx/Makefile
index 16c1165..d7ae5a9 100644
--- a/drivers/video/fbdev/mbx/Makefile
+++ b/drivers/video/fbdev/mbx/Makefile
@@ -1,4 +1,3 @@
 # Makefile for the 2700G controller driver.
 
-obj-$(CONFIG_FB_MBX)	   += mbxfb.o
-obj-$(CONFIG_FB_MBX_DEBUG) += mbxfbdebugfs.o
+obj-y 			+= mbxfb.o
diff --git a/drivers/video/fbdev/mbx/mbxdebugfs.c b/drivers/video/fbdev/mbx/mbxdebugfs.c
index 4449f24..e3bc00a 100644
--- a/drivers/video/fbdev/mbx/mbxdebugfs.c
+++ b/drivers/video/fbdev/mbx/mbxdebugfs.c
@@ -17,7 +17,7 @@ struct mbxfb_debugfs_data {
 
 static int open_file_generic(struct inode *inode, struct file *file)
 {
-	file->private_data = inode->u.generic_ip;
+	file->private_data = inode->i_private;
 	return 0;
 }
 
diff --git a/drivers/video/fbdev/mbx/mbxfb.c b/drivers/video/fbdev/mbx/mbxfb.c
index f0a5392..2bd52ed 100644
--- a/drivers/video/fbdev/mbx/mbxfb.c
+++ b/drivers/video/fbdev/mbx/mbxfb.c
@@ -877,6 +877,8 @@ static int mbxfb_resume(struct platform_device *dev)
 #ifndef CONFIG_FB_MBX_DEBUG
 #define mbxfb_debugfs_init(x)	do {} while(0)
 #define mbxfb_debugfs_remove(x)	do {} while(0)
+#else
+#include "mbxdebugfs.c"
 #endif
 
 #define res_size(_r) (((_r)->end - (_r)->start) + 1)
-- 
1.7.9.5

