Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbbALSFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57284 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbbALSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 005/216] s390/3215: fix tty output containing tabs
Date: Mon, 12 Jan 2015 18:02:02 +0000
Message-Id: <1421085933-32536-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit e512d56c799517f33b301d81e9a5e0ebf30c2d1e upstream.

git commit 37f81fa1f63ad38e16125526bb2769ae0ea8d332
"n_tty: do O_ONLCR translation as a single write"
surfaced a bug in the 3215 device driver. In combination this
broke tab expansion for tty ouput.

The cause is an asymmetry in the behaviour of tty3215_ops->write
vs tty3215_ops->put_char. The put_char function scans for '\t'
but the write function does not.

As the driver has logic for the '\t' expansion remove XTABS
from c_oflag of the initial termios as well.

Reported-by: Stephen Powell <zlinuxman@wowway.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/char/con3215.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index a6d47e5eee9e..c43aca69fb30 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -1035,12 +1035,26 @@ static int tty3215_write(struct tty_struct * tty,
 			 const unsigned char *buf, int count)
 {
 	struct raw3215_info *raw;
+	int i, written;
 
 	if (!tty)
 		return 0;
 	raw = (struct raw3215_info *) tty->driver_data;
-	raw3215_write(raw, buf, count);
-	return count;
+	written = count;
+	while (count > 0) {
+		for (i = 0; i < count; i++)
+			if (buf[i] == '\t' || buf[i] == '\n')
+				break;
+		raw3215_write(raw, buf, i);
+		count -= i;
+		buf += i;
+		if (count > 0) {
+			raw3215_putchar(raw, *buf);
+			count--;
+			buf++;
+		}
+	}
+	return written;
 }
 
 /*
@@ -1188,7 +1202,7 @@ static int __init tty3215_init(void)
 	driver->subtype = SYSTEM_TYPE_TTY;
 	driver->init_termios = tty_std_termios;
 	driver->init_termios.c_iflag = IGNBRK | IGNPAR;
-	driver->init_termios.c_oflag = ONLCR | XTABS;
+	driver->init_termios.c_oflag = ONLCR;
 	driver->init_termios.c_lflag = ISIG;
 	driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(driver, &tty3215_ops);
-- 
2.1.4

