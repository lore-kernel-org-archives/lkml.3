Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412AbaK0I4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:56:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:42476 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbaK0It1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:27 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 68/91] shmem: fix nlink for rename overwrite directory
Date: Thu, 27 Nov 2014 16:42:51 +0800
Message-Id: <1417077794-9299-68-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 4bb5a80..0b77082 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1725,8 +1725,10 @@ static int shmem_rename(struct inode *old_dir, struct dentry *old_dentry, struct
 
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

