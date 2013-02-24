Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288Ab3BXPu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 10:50:26 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52909 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab3BXPuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 10:50:25 -0500
Message-ID: <512A36BB.9070309@gentoo.org>
Date: Sun, 24 Feb 2013 16:50:19 +0100
From: Justin <jlec@gentoo.org>
Reply-To: jlec@gentoo.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130222 Thunderbird/17.0.3
MIME-Version: 1.0
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Use config scripts to detect ncurses libs for, menuconfig/nconfig
 dialogs
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="----enig2PFGENJVPRCQRCDRRQKOG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2PFGENJVPRCQRCDRRQKOG
Content-Type: multipart/mixed;
 boundary="------------020007030509030600020302"

This is a multi-part message in MIME format.
--------------020007030509030600020302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

when ncurses is build with --with-termlib several symbols are moved to a
seperate terminfo library (libtinfo.so). Current Kernel buildsystem
results in a build error with menuconfig and nconfig dialogs.

gcc  -o scripts/kconfig/mconf scripts/kconfig/mconf.o
scripts/kconfig/zconf.tab.o scripts/kconfig/lxdialog/checklist.o
scripts/kconfig/lxdialog/util.o scripts/kconfig/lxdialog/inputbox.o
scripts/kconfig/lxdialog/textbox.o scripts/kconfig/lxdialog/yesno.o
scripts/kconfig/lxdialog/menubox.o  -lncursesw
scripts/kconfig/mconf.o:mconf.c:function show_help: error: undefined
reference to 'stdscr'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function print_arrows:
error: undefined reference to 'acs_map'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function print_arrows:
error: undefined reference to 'acs_map'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function print_arrows:
error: undefined reference to 'acs_map'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function print_arrows:
error: undefined reference to 'acs_map'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function
dialog_checklist: error: undefined reference to 'stdscr'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function
dialog_checklist: error: undefined reference to 'COLS'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function
dialog_checklist: error: undefined reference to 'stdscr'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function
dialog_checklist: error: undefined reference to 'LINES'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function
dialog_checklist: error: undefined reference to 'keypad'
scripts/kconfig/lxdialog/checklist.o:checklist.c:function
dialog_checklist: error: undefined reference to 'keypad'
scripts/kconfig/lxdialog/util.o:util.c:function dialog_clear: error:
undefined reference to 'COLS'
scripts/kconfig/lxdialog/util.o:util.c:function dialog_clear: error:
undefined reference to 'LINES'
scripts/kconfig/lxdialog/util.o:util.c:function dialog_clear: error:
undefined reference to 'stdscr'
scripts/kconfig/lxdialog/util.o:util.c:function dialog_clear: error:
undefined reference to 'COLS'
scripts/kconfig/lxdialog/util.o:util.c:function dialog_clear: error:
undefined reference to 'COLS'
scripts/kconfig/lxdialog/util.o:util.c:function init_dialog: error:
undefined reference to 'keypad'
scripts/kconfig/lxdialog/util.o:util.c:function init_dialog: error:
undefined reference to 'cbreak'
scripts/kconfig/lxdialog/util.o:util.c:function on_key_esc: error:
undefined reference to 'nodelay'
scripts/kconfig/lxdialog/util.o:util.c:function on_key_esc: error:
undefined reference to 'keypad'
scripts/kconfig/lxdialog/util.o:util.c:function on_key_esc: error:
undefined reference to 'nodelay'
scripts/kconfig/lxdialog/inputbox.o:inputbox.c:function dialog_inputbox:
error: undefined reference to 'LINES'
scripts/kconfig/lxdialog/textbox.o:textbox.c:function dialog_textbox:
error: undefined reference to 'LINES'
collect2: error: ld returned 1 exit status


Attached patch uses ncurses5-config and pkg-config to detect the libs to
link with. Please include this to fix the build error.

justin

--------------020007030509030600020302
Content-Type: text/x-patch;
 name="0001-Use-config-scripts-to-detect-ncurses-libs-for-menuco.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-Use-config-scripts-to-detect-ncurses-libs-for-menuco.pa";
 filename*1="tch"

=46rom 5c3e9e44432697b9f638c5367e01bdde47adf0f2 Mon Sep 17 00:00:00 2001
From: Justin Lecher <jlec@gentoo.org>
Date: Sun, 24 Feb 2013 16:02:00 +0100
Subject: [PATCH] Use config scripts to detect ncurses libs for
 menuconfig/nconfig dialogs

When building ncurses with --with-termlib several symbols get moved from
libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
additionally needs to link with libtinfo.so.

Ncurses provides a config script (ncurses5-config) and an interface with
pkg-config. This patch makes use of those to detect the necessary libs
for linking of the ncurses menuconfig and nconfig dialogs.

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 scripts/kconfig/Makefile                   |  2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh | 22 ++++++++++++++--------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 3091794..7649047 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -216,7 +216,7 @@ HOSTCFLAGS_gconf.o	=3D `pkg-config --cflags gtk+-2.0 =
gmodule-2.0 libglade-2.0` \
=20
 HOSTLOADLIBES_mconf   =3D $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldf=
lags $(HOSTCC))
=20
-HOSTLOADLIBES_nconf	=3D -lmenu -lpanel -lncurses
+HOSTLOADLIBES_nconf	=3D `pkg-config --libs menu panel ncurses`
 $(obj)/qconf.o: $(obj)/.tmp_qtcheck
=20
 ifeq ($(qconf-target),1)
diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig=
/lxdialog/check-lxdialog.sh
index c8e8a71..4699c1b 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,15 +4,21 @@
 # What library to link
 ldflags()
 {
-	for ext in so a dll.a dylib ; do
-		for lib in ncursesw ncurses curses ; do
-			$cc -print-file-name=3Dlib${lib}.${ext} | grep -q /
-			if [ $? -eq 0 ]; then
-				echo "-l${lib}"
-				exit
-			fi
+	if type -p ncurses5-config &> /dev/null ; then
+		ncurses5-config --libs
+		exit 0
+	else
+		for ext in so a dll.a dylib ; do
+			for lib in ncursesw ncurses curses ; do
+				$cc -print-file-name=3Dlib${lib}.${ext} | \
+					grep -q /
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
=20
--=20
1.8.1.4


--------------020007030509030600020302--

------enig2PFGENJVPRCQRCDRRQKOG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEAREKAAYFAlEqNrsACgkQgAnW8HDreRY3jgCeOA8lnT+M26XzRVKyK/MLpnMt
96EAnjFRmKqcWwb5rCB1JC09fkOcZGpx
=iuB0
-----END PGP SIGNATURE-----

------enig2PFGENJVPRCQRCDRRQKOG--
