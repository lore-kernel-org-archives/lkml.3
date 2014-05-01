Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaEATrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 15:47:19 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33973 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbaEATrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 15:47:18 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] tools/perf: allow overriding sysfs and proc finding with env var
Date: Thu,  1 May 2014 12:45:01 -0700
Message-Id: <1398973590-31781-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050119-7182-0000-0000-00000A7B290C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSFS_PATH and PROC_PATH environment variables now let the user override
the detection of sysfs and proc locations for testing purposes.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
Since v2: use strncpy() when copying into fs->path
Since v1: rebased onto acme's perf/core

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
1.9.2

