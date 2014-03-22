Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaCVMax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 08:30:53 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34425 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaCVMaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 08:30:04 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Alexander Holler <holler@ahsoftware.de>, <stable@vger.kernel.org>
Subject: [PATCH 2/2 v3] initramfs: print error and shell out for unsupported content
Date: Sat, 22 Mar 2014 13:29:21 +0100
Message-Id: <1395491361-28069-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395491361-28069-1-git-send-email-holler@ahsoftware.de>
References: <532CC625.7020509@ahsoftware.de>
 <1395491361-28069-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The initramfs generation is broken for file and directory names which contain
colons, spaces and other unusual characters. Print an error and don't try to
continue.

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

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: <stable@vger.kernel.org>
---
 Changes in v2, v3: check for \n, \r and \t too, updated error msg.

 scripts/gen_initramfs_list.sh | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 17fa901..2c613e7 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -171,6 +171,19 @@ dir_filelist() {
 	${dep_list}header "$1"
 
 	srcdir=$(echo "$1" | sed -e 's://*:/:g')
+
+	# Files and directories with spaces and colons are unsupported.
+	local unsupported=$(find "${srcdir}" -regex '.*\(:\| \|\n\|\r\|\t\).*')
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

