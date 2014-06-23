Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaFWBdG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:33:06 -0400
Received: from linuxhacker.ru ([217.76.32.60]:39791 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbaFWBdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:33:00 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Bob Glossman <bob.glossman@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 15/18] staging/lustre/obdclass: runtime load lustre client when needed
Date: Sun, 22 Jun 2014 21:32:19 -0400
Message-Id: <1403487142-4880-16-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
References: <1403487142-4880-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Glossman <bob.glossman@intel.com>

Manually force loading of lustre.ko during client
mounts with request_module for cases where
autoloading doesn't happen.

Signed-off-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-on: http://review.whamcloud.com/10587
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4800
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Yang Sheng <yang.sheng@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/obd_mount.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/obd_mount.c b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
index 03d9a6a..4e77f07 100644
--- a/drivers/staging/lustre/lustre/obdclass/obd_mount.c
+++ b/drivers/staging/lustre/lustre/obdclass/obd_mount.c
@@ -1216,7 +1216,9 @@ int lustre_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (lmd_is_client(lmd)) {
 		CDEBUG(D_MOUNT, "Mounting client %s\n", lmd->lmd_profile);
-		if (!client_fill_super) {
+		if (client_fill_super == NULL)
+			request_module("lustre");
+		if (client_fill_super == NULL) {
 			LCONSOLE_ERROR_MSG(0x165, "Nothing registered for "
 					   "client mount! Is the 'lustre' "
 					   "module loaded?\n");
@@ -1299,6 +1301,7 @@ struct file_system_type lustre_fs_type = {
 	.fs_flags     = FS_BINARY_MOUNTDATA | FS_REQUIRES_DEV |
 			FS_HAS_FIEMAP | FS_RENAME_DOES_D_MOVE,
 };
+MODULE_ALIAS_FS("lustre");
 
 int lustre_register_fs(void)
 {
-- 
1.9.0

