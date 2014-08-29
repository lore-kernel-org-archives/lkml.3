Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaH2Cbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 22:31:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:11460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaH2Cbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 22:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="594892206"
From: Chen LinX <linx.z.chen@intel.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: yanmin_zhang@linux.intel.com, "Chen, LinX" <linx.z.chen@intel.com>,
        "He, Bo" <bo.he@intel.com>
Subject: [PATCH V2] debugfs: keep the old mode value at remount when no explicit change
Date: Fri, 29 Aug 2014 10:33:23 +0800
Message-Id: <1409279603-19468-1-git-send-email-linx.z.chen@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Chen, LinX" <linx.z.chen@intel.com>

Android framework has a good method to detect userspace hang and reports
UIWDT issues. It uses client/server model. Clients communicate with
servers by binder. binder has debugfs interfaces. Some files show what
threads are communicating with what other threads. If one thread is
blocked for a long time, we can find the blocking chain from the binder
info. Since the error dumping process has no root access, booting
process changes debugfs mount dir mode to 0755. When UIWDT happens,
the error dumping process can read the info.

Unfortunately, some other scripts at booting try to mount debugfs for
many times. No matter if the double mounting fails or succeeds,
debugfs_parse_options changes the root inode's mode back to default
0700. It means the effect of previous mode changing to 0755 is lost.
At UIWDT, the dumping process can't save binder info to disk log files.

The patch checks if debugfs_mount_opts->mode is initiated. If it is
already, it bypasses the reinitiation, and the old mode value is kept.

Signed-off-by: He, Bo <bo.he@intel.com>
Signed-off-by: Chen, LinX <linx.z.chen@intel.com>
---
 fs/debugfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index c7c83ff..f1eb4b9 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -159,7 +159,8 @@ static int debugfs_parse_options(char *data, struct debugfs_mount_opts *opts)
 	kgid_t gid;
 	char *p;
 
-	opts->mode = DEBUGFS_DEFAULT_MODE;
+	if (opts->mode == 0)
+		opts->mode = DEBUGFS_DEFAULT_MODE;
 
 	while ((p = strsep(&data, ",")) != NULL) {
 		if (!*p)
-- 
1.7.9.5

