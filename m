Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaDDUAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 16:00:24 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42698 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbaDDUAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 16:00:22 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>, Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] tools/perf: allow overriding sysfs and proc finding with env var
Date: Fri,  4 Apr 2014 12:59:25 -0700
Message-Id: <1396641598-525-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040420-5806-0000-0000-000024856C0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SYSFS_PATH and PROC_PATH environment variables now let the user override
the detection of sysfs and proc locations for testing purposes.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/perf/util/fs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/perf/util/fs.c b/tools/perf/util/fs.c
index f5be1f2..dccbd26 100644
--- a/tools/perf/util/fs.c
+++ b/tools/perf/util/fs.c
@@ -91,8 +91,44 @@ static bool fs__check_mounts(struct fs *fs)
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
+	strcpy(fs->path, override_path);
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
 
-- 
1.9.1

