Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbbALURG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:17:06 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:39208 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbbALURD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:17:03 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH resend] console/dummy: Move screen size selection from CPP to Kconfig
Date: Mon, 12 Jan 2015 21:17:02 +0100
Message-Id: <1421093822-26761-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PA-RISC already handled the dummy console screen size selection in
Kconfig, so generalize this to other platforms.

ARM keeps on using screen_info, which is filled in by
platform-specific code, or from ATAGS.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/console/Kconfig    | 16 ++++++++++------
 drivers/video/console/dummycon.c |  5 +----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index fe1cd0148e139eaa..ba97efc3bf707db8 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -77,18 +77,22 @@ config DUMMY_CONSOLE
 
 config DUMMY_CONSOLE_COLUMNS
         int "Initial number of console screen columns"
-        depends on PARISC && DUMMY_CONSOLE
-        default "160"
+        depends on DUMMY_CONSOLE && !ARM
+        default 160 if PARISC
+        default 80
         help
-          The default value is 160, which should fit a 1280x1024 monitor.
+          On PA-RISC, the default value is 160, which should fit a 1280x1024
+          monitor.
           Select 80 if you use a 640x480 resolution by default.
 
 config DUMMY_CONSOLE_ROWS
         int "Initial number of console screen rows"
-        depends on PARISC && DUMMY_CONSOLE
-        default "64"
+        depends on DUMMY_CONSOLE && !ARM
+        default 64 if PARISC
+        default 25
         help
-          The default value is 64, which should fit a 1280x1024 monitor.
+          On PA-RISC, the default value is 64, which should fit a 1280x1024
+          monitor.
           Select 25 if you use a 640x480 resolution by default.
 
 config FRAMEBUFFER_CONSOLE
diff --git a/drivers/video/console/dummycon.c b/drivers/video/console/dummycon.c
index 40bec8d64b0a4a56..0efc52f11ad003ae 100644
--- a/drivers/video/console/dummycon.c
+++ b/drivers/video/console/dummycon.c
@@ -20,13 +20,10 @@
 #if defined(__arm__)
 #define DUMMY_COLUMNS	screen_info.orig_video_cols
 #define DUMMY_ROWS	screen_info.orig_video_lines
-#elif defined(__hppa__)
+#else
 /* set by Kconfig. Use 80x25 for 640x480 and 160x64 for 1280x1024 */
 #define DUMMY_COLUMNS	CONFIG_DUMMY_CONSOLE_COLUMNS
 #define DUMMY_ROWS	CONFIG_DUMMY_CONSOLE_ROWS
-#else
-#define DUMMY_COLUMNS	80
-#define DUMMY_ROWS	25
 #endif
 
 static const char *dummycon_startup(void)
-- 
1.9.1

