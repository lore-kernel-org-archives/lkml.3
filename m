Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964897Ab3CSUpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:45:25 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:40566 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab3CSUpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:45:21 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Min Zhang <mzhang@mvista.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 16/18] n_tty: Fix type mismatches in receive_buf raw copy
Date: Tue, 19 Mar 2013 16:21:51 -0400
Message-Id: <1363724513-15604-17-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 9d7badc..68445c7 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1471,26 +1471,29 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	struct n_tty_data *ldata = tty->disc_data;
 	const unsigned char *p;
 	char *f, flags = TTY_NORMAL;
-	int	i;
 	char	buf[64];
 
 	down_read(&tty->termios_rwsem);
 
 	if (ldata->real_raw) {
-		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
-			N_TTY_BUF_SIZE - (ldata->read_head & (N_TTY_BUF_SIZE - 1)));
-		i = min(count, i);
-		memcpy(read_buf_addr(ldata, ldata->read_head), cp, i);
-		ldata->read_head += i;
-		cp += i;
-		count -= i;
-
-		i = min(N_TTY_BUF_SIZE - read_cnt(ldata),
-			N_TTY_BUF_SIZE - (ldata->read_head & (N_TTY_BUF_SIZE - 1)));
-		i = min(count, i);
-		memcpy(read_buf_addr(ldata, ldata->read_head), cp, i);
-		ldata->read_head += i;
+		size_t n, head;
+
+		head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
+		n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+		n = min_t(size_t, count, n);
+		memcpy(read_buf_addr(ldata, head), cp, n);
+		ldata->read_head += n;
+		cp += n;
+		count -= n;
+
+		head = ldata->read_head & (N_TTY_BUF_SIZE - 1);
+		n = N_TTY_BUF_SIZE - max(read_cnt(ldata), head);
+		n = min_t(size_t, count, n);
+		memcpy(read_buf_addr(ldata, head), cp, n);
+		ldata->read_head += n;
 	} else {
+		int i;
+
 		for (i = count, p = cp, f = fp; i; i--, p++) {
 			if (f)
 				flags = *f++;
-- 
1.8.1.2

