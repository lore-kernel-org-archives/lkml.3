Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3LBT0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:26:12 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44387 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3LBTZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:51 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 5/8] n_tty: Refactor input_available_p() by call site
Date: Mon,  2 Dec 2013 14:24:45 -0500
Message-Id: <1386012288-5079-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
 <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distinguish if caller is n_tty_poll() or n_tty_read(), and
set the read/wakeup threshold accordingly.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 008b6e5..aae171e 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1881,14 +1881,15 @@ static int n_tty_open(struct tty_struct *tty)
 	return 0;
 }
 
-static inline int input_available_p(struct tty_struct *tty, int amt)
+static inline int input_available_p(struct tty_struct *tty, int poll)
 {
 	struct n_tty_data *ldata = tty->disc_data;
+	int amt = poll && !TIME_CHAR(tty) ? MIN_CHAR(tty) : 1;
 
 	if (ldata->icanon && !L_EXTPROC(tty)) {
 		if (ldata->canon_head != ldata->read_tail)
 			return 1;
-	} else if (read_cnt(ldata) >= (amt ? amt : 1))
+	} else if (read_cnt(ldata) >= amt)
 		return 1;
 
 	return 0;
@@ -2393,7 +2394,7 @@ static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 
 	poll_wait(file, &tty->read_wait, wait);
 	poll_wait(file, &tty->write_wait, wait);
-	if (input_available_p(tty, TIME_CHAR(tty) ? 0 : MIN_CHAR(tty)))
+	if (input_available_p(tty, 1))
 		mask |= POLLIN | POLLRDNORM;
 	if (tty->packet && tty->link->ctrl_status)
 		mask |= POLLPRI | POLLIN | POLLRDNORM;
-- 
1.8.1.2

