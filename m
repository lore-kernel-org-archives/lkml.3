Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab3IJWNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:13:48 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:49859 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3IJWNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:13:46 -0400
X-Greylist: delayed 2314 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Sep 2013 18:13:46 EDT
In-Reply-To: <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
References: <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
From: Adam Borowski <kilobyte@angband.pl>
Date: Fri, 12 Jul 2013 22:23:41 +0200
Subject: [PATCH 2/2] vt: properly ignore xterm-256 colour codes
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-Id: <E1VJVaa-0001el-3H@tartarus.angband.pl>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: 404b564a8c9bab9542f36361b8add60c1bd78631@tartarus.angband.pl
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
 drivers/tty/vt/vt.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index ba528bb..bc441cf 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1300,6 +1300,28 @@ static void csi_m(struct vc_data *vc)
 			case 27:
 				vc->vc_reverse = 0;
 				break;
+			case 38:
+			case 48: /* ITU T.416
+				  * Higher colour modes.
+				  * They break the usual properties of SGR codes
+				  * and thus need to be detected and ignored by
+				  * hand.  Strictly speaking, that standard also
+				  * wants : rather than ; as separators, contrary
+				  * to ECMA-48, but no one produces such codes
+				  * and almost no one accepts them.
+				  */
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
+				break;
 			case 39:
 				vc->vc_color = (vc->vc_def_color & 0x0f) | (vc->vc_color & 0xf0);
 				break;
-- 
1.7.10.4

