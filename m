Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516AbbAYSLP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:11:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbbAYSIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Powell <zlinuxman@wowway.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.10 50/50] s390/3215: fix tty output containing tabs
Date: Sun, 25 Jan 2015 10:07:40 -0800
Message-Id: <20150125180705.453976868@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/char/con3215.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -1029,12 +1029,26 @@ static int tty3215_write(struct tty_stru
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
@@ -1182,7 +1196,7 @@ static int __init tty3215_init(void)
 	driver->subtype = SYSTEM_TYPE_TTY;
 	driver->init_termios = tty_std_termios;
 	driver->init_termios.c_iflag = IGNBRK | IGNPAR;
-	driver->init_termios.c_oflag = ONLCR | XTABS;
+	driver->init_termios.c_oflag = ONLCR;
 	driver->init_termios.c_lflag = ISIG;
 	driver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(driver, &tty3215_ops);


