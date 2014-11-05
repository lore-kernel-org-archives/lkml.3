Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaKERu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:58 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53179 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbaKERuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:52 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 13/26] tty: Simplify pty pair teardown logic
Date: Wed,  5 Nov 2014 12:12:56 -0500
Message-Id: <1415207589-15967-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the slave side closes and its tty count is 0, the pty
pair can be destroyed; the master side must have already
closed for the slave side tty count to be 0. Thus, only the
pty master close must check if the slave side has closed by
checking the slave tty count.

Remove the pre-computed closing flags and check the actual count(s).
Regular ttys are unaffected by this change.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 41eeee0..7b91007 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1755,7 +1755,7 @@ int tty_release(struct inode *inode, struct file *filp)
 {
 	struct tty_struct *tty = file_tty(filp);
 	struct tty_struct *o_tty;
-	int	pty_master, tty_closing, o_tty_closing, do_sleep;
+	int	pty_master, do_sleep, final;
 	int	idx;
 	char	buf[64];
 	long	timeout = 0;
@@ -1799,18 +1799,15 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * The test for the o_tty closing is necessary, since the master and
 	 * slave sides may close in any order.  If the slave side closes out
 	 * first, its count will be one, since the master side holds an open.
-	 * Thus this test wouldn't be triggered at the time the slave closes,
+	 * Thus this test wouldn't be triggered at the time the slave closed,
 	 * so we do it now.
 	 */
 	tty_lock_pair(tty, o_tty);
 
 	while (1) {
-		tty_closing = tty->count <= 1;
-		o_tty_closing = o_tty &&
-			(o_tty->count <= (pty_master ? 1 : 0));
 		do_sleep = 0;
 
-		if (tty_closing) {
+		if (tty->count <= 1) {
 			if (waitqueue_active(&tty->read_wait)) {
 				wake_up_poll(&tty->read_wait, POLLIN);
 				do_sleep++;
@@ -1820,7 +1817,7 @@ int tty_release(struct inode *inode, struct file *filp)
 				do_sleep++;
 			}
 		}
-		if (o_tty_closing) {
+		if (pty_master && o_tty->count <= 1) {
 			if (waitqueue_active(&o_tty->read_wait)) {
 				wake_up_poll(&o_tty->read_wait, POLLIN);
 				do_sleep++;
@@ -1845,14 +1842,6 @@ int tty_release(struct inode *inode, struct file *filp)
 			timeout = MAX_SCHEDULE_TIMEOUT;
 	}
 
-	/*
-	 * The closing flags are now consistent with the open counts on
-	 * both sides, and we've completed the last operation that could
-	 * block, so it's safe to proceed with closing.
-	 *
-	 * We must *not* drop the tty_mutex until we ensure that a further
-	 * entry into tty_open can not pick up this tty.
-	 */
 	if (pty_master) {
 		if (--o_tty->count < 0) {
 			printk(KERN_WARNING "%s: bad pty slave count (%d) for %s\n",
@@ -1884,20 +1873,22 @@ int tty_release(struct inode *inode, struct file *filp)
 	 * processes that still think tty or o_tty is their controlling
 	 * tty.
 	 */
-	if (tty_closing || o_tty_closing) {
+	if (!tty->count) {
 		read_lock(&tasklist_lock);
 		session_clear_tty(tty->session);
-		if (o_tty)
+		if (pty_master)
 			session_clear_tty(o_tty->session);
 		read_unlock(&tasklist_lock);
 	}
 
+	/* check whether both sides are closing ... */
+	final = !tty->count && !(pty_master && o_tty->count);
+
 	tty_unlock_pair(tty, o_tty);
 	/* At this point, the tty->count == 0 should ensure a dead tty
 	   cannot be re-opened by a racing opener */
 
-	/* check whether both sides are closing ... */
-	if (!tty_closing || (o_tty && !o_tty_closing))
+	if (!final)
 		return 0;
 
 #ifdef TTY_DEBUG_HANGUP
-- 
2.1.3

