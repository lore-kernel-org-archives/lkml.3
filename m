Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaE0Tmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:42:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:20751 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441AbaE0Tmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:42:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,921,1392192000"; 
   d="scan'208";a="437542752"
From: eric.ernst@linux.intel.com
To: paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com
Cc: eric.ernst@linux.intel.com
Subject: [PATCH 1/1] Add kernel parameter for kernel version
Date: Tue, 27 May 2014 12:40:41 -0700
Message-Id: <1401219641-79301-1-git-send-email-eric.ernst@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Ernst <eric.ernst@linux.intel.com>

Create a kernel cmdline parameter, "version_addendum", which can be
used to add text to the kernel version that is reported from
/proc/version.

Signed-off-by: Eric Ernst <eric.ernst@linux.intel.com>
---
 fs/proc/version.c |   14 +++++++++++++-
 init/version.c    |    2 +-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/proc/version.c b/fs/proc/version.c
index d2154eb6d78f..1ea545d471a1 100644
--- a/fs/proc/version.c
+++ b/fs/proc/version.c
@@ -5,12 +5,17 @@
 #include <linux/seq_file.h>
 #include <linux/utsname.h>
 
+#define ADDENDUM_LENGTH 20
+static char version_addendum[ADDENDUM_LENGTH];
+
 static int version_proc_show(struct seq_file *m, void *v)
 {
 	seq_printf(m, linux_proc_banner,
 		utsname()->sysname,
 		utsname()->release,
-		utsname()->version);
+		utsname()->version,
+		version_addendum);
+
 	return 0;
 }
 
@@ -26,6 +31,13 @@ static const struct file_operations version_proc_fops = {
 	.release	= single_release,
 };
 
+static int __init set_version_addendum(char *str)
+{
+	strncpy(version_addendum, str, ADDENDUM_LENGTH);
+	return 0;
+}
+early_param("version_addendum", set_version_addendum);
+
 static int __init proc_version_init(void)
 {
 	proc_create("version", 0, NULL, &version_proc_fops);
diff --git a/init/version.c b/init/version.c
index 1a4718e500fe..180059b69b7a 100644
--- a/init/version.c
+++ b/init/version.c
@@ -47,4 +47,4 @@ const char linux_banner[] =
 const char linux_proc_banner[] =
 	"%s version %s"
 	" (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ")"
-	" (" LINUX_COMPILER ") %s\n";
+	" (" LINUX_COMPILER ") %s " "%s\n";
-- 
1.7.9.5

