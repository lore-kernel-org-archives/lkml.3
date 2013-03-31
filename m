Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3CaCvi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 22:51:38 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:35198 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab3CaCvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 22:51:37 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH] f2fs-tools: mkfs: fix to avoid format of device when already mounted
Date: Sun, 31 Mar 2013 11:51:29 +0900
Message-Id: <1364698289-22182-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

In case of embedded devices, where /etc/ is mounted as 'read-only'.
We donot have the /etc/mtab file. So, checking if the device is already
mounted from this file is not sufficient.
Try to read /proc/mounts in case of failure from /etc/mtab.

Issue logs:
/dev/sdb4 /mnt vfat rw,relatime,fmask=0022,dmask=0022,codepage=cp437,
iocharset=ascii,errors=remount-ro 0 0

Here device - sb4 is already mounted.
But, when trying to format using mkfs.f2fs

F2FS-tools: Ver: 1.1.0 (2013-01-14)
Info: sector size = 512
Info: total sectors = 13108784 (in 512bytes)
WARN: Align start sector number in a unit of pages
        i.e., start sector: 2542124, ofs:4 (sectors per page: 8)
Info: zone aligned segment0 blkaddr: 186
Info: This device doesn't support TRIM
Info: format successful

After Change:

F2FS-tools: Ver: 1.1.0 (2013-01-14)
Error: /dev/sdb4 is already mounted

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 lib/libf2fs.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/libf2fs.c b/lib/libf2fs.c
index 37ed147..d228492 100644
--- a/lib/libf2fs.c
+++ b/lib/libf2fs.c
@@ -152,8 +152,13 @@ int f2fs_dev_is_mounted(struct f2fs_configuration *c)
 	struct mntent *mnt = NULL;
 
 	file = setmntent(MOUNTED, "r");
-	if (file == NULL)
-		return 0;
+	if (file == NULL) {
+		/* if failed due to /etc/mtab file not present
+		   try with /proc/mounts */
+		file = setmntent("/proc/mounts", "r");
+		if (file == NULL)
+			return 0;
+	}
 
 	while (1) {
 		mnt = getmntent(file);
-- 
1.7.9.5

