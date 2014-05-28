Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaE1NWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:22:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbaE1NV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:21:28 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <dev@codyps.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 8/9] perf tools: Allow overriding sysfs and proc finding with env var
Date: Wed, 28 May 2014 15:21:01 +0200
Message-Id: <1401283262-16035-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401283262-16035-1-git-send-email-jolsa@kernel.org>
References: <1401283262-16035-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <dev@codyps.com>

SYSFS_PATH and PROC_PATH environment variables now let the user override
the detection of sysfs and proc locations for testing purposes.

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
Link: http://lkml.kernel.org/r/1401236684-10579-2-git-send-email-dev@codyps.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/api/fs/fs.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index 5b5eb78..c1b49c3 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -1,8 +1,10 @@
 /* TODO merge/factor in debugfs.c here */
 
+#include <ctype.h>
 #include <errno.h>
 #include <stdbool.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <sys/vfs.h>
 
@@ -96,12 +98,51 @@ static bool fs__check_mounts(struct fs *fs)
 	return false;
 }
 
+static void mem_toupper(char *f, size_t len)
+{
+	while (len) {
+		*f = toupper(*f);
+		f++;
+		len--;
+	}
+}
+
+/*
+ * Check for "NAME_PATH" environment variable to override fs location (for
+ * testing). This matches the recommendation in Documentation/sysfs-rules.txt
+ * for SYSFS_PATH.
+ */
+static bool fs__env_override(struct fs *fs)
+{
+	char *override_path;
+	size_t name_len = strlen(fs->name);
+	/* name + "_PATH" + '\0' */
+	char upper_name[name_len + 5 + 1];
+	memcpy(upper_name, fs->name, name_len);
+	mem_toupper(upper_name, name_len);
+	strcpy(&upper_name[name_len], "_PATH");
+
+	override_path = getenv(upper_name);
+	if (!override_path)
+		return false;
+
+	fs->found = true;
+	strncpy(fs->path, override_path, sizeof(fs->path));
+	return true;
+}
+
 static const char *fs__get_mountpoint(struct fs *fs)
 {
+	if (fs__env_override(fs))
+		return fs->path;
+
 	if (fs__check_mounts(fs))
 		return fs->path;
 
-	return fs__read_mounts(fs) ? fs->path : NULL;
+	if (fs__read_mounts(fs))
+		return fs->path;
+
+	return NULL;
 }
 
 static const char *fs__mountpoint(int idx)
-- 
1.8.3.1

