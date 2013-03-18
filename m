Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3CRQ2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:28:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49430
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005Ab3CRQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:26:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/54] tools/vm: Switch to liblk library
Date: Mon, 18 Mar 2013 13:24:57 -0300
Message-Id: <1363623939-10748-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

page-flags.c had some older version of debugfs_mount copied from perf so
convert it to using the version in the tools library.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/1361374353-30385-8-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/vm/Makefile     |   17 ++++++++--
 tools/vm/page-types.c |   85 ++++---------------------------------------------
 2 files changed, 21 insertions(+), 81 deletions(-)

diff --git a/tools/vm/Makefile b/tools/vm/Makefile
index 8e30e5c..24e9ddd 100644
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
index b76edf2..71c9c25 100644
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
1.7.1

