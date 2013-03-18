Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab3CREby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33629 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159Ab3CREbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:00 -0400
Message-Id: <20130318042147.807596536@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:21 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ilya Zykov <ilya@ilyx.ru>
Subject: [ 37/82] tty: Correct tty buffer flush.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Zykov <ilya@ilyx.ru>

commit 64325a3be08d364a62ee8f84b2cf86934bc2544a upstream.

  The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
when another thread can use it. It can be cause of "NULL pointer dereference".
  Main idea of the patch, this is never free last (struct tty_buffer) in the active buffer.
Only flush the data for ldisc(buf->head->read = buf->head->commit).
At that moment driver can collect(write) data in buffer without conflict.
It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tt
 {
 	struct tty_buffer *thead;
 
-	while ((thead = tty->buf.head) != NULL) {
-		tty->buf.head = thead->next;
-		tty_buffer_free(tty, thead);
+	if (tty->buf.head == NULL)
+		return;
+	while ((thead = tty->buf.head->next) != NULL) {
+		tty_buffer_free(tty, tty->buf.head);
+		tty->buf.head = thead;
 	}
-	tty->buf.tail = NULL;
+	WARN_ON(tty->buf.head != tty->buf.tail);
+	tty->buf.head->read = tty->buf.head->commit;
 }
 
 /**


