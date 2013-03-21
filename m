Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3CUKvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:51:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55961 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3CUKvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:51:45 -0400
Date: Thu, 21 Mar 2013 03:49:27 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-fed1208841f5db92cc3bede4b1004e9e986d843e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1361374353-30385-2-git-send-email-bp@alien8.de>
References: <1361374353-30385-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove a write-only variable in the debugfs code
Git-Commit-ID: fed1208841f5db92cc3bede4b1004e9e986d843e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:49:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fed1208841f5db92cc3bede4b1004e9e986d843e
Gitweb:     http://git.kernel.org/tip/fed1208841f5db92cc3bede4b1004e9e986d843e
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Wed, 20 Feb 2013 16:32:27 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:05:58 -0300

perf tools: Remove a write-only variable in the debugfs code

debugfs_premounted is written-to only so drop it. This functionality is
covered by debugfs_found now. Make it a bool while at it.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1361374353-30385-2-git-send-email-bp@alien8.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debugfs.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

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
