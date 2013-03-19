Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009Ab3CSW5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 18:57:52 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42346 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936Ab3CSW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 18:57:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Min Zhang <mzhang@mvista.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 04/18] n_tty: Factor canonical mode copy from n_tty_read()
Date: Tue, 19 Mar 2013 16:21:39 -0400
Message-Id: <1363724513-15604-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify n_tty_read(); extract complex copy algorithm
into separate function, canon_copy_to_user().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 95 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 38 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index a185aff..9888972 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1745,6 +1745,62 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	return retval;
 }
 
+/**
+ *	canon_copy_to_user	-	copy read data in canonical mode
+ *	@tty: terminal device
+ *	@b: user data
+ *	@nr: size of data
+ *
+ *	Helper function for n_tty_read.  It is only called when ICANON is on;
+ *	it copies characters one at a time from the read buffer to the user
+ *	space buffer.
+ *
+ *	Called under the atomic_read_lock mutex
+ */
+
+static int canon_copy_to_user(struct tty_struct *tty,
+			      unsigned char __user **b,
+			      size_t *nr)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	unsigned long flags;
+	int eol, c;
+
+	/* N.B. avoid overrun if nr == 0 */
+	raw_spin_lock_irqsave(&ldata->read_lock, flags);
+	while (*nr && ldata->read_cnt) {
+
+		eol = test_and_clear_bit(ldata->read_tail, ldata->read_flags);
+		c = ldata->read_buf[ldata->read_tail];
+		ldata->read_tail = (ldata->read_tail+1) & (N_TTY_BUF_SIZE-1);
+		ldata->read_cnt--;
+		if (eol) {
+			/* this test should be redundant:
+			 * we shouldn't be reading data if
+			 * canon_data is 0
+			 */
+			if (--ldata->canon_data < 0)
+				ldata->canon_data = 0;
+		}
+		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+
+		if (!eol || (c != __DISABLED_CHAR)) {
+			if (tty_put_user(tty, c, *b))
+				return -EFAULT;
+			*b += 1;
+			*nr -= 1;
+		}
+		if (eol) {
+			tty_audit_push(tty);
+			return 0;
+		}
+		raw_spin_lock_irqsave(&ldata->read_lock, flags);
+	}
+	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+
+	return 0;
+}
+
 extern ssize_t redirected_tty_write(struct file *, const char __user *,
 							size_t, loff_t *);
 
@@ -1914,44 +1970,7 @@ do_it_again:
 		}
 
 		if (ldata->icanon && !L_EXTPROC(tty)) {
-			/* N.B. avoid overrun if nr == 0 */
-			raw_spin_lock_irqsave(&ldata->read_lock, flags);
-			while (nr && ldata->read_cnt) {
-				int eol;
-
-				eol = test_and_clear_bit(ldata->read_tail,
-						ldata->read_flags);
-				c = ldata->read_buf[ldata->read_tail];
-				ldata->read_tail = ((ldata->read_tail+1) &
-						  (N_TTY_BUF_SIZE-1));
-				ldata->read_cnt--;
-				if (eol) {
-					/* this test should be redundant:
-					 * we shouldn't be reading data if
-					 * canon_data is 0
-					 */
-					if (--ldata->canon_data < 0)
-						ldata->canon_data = 0;
-				}
-				raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
-
-				if (!eol || (c != __DISABLED_CHAR)) {
-					if (tty_put_user(tty, c, b++)) {
-						retval = -EFAULT;
-						b--;
-						raw_spin_lock_irqsave(&ldata->read_lock, flags);
-						break;
-					}
-					nr--;
-				}
-				if (eol) {
-					tty_audit_push(tty);
-					raw_spin_lock_irqsave(&ldata->read_lock, flags);
-					break;
-				}
-				raw_spin_lock_irqsave(&ldata->read_lock, flags);
-			}
-			raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+			retval = canon_copy_to_user(tty, &b, &nr);
 			if (retval)
 				break;
 		} else {
-- 
1.8.1.2

