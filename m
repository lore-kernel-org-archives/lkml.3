Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab3DPRnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:43:31 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46158 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965097Ab3DPRn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:43:29 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/4] kconfig/lxdialog: rationalise the include paths where to find {.n}curses{,w}.h
Date: Tue, 16 Apr 2013 19:43:10 +0200
Message-Id: <1366134193-22030-2-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1366134193-22030-1-git-send-email-yann.morin.1998@free.fr>
References: <1366134193-22030-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 2 insertions(+), 2 deletions(-)

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
1.7.2.5

