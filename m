Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3CFNVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:21:22 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:48786 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3CFNVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:21:19 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Vincent Pillet <vincentx.pillet@intel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 1/3] n_tty: Inline check_unthrottle() at lone call site
Date: Wed,  6 Mar 2013 08:20:51 -0500
Message-Id: <1362576053-1295-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2-line function check_unthrottle() is now only called from
n_tty_read(); merge into caller.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 66ce178..8f9f665 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -195,21 +195,6 @@ static void put_tty_queue(unsigned char c, struct n_tty_data *ldata)
 }
 
 /**
- *	check_unthrottle	-	allow new receive data
- *	@tty; tty device
- *
- *	Check whether to call the driver unthrottle functions
- *
- *	Can sleep, may be called under the atomic_read_lock mutex but
- *	this is not guaranteed.
- */
-static void check_unthrottle(struct tty_struct *tty)
-{
-	if (tty->count)
-		tty_unthrottle(tty);
-}
-
-/**
  *	reset_buffer_flags	-	reset buffer state
  *	@tty: terminal to reset
  *
@@ -1971,7 +1956,8 @@ do_it_again:
 		 */
 		if (n_tty_chars_in_buffer(tty) <= TTY_THRESHOLD_UNTHROTTLE) {
 			n_tty_set_room(tty);
-			check_unthrottle(tty);
+			if (tty->count)
+				tty_unthrottle(tty);
 		}
 
 		if (b - buf >= minimum)
-- 
1.8.1.2

