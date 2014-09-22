Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbaIVQ5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:57:05 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:45098
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbaIVQ5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:57:03 -0400
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com
Subject: [PATCH] Tools: hv: vssdaemon: ignore the EBUSY on multiple freezing the same partition
Date: Mon, 22 Sep 2014 11:02:13 -0700
Message-Id: <1411408933-11060-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dexuan Cui <decui@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 tools/hv/hv_vss_daemon.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index 6a213b8..19567c5 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -51,6 +51,27 @@ static int vss_do_freeze(char *dir, unsigned int cmd, char *fs_op)
 	if (fd < 0)
 		return 1;
 	ret = ioctl(fd, cmd, 0);
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
+			syslog(LOG_INFO, "VSS: %s of %s: %s: ignored\n",
+				fs_op, dir,
+				errno == EBUSY ? "EBUSY" : "EINVAL");
+			close(fd);
+			return 0;
+		}
+	}
+
 	syslog(LOG_INFO, "VSS: %s of %s: %s\n", fs_op, dir, strerror(errno));
 	close(fd);
 	return !!ret;
-- 
1.9.1

