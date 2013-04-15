Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3DOPdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:33:08 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45952 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934113Ab3DOPdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:33:05 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 10/24] n_tty: Remove read_cnt
Date: Mon, 15 Apr 2013 11:19:14 -0400
Message-Id: <1366039168-8510-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Storing the read_cnt creates an unnecessary shared variable
between the single-producer (n_tty_receive_buf()) and the
single-consumer (n_tty_read()).

Compute read_cnt from head & tail instead of storing.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 1406b63..fdabd65 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -98,7 +98,6 @@ struct n_tty_data {
 	char *read_buf;
 	size_t read_head;
 	size_t read_tail;
-	int read_cnt;
 	int minimum_to_wake;
 
 	unsigned char *echo_buf;
@@ -117,7 +116,7 @@ struct n_tty_data {
 
 static inline size_t read_cnt(struct n_tty_data *ldata)
 {
-	return ldata->read_cnt;
+	return ldata->read_head - ldata->read_tail;
 }
 
 static inline unsigned char read_buf(struct n_tty_data *ldata, size_t i)
@@ -198,7 +197,6 @@ static void put_tty_queue_nolock(unsigned char c, struct n_tty_data *ldata)
 	if (read_cnt(ldata) < N_TTY_BUF_SIZE) {
 		*read_buf_addr(ldata, ldata->read_head) = c;
 		ldata->read_head++;
-		ldata->read_cnt++;
 	}
 }
 
@@ -239,7 +237,7 @@ static void reset_buffer_flags(struct n_tty_data *ldata)
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
-	ldata->read_head = ldata->read_tail = ldata->read_cnt = 0;
+	ldata->read_head = ldata->read_tail = 0;
 	raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 
 	mutex_lock(&ldata->echo_lock);
@@ -943,16 +941,12 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 	else {
 		if (!L_ECHO(tty)) {
 			raw_spin_lock_irqsave(&ldata->read_lock, flags);
-			ldata->read_cnt -= ((ldata->read_head - ldata->canon_head) &
-					  (N_TTY_BUF_SIZE - 1));
 			ldata->read_head = ldata->canon_head;
 			raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 			return;
 		}
 		if (!L_ECHOK(tty) || !L_ECHOKE(tty) || !L_ECHOE(tty)) {
 			raw_spin_lock_irqsave(&ldata->read_lock, flags);
-			ldata->read_cnt -= ((ldata->read_head - ldata->canon_head) &
-					  (N_TTY_BUF_SIZE - 1));
 			ldata->read_head = ldata->canon_head;
 			raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 			finish_erasing(ldata);
@@ -990,7 +984,6 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 		cnt = ldata->read_head - head;
 		raw_spin_lock_irqsave(&ldata->read_lock, flags);
 		ldata->read_head = head;
-		ldata->read_cnt -= cnt;
 		raw_spin_unlock_irqrestore(&ldata->read_lock, flags);
 		if (L_ECHO(tty)) {
 			if (L_ECHOPRT(tty)) {
@@ -1449,7 +1442,6 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		i = min(count, i);
 		memcpy(read_buf_addr(ldata, ldata->read_head), cp, i);
 		ldata->read_head += i;
-		ldata->read_cnt += i;
 		cp += i;
 		count -= i;
 
@@ -1458,7 +1450,6 @@ static void __receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		i = min(count, i);
 		memcpy(read_buf_addr(ldata, ldata->read_head), cp, i);
 		ldata->read_head += i;
-		ldata->read_cnt += i;
 		raw_spin_unlock_irqrestore(&ldata->read_lock, cpuflags);
 	} else {
 		for (i = count, p = cp, f = fp; i; i--, p++) {
@@ -1760,7 +1751,6 @@ static int copy_from_read_buf(struct tty_struct *tty,
 				ldata->icanon);
 		raw_spin_lock_irqsave(&ldata->read_lock, flags);
 		ldata->read_tail += n;
-		ldata->read_cnt -= n;
 		/* Turn single EOF into zero-length read */
 		if (L_EXTPROC(tty) && ldata->icanon && is_eof && !read_cnt(ldata))
 			n = 0;
@@ -1848,7 +1838,6 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 
 	raw_spin_lock_irqsave(&ldata->read_lock, flags);
 	ldata->read_tail += c;
-	ldata->read_cnt -= c;
 	if (found) {
 		__clear_bit(eol, ldata->read_flags);
 		/* this test should be redundant:
-- 
1.8.1.2

