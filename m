Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782AbaCTWBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:01:06 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60891 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758484AbaCTWBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:01:03 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH v2] initramfs: print error and shell out for unsupported content
Date: Thu, 20 Mar 2014 23:00:45 +0100
Message-Id: <1395352845-7435-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>
References: <CAAsK9AEeobOG1j6NHUoqkZaZ5h8GGK_fL+gyh9MhSvguQjyU_w@mail.gmail.com>
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
 Silly and trivial changes in v2: Fixed a typo and added 'colons and spaces'

 scripts/gen_initramfs_list.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
index 17fa901..8f4c145 100644
--- a/scripts/gen_initramfs_list.sh
+++ b/scripts/gen_initramfs_list.sh
@@ -171,6 +171,18 @@ dir_filelist() {
 	${dep_list}header "$1"
 
 	srcdir=$(echo "$1" | sed -e 's://*:/:g')
+
+	# Files and directories with spaces and colons are unsupported.
+	local unsupported=$(find "${srcdir}" -regex '.*\(:\| \).*')
+	if [ ! -z "${unsupported}" ]; then
+		printf "ERROR: Unable to handle files/directories with " >&2
+		printf "unsupported characters (spaces and colons).\n" >&2
+		printf "Please use other ways to generate a cpio-archive. " >&2
+		printf "Unsupported files and directories are:\n" >&2
+		printf "$unsupported\n" >&2
+		exit 1
+	fi
+
 	dirlist=$(find "${srcdir}" -printf "%p %m %U %G\n")
 
 	# If $dirlist is only one line, then the directory is empty
-- 
1.8.3.1

