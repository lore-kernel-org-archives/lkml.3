Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab3BASeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:34:50 -0500
Received: from ngcobalt07.manitu.net ([217.11.48.107]:54875 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3BASer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:34:47 -0500
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Fri, 1 Feb 2013 19:33:57 +0100
From: Roland Eggner <edvx1@systemanalysen.net>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH resend v3 3/3] kconfig: nconf:  add vi-style navigation
 keys
Message-ID: <20130201183357.GD11098@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: "Yann E. MORIN" <yann.morin.1998@free.fr>,
	Dmitry Voytik <dvv.kernel@gmail.com>, Michal Marek <mmarek@suse.cz>,
	Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org
References: <20130201182237.GA11098@mobil.systemanalysen.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5gxpn/Q6ypwruk0T"
Content-Disposition: inline
In-Reply-To: <20130201182237.GA11098@mobil.systemanalysen.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5gxpn/Q6ypwruk0T
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>From: Roland Eggner <edvx1@systemanalysen.net>

Add vi-style navigation keys, based on initial work by Dmitry Voytik.  User=
s of=20
netbooks, notebooks and other devices with keyboards lacking a dedicated nu=
mber=20
keypad will enjoy.  And advanced users of vim, less, mutt, =E2=80=A6 having=
 navigation=20
by keys hjkl =E2=80=9Chardwired=E2=80=9D in their fingers will =E2=80=9Cfly=
=E2=80=9D :)
In global help window called by key <F1> provide a table with all current a=
nd=20
added keybindings:

| Menu navigation keys        plain style             vi-style           |
| ---------------------------------------------------------------------- |
| Linewise up                 <Up>                    <k>                |
| Linewise down               <Down>                  <j>                |
| Pagewise up                 <Page Up>               <Ctrl-b>  <Ctrl-p> |
| Pagewise down               <Page Down>             <Ctrl-f>  <Ctrl-n> |
| First entry                 <Home>                  <g>                |
| Last entry                  <End>                   <G>                |
| Enter a submenu             <Right>  <Enter>        <l>                |
| Go back to parent menu      <Left>   <Esc>  <F5>    <h>                |
| Close a help window         <Enter>  <Esc>  <F5>                       |
| Close entry window, apply   <Enter>                                    |
| Close entry window, forget  <Esc>  <F5>                                |
| Start incremental, case-insensitive search for STRING in menu entries, |
|     no regex support, STRING is displayed in upper left corner         |
|                             </>STRING                                  |
|     Remove last character   <Backspace>                                |
|     Jump to next hit        <Down>                                     |
|     Jump to previous hit    <Up>                                       |
| Exit menu search mode       </>  <Esc>                                 |
| Search for configuration variables with or without leading CONFIG_     |
|                             <F8>RegExpr<Enter>                         |
| Verbose search help         <F8><F1>                                   |
| ---------------------------------------------------------------------- |

Intention is an easy to memorize set of keybindings resembling user interfa=
ces=20
of other frequently used software, not a strict clone of the historic vi us=
er=20
interface.  In contrast to historic vi, <Ctrl-f> <Ctrl-b> is used for=20
characterwise right and left movement by libreadline (bash, xfsprogs, bc, g=
db,=20
python, ruby, hunspell, mysql, sqlite, gnupg, xine-ui, parted =E2=80=A6).  =
Thus pagewise=20
movement by <Ctrl-f> <Ctrl-b> would be weird for my fingers, so I have adde=
d=20
<Ctrl-n> <Ctrl-p>, resembling e.g. thread-wise navigation in mutt message l=
ists.

To call help related to the current menu entry, currently any of the keys <=
?>=20
<h> may be used.  To solve the conflict with new navigation key <h>, this i=
s=20
changed to keys <?> <H>.  Lesser experienced users will not note, they use =
<?>. =20
And advanced users will consider, how much faster they can work, when all=
=20
frequently used keys are in the middle of the keyboard.

Signed-off-by: Dmitry Voytik <dvv.kernel@gmail.com>
Signed-off-by: Roland Eggner <edvx1@systemanalysen.net>
---
scripts/kconfig/nconf.c |  81 ++++++++++++++++++++++++++++++---------------=
---
1 files changed, 51 insertions(+), 30 deletions(-)

To be applied on vanilla 3.8-rc3

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -12,6 +12,8 @@
 #include "nconf.h"
 #include <ctype.h>
