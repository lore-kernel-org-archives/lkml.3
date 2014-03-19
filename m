Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934271AbaCSN5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:57:19 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64091 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSN5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:57:16 -0400
Date: Wed, 19 Mar 2014 14:57:06 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Dave Chinner <david@fromorbit.com>
Cc: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: xfstest for renameat2 system call (was: [PATCH 00/13] cross rename
 v4)
Message-ID: <20140319135706.GA24182@tucsk.piliscsaba.szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
 <20140210105145.GW13997@dastard>
 <20140211160141.GD8204@tucsk.piliscsaba.szeredi.hu>
 <20140212171852.GA4026@tucsk.piliscsaba.szeredi.hu>
 <20140217081911.GZ13647@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140217081911.GZ13647@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Mon, Feb 17, 2014 at 07:19:11PM +1100, Dave Chinner wrote:
> On Wed, Feb 12, 2014 at 06:18:52PM +0100, Miklos Szeredi wrote:
> > On Tue, Feb 11, 2014 at 05:01:41PM +0100, Miklos Szeredi wrote:
> > > On Mon, Feb 10, 2014 at 09:51:45PM +1100, Dave Chinner wrote:
> > 
> > > > Miklos, can you please write an xfstest for this new API? That way
> > > > we can verify that the behaviour is as documented, and we can ensure
> > > > that when we implement it on other filesystems it works exactly the
> > > > same on all filesystems?
> > 
> > This is a standalone testprog, but I guess it's trivial to integrate into
> > xfstests.
> 
> Same problem with integrating any standalone test program into
> xfstests - we end up with a standalone pass/fail test instead of a
> bunch of components we can reuse and refactor for other tests.  But
> we can work around that for the moment.
> 
> [ FWIW, the normal way to write an xfstest like this is to write a
> small helper program that just does the renameat2() syscall (we
> often use xfs_io to provide this) and everything is just shell
> scripts to drive the helper program in the necessary way. We don't
> directly check that mode, size, destination of a file is correct -
> just stat(1) on the expected destinations is sufficient to capture
> this information. stdout is captured by the test harness and used to match
> against a golden output. If the match fails, the test fails.
> 
> This would allow us to use the same test infrastructure for testing
> a coreutils binary that implemented renameat2 when that comes
> along... ]

Okay, here's a patch for xfstests implementing the above.

The renameat2 patches aren't merged yet, but I hope they will be in the 3.15
cycle.  Until then this is just an RFC.

Thanks,
Miklos
----

commit 367394034ce4926adc368f5ad7568b088e324a21
Author: Miklos Szeredi <mszeredi@suse.cz>
Date:   Wed Mar 19 14:33:43 2014 +0100

    add tests for renameat2 syscall
    
    tests/generic/323: plain rename
    tests/generic/324: noreplace rename
    tests/generic/325: cross rename

diff --git a/.gitignore b/.gitignore
index b6f2463..5d5ef1e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -105,6 +105,7 @@
 /src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer
 /src/aio-dio-regress/aiodio_sparse2
 /src/cloner
+/src/renameat2
 
 # dmapi/ binaries
 /dmapi/src/common/cmd/read_invis
diff --git a/common/renameat2 b/common/renameat2
new file mode 100644
index 0000000..e235c4c
--- /dev/null
+++ b/common/renameat2
@@ -0,0 +1,128 @@
+######
+#
+# renameat2 helpers
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
+#
+# Setup source or dest
+#
+_setup_one()
+{
+    path=$1
+    type=$2
+
+    case $type in
+	none)	;;
+	regu)	echo foo > $path;;
+	symb)	ln -s foo $path;;
+	dire)	mkdir $path;;
+	tree)	mkdir $path; echo foo > $path/bar;;
+    esac
+}
+
+#
+# Cleanup source or dest
+#
+_cleanup_one()
+{
+    path=$1
+
+    if test -d $path; then
+	rm -f $path/bar
+	rmdir $path
+    else
+	rm -f $path
+    fi
+}
+
+#
+# Check type of source or destination
+#
+_showtype_one()
+{
+    path=$1
+
+    if test -e $path -o -h $path; then
+	if test -d $path -a -e $path/bar; then
+		echo -n "tree"
+	else
+	    echo -n `stat -c %F $path | cut -b-4`
+	fi
+    else
+	echo -n "none"
+    fi
+}
+
+#
+# This runs renameat2 on all combinations of source and dest
+#
+_rename_tests_source_dest()
+{
+    source=$1
+    dest=$2
+    options=$3
+
+    for stype in none regu symb dire tree; do
+	for dtype in none regu symb dire tree; do
+	    echo -n "$options $stype/$dtype -> "
+	    _setup_one $source $stype
+	    _setup_one $dest $dtype
+	    src/renameat2 $source $dest $flags
+	    if test $? == 0; then
+		_showtype_one $source
+		echo -n "/"
+		_showtype_one $dest
+		echo "."
+	    fi
+	    _cleanup_one $source
+	    _cleanup_one $dest
+	done
+    done
+}
+
+#
+# This runs _rename_tests_source_dest() for both same-directory and
+# cross-directory renames
+#
+_rename_tests()
+{
+    flags=$1
+
+    #same directory renames
+    _rename_tests_source_dest $tmp/src $tmp/dst     "samedir "
+
+    #cross directory renames
+    mkdir $tmp/x $tmp/y
+    _rename_tests_source_dest $tmp/x/src $tmp/y/dst "crossdir"
+    rmdir $tmp/x $tmp/y
+}
+
+#
+# This checks whether the renameat2 syscall is supported
+#
+_requires_renameat2()
+{
+    if test ! -x src/renameat2; then
+	_notrun "renameat2 binary not found"
+    fi
+    if ! src/renameat2 -t; then
+	_notrun "kernel doesn't support renameat2 syscall"
+    fi
+}
diff --git a/configure.ac b/configure.ac
index 2f95c4c..43e6029 100644
--- a/configure.ac
+++ b/configure.ac
@@ -76,6 +76,8 @@ in
 		;;
 esac
 
