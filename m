Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3FOOFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:05:42 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40218 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3FOOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:05:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 8/9] n_tty: Eliminate counter in __process_echoes
Date: Sat, 15 Jun 2013 10:04:28 -0400
Message-Id: <1371305069-5366-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since neither echo_commit nor echo_tail can change for the duration
of __process_echoes loop, substitute index comparison for the
snapshot counter.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4a2da9e..e689026 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -655,8 +655,7 @@ static size_t __process_echoes(struct tty_struct *tty)
 	old_space = space = tty_write_room(tty);
 
 	tail = ldata->echo_tail;
-	nr = ldata->echo_commit - ldata->echo_tail;
-	while (nr > 0) {
+	while (ldata->echo_commit != tail) {
 		c = echo_buf(ldata, tail);
 		if (c == ECHO_OP_START) {
 			unsigned char op;
@@ -700,20 +699,17 @@ static size_t __process_echoes(struct tty_struct *tty)
 						ldata->column--;
 				}
 				tail += 3;
-				nr -= 3;
 				break;
 
 			case ECHO_OP_SET_CANON_COL:
 				ldata->canon_column = ldata->column;
 				tail += 2;
-				nr -= 2;
 				break;
 
 			case ECHO_OP_MOVE_BACK_COL:
 				if (ldata->column > 0)
 					ldata->column--;
 				tail += 2;
-				nr -= 2;
 				break;
 
 			case ECHO_OP_START:
@@ -726,7 +722,6 @@ static size_t __process_echoes(struct tty_struct *tty)
 				ldata->column++;
 				space--;
 				tail += 2;
-				nr -= 2;
 				break;
 
 			default:
@@ -748,7 +743,6 @@ static size_t __process_echoes(struct tty_struct *tty)
 				ldata->column += 2;
 				space -= 2;
 				tail += 2;
-				nr -= 2;
 			}
 
 			if (no_space_left)
@@ -766,7 +760,6 @@ static size_t __process_echoes(struct tty_struct *tty)
 				space -= 1;
 			}
 			tail += 1;
-			nr -= 1;
 		}
 	}
 
-- 
1.8.1.2

