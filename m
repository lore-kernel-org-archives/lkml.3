Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBSAib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:38:31 -0500
Received: from tartarus.angband.pl ([89.206.35.136]:53444 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaBSAi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:38:29 -0500
From: Adam Borowski <kilobyte@angband.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Date: Wed, 19 Feb 2014 01:38:04 +0100
Message-Id: <1392770284-6890-1-git-send-email-kilobyte@angband.pl>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140218184430.GA29209@kroah.com>
References: <20140218184430.GA29209@kroah.com>
X-SA-Exim-Connect-IP: 2001:6a0:118::6
X-SA-Exim-Mail-From: kilobyte@angband.pl
Subject: [PATCH] vt: detect and ignore OSC codes.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on tartarus.angband.pl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These can be used to send commands consisting of an arbitrary string to the
terminal, most often used to set a terminal's window title or to redefine
the colour palette.  Our console doesn't use OSC, unlike everything else,
which can lead to junk being displayed if a process sends such a code
unconditionally.

The rules for termination follow established practice rather than Ecma-48.
Ecma-48 requires the string to use only byte values 0x08..0x0D and
0x20..0x7E, terminated with either ESC \ or 0x9C.  This would disallow using
8-bit characters, which are reasonable for example in window titles.
A widespread idiom is to terminate with 0x07.  The behaviour for other
control characters differs between terminal emulators, I followed libvte and
xterm:
* 0x07 and ESC anything terminate
* nothing else terminates, all 8-bit values including 0x9C are considered a
  part of the string

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 drivers/tty/vt/vt.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index b7bde54..3ad0b61 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1592,7 +1592,7 @@ static void restore_cur(struct vc_data *vc)
 
 enum { ESnormal, ESesc, ESsquare, ESgetpars, ESfunckey,
 	EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
-	ESpalette };
+	ESpalette, ESosc };
 
 /* console_lock is held (except via vc_init()) */
 static void reset_terminal(struct vc_data *vc, int do_clear)
@@ -1652,11 +1652,15 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 	 *  Control characters can be used in the _middle_
 	 *  of an escape sequence.
 	 */
+	if (vc->vc_state == ESosc && c>=8 && c<=13) /* ... except for OSC */
+		return;
 	switch (c) {
 	case 0:
 		return;
 	case 7:
-		if (vc->vc_bell_duration)
+		if (vc->vc_state == ESosc)
+			vc->vc_state = ESnormal;
+		else if (vc->vc_bell_duration)
 			kd_mksound(vc->vc_bell_pitch, vc->vc_bell_duration);
 		return;
 	case 8:
@@ -1767,7 +1771,9 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 		} else if (c=='R') {   /* reset palette */
 			reset_palette(vc);
 			vc->vc_state = ESnormal;
-		} else
+		} else if (c>='0' && c<='9')
+			vc->vc_state = ESosc;
+		else
 			vc->vc_state = ESnormal;
 		return;
 	case ESpalette:
@@ -2021,6 +2027,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 			vc->vc_translate = set_translate(vc->vc_G1_charset, vc);
 		vc->vc_state = ESnormal;
 		return;
+	case ESosc:
+		return;
 	default:
 		vc->vc_state = ESnormal;
 	}
-- 
1.9.0

