Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab3CCTtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 14:49:46 -0500
Received: from mail1.windriver.com ([147.11.146.13]:57745 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3CCTto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 14:49:44 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: <mmarek@suse.cz>
CC: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] menuconfig,check-lxdiaglog.sh: Allow specification of ncurses location
Date: Sun, 3 Mar 2013 13:48:44 -0600
Message-ID: <1362340124-2768-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cross build environments such as the Yocto Project build
environment it provides an ncurses library that is compiled
differently than the host's version.  This causes display corruption
problems when the host's curses includes are used instead of the
includes from the provided compiler are overridden.  There is a second
case where there is no curses libraries at all on the host system and
menuconfig will just fail entirely.

The solution is simply to allow an override variable in
check-lxdialog.sh for environments such as the Yocto Project.  Adding
a CROSS_CURSES_LIB and CROSS_CURSES_INC solves the issue and allowing
compiling and linking against the right headers and libraries.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
cc: Michal Marek <mmarek@suse.cz>
cc: linux-kbuild@vger.kernel.org
---
 scripts/kconfig/lxdialog/check-lxdialog.sh |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 8078813..99473e4 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,6 +4,10 @@
 # What library to link
 ldflags()
 {
+	if [ x"$CROSS_CURSES_LIB" != x ]; then
+		echo "$CROSS_CURSES_LIB"
+		exit
+	fi
 	for ext in so a dll.a dylib ; do
 		for lib in ncursesw ncurses curses ; do
 			$cc -print-file-name=lib${lib}.${ext} | grep -q /
@@ -19,6 +23,10 @@ ldflags()
 # Where is ncurses.h?
 ccflags()
 {
+	if [ x"$CROSS_CURSES_INC" != x ]; then
+		echo "$CROSS_CURSES_INC"
+		exit
+	fi
 	if [ -f /usr/include/ncursesw/curses.h ]; then
 		echo '-I/usr/include/ncursesw -DCURSES_LOC="<ncursesw/curses.h>"'
 		echo ' -DNCURSES_WIDECHAR=1'
-- 
1.7.9.5

