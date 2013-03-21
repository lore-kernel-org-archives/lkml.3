Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab3CULEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:04:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56165 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3CULEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:04:38 -0400
Date: Thu, 21 Mar 2013 04:02:23 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-5a439645eaf3c0c64ae303ca57f9a4467cbdc6f3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de,
        fengguang.wu@intel.com
In-Reply-To: <1361374353-30385-8-git-send-email-bp@alien8.de>
References: <1361374353-30385-8-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/vm: Switch to liblk library
Git-Commit-ID: 5a439645eaf3c0c64ae303ca57f9a4467cbdc6f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 04:02:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a439645eaf3c0c64ae303ca57f9a4467cbdc6f3
Gitweb:     http://git.kernel.org/tip/5a439645eaf3c0c64ae303ca57f9a4467cbdc6f3
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Feb 2013 16:32:33 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:01 -0300

tools/vm: Switch to liblk library

page-flags.c had some older version of debugfs_mount copied from perf so
convert it to using the version in the tools library.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/1361374353-30385-8-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/vm/Makefile     | 17 +++++++++--
 tools/vm/page-types.c | 85 +++++----------------------------------------------
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
