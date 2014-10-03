Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbaJCWHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:07:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932432AbaJCWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Miklos Szeredi <mszeredi@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 3.14 132/238] shmem: fix nlink for rename overwrite directory
Date: Fri,  3 Oct 2014 14:30:47 -0700
Message-Id: <20141003212917.893404340@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/shmem.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2143,8 +2143,10 @@ static int shmem_rename(struct inode *ol
 
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


