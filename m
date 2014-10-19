Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaJSHTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 03:19:14 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:42105 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaJSHTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 03:19:10 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        Alexander Holler <holler@ahsoftware.de>, <stable@vger.kernel.org>
Subject: [PATCH 2/2 v4] initramfs: print error and shell out for unsupported content
Date: Sun, 19 Oct 2014 09:18:43 +0200
Message-Id: <1413703123-2991-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1413703123-2991-1-git-send-email-holler@ahsoftware.de>
References: <533AFCC3.3030504@ahsoftware.de>
 <1413703123-2991-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initramfs generation is broken for file and directory names which contain
colons, spaces and other unusual characters which can't be included in names
for dependencies in traditional Makefiles (which gen_initramfs_list.sh
generates). Print an error for the most common unsupported characters (colons
and whitespace) and don't try to continue if these are discovered.

Some tests:

cd linux
make defconfig
echo 'CONFIG_BLK_DEV_INITRD=y' >> .config
echo 'CONFIG_INITRAMFS_ROOT_UID=0' >>.config
echo 'CONFIG_INITRAMFS_ROOT_GID=0' >>.config
echo 'CONFIG_INITRAMFS_COMPRESSION_NONE=y' >>.config
echo 'CONFIG_INITRAMFS_SOURCE="/tmp/bugroot"' >>.config

Problem with colons:

mkdir -p /tmp/bugroot/a:b
make -j4 bzImage # no error
make bzImage # try again, oops

Problem with spaces:

mkdir -p /tmp/bugroot/a\ b
make -j4 bzImage # no error
zcat usr/initramfs_data.cpio.gz | cpio --extract --list # oops, no content

Cc: <stable@vger.kernel.org>
---

 Changes to v3:
   - Uses find with -name and an expression suggested by Michael Marek
     instead of find -regex. Therefor I've added his Signed-off-by.
   - Detail the unsupported characters which which will be discovered in
     the commit message.

 scripts/gen_initramfs_list.sh | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 17fa901..53398d5 100755
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -171,6 +171,19 @@ dir_filelist() {
 	${dep_list}header "$1"
 
 	srcdir=$(echo "$1" | sed -e 's://*:/:g')
+
+	# Files and directories with spaces and colons are unsupported.
+	local unsupported=$(find "${srcdir}" -name '*[:[:space:]]*')
+	if [ ! -z "${unsupported}" ]; then
+		printf "ERROR: Unable to handle files/directories with " >&2
+		printf "unsupported characters (spaces, :, \\\n, \\\r, " >&2
+		printf "\\\t).\n Please use other ways to generate a " >&2
+		printf "cpio-archive with such names.\n" >&2
+		printf "Unsupported files and directories are:\n" >&2
+		printf "$unsupported\n" >&2
+		exit 1
+	fi
+
 	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n")
 
 	# If $dirlist is only one line, then the directory is empty
-- 
1.8.3.1