=20
+#define KEY_CONTROL(k) ((k) & 0x1f)
+
 static const char nconf_global_help[] =3D N_(
 "Help windows\n"
 "------------\n"
@@ -21,7 +23,7 @@ static const char nconf_global_help[] =3D=20
 "o  A short version of the global help is available by key <F3>.\n"
 "\n"
 "o  Local help:  To get help related to the current menu entry, use any\n"
-"   of <?> <h> keys, or if in a data entry window then use <F1> key.\n"
+"   of <?> <H> keys, or if in a data entry window then use <F1> key.\n"
 "\n"
 "\n"
 "Menu entries\n"
@@ -47,16 +49,16 @@ static const char nconf_global_help[] =3D=20
 "A trailing \"--->\" designates a submenu.\n"
 "\n"
 "\n"
-"Menu navigation keys\n"
+"Menu navigation keys        plain style             vi-style\n"
 "----------------------------------------------------------------------\n"
-"Linewise up                 <Up>\n"
-"Linewise down               <Down>\n"
-"Pagewise up                 <Page Up>\n"
-"Pagewise down               <Page Down>\n"
-"First entry                 <Home>\n"
-"Last entry                  <End>\n"
-"Enter a submenu             <Right>  <Enter>\n"
-"Go back to parent menu      <Left>   <Esc>  <F5>\n"
+"Linewise up                 <Up>                    <k>\n"
+"Linewise down               <Down>                  <j>\n"
+"Pagewise up                 <Page Up>               <Ctrl-b>  <Ctrl-p>\n"
+"Pagewise down               <Page Down>             <Ctrl-f>  <Ctrl-n>\n"
+"First entry                 <Home>                  <g>\n"
+"Last entry                  <End>                   <G>\n"
+"Enter a submenu             <Right>  <Enter>        <l>\n"
+"Go back to parent menu      <Left>   <Esc>  <F5>    <h>\n"
 "Close a help window         <Enter>  <Esc>  <F5>\n"
 "Close entry window, apply   <Enter>\n"
 "Close entry window, forget  <Esc>  <F5>\n"
@@ -90,8 +92,8 @@ static const char nconf_global_help[] =3D=20
 "\n"
 "Text Box (Help Window)\n"
 "----------------------\n"
-"Use movement keys <Down> <Up> <PageDown> <PageUp> <End> <Home> as listed =
in\n"
-"table above.\n"
+"Use movement keys <Down> <Up> <j> <k> <PageDown> <PageUp> <End> <Home>\n"
+"as listed in table above.\n"
 "\n"
 "Press any of <Enter> <Esc> <q> <F5> <F9> to exit.\n"
 "\n"
@@ -134,9 +136,9 @@ menu_no_f_instructions[] =3D N_(
 "Submenus are designated by a trailing \"--->\".\n"
 "\n"
 "Use the following keys to navigate the menus:\n"
-"Move up or down by any of <Up> <Down> keys.\n"
-"To enter a submenu use any of <Enter> <Right> keys.\n"
-"To go back to the parent menu use any of <Esc> <Left> keys.\n"
+"Move up or down by any of <Up> <Down> <k> <j> keys.\n"
+"To enter a submenu use any of <Enter> <Right> <l> keys.\n"
+"To go back to the parent menu use any of <Esc> <Left> <h> keys.\n"
 "Pressing <y> includes, <n> excludes, <m> modularizes features.\n"
 "Pressing <Space> cycles through the available options.\n"
 "To search for menu entries use key </>.\n"
@@ -145,15 +147,15 @@ menu_no_f_instructions[] =3D N_(
 "You do not have function keys support.\n"
 "Use key <1> instead of <F1>, <2> instead of <F2>, etc.\n"
 "For verbose global help use key <1>.\n"
-"For help related to the current menu entry use any of <?> <h> keys.\n"),
+"For help related to the current menu entry use any of <?> <H> keys.\n"),
 menu_instructions[] =3D N_(
 "Legend:  [*] built-in  [ ] excluded  <M> module  < > module capable.\n"
 "Submenus are designated by a trailing \"--->\".\n"
 "\n"
 "Use the following keys to navigate the menus:\n"
-"Move up or down by any of <Up> <Down> keys.\n"
-"To enter a submenu use any of <Enter> <Right> keys.\n"
-"To go back to the parent menu use any of <Esc> <Left> keys.\n"
+"Move up or down by any of <Up> <Down> <k> <j> keys.\n"
+"To enter a submenu use any of <Enter> <Right> <l> keys.\n"
+"To go back to the parent menu use any of <Esc> <Left> <h> keys.\n"
 "Pressing <y> includes, <n> excludes, <m> modularizes features.\n"
 "Pressing <Space> cycles through the available options.\n"
 "To search for menu entries use key </>.\n"
@@ -161,11 +163,11 @@ menu_instructions[] =3D N_(
 "\n"
 "Key <1> may be used instead of <F1>, <2> instead of <F2>, etc.\n"
 "For verbose global help use key <F1>.\n"
-"For help related to the current menu entry use any of <?> <h> keys.\n"),
+"For help related to the current menu entry use any of <?> <H> keys.\n"),
 radiolist_instructions[] =3D N_(
-"Use <Up> <Down> <Home> <End> keys to navigate this\n"
+"Use <Up> <Down> <Home> <End> <k> <j> <g> <G> keys to navigate this\n"
 "radiolist followed by <Space>.\n"
-"For help related to the current entry use any of <?> <h> keys.\n"
+"For help related to the current entry use any of <?> <H> keys.\n"
 "For global help use key <F1>.\n"),
 inputbox_instructions_int[] =3D N_(
 "Please enter a decimal value.\n"
@@ -1101,24 +1103,32 @@ static void conf(struct menu *menu)
 				break;
 			switch (res) {
 			case KEY_DOWN:
+			case 'j':
 				menu_driver(curses_menu, REQ_DOWN_ITEM);
 				break;
 			case KEY_UP:
+			case 'k':
 				menu_driver(curses_menu, REQ_UP_ITEM);
 				break;
 			case KEY_NPAGE:
+			case KEY_CONTROL('f'):
+			case KEY_CONTROL('n'):
 				menu_driver(curses_menu, REQ_SCR_DPAGE);
 				break;
 			case KEY_PPAGE:
+			case KEY_CONTROL('b'):
+			case KEY_CONTROL('p'):
 				menu_driver(curses_menu, REQ_SCR_UPAGE);
 				break;
 			case KEY_HOME:
+			case 'g':
 				menu_driver(curses_menu, REQ_FIRST_ITEM);
 				break;
 			case KEY_END:
+			case 'G':
 				menu_driver(curses_menu, REQ_LAST_ITEM);
 				break;
-			case 'h':
+			case 'H':
 			case '?':
 				show_help((struct menu *) item_data());
 				break;
@@ -1126,14 +1136,15 @@ static void conf(struct menu *menu)
 			if (res =3D=3D 10 || res =3D=3D 27 ||
 				res =3D=3D 32 || res =3D=3D 'n' || res =3D=3D 'y' ||
 				res =3D=3D KEY_LEFT || res =3D=3D KEY_RIGHT ||
-				res =3D=3D 'm')
+				res =3D=3D 'h' || res =3D=3D 'l' || res =3D=3D 'm')
 				break;
 			refresh_all_windows(main_window);
 		}
=20
 		refresh_all_windows(main_window);
 		/* if ESC or left*/
-		if (res =3D=3D 27 || (menu !=3D &rootmenu && res =3D=3D KEY_LEFT))
+		if (res =3D=3D 27 || (menu !=3D &rootmenu
+			&& (res =3D=3D 'h' || res =3D=3D KEY_LEFT)))
 			break;
=20
 		/* remember location in the menu */
@@ -1155,6 +1166,7 @@ static void conf(struct menu *menu)
 			else if (item_is_tag('m'))
 				conf(submenu);
 			break;
+		case 'l':
 		case KEY_RIGHT:
 		case 10: /* ENTER WAS PRESSED */
 			switch (item_tag()) {
@@ -1286,36 +1298,44 @@ static void conf_choice(struct menu *men
 				break;
 			switch (res) {
 			case KEY_DOWN:
+			case 'j':
 				menu_driver(curses_menu, REQ_DOWN_ITEM);
 				break;
 			case KEY_UP:
+			case 'k':
 				menu_driver(curses_menu, REQ_UP_ITEM);
 				break;
 			case KEY_NPAGE:
+			case KEY_CONTROL('f'):
+			case KEY_CONTROL('n'):
 				menu_driver(curses_menu, REQ_SCR_DPAGE);
 				break;
 			case KEY_PPAGE:
+			case KEY_CONTROL('b'):
+			case KEY_CONTROL('p'):
 				menu_driver(curses_menu, REQ_SCR_UPAGE);
 				break;
 			case KEY_HOME:
+			case 'g':
 				menu_driver(curses_menu, REQ_FIRST_ITEM);
 				break;
 			case KEY_END:
+			case 'G':
 				menu_driver(curses_menu, REQ_LAST_ITEM);
 				break;
-			case 'h':
+			case 'H':
 			case '?':
 				show_help((struct menu *) item_data());
 				break;
 			}
-			if (res =3D=3D 10 || res =3D=3D 27 || res =3D=3D ' ' ||
-					res =3D=3D KEY_LEFT){
+			if (res =3D=3D 10 || res =3D=3D 27 || res =3D=3D ' '
+				|| res =3D=3D 'h' || res =3D=3D KEY_LEFT){
 				break;
 			}
 			refresh_all_windows(main_window);
 		}
 		/* if ESC or left */
-		if (res =3D=3D 27 || res =3D=3D KEY_LEFT)
+		if (res =3D=3D 27 || res =3D=3D 'h' || res =3D=3D KEY_LEFT)
 			break;
=20
 		child =3D item_data();
@@ -1324,10 +1344,11 @@ static void conf_choice(struct menu *men
 		switch (res) {
 		case ' ':
 		case  10:
+		case 'l':
 		case KEY_RIGHT:
 			sym_set_tristate_value(child->sym, yes);
 			return;
-		case 'h':
+		case 'H':
 		case '?':
 			show_help(child);
 			active =3D child->sym;


--=20
Roland Eggner

--5gxpn/Q6ypwruk0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEMCpUACgkQdN/hKfT7G/LEMQCeIeJ7+WeJ3/suJxgQxqD7UZnm
+hcAoJX9sspe3k0U4RF3Dwslh0dm9qMN
=71dy
-----END PGP SIGNATURE-----

--5gxpn/Q6ypwruk0T--
