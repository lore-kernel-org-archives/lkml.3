Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab3DWUvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:51:35 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:52878
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671Ab3DWUvd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:51:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/5] tools: hv: use FIFREEZE/FITHAW in hv_vss_daemon
Date: Tue, 23 Apr 2013 14:24:00 -0700
Message-Id: <1366752241-357-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366752241-357-1-git-send-email-kys@microsoft.com>
References: <1366752210-318-1-git-send-email-kys@microsoft.com>
 <1366752241-357-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

As suggested by Paolo Bonzini, use ioctl instead of calling fsfreeze.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c |   31 ++++++++++++++++++++++---------
 1 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index e37d86c..830d606 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -21,7 +21,9 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <sys/poll.h>
+#include <sys/ioctl.h>
 #include <linux/types.h>
+#include <fcntl.h>
 #include <stdio.h>
 #include <mntent.h>
 #include <stdlib.h>
@@ -30,6 +32,7 @@
 #include <ctype.h>
 #include <errno.h>
 #include <arpa/inet.h>
+#include <linux/fs.h>
 #include <linux/connector.h>
 #include <linux/hyperv.h>
 #include <linux/netlink.h>
@@ -44,21 +47,35 @@ static struct sockaddr_nl addr;
 #endif
 
 
+static int vss_do_freeze(char *dir, unsigned int cmd, char *fs_op)
+{
+	int ret, fd = open(dir, O_RDONLY);
+
+	if (fd < 0)
+		return 1;
+	ret = ioctl(fd, cmd, 0);
+	syslog(LOG_INFO, "VSS: %s of %s: %s\n", fs_op, dir, strerror(errno));
+	close(fd);
+	return !!ret;
+}
+
 static int vss_operate(int operation)
 {
 	char *fs_op;
-	char cmd[512];
 	char match[] = "/dev/";
 	FILE *mounts;
 	struct mntent *ent;
+	unsigned int cmd;
 	int error = 0, root_seen = 0;
 
 	switch (operation) {
 	case VSS_OP_FREEZE:
-		fs_op = "-f ";
+		cmd = FIFREEZE;
+		fs_op = "freeze";
 		break;
 	case VSS_OP_THAW:
-		fs_op = "-u ";
+		cmd = FITHAW;
+		fs_op = "thaw";
 		break;
 	default:
 		return -1;
@@ -75,16 +92,12 @@ static int vss_operate(int operation)
 			root_seen = 1;
 			continue;
 		}
-		snprintf(cmd, sizeof(cmd), "fsfreeze %s '%s'", fs_op, ent->mnt_dir);
-		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
-		error |= system(cmd);
+		error |= vss_do_freeze(ent->mnt_dir, cmd, fs_op);
 	}
 	endmntent(mounts);
 
 	if (root_seen) {
-		sprintf(cmd, "fsfreeze %s /", fs_op);
-		syslog(LOG_INFO, "VSS cmd is %s\n", cmd);
-		error |= system(cmd);
+		error |= vss_do_freeze("/", cmd, fs_op);
 	}
 
 	return error;
-- 
1.7.4.1

