Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3E0Igj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:36:39 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:40560 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab3E0Igh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:36:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] console/dummy: Move screen size selection from CPP to Kconfig
Date: Mon, 27 May 2013 10:36:16 +0200
Message-Id: <1369643776-20516-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PA-RISC already handled the dummy console screen size selection in Kconfig,
so generalize this to other platforms.

ARM keeps on using screen_info, which is filled in by platform-specific
code, or from ATAGS.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/console/Kconfig    |   16 ++++++++++------
 drivers/video/console/dummycon.c |    5 +----
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index 8af6ad3..7bfe7e1 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -76,18 +76,22 @@ config DUMMY_CONSOLE
 
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
index b63860f..6b1a5d1 100644
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
1.7.0.4

