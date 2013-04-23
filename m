Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab3DWU0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:26:15 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56249
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab3DWU0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:26:13 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/5] [PATCH 3/3] tools: hv: use getmntent in hv_vss_daemon
Date: Tue, 23 Apr 2013 13:58:38 -0700
Message-Id: <1366750720-32667-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366750720-32667-1-git-send-email-kys@microsoft.com>
References: <1366750685-32626-1-git-send-email-kys@microsoft.com>
 <1366750720-32667-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de> 

As suggested by Paolo Bonzini, use getmntent instead of parsing output
of mount(1).

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |   39 +++++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index dc3eb1e..e37d86c 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -23,6 +23,7 @@
 #include <sys/poll.h>
 #include <linux/types.h>
 #include <stdio.h>
+#include <mntent.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <string.h>
@@ -47,11 +48,10 @@ static int vss_operate(int operation)
 {
 	char *fs_op;
 	char cmd[512];
-	char buf[512];
-	FILE *file;
-	char *p;
-	char *x;
-	int error = 0;
+	char match[] = "/dev/";
+	FILE *mounts;
+	struct mntent *ent;
+	int error = 0, root_seen = 0;
 
 	switch (operation) {
 	case VSS_OP_FREEZE:
@@ -64,25 +64,28 @@ static int vss_operate(int operation)
 		return -1;
 	}
 
-	file = popen("mount | awk '/^\\/dev\\// { print $3}'", "r");
-	if (file == NULL)
+	mounts = setmntent("/proc/mounts", "r");
+	if (mounts == NULL)
 		return -1;
 
-	while ((p = fgets(buf, sizeof(buf), file)) != NULL) {
-		x = strchr(p, '\n');
-		*x = '\0';
-		if (!strncmp(p, "/", sizeof("/")))
+	while((ent = getmntent(mounts))) {
+		if (strncmp(ent->mnt_fsname, match, strlen(match)))
 			continue;
-
-		sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, p);
+		if (strcmp(ent->mnt_dir, "/") == 0) {
+			root_seen = 1;
+			continue;
+		}
+		snprintf(cmd, sizeof(cmd), "fsfreeze %s '%s'", fs_op, ent->mnt_dir);
 		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
-		error = system(cmd);
+		error |= system(cmd);
 	}
-	pclose(file);
+	endmntent(mounts);
 
-	sprintf(cmd, "%s %s %s", "fsfreeze ", fs_op, "/");
-	syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
-	error = system(cmd);
+	if (root_seen) {
+		sprintf(cmd, "fsfreeze %s /", fs_op);
+		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
+		error |= system(cmd);
+	}
 
 	return error;
 }
-- 
1.7.4.1

