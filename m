Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbaCTVh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:37:28 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58465 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759798AbaCTVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:37:27 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] initramfs: print error and shell out for unsupported content
Date: Thu, 20 Mar 2014 22:35:44 +0100
Message-Id: <1395351344-2054-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initramfs generation is broken for file and directory names which contain
colons or spaces. Print an error and don't try to continue.

Tests:

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

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 scripts/gen_initramfs_list.sh | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 17fa901..aacf366 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -171,6 +171,17 @@ dir_filelist() {
 	${dep_list}header "$1"
 
 	srcdir=$(echo "$1" | sed -e 's://*:/:g')
+
+	# Files and directories with spaces and colons are unsupported.
+	local unsupported=$(find "${srcdir}" -regex '.*\(:\| \).*')
+	if [ ! -z "${unsupported}" ]; then
+		printf "ERROR: Unable to handle files/directories with " >&2
+		printf "unsupported characters.\nPlease use other ways " >&2
+		printf "generate a cpio-archive.\nUnsupported files and " >&2
+		printf "directories are:\n$unsupported\n" >&2
+		exit 1
+	fi
+
 	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n")
 
 	# If $dirlist is only one line, then the directory is empty
-- 
1.8.3.1

