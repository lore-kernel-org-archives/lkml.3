Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaJPTeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:34:44 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53815 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752192AbaJPTd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 9/9] n_tty: Only process packet mode data in raw mode
Date: Thu, 16 Oct 2014 15:33:30 -0400
Message-Id: <1413488010-16885-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Packet mode can only be set for a pty master, and a pty master is
always in raw mode since its termios cannot be changed.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 602dbc2..379f60c 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2228,16 +2228,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		}
 		__set_current_state(TASK_RUNNING);
 
-		/* Deal with packet mode. */
-		if (packet && b == buf) {
-			if (tty_put_user(tty, TIOCPKT_DATA, b++)) {
-				retval = -EFAULT;
-				b--;
-				break;
-			}
-			nr--;
-		}
-
 		if (ldata->icanon && !L_EXTPROC(tty)) {
 			retval = canon_copy_from_read_buf(tty, &b, &nr);
 			if (retval == -EAGAIN) {
@@ -2247,6 +2237,17 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 				break;
 		} else {
 			int uncopied;
+
+			/* Deal with packet mode. */
+			if (packet && b == buf) {
+				if (tty_put_user(tty, TIOCPKT_DATA, b++)) {
+					retval = -EFAULT;
+					b--;
+					break;
+				}
+				nr--;
+			}
+
 			/* The copy function takes the read lock and handles
 			   locking internally for this case */
 			uncopied = copy_from_read_buf(tty, &b, &nr);
-- 
2.1.1

