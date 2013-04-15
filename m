Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3DOPa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:30:28 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45597 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3DOPaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:25 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 7/9] n_tty: Only flush echo output if actually output
Date: Mon, 15 Apr 2013 11:29:45 -0400
Message-Id: <1366039787-8719-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
 <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't have the driver flush received echoes if no echoes were
actually output.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 6f507f5..a601c46 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -645,14 +645,14 @@ break_out:
  *	Locking: callers must hold output_lock
  */
 
-static void __process_echoes(struct tty_struct *tty)
+static size_t __process_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int	space, nr;
+	int	space, old_space;
 	size_t tail;
 	unsigned char c;
 
-	space = tty_write_room(tty);
+	old_space = space = tty_write_room(tty);
 
 	tail = ldata->echo_tail;
 	nr = ldata->echo_commit - ldata->echo_tail;
@@ -785,12 +785,13 @@ static void __process_echoes(struct tty_struct *tty)
 	}
 
 	ldata->echo_tail = tail;
+	return old_space - space;
 }
 
 static void commit_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	size_t nr, old;
+	size_t nr, old, echoed;
 	size_t head;
 
 	head = ldata->echo_head;
@@ -805,25 +806,26 @@ static void commit_echoes(struct tty_struct *tty)
 
 	mutex_lock(&ldata->output_lock);
 	ldata->echo_commit = head;
-	__process_echoes(tty);
+	echoed = __process_echoes(tty);
 	mutex_unlock(&ldata->output_lock);
 
-	if (tty->ops->flush_chars)
+	if (echoed && tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
 }
 
 static void process_echoes(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	size_t echoed;
 
 	if (!L_ECHO(tty) || ldata->echo_commit == ldata->echo_tail)
 		return;
 
 	mutex_lock(&ldata->output_lock);
-	__process_echoes(tty);
+	echoed = __process_echoes(tty);
 	mutex_unlock(&ldata->output_lock);
 
-	if (tty->ops->flush_chars)
+	if (echoed && tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
 }
 
-- 
1.8.1.2

