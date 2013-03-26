Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410Ab3CZP3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:29:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:37717 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965454Ab3CZP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:28:57 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ8KkvZ5r/TwSabzUg=
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: kys@microsoft.com, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH 3/3] tools: hv: use getmntent in hv_vss_daemon
Date: Tue, 26 Mar 2013 16:28:29 +0100
Message-Id: <1364311709-18228-3-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
References: <1364311709-18228-1-git-send-email-olaf@aepfle.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Paolo Bonzini, use getmntent instead of parsing output
of mount(1).

Signed-off-by: Olaf Hering <olaf@aepfle.de>
---
 tools/hv/hv_vss_daemon.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

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
