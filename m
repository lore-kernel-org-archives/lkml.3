Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab3FOOFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:05:37 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40206 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab3FOOFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:05:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 5/9] n_tty: Eliminate echo_commit memory barrier
Date: Sat, 15 Jun 2013 10:04:25 -0400
Message-Id: <1371305069-5366-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
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
index d22c14c..c595264 100644
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
@@ -771,20 +766,34 @@ static void process_echoes(struct tty_struct *tty)
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