+AC_CHECK_FUNCS([renameat2])
+
 AC_CONFIG_HEADER(include/config.h)
 AC_CONFIG_FILES([include/builddefs])
 AC_OUTPUT
diff --git a/src/Makefile b/src/Makefile
index 6509f2d..0fda008 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,8 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner
+	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
+	renameat2
 
 SUBDIRS =
 
diff --git a/src/renameat2.c b/src/renameat2.c
new file mode 100644
index 0000000..5145959
--- /dev/null
+++ b/src/renameat2.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2014, Miklos Szeredi <mszeredi@suse.cz>
+ * This file is published under GPL2+.
+ *
+ * This is a trivial wrapper around the renameat2 syscall.
+ */
+
+#include "global.h"
+
+#ifndef HAVE_RENAMEAT2
+#include <sys/syscall.h>
+
+#if !defined(SYS_renameat2) && defined(__x86_64__)
+#define SYS_renameat2 316
+#endif
+
+static int renameat2(int dfd1, const char *path1,
+		     int dfd2, const char *path2,
+		     unsigned int flags)
+{
+#ifdef SYS_renameat2
+	return syscall(SYS_renameat2, dfd1, path1, dfd2, path2, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+#endif
+
+#ifndef RENAME_NOREPLACE
+#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
+#endif
+#ifndef RENAME_EXCHANGE
+#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#endif
+#ifndef RENAME_WHITEOUT
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#endif
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	int c;
+	const char *path1 = NULL;
+	const char *path2 = NULL;
+	unsigned int flags = 0;
+	int test = 0;
+
+	for (c = 1; c < argc; c++) {
+		if (argv[c][0] == '-') {
+			switch (argv[c][1]) {
+			case 't':
+				test = 1;
+				break;
+			case 'n':
+				flags |= RENAME_NOREPLACE;
+				break;
+			case 'x':
+				flags |= RENAME_EXCHANGE;
+				break;
+			case 'w':
+				flags |= RENAME_WHITEOUT;
+				break;
+			default:
+				goto usage;
+			}
+		} else if (!path1) {
+			path1 = argv[c];
+		} else if (!path2) {
+			path2 = argv[c];
+		} else {
+			goto usage;
+		}
+	}
+
+	if (!test && (!path1 || !path2))
+		goto usage;
+
+	ret = renameat2(AT_FDCWD, path1, AT_FDCWD, path2, flags);
+	if (ret == -1) {
+		if (test) {
+			if (errno == ENOSYS || errno == EINVAL)
+				return 1;
+			else
+				return 0;
+		}
+		perror("");
+		return 1;
+	}
+
+	return 0;
+
+usage:
+	fprintf(stderr,
+		"usage: %s [-t] [-n|-x|-w] path1 path2\n"
+		"  -t  test\n"
+		"  -n  noreplace\n"
+		"  -x  exchange\n"
+		"  -w  whiteout\n", argv[0]);
+
+	return 1;
+}
diff --git a/tests/generic/323 b/tests/generic/323
new file mode 100755
index 0000000..1f17246
--- /dev/null
+++ b/tests/generic/323
@@ -0,0 +1,56 @@
+#! /bin/bash
+# FS QA Test No. 323
+#
+# Check renameat2 syscall without flags
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
+tmp=$TEST_DIR/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/renameat2
+
+_supported_fs generic
+_supported_os Linux
+
+_requires_renameat2
+
+# real QA test starts here
+
+mkdir $tmp
+_rename_tests
+rmdir $tmp
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/323.out b/tests/generic/323.out
new file mode 100644
index 0000000..bb85b9a
--- /dev/null
+++ b/tests/generic/323.out
@@ -0,0 +1,51 @@
+QA output created by 323
+samedir  none/none -> No such file or directory
+samedir  none/regu -> No such file or directory
+samedir  none/symb -> No such file or directory
+samedir  none/dire -> No such file or directory
+samedir  none/tree -> No such file or directory
+samedir  regu/none -> none/regu.
+samedir  regu/regu -> none/regu.
+samedir  regu/symb -> none/regu.
+samedir  regu/dire -> Is a directory
+samedir  regu/tree -> Is a directory
+samedir  symb/none -> none/symb.
+samedir  symb/regu -> none/symb.
+samedir  symb/symb -> none/symb.
+samedir  symb/dire -> Is a directory
+samedir  symb/tree -> Is a directory
+samedir  dire/none -> none/dire.
+samedir  dire/regu -> Not a directory
+samedir  dire/symb -> Not a directory
+samedir  dire/dire -> none/dire.
+samedir  dire/tree -> Directory not empty
+samedir  tree/none -> none/tree.
+samedir  tree/regu -> Not a directory
+samedir  tree/symb -> Not a directory
+samedir  tree/dire -> none/tree.
+samedir  tree/tree -> Directory not empty
+crossdir none/none -> No such file or directory
+crossdir none/regu -> No such file or directory
+crossdir none/symb -> No such file or directory
+crossdir none/dire -> No such file or directory
+crossdir none/tree -> No such file or directory
+crossdir regu/none -> none/regu.
+crossdir regu/regu -> none/regu.
+crossdir regu/symb -> none/regu.
+crossdir regu/dire -> Is a directory
+crossdir regu/tree -> Is a directory
+crossdir symb/none -> none/symb.
+crossdir symb/regu -> none/symb.
+crossdir symb/symb -> none/symb.
+crossdir symb/dire -> Is a directory
+crossdir symb/tree -> Is a directory
+crossdir dire/none -> none/dire.
+crossdir dire/regu -> Not a directory
+crossdir dire/symb -> Not a directory
+crossdir dire/dire -> none/dire.
+crossdir dire/tree -> Directory not empty
+crossdir tree/none -> none/tree.
+crossdir tree/regu -> Not a directory
+crossdir tree/symb -> Not a directory
+crossdir tree/dire -> none/tree.
+crossdir tree/tree -> Directory not empty
diff --git a/tests/generic/324 b/tests/generic/324
new file mode 100755
index 0000000..9a66f14
--- /dev/null
+++ b/tests/generic/324
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 324
+#
+# Check renameat2 syscall with RENAME_NOREPLACE flag
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
+tmp=$TEST_DIR/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/renameat2
+
+_supported_fs generic
+_supported_os Linux
+
+_requires_renameat2
+
+mkdir $tmp
+touch $tmp/foo
+if ! src/renameat2 -t -n $tmp/foo $tmp/bar; then
+    rm -f $tmp/foo $tmp/bar; rmdir $tmp
+    _notrun "fs doesn't support RENAME_NOREPLACE"
+fi
+rm -f $tmp/foo $tmp/bar
+
+# real QA test starts here
+
+_rename_tests -n
+rmdir $tmp
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/324.out b/tests/generic/324.out
new file mode 100644
index 0000000..fff5547
--- /dev/null
+++ b/tests/generic/324.out
@@ -0,0 +1,51 @@
+QA output created by 324
+samedir  none/none -> No such file or directory
+samedir  none/regu -> No such file or directory
+samedir  none/symb -> No such file or directory
+samedir  none/dire -> No such file or directory
+samedir  none/tree -> No such file or directory
+samedir  regu/none -> none/regu.
+samedir  regu/regu -> File exists
+samedir  regu/symb -> File exists
+samedir  regu/dire -> File exists
+samedir  regu/tree -> File exists
+samedir  symb/none -> none/symb.
+samedir  symb/regu -> File exists
+samedir  symb/symb -> File exists
+samedir  symb/dire -> File exists
+samedir  symb/tree -> File exists
+samedir  dire/none -> none/dire.
+samedir  dire/regu -> File exists
+samedir  dire/symb -> File exists
+samedir  dire/dire -> File exists
+samedir  dire/tree -> File exists
+samedir  tree/none -> none/tree.
+samedir  tree/regu -> File exists
+samedir  tree/symb -> File exists
+samedir  tree/dire -> File exists
+samedir  tree/tree -> File exists
+crossdir none/none -> No such file or directory
+crossdir none/regu -> No such file or directory
+crossdir none/symb -> No such file or directory
+crossdir none/dire -> No such file or directory
+crossdir none/tree -> No such file or directory
+crossdir regu/none -> none/regu.
+crossdir regu/regu -> File exists
+crossdir regu/symb -> File exists
+crossdir regu/dire -> File exists
+crossdir regu/tree -> File exists
+crossdir symb/none -> none/symb.
+crossdir symb/regu -> File exists
+crossdir symb/symb -> File exists
+crossdir symb/dire -> File exists
+crossdir symb/tree -> File exists
+crossdir dire/none -> none/dire.
+crossdir dire/regu -> File exists
+crossdir dire/symb -> File exists
+crossdir dire/dire -> File exists
+crossdir dire/tree -> File exists
+crossdir tree/none -> none/tree.
+crossdir tree/regu -> File exists
+crossdir tree/symb -> File exists
+crossdir tree/dire -> File exists
+crossdir tree/tree -> File exists
diff --git a/tests/generic/325 b/tests/generic/325
new file mode 100755
index 0000000..dfd4331
--- /dev/null
+++ b/tests/generic/325
@@ -0,0 +1,63 @@
+#! /bin/bash
+# FS QA Test No. 325
+#
+# Check renameat2 syscall without flags
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
+tmp=$TEST_DIR/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/renameat2
+
+_supported_fs generic
+_supported_os Linux
+
+_requires_renameat2
+
+mkdir $tmp
+touch $tmp/foo $tmp/bar
+if ! src/renameat2 -t -x $tmp/foo $tmp/bar; then
+    rm -f $tmp/foo $tmp/bar; rmdir $tmp
+    _notrun "fs doesn't support RENAME_EXCHANGE"
+fi
+rm -f $tmp/foo $tmp/bar
+
+# real QA test starts here
+
+_rename_tests -x
+rmdir $tmp
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/325.out b/tests/generic/325.out
new file mode 100644
index 0000000..f73d7c1
--- /dev/null
+++ b/tests/generic/325.out
@@ -0,0 +1,51 @@
+QA output created by 325
+samedir  none/none -> No such file or directory
+samedir  none/regu -> No such file or directory
+samedir  none/symb -> No such file or directory
+samedir  none/dire -> No such file or directory
+samedir  none/tree -> No such file or directory
+samedir  regu/none -> No such file or directory
+samedir  regu/regu -> regu/regu.
+samedir  regu/symb -> symb/regu.
+samedir  regu/dire -> dire/regu.
+samedir  regu/tree -> tree/regu.
+samedir  symb/none -> No such file or directory
+samedir  symb/regu -> regu/symb.
+samedir  symb/symb -> symb/symb.
+samedir  symb/dire -> dire/symb.
+samedir  symb/tree -> tree/symb.
+samedir  dire/none -> No such file or directory
+samedir  dire/regu -> regu/dire.
+samedir  dire/symb -> symb/dire.
+samedir  dire/dire -> dire/dire.
+samedir  dire/tree -> tree/dire.
+samedir  tree/none -> No such file or directory
+samedir  tree/regu -> regu/tree.
+samedir  tree/symb -> symb/tree.
+samedir  tree/dire -> dire/tree.
+samedir  tree/tree -> tree/tree.
+crossdir none/none -> No such file or directory
+crossdir none/regu -> No such file or directory
+crossdir none/symb -> No such file or directory
+crossdir none/dire -> No such file or directory
+crossdir none/tree -> No such file or directory
+crossdir regu/none -> No such file or directory
+crossdir regu/regu -> regu/regu.
+crossdir regu/symb -> symb/regu.
+crossdir regu/dire -> dire/regu.
+crossdir regu/tree -> tree/regu.
+crossdir symb/none -> No such file or directory
+crossdir symb/regu -> regu/symb.
+crossdir symb/symb -> symb/symb.
+crossdir symb/dire -> dire/symb.
+crossdir symb/tree -> tree/symb.
+crossdir dire/none -> No such file or directory
+crossdir dire/regu -> regu/dire.
+crossdir dire/symb -> symb/dire.
+crossdir dire/dire -> dire/dire.
+crossdir dire/tree -> tree/dire.
+crossdir tree/none -> No such file or directory
+crossdir tree/regu -> regu/tree.
+crossdir tree/symb -> symb/tree.
+crossdir tree/dire -> dire/tree.
+crossdir tree/tree -> tree/tree.
diff --git a/tests/generic/group b/tests/generic/group
index a99b6a1..7683e22 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -127,3 +127,6 @@
 320 auto rw
 321 auto quick metadata log
 322 auto quick metadata log
+323 auto quick
+324 auto quick
+325 auto quick
