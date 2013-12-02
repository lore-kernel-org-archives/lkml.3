Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3LBT1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:27:42 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44374 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3LBTZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:42 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 1/8] n_tty: Merge .receive_buf() flavors
Date: Mon,  2 Dec 2013 14:24:41 -0500
Message-Id: <1386012288-5079-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
 <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
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
index d4d63b0..446ccfd 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1677,32 +1677,9 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
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
@@ -1713,7 +1690,7 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
 		room = receive_room(tty);
 		n = min(count, room);
 		if (!n) {
-			if (!room)
+			if (flow && !room)
 				ldata->no_room = 1;
 			break;
 		}
@@ -1732,6 +1709,18 @@ static int n_tty_receive_buf2(struct tty_struct *tty, const unsigned char *cp,
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

