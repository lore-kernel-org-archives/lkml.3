Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3IQQzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:55:43 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:49069 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab3IQQzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:55:42 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] n_tty: Fix EOF push index when termios changes
Date: Tue, 17 Sep 2013 12:34:14 -0400
Message-Id: <1379435654-14354-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 40d5e0905a03601d40cd4e46b8690093c2355d03,
'n_tty: Fix EOF push handling' introduced a subtle state
change error wrt EOF push handling when the termios is
changed from non-canonical to canonical mode.

Reset line_start to the current read_tail index, not 0.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index c9a9ddd..01bf5eb 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1758,8 +1758,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		canon_change = (old->c_lflag ^ tty->termios.c_lflag) & ICANON;
 	if (canon_change) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
-		ldata->line_start = 0;
-		ldata->canon_head = ldata->read_tail;
+		ldata->line_start = ldata->canon_head = ldata->read_tail;
 		ldata->erasing = 0;
 		ldata->lnext = 0;
 	}
-- 
1.8.1.2

