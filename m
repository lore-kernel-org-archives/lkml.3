Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618Ab3B0SHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 13:07:45 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:53681 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758009Ab3B0SHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 13:07:42 -0500
From: jlec@gentoo.org
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Justin Lecher <jlec@gentoo.org>
Subject: [PATCH 1/2] Use config scripts to detect ncurses libs for menuconfig
Date: Wed, 27 Feb 2013 19:07:37 +0100
Message-Id: <1361988458-18486-1-git-send-email-jlec@gentoo.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <jlec@gentoo.org>
References: <jlec@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Lecher <jlec@gentoo.org>

When building ncurses with --with-termlib several symbols get moved from
libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
additionally needs to link with libtinfo.so.

Ncurses provides a config script (ncurses5-config) to assist finding ncurses.
This patch makes use of it to detect the necessary libs for linking of the
ncurses menuconfig dialog.

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index c8e8a71..e429207 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,15 +4,23 @@
 # What library to link
 ldflags()
 {
-	for ext in so a dll.a dylib ; do
-		for lib in ncursesw ncurses curses ; do
-			$cc -print-file-name=lib${lib}.${ext} | grep -q /
-			if [ $? -eq 0 ]; then
-				echo "-l${lib}"
-				exit
-			fi
+	if ncursesw5-config --libs >/dev/null 2>&1; then
+		ncursesw5-config --libs
+		exit
+	elif ncurses5-config --libs >/dev/null 2>&1; then
+		ncurses5-config --libs
+		exit
+	else
+		for ext in so a dll.a dylib ; do
+			for lib in ncursesw ncurses curses ; do
+				$cc -print-file-name=lib${lib}.${ext} | grep -q /
+				if [ $? -eq 0 ]; then
+					echo "-l${lib}"
+					exit
+				fi
+			done
 		done
-	done
+	fi
 	exit 1
 }
 
-- 
1.8.1.4

