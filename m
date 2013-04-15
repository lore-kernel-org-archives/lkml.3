Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933914Ab3DOPdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:33:00 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45927 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933323Ab3DOPc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:32:57 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 20/24] n_tty: Move chars_in_buffer() to factor throttle/unthrottle
Date: Mon, 15 Apr 2013 11:19:24 -0400
Message-Id: <1366039168-8510-21-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare to factor throttle and unthrottle into helper functions;
relocate chars_in_buffer() to avoid forward declaration.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index dba7e99..d905b45 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -202,6 +202,18 @@ static void n_tty_set_room(struct tty_struct *tty)
 	}
 }
 
+static ssize_t chars_in_buffer(struct tty_struct *tty)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	ssize_t n = 0;
+
+	if (!ldata->icanon)
+		n = read_cnt(ldata);
+	else
+		n = ldata->canon_head - ldata->read_tail;
+	return n;
+}
+
 /**
  *	put_tty_queue		-	add character to tty
  *	@c: character
@@ -285,18 +297,6 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
 	up_write(&tty->termios_rwsem);
 }
 
-static ssize_t chars_in_buffer(struct tty_struct *tty)
-{
-	struct n_tty_data *ldata = tty->disc_data;
-	ssize_t n = 0;
-
-	if (!ldata->icanon)
-		n = read_cnt(ldata);
-	else
-		n = ldata->canon_head - ldata->read_tail;
-	return n;
-}
-
 /**
  *	n_tty_chars_in_buffer	-	report available bytes
  *	@tty: tty device
-- 
1.8.1.2

