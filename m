Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3J1F2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:28:45 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56411 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab3J1F2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:28:43 -0400
From: RUC_SoftSec <rucsoftsec@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Wang YanQing <udknight@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, RUC_SoftSec <rucsoftsec@gmail.com>
Subject: [PATCH 1/1] tty: Add NULL check to return value of kzalloc()
Date: Mon, 28 Oct 2013 13:27:52 +0800
Message-Id: <1382938072-14769-1-git-send-email-rucsoftsec@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function kzalloc() may return a NULL pointer, it should be checked against NULL before used.
This bug is found by a static analysis tool developed by RUC_SoftSec, supported by China.X.Orion.

Signed-off-by: RUC_SoftSec <rucsoftsec@gmail.com>
---
 drivers/tty/vt/vt.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 9a8e8c5..fcba3ce 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2887,12 +2887,14 @@ static int __init con_init(void)
 
 	for (currcons = 0; currcons < MIN_NR_CONSOLES; currcons++) {
 		vc_cons[currcons].d = vc = kzalloc(sizeof(struct vc_data), GFP_NOWAIT);
-		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
-		tty_port_init(&vc->port);
-		visual_init(vc, currcons, 1);
-		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
-		vc_init(vc, vc->vc_rows, vc->vc_cols,
-			currcons || !vc->vc_sw->con_save_screen);
+		if (vc) {
+			INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
+			tty_port_init(&vc->port);
+			visual_init(vc, currcons, 1);
+			vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
+			vc_init(vc, vc->vc_rows, vc->vc_cols,
+					currcons || !vc->vc_sw->con_save_screen);
+		}
 	}
 	currcons = fg_console = 0;
 	master_display_fg = vc = vc_cons[currcons].d;
-- 
1.7.9.5

