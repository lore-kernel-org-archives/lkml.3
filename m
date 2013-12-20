Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab3LTKWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:22:23 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:16031 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab3LTKWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:22:20 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <git@vger.kernel.org>
CC: Wang Nan <wangnan0@huawei.com>
Subject: [PATCH] git-quiltimport: add a --series option
Date: Fri, 20 Dec 2013 18:21:27 +0800
Message-ID: <1387534887-68321-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a --series option to git-quiltimport to allow users to
select the name of series file. This option is an analog of quilt's
QUILT_SERIES environment variable.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 Documentation/git-quiltimport.txt |  5 +++++
 git-quiltimport.sh                | 21 ++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/Documentation/git-quiltimport.txt b/Documentation/git-quiltimport.txt
index a356196..39d8e4b 100644
--- a/Documentation/git-quiltimport.txt
+++ b/Documentation/git-quiltimport.txt
@@ -44,6 +44,11 @@ OPTIONS
 --patches <dir>::
 	The directory to find the quilt patches and the
 	quilt series file.
+
+--series <file>::
+	The name of the series file, defaulting to "series". Relative to
+	patches directory unless an absolute path is used.
+
 +
 The default for the patch directory is patches
 or the value of the $QUILT_PATCHES environment
diff --git a/git-quiltimport.sh b/git-quiltimport.sh
index 8e17525..11a97b4 100755
--- a/git-quiltimport.sh
+++ b/git-quiltimport.sh
@@ -6,6 +6,7 @@ git quiltimport [options]
 n,dry-run     dry run
 author=       author name and email address for patches without any
 patches=      path to the quilt series and patches
+series=       name of the series file
 "
 SUBDIRECTORY_ON=Yes
 . git-sh-setup
@@ -26,6 +27,10 @@ do
 		shift
 		QUILT_PATCHES="$1"
 		;;
+	--series)
+		shift
+		QUILT_SERIES="$1"
+		;;
 	--)
 		shift
 		break;;
@@ -52,6 +57,20 @@ if ! [ -d "$QUILT_PATCHES" ] ; then
 	exit 1
 fi
 
+: ${QUILT_SERIES:=series}
+case ${QUILT_SERIES} in
+	/*)
+		QUILT_SERIES_FILE=${QUILT_SERIES}
+	   ;;
+	*)
+		QUILT_SERIES_FILE=${QUILT_PATCHES}/${QUILT_SERIES}
+esac
+
+if ! [ -f "$QUILT_SERIES_FILE" ] ; then
+	echo "The \"$QUILT_SERIES_FILE\" file does not exist."
+	exit 1
+fi
+
 # Temporary directories
 tmp_dir="$GIT_DIR"/rebase-apply
 tmp_msg="$tmp_dir/msg"
@@ -134,5 +153,5 @@ do
 		commit=$( (echo "$SUBJECT"; echo; cat "$tmp_msg") | git commit-tree $tree -p $commit) &&
 		git update-ref -m "quiltimport: $patch_name" HEAD $commit || exit 4
 	fi
-done 3<"$QUILT_PATCHES/series"
+done 3<"$QUILT_SERIES_FILE"
 rm -rf $tmp_dir || exit 5
-- 
1.8.4

