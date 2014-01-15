Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291AbaAOHBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 02:01:06 -0500
Received: from tartarus.angband.pl ([89.206.35.136]:45948 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaAOHBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 02:01:05 -0500
X-Greylist: delayed 2322 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Jan 2014 02:01:04 EST
From: Adam Borowski <kilobyte@angband.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>
Date: Wed, 15 Jan 2014 07:21:04 +0100
Message-Id: <1389766864-22673-1-git-send-email-kilobyte@angband.pl>
X-Mailer: git-send-email 1.8.5.2
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

Not following Ecma-48, this commit recognizes 7-bit forms (ESC ] ... 0x07,
ESC ] .. ESC \) but not 8-bit (0x9D ... 0x9C).

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 drivers/tty/vt/vt.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 61b1137..0377c52 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1590,7 +1590,7 @@ static void restore_cur(struct vc_data *vc)
 
 enum { ESnormal, ESesc, ESsquare, ESgetpars, ESgotpars, ESfunckey,
 	EShash, ESsetG0, ESsetG1, ESpercent, ESignore, ESnonstd,
-	ESpalette };
+	ESpalette, ESosc };
 
 /* console_lock is held (except via vc_init()) */
 static void reset_terminal(struct vc_data *vc, int do_clear)
@@ -1650,11 +1650,15 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
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
@@ -1765,7 +1769,9 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
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
@@ -2023,6 +2029,8 @@ static void do_con_trol(struct tty_struct *tty, struct vc_data *vc, int c)
 		return;
 	default:
 		vc->vc_state = ESnormal;
+	case ESosc:
+		return;
 	}
 }
 
-- 
1.8.5.2

