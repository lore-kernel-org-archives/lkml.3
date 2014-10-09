Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbaJIVpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:45:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59014 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194AbaJIVFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 147/163] shmem: fix nlink for rename overwrite directory
Date: Thu,  9 Oct 2014 14:02:52 -0700
Message-Id: <1412888588-26755-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit b928095b0a7cff7fb9fcf4c706348ceb8ab2c295 upstream.

If overwriting an empty directory with rename, then need to drop the extra
nlink.

Test prog:

#include <stdio.h>
#include <fcntl.h>
#include <err.h>
#include <sys/stat.h>

int main(void)
{
	const char *test_dir1 = "test-dir1";
	const char *test_dir2 = "test-dir2";
	int res;
	int fd;
	struct stat statbuf;

	res = mkdir(test_dir1, 0777);
	if (res == -1)
		err(1, "mkdir(\"%s\")", test_dir1);

	res = mkdir(test_dir2, 0777);
	if (res == -1)
		err(1, "mkdir(\"%s\")", test_dir2);

	fd = open(test_dir2, O_RDONLY);
	if (fd == -1)
		err(1, "open(\"%s\")", test_dir2);

	res = rename(test_dir1, test_dir2);
	if (res == -1)
		err(1, "rename(\"%s\", \"%s\")", test_dir1, test_dir2);

	res = fstat(fd, &statbuf);
	if (res == -1)
		err(1, "fstat(%i)", fd);

	if (statbuf.st_nlink != 0) {
		fprintf(stderr, "nlink is %lu, should be 0\n", statbuf.st_nlink);
		return 1;
	}

	return 0;
}

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index de64924..bed15b5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2157,8 +2157,10 @@ static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct
 
 	if (new_dentry->d_inode) {
 		(void) shmem_unlink(new_dir, new_dentry);
-		if (they_are_dirs)
+		if (they_are_dirs) {
+			drop_nlink(new_dentry->d_inode);
 			drop_nlink(old_dir);
+		}
 	} else if (they_are_dirs) {
 		drop_nlink(old_dir);
 		inc_nlink(new_dir);
-- 
1.9.1

