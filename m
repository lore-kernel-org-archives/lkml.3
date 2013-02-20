Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935837Ab3BTPe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:34:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50999 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934944Ab3BTPci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:32:38 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/7] perf, debugfs: Remove a write-only variable
Date: Wed, 20 Feb 2013 16:32:27 +0100
Message-Id: <1361374353-30385-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1361374353-30385-1-git-send-email-bp@alien8.de>
References: <1361374353-30385-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

debugfs_premounted is written-to only so drop it. This functionality is
covered by debugfs_found now. Make it a bool while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 tools/perf/util/debugfs.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/debugfs.c b/tools/perf/util/debugfs.c
index dd8b19319c03..e55495c7823a 100644
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
1.8.1.3.535.ga923c31

