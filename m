Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab3DOPmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:42:05 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45557 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3DOPaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:17 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 5/9] n_tty: Eliminate echo_commit memory barrier
Date: Mon, 15 Apr 2013 11:29:43 -0400
Message-Id: <1366039787-8719-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
 <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use output_lock mutex as a memory barrier when storing echo_commit.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 49ef008..c101492 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -637,21 +637,16 @@ break_out:
  *	are prioritized.  Also, when control characters are echoed with a
  *	prefixed "^", the pair is treated atomically and thus not separated.
  *
- *	Locking: output_lock to protect column state and space left
+ *	Locking: callers must hold output_lock
  */
 
-static void process_echoes(struct tty_struct *tty)
+static void __process_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	int	space, nr;
 	size_t tail;
 	unsigned char c;
 
-	if (ldata->echo_commit == ldata->echo_tail)
-		return;
-
-	mutex_lock(&ldata->output_lock);
-
 	space = tty_write_room(tty);
 
 	tail = ldata->echo_tail;
@@ -772,20 +767,34 @@ static void process_echoes(struct tty_struct *tty)
 	}
 
 	ldata->echo_tail = tail;
+}
+
+static void commit_echoes(struct tty_struct *tty)
+{
+	struct n_tty_data *ldata = tty->disc_data;
 
+	mutex_lock(&ldata->output_lock);
+	ldata->echo_commit = ldata->echo_head;
+	__process_echoes(tty);
 	mutex_unlock(&ldata->output_lock);
 
 	if (tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
 }
 
-static void commit_echoes(struct tty_struct *tty)
+static void process_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 
-	smp_mb();
-	ldata->echo_commit = ldata->echo_head;
-	process_echoes(tty);
+	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
+		return;
+
+	mutex_lock(&ldata->output_lock);
+	__process_echoes(tty);
+	mutex_unlock(&ldata->output_lock);
+
+	if (tty->ops->flush_chars)
+		tty->ops->flush_chars(tty);
 }
 
 /**
-- 
1.8.1.2

