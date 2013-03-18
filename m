Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3CRQnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:43:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36329 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3CRQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/54] perf tools: Remove a write-only variable in the debugfs code
Date: Mon, 18 Mar 2013 13:24:47 -0300
Message-Id: <1363623939-10748-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

debugfs_premounted is written-to only so drop it. This functionality is
covered by debugfs_found now. Make it a bool while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-2-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debugfs.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
index dd8b193..e55495c 100644
--- a/tools/perf/util/debugfs.c
+++ b/tools/perf/util/debugfs.c
@@ -5,7 +5,6 @@
 #include <linux/kernel.h>
 #include <sys/mount.h>
 
-static int debugfs_premounted;
 char debugfs_mountpoint[PATH_MAX + 1] = "/sys/kernel/debug";
 char tracing_events_path[PATH_MAX + 1] = "/sys/kernel/debug/tracing/events";
 
@@ -15,7 +14,7 @@ static const char *debugfs_known_mountpoints[] = {
 	0,
 };
 
-static int debugfs_found;
+static bool debugfs_found;
 
 /* find the path to the mounted debugfs */
 const char *debugfs_find_mountpoint(void)
@@ -30,7 +29,7 @@ const char *debugfs_find_mountpoint(void)
 	ptr = debugfs_known_mountpoints;
 	while (*ptr) {
 		if (debugfs_valid_mountpoint(*ptr) == 0) {
-			debugfs_found = 1;
+			debugfs_found = true;
 			strcpy(debugfs_mountpoint, *ptr);
 			return debugfs_mountpoint;
 		}
@@ -52,7 +51,7 @@ const char *debugfs_find_mountpoint(void)
 	if (strcmp(type, "debugfs") != 0)
 		return NULL;
 
-	debugfs_found = 1;
+	debugfs_found = true;
 
 	return debugfs_mountpoint;
 }
@@ -82,10 +81,8 @@ static void debugfs_set_tracing_events_path(const char *mountpoint)
 char *debugfs_mount(const char *mountpoint)
 {
 	/* see if it's already mounted */
-	if (debugfs_find_mountpoint()) {
-		debugfs_premounted = 1;
+	if (debugfs_find_mountpoint())
 		goto out;
-	}
 
 	/* if not mounted and no argument */
 	if (mountpoint == NULL) {
@@ -100,7 +97,7 @@ char *debugfs_mount(const char *mountpoint)
 		return NULL;
 
 	/* save the mountpoint */
-	debugfs_found = 1;
+	debugfs_found = true;
 	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
 out:
 	debugfs_set_tracing_events_path(debugfs_mountpoint);
-- 
1.7.1

