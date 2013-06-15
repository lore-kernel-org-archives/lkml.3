Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3FOOFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:05:41 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40214 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3FOOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:05:07 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 7/9] n_tty: Only flush echo output if actually output
Date: Sat, 15 Jun 2013 10:04:27 -0400
Message-Id: <1371305069-5366-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
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
index f298890..4a2da9e 100644
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
@@ -784,12 +784,13 @@ static void __process_echoes(struct tty_struct *tty)
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
@@ -804,25 +805,26 @@ static void commit_echoes(struct tty_struct *tty)
 
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

