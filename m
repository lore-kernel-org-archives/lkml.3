Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985Ab3IHWNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 18:13:44 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:60120 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab3IHWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 18:13:43 -0400
X-Greylist: delayed 1079 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Sep 2013 18:13:42 EDT
From: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 12 Jul 2013 22:23:41 +0200
Subject: [PATCH] vt: properly ignore xterm-256 colour codes
To: linux-kernel@vger.kernel.org
Message-Id: <E1VImxG-0002w1-UA@tartarus.angband.pl>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: 5a7c2d610b81162a8ec2e0fbc13070b265771604@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not a bug on our side, but a misdesign in ITU T.416, yet with
all popular terminals supporting these codes, people consider this to
be a bug in Linux.  By breaking the design principles behind SGR codes
(gracefully ignoring unsupported ones should not require knowing about
them), 256 colour ones tend to turn blinking on before invoking an
arbitrary unrelated command.

This commit doesn't add such support, merely skips such codes without
ill effects.

Signed-off-by: Adam Borowski <kilobyte@angband.pl>
---
 drivers/tty/vt/vt.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index c677829..f7aaa28 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1300,13 +1300,27 @@ static void csi_m(struct vc_data *vc)
 			case 27:
 				vc->vc_reverse = 0;
 				break;
-			case 38: /* ANSI X3.64-1979 (SCO-ish?)
-				  * Enables underscore, white foreground
-				  * with white underscore (Linux - use
-				  * default foreground).
+			case 38:
+			case 48: /* ITU T.416
+				  * Higher colour modes.
+				  * They break the usual properties of SGR codes
+				  * and thus need to be detected and ignored by
+				  * hand.  Strictly speaking, that standard also
+				  * wants : rather than ; as separators, contrary
+				  * to ECMA-48, but no one produces such codes
+				  * and almost no one accepts them.
 				  */
-				vc->vc_color = (vc->vc_def_color & 0x0f) | (vc->vc_color & 0xf0);
-				vc->vc_underline = 1;
+				i++;
+				if (i > vc->vc_npar)
+					break;
+				if (vc->vc_par[i] == 5)      /* 256 colours */
+					i++;                 /* ubiquitous */
+				else if (vc->vc_par[i] == 2) /* 24 bit colours */
+					i += 3;              /* extremely rare */
+				/* Subcommands 3 (CMY) and 4 (CMYK) are so insane
+				 * that detecting them is not worth the few extra
+				 * bytes of kernel's size.
+				 */
 				break;
 			case 39: /* ANSI X3.64-1979 (SCO-ish?)
 				  * Disable underline option.
-- 
1.8.4.rc3

