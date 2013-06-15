Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3FONPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:15:09 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42771 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3FONPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:15:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 04/24] n_tty: Factor canonical mode copy from n_tty_read()
Date: Sat, 15 Jun 2013 09:14:16 -0400
Message-Id: <1371302076-4688-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
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
index eddeb78..7fd7774 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1747,6 +1747,62 @@ static int copy_from_read_buf(struct tty_struct *tty,
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
 
@@ -1916,44 +1972,7 @@ do_it_again:
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

