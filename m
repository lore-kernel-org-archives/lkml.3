Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab3FONQs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:16:48 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42778 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab3FONPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:15:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 05/24] n_tty: Line copy to user buffer in canonical mode
Date: Sat, 15 Jun 2013 09:14:17 -0400
Message-Id: <1371302076-4688-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of pushing one char per loop, pre-compute the data length
to copy and copy all at once.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 110 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 77 insertions(+), 33 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 7fd7774..74dcedd 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -74,6 +74,13 @@
 #define ECHO_OP_SET_CANON_COL 0x81
 #define ECHO_OP_ERASE_TAB 0x82
 
+#undef N_TTY_TRACE
+#ifdef N_TTY_TRACE
+# define n_tty_trace(f, args...)	trace_printk(f, ##args)
+#else
+# define n_tty_trace(f, args...)
+#endif
+
 struct n_tty_data {
 	unsigned int column;
 	unsigned long overrun_time;
@@ -1748,58 +1755,95 @@ static int copy_from_read_buf(struct tty_struct *tty,
 }
 
 /**
- *	canon_copy_to_user	-	copy read data in canonical mode
+ *	canon_copy_from_read_buf	-	copy read data in canonical mode
  *	@tty: terminal device
  *	@b: user data
  *	@nr: size of data
  *
  *	Helper function for n_tty_read.  It is only called when ICANON is on;
- *	it copies characters one at a time from the read buffer to the user
- *	space buffer.
+ *	it copies one line of input up to and including the line-delimiting
+ *	character into the user-space buffer.
  *
  *	Called under the atomic_read_lock mutex
  */
 
-static int canon_copy_to_user(struct tty_struct *tty,
-			      unsigned char __user **b,
-			      size_t *nr)
+static int canon_copy_from_read_buf(struct tty_struct *tty,
+				    unsigned char __user **b,
+				    size_t *nr)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned long flags;
-	int eol, c;
+	size_t n, size, more, c;
+	unsigned long eol;
+	int ret, tail, found = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
+
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	while (*nr && ldata->read_cnt) {
-
-		eol = test_and_clear_bit(ldata->read_tail, ldata->read_flags);
-		c = ldata->read_buf[ldata->read_tail];
-		ldata->read_tail = (ldata->read_tail+1) & (N_TTY_BUF_SIZE-1);
-		ldata->read_cnt--;
-		if (eol) {
-			/* this test should be redundant:
-			 * we shouldn't be reading data if
-			 * canon_data is 0
-			 */
-			if (--ldata->canon_data < 0)
-				ldata->canon_data = 0;
-		}
+
+	n = min_t(size_t, *nr, ldata->read_cnt);
+	if (!n) {
 		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+		return 0;
+	}
 
-		if (!eol || (c != __DISABLED_CHAR)) {
-			if (tty_put_user(tty, c, *b))
-				return -EFAULT;
-			*b += 1;
-			*nr -= 1;
-		}
-		if (eol) {
-			tty_audit_push(tty);
-			return 0;
-		}
-		raw_spin_lock_irqsave(&ldata->read_lock, flags);
+	tail = ldata->read_tail;
+	size = min_t(size_t, tail + n, N_TTY_BUF_SIZE);
+
+	n_tty_trace("%s: nr:%zu tail:%d n:%zu size:%zu\n",
+		    __func__, *nr, tail, n, size);
+
+	eol = find_next_bit(ldata->read_flags, size, tail);
+	more = n - (size - tail);
+	if (eol == N_TTY_BUF_SIZE && more) {
+		/* scan wrapped without finding set bit */
+		eol = find_next_bit(ldata->read_flags, more, 0);
+		if (eol != more)
+			found = 1;
+	} else if (eol != size)
+		found = 1;
+
+	size = N_TTY_BUF_SIZE - tail;
+	n = (found + eol + size) & (N_TTY_BUF_SIZE - 1);
+	c = n;
+
+	if (found && ldata->read_buf[eol] == __DISABLED_CHAR)
+		n--;
+
+	n_tty_trace("%s: eol:%lu found:%d n:%zu c:%zu size:%zu more:%zu\n",
+		    __func__, eol, found, n, c, size, more);
+
+	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
+
+	if (n > size) {
+		ret = copy_to_user(*b, &ldata->read_buf[tail], size);
+		if (ret)
+			return -EFAULT;
+		ret = copy_to_user(*b + size, ldata->read_buf, n - size);
+	} else
+		ret = copy_to_user(*b, &ldata->read_buf[tail], n);
+
+	if (ret)
+		return -EFAULT;
+	*b += n;
+	*nr -= n;
+
+	raw_spin_lock_irqsave(&ldata->read_lock, flags);
+	ldata->read_tail = (ldata->read_tail + c) & (N_TTY_BUF_SIZE - 1);
+	ldata->read_cnt -= c;
+	if (found) {
+		__clear_bit(eol, ldata->read_flags);
+		/* this test should be redundant:
+		 * we shouldn't be reading data if
+		 * canon_data is 0
+		 */
+		if (--ldata->canon_data < 0)
+			ldata->canon_data = 0;
 	}
 	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 
+	if (found)
+		tty_audit_push(tty);
 	return 0;
 }
 
@@ -1972,7 +2016,7 @@ do_it_again:
 		}
 
 		if (ldata->icanon && !L_EXTPROC(tty)) {
-			retval = canon_copy_to_user(tty, &b, &nr);
+			retval = canon_copy_from_read_buf(tty, &b, &nr);
 			if (retval)
 				break;
 		} else {
-- 
1.8.1.2

