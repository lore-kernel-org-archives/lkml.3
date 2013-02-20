Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935813Ab3BTPdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:33:31 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51013 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935744Ab3BTPck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:32:40 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Subject: [PATCH 7/7] tools/vm: Switch to liblk library
Date: Wed, 20 Feb 2013 16:32:33 +0100
Message-Id: <1361374353-30385-8-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1361374353-30385-1-git-send-email-bp@alien8.de>
References: <1361374353-30385-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

page-flags.c had some older version of debugfs_mount copied from perf so
convert it to using the version in the tools library.

Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/vm/Makefile     | 17 +++++++++--
 tools/vm/page-types.c | 85 +++++----------------------------------------------
 2 files changed, 21 insertions(+), 81 deletions(-)

diff --git a/tools/vm/Makefile b/tools/vm/Makefile
index 8e30e5c40f8a..24e9ddd93fa4 100644
--- a/tools/vm/Makefile
+++ b/tools/vm/Makefile
@@ -1,11 +1,22 @@
 # Makefile for vm tools
+#
+TARGETS=page-types slabinfo
+
+LK_DIR = ../lib/lk
+LIBLK = $(LK_DIR)/liblk.a
 
 CC = $(CROSS_COMPILE)gcc
-CFLAGS = -Wall -Wextra
+CFLAGS = -Wall -Wextra -I../lib/
+LDFLAGS = $(LIBLK)
+
+$(TARGETS): liblk
+
+liblk:
+	make -C $(LK_DIR)
 
-all: page-types slabinfo
 %: %.c
-	$(CC) $(CFLAGS) -o $@ $^
+	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
 
 clean:
 	$(RM) page-types slabinfo
+	make -C ../lib/lk clean
diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
index b76edf2f8333..71c9c2511ee7 100644
--- a/tools/vm/page-types.c
+++ b/tools/vm/page-types.c
@@ -36,7 +36,7 @@
 #include <sys/statfs.h>
 #include "../../include/uapi/linux/magic.h"
 #include "../../include/uapi/linux/kernel-page-flags.h"
-
+#include <lk/debugfs.h>
 
 #ifndef MAX_PATH
 # define MAX_PATH 256
@@ -178,7 +178,7 @@ static int		kpageflags_fd;
 static int		opt_hwpoison;
 static int		opt_unpoison;
 
-static char		hwpoison_debug_fs[MAX_PATH+1];
+static char		*hwpoison_debug_fs;
 static int		hwpoison_inject_fd;
 static int		hwpoison_forget_fd;
 
@@ -458,81 +458,6 @@ static uint64_t kpageflags_flags(uint64_t flags)
 	return flags;
 }
 
-/* verify that a mountpoint is actually a debugfs instance */
-static int debugfs_valid_mountpoint(const char *debugfs)
-{
-	struct statfs st_fs;
-
-	if (statfs(debugfs, &st_fs) < 0)
-		return -ENOENT;
-	else if (st_fs.f_type != (long) DEBUGFS_MAGIC)
-		return -ENOENT;
-
-	return 0;
-}
-
-/* find the path to the mounted debugfs */
-static const char *debugfs_find_mountpoint(void)
-{
-	const char *const *ptr;
-	char type[100];
-	FILE *fp;
-
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			strcpy(hwpoison_debug_fs, *ptr);
-			return hwpoison_debug_fs;
-		}
-		ptr++;
-	}
-
-	/* give up and parse /proc/mounts */
-	fp = fopen("/proc/mounts", "r");
-	if (fp == NULL)
-		perror("Can't open /proc/mounts for read");
-
-	while (fscanf(fp, "%*s %"
-		      STR(MAX_PATH)
-		      "s %99s %*s %*d %*d\n",
-		      hwpoison_debug_fs, type) == 2) {
-		if (strcmp(type, "debugfs") == 0)
-			break;
-	}
-	fclose(fp);
-
-	if (strcmp(type, "debugfs") != 0)
-		return NULL;
-
-	return hwpoison_debug_fs;
-}
-
-/* mount the debugfs somewhere if it's not mounted */
-
-static void debugfs_mount(void)
-{
-	const char *const *ptr;
-
-	/* see if it's already mounted */
-	if (debugfs_find_mountpoint())
-		return;
-
-	ptr = debugfs_known_mountpoints;
-	while (*ptr) {
-		if (mount(NULL, *ptr, "debugfs", 0, NULL) == 0) {
-			/* save the mountpoint */
-			strcpy(hwpoison_debug_fs, *ptr);
-			break;
-		}
-		ptr++;
-	}
-
-	if (*ptr == NULL) {
-		perror("mount debugfs");
-		exit(EXIT_FAILURE);
-	}
-}
-
 /*
  * page actions
  */
@@ -541,7 +466,11 @@ static void prepare_hwpoison_fd(void)
 {
 	char buf[MAX_PATH + 1];
 
-	debugfs_mount();
+	hwpoison_debug_fs = debugfs_mount(NULL);
+	if (!hwpoison_debug_fs) {
+		perror("mount debugfs");
+		exit(EXIT_FAILURE);
+	}
 
 	if (opt_hwpoison && !hwpoison_inject_fd) {
 		snprintf(buf, MAX_PATH, "%s/hwpoison/corrupt-pfn",
-- 
1.8.1.3.535.ga923c31

