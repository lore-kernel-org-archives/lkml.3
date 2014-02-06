Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbaBFUWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 15:22:10 -0500
Received: from fep36.mx.upcmail.net ([62.179.121.54]:45538 "EHLO
	fep36.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaBFUVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 15:21:25 -0500
X-Greylist: delayed 957 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Feb 2014 15:21:24 EST
X-SourceIP: 94.113.216.134
From: =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <petr.pisar@atlas.cz>
To: <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Jean-Fran=C3=A7ois=20Moine?= <moinejf@free.fr>,
        =?UTF-8?q?Petr=20P=C3=ADsa=C5=99?= <petr.pisar@atlas.cz>
Subject: [PATCH] vt: Fix secure clear screen
Date: Thu,  6 Feb 2014 21:01:23 +0100
Message-Id: <1391716883-31383-1-git-send-email-petr.pisar@atlas.cz>
X-Mailer: git-send-email 1.8.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

\E[3J console code (secure clear screen) needs to update_screen(vc)
in order to write-through blanks into off-screen video memory.

This has been removed accidentally in 3.6 by:

commit 81732c3b2fede049a692e58a7ceabb6d18ffb18c
Author: Jean-François Moine <moinejf@free.fr>
Date:   Thu Sep 6 19:24:13 2012 +0200

    tty vt: Fix line garbage in virtual console on command line edition

Signed-off-by: Petr Písař <petr.pisar@atlas.cz>
---
 drivers/tty/vt/vt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 61b1137..23b5d32 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1164,6 +1164,8 @@ static void csi_J(struct vc_data *vc, int vpar)
 			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
 				    vc->vc_screenbuf_size >> 1);
 			set_origin(vc);
+			if (CON_IS_VISIBLE(vc))
+				update_screen(vc);
 			/* fall through */
 		case 2: /* erase whole display */
 			count = vc->vc_cols * vc->vc_rows;
-- 
1.8.5.3

