Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaI2NvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:51:16 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:50993 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaI2NvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:51:14 -0400
Date: Mon, 29 Sep 2014 15:51:05 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] generic: check overwriting rename
Message-ID: <20140929135105.GA5011@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This tests whether the file or directory overwritten by rename is properly
removed (nlink is zero).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 .gitignore               |  1 +
 src/Makefile             |  2 +-
 src/t_rename_overwrite.c | 39 ++++++++++++++++++++++++++
 tests/generic/035        | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/035.out    |  3 ++
 tests/generic/group      |  1 +
 6 files changed, 117 insertions(+), 1 deletion(-)
 create mode 100644 src/t_rename_overwrite.c
 create mode 100755 tests/generic/035
 create mode 100644 tests/generic/035.out

diff --git a/.gitignore b/.gitignore
index 5353439..2c9d640 100644
--- a/.gitignore
+++ b/.gitignore
@@ -108,6 +108,7 @@
 /src/aio-dio-regress/aiodio_sparse2
 /src/cloner
 /src/renameat2
+/src/t_rename_overwrite
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/src/Makefile b/src/Makefile
index a539c4a..4781736 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -11,7 +11,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
-	t_mmap_writev t_truncate_cmtime dirhash_collide
+	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_rename_overwrite.c b/src/t_rename_overwrite.c
new file mode 100644
index 0000000..fe17f9d
--- /dev/null
+++ b/src/t_rename_overwrite.c
@@ -0,0 +1,39 @@
+#include <stdio.h>
+#include <fcntl.h>
+#include <err.h>
+#include <sys/stat.h>
+
+int main(int argc, char *argv[])
+{
+	const char *path1;
+	const char *path2;
+	struct stat stbuf;
+	int res;
+	int fd;
+
+	if (argc != 3) {
+		fprintf(stderr, "usage: %s path1 path2\n", argv[0]);
+		return 1;
+	}
+
+	path1 = argv[1];
+	path2 = argv[2];
+	fd = open(path2, O_RDONLY);
+	if (fd == -1)
+		err(1, "open(\"%s\")", path2);
+
+	res = rename(path1, path2);
+	if (res == -1)
+		err(1, "rename(\"%s\", \"%s\")", path1, path2);
+
+	res = fstat(fd, &stbuf);
+	if (res == -1)
+		err(1, "fstat(%i)", fd);
+
+	if (stbuf.st_nlink != 0) {
+		fprintf(stderr, "nlink is %lu, should be 0\n", stbuf.st_nlink);
+		return 1;
+	}
+
+	return 0;
+}
diff --git a/tests/generic/035 b/tests/generic/035
new file mode 100755
index 0000000..443ddd5
--- /dev/null
+++ b/tests/generic/035
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FS QA Test No. generic/035
+#
+# Check overwriting rename system call
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Miklos Szeredi.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+
+_supported_fs generic
+_supported_os Linux
+
+_require_test
+
+# real QA test starts here
+
+rename_dir=$TEST_DIR/$$
+mkdir -p $rename_dir
+
+echo "overwriting regular file:"
+file1=$rename_dir/file1
+file2=$rename_dir/file2
+touch $file1
+touch $file2
+src/t_rename_overwrite $file1 $file2
+rm $file2
+
+echo "overwriting directory:"
+dir1=$rename_dir/dir1
+dir2=$rename_dir/dir2
+mkdir $dir1
+mkdir $dir2
+src/t_rename_overwrite $dir1 $dir2
+rmdir $dir2
+
+rmdir $rename_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/035.out b/tests/generic/035.out
new file mode 100644
index 0000000..4f68cc1
--- /dev/null
+++ b/tests/generic/035.out
@@ -0,0 +1,3 @@
+QA output created by 035
+overwriting regular file:
+overwriting directory:
diff --git a/tests/generic/group b/tests/generic/group
index 799bfd8..9c82a6f 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -37,6 +37,7 @@
 032 auto quick rw
 033 auto quick rw
 034 auto quick metadata log
+035 auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.1.4

