Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaKJQhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:37:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945AbaKJQhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:37:16 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 1/2] Tools: hv: vssdaemon: report freeze errors
Date: Mon, 10 Nov 2014 17:37:01 +0100
Message-Id: <1415637422-27880-2-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
References: <1415637422-27880-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ioctl(fd, FIFREEZE, 0) results in an error we cannot report it
to syslog instantly since that can cause write to a frozen disk.
However, the name of the filesystem which caused the error and errno
are valuable and we would like to get a nice human-readable message
in the log. Save errno before calling vss_operate(VSS_OP_THAW) and
report the error right after.

Unfortunately, FITHAW errors cannot be reported the same way as we
need to finish thawing all filesystems before calling syslog().

We should also avoid calling endmntent() for the second time in
case we encountered an error during freezing of '/' as it usually
results in SEGSEGV.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/hv/hv_vss_daemon.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
index b720d8f..ee44f0d 100644
--- a/tools/hv/hv_vss_daemon.c
+++ b/tools/hv/hv_vss_daemon.c
@@ -82,7 +82,7 @@ static int vss_operate(int operation)
 	FILE *mounts;
 	struct mntent *ent;
 	unsigned int cmd;
-	int error = 0, root_seen = 0;
+	int error = 0, root_seen = 0, save_errno = 0;
 
 	switch (operation) {
 	case VSS_OP_FREEZE:
@@ -114,7 +114,6 @@ static int vss_operate(int operation)
 		if (error && operation == VSS_OP_FREEZE)
 			goto err;
 	}
-	endmntent(mounts);
 
 	if (root_seen) {
 		error |= vss_do_freeze("/", cmd);
@@ -122,10 +121,19 @@ static int vss_operate(int operation)
 			goto err;
 	}
 
-	return error;
+	goto out;
 err:
-	endmntent(mounts);
+	save_errno = errno;
 	vss_operate(VSS_OP_THAW);
+	/* Call syslog after we thaw all filesystems */
+	if (ent)
+		syslog(LOG_ERR, "FREEZE of %s failed; error:%d %s",
+		       ent->mnt_dir, save_errno, strerror(save_errno));
+	else
+		syslog(LOG_ERR, "FREEZE of / failed; error:%d %s", save_errno,
+		       strerror(save_errno));
+out:
+	endmntent(mounts);
 	return error;
 }
 
-- 
1.9.3

