Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab3KVP7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:59:51 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54732 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab3KVP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:59:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 1/7] n_tty: Merge .receive_buf() flavors
Date: Fri, 22 Nov 2013 10:59:19 -0500
Message-Id: <1385135965-4235-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

N_TTY's direct and flow-controlled flavors of the .receive_buf()
method are nearly identical; fold together.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 43 ++++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 5f1c5f3..3eb54c7 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1675,32 +1675,9 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	}
 }
 
-static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-			      char *fp, int count)
-{
-	int room, n;
-
-	down_read(&tty->termios_rwsem);
-
-	while (1) {
-		room = receive_room(tty);
-		n = min(count, room);
-		if (!n)
-			break;
-		__receive_buf(tty, cp, fp, n);
-		cp += n;
-		if (fp)
-			fp += n;
-		count -= n;
-	}
-
-	tty->receive_room = room;
-	n_tty_check_throttle(tty);
-	up_read(&tty->termios_rwsem);
-}
-
-static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
-			      char *fp, int count)
+static int
+n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
+			 char *fp, int count, int flow)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int room, n, rcvd = 0;
@@ -1711,7 +1688,7 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
 		room = receive_room(tty);
 		n = min(count, room);
 		if (!n) {
-			if (!room)
+			if (flow && !room)
 				ldata->no_room = 1;
 			break;
 		}
@@ -1730,6 +1707,18 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
 	return rcvd;
 }
 
+static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+			      char *fp, int count)
+{
+	n_tty_receive_buf_common(tty, cp, fp, count, 0);
+}
+
+static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
+			      char *fp, int count)
+{
+	return n_tty_receive_buf_common(tty, cp, fp, count, 1);
+}
+
 int is_ignored(int sig)
 {
 	return (sigismember(&current->blocked, sig) ||
-- 
1.8.1.2

