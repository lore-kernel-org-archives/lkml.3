Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbaJUI4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 04:56:52 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:36073
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932265AbaJUI4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 04:56:46 -0400
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 04:56:46 EDT
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com
Subject: [PATCH v3 RESEND] Tools: hv: vssdaemon: ignore the EBUSY on multiple freezing the same partition
Date: Tue, 21 Oct 2014 02:56:14 -0700
Message-Id: <1413885374-12148-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a partition appears mounted more than once in /proc/mounts, vss_do_freeze()
succeeds only for the first time and gets EBUSY (on freeze) or EINVAL (on
thaw) for the second time. The patch ignores these to make the backup feature
work.

Also improved the error handling in case a freeze operation fails.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---

v2: Add "errno = 0;" before the ioctl()
(Unnecessary and removed now since we remove syslog() in vss_do_freeze() in v3)

v3: Remove the unsafe syslog() in vss_do_freeze(): that could write the disk.
    Thaw the filesystems in case the freezing operation fails.
    In main(), add syslog() when we check the return value of vss_operate().

[Oct 21, 2014] This is just a RESEND since the previous one I sent about a month
ago seems neglected. :-(

 tools/hv/hv_vss_daemon.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 6a213b8..1db9430 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -44,21 +44,39 @@ static struct sockaddr_nl addr;
 #endif
 
 
-static int vss_do_freeze(char *dir, unsigned int cmd, char *fs_op)
+/* Don't use syslog() in the function since that can cause write to disk */
+static int vss_do_freeze(char *dir, unsigned int cmd)
 {
 	int ret, fd = open(dir, O_RDONLY);
 
 	if (fd < 0)
 		return 1;
+
 	ret = ioctl(fd, cmd, 0);
-	syslog(LOG_INFO, "VSS: %s of %s: %s\n", fs_op, dir, strerror(errno));
+
+	/*
+	 * If a partition is mounted more than once, only the first
+	 * FREEZE/THAW can succeed and the later ones will get
+	 * EBUSY/EINVAL respectively: there could be 2 cases:
+	 * 1) a user may mount the same partition to differnt directories
+	 *  by mistake or on purpose;
+	 * 2) The subvolume of btrfs appears to have the same partition
+	 * mounted more than once.
+	 */
+	if (ret) {
+		if ((cmd == FIFREEZE && errno == EBUSY) ||
+		    (cmd == FITHAW && errno == EINVAL)) {
+			close(fd);
+			return 0;
+		}
+	}
+
 	close(fd);
 	return !!ret;
 }
 
 static int vss_operate(int operation)
 {
-	char *fs_op;
 	char match[] = "/dev/";
 	FILE *mounts;
 	struct mntent *ent;
@@ -68,11 +86,9 @@ static int vss_operate(int operation)
 	switch (operation) {
 	case VSS_OP_FREEZE:
 		cmd = FIFREEZE;
-		fs_op = "freeze";
 		break;
 	case VSS_OP_THAW:
 		cmd = FITHAW;
-		fs_op = "thaw";
 		break;
 	default:
 		return -1;
@@ -93,15 +109,23 @@ static int vss_operate(int operation)
 			root_seen = 1;
 			continue;
 		}
-		error |= vss_do_freeze(ent->mnt_dir, cmd, fs_op);
+		error |= vss_do_freeze(ent->mnt_dir, cmd);
+		if (error && operation == VSS_OP_FREEZE)
+			goto err;
 	}
 	endmntent(mounts);
 
 	if (root_seen) {
-		error |= vss_do_freeze("/", cmd, fs_op);
+		error |= vss_do_freeze("/", cmd);
+		if (error && operation == VSS_OP_FREEZE)
+			goto err;
 	}
 
 	return error;
+err:
+	endmntent(mounts);
+	vss_operate(VSS_OP_THAW);
+	return error;
 }
 
 static int netlink_send(int fd, struct cn_msg *msg)
@@ -249,8 +273,16 @@ int main(void)
 		case VSS_OP_FREEZE:
 		case VSS_OP_THAW:
 			error = vss_operate(op);
-			if (error)
+			syslog(LOG_INFO, "VSS: op=%s: %s\n",
+				op == VSS_OP_FREEZE ? "FREEZE" : "THAW",
+				error ? "failed" : "succeeded");
+
+			if (error) {
 				error = HV_E_FAIL;
+				syslog(LOG_ERR, "op=%d failed!", op);
+				syslog(LOG_ERR, "report it with these files:");
+				syslog(LOG_ERR, "/etc/fstab and /proc/mounts");
+			}
 			break;
 		default:
 			syslog(LOG_ERR, "Illegal op:%d\n", op);
-- 
1.9.1

