Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaKAW4t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:56:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60105 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbaKAWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Al Viro" <viro@zeniv.linux.org.uk>,
        "Miklos Szeredi" <mszeredi@suse.cz>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.876822152@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 074/102] shmem: fix nlink for rename overwrite directory
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/shmem.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1719,8 +1719,10 @@ static int shmem_rename(struct inode *ol
 
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

