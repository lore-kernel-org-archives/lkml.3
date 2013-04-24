Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3DXWal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 18:30:41 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63375 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab3DXWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 18:30:24 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 3/8] kconfig/lxdialog: rationalise the include paths where to find {.n}curses{,w}.h
Date: Thu, 25 Apr 2013 00:29:50 +0200
Message-Id: <cdf0c2cfd75c6c2f2a6eee5e21ff0e8271bd0660.1366841993.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

The current code does this:

    if [ -f /usr/include/ncursesw/curses.h ]; then
        echo '-I/usr/include/ncursesw -DCURSES_LOC="<ncursesw/curses.h>"'
    elif [ -f /usr/include/ncurses/ncurses.h ]; then
        echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses.h>"'
    elif [ -f /usr/include/ncurses/curses.h ]; then
        echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses/curses.h>"'
    [...]

This is merely inconsistent:
  - adding the full path to the directory in the -I directive,
  - especially since that path is already a sub-path of the system
    include path,
  - and then repeating the sub-path in the #include directive.

Rationalise each include directive:
  - only use the filename in the #include directive,
  - keep the -I directives: they are always searched for before the
    system include path; this ensures the correct header is used.

Using the -I directives and the filename-only in #include is more in
line with how pkg-config behaves, eg.:
    $ pkg-config --cflags ncursesw
    -I/usr/include/ncursesw

This paves the way for using pkg-config for CFLAGS, too, now we use it
to find the libraries.

Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 782d200..9d2a4c5 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -22,12 +22,12 @@ ldflags()
 ccflags()
 {
 	if [ -f /usr/include/ncursesw/curses.h ]; then
-		echo '-I/usr/include/ncursesw -DCURSES_LOC="<ncursesw/curses.h>"'
+		echo '-I/usr/include/ncursesw -DCURSES_LOC="<curses.h>"'
 		echo ' -DNCURSES_WIDECHAR=1'
 	elif [ -f /usr/include/ncurses/ncurses.h ]; then
 		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses.h>"'
 	elif [ -f /usr/include/ncurses/curses.h ]; then
-		echo '-I/usr/include/ncurses -DCURSES_LOC="<ncurses/curses.h>"'
+		echo '-I/usr/include/ncurses -DCURSES_LOC="<curses.h>"'
 	elif [ -f /usr/include/ncurses.h ]; then
 		echo '-DCURSES_LOC="<ncurses.h>"'
 	else
-- 
1.7.10.4

