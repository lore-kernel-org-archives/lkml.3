Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499Ab3ERNWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 09:22:49 -0400
Received: from smtp39.i.mail.ru ([94.100.177.99]:36296 "EHLO smtp39.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab3ERNWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 09:22:48 -0400
Message-ID: <5197800D.60601@list.ru>
Date: Sat, 18 May 2013 17:20:13 +0400
From: Stas Sergeev <stsp@list.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux kernel <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] n_tty: fix .chars_in_buffer confusion
Content-Type: multipart/mixed;
 boundary="------------020304020400070202030504"
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020304020400070202030504
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

I think there is a confusion with n_tty_chars_in_buffer(): it
calculates the amount of input chars, but is used as a
.chars_in_buffer member of tty_ldisc_ops, which, AFAIK,
should calculate the amount of _output_ chars buffered.

Here is the patch that changes this.
Since it doesn't fix any problem I can practically observe,
the chances are high that I am missing something obvious.

Can someone please take a look if there is really a bug here?

--------------020304020400070202030504
Content-Type: text/x-patch;
 name="0001-n_tty-fix-.chars_in_buffer-confusion.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-n_tty-fix-.chars_in_buffer-confusion.patch"

>From cea19eda592e61db780e3ce1a7bf9a5f0899a0fc Mon Sep 17 00:00:00 2001
From: Stas Sergeev <stsp@users.sourceforge.net>
Date: Sat, 18 May 2013 15:06:39 +0400
Subject: [PATCH] n_tty: fix .chars_in_buffer confusion

n_tty_chars_in_buffer() was calculating the amount of input
chars, not output chars. It therefore should not be used as
a .chars_in_buffer member.
This patch removes it from tty_ldisc_ops and renames to
chars_in_input_buffer()

Signed-off-by: Stas Sergeev <stsp@users.sourceforge.net>
---
 drivers/tty/n_tty.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3f228c9..0567235 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -253,7 +253,7 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
 }
 
 /**
- *	n_tty_chars_in_buffer	-	report available bytes
+ *	chars_in_input_buffer	-	report available bytes
  *	@tty: tty device
  *
  *	Report the number of characters buffered to be delivered to user
@@ -262,7 +262,7 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
  *	Locking: read_lock
  */
 
-static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
+static ssize_t chars_in_input_buffer(struct tty_struct *tty)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	unsigned long flags;
@@ -1977,7 +1977,7 @@ do_it_again:
 		}
 
 		/* If there is enough space in the read buffer now, let the
-		 * low-level driver know. We use n_tty_chars_in_buffer() to
+		 * low-level driver know. We use chars_in_input_buffer() to
 		 * check the buffer, as it now knows about canonical mode.
 		 * Otherwise, if the driver is throttled and the line is
 		 * longer than TTY_THRESHOLD_UNTHROTTLE in canonical mode,
@@ -1985,7 +1985,7 @@ do_it_again:
 		 */
 		while (1) {
 			tty_set_flow_change(tty, TTY_UNTHROTTLE_SAFE);
-			if (n_tty_chars_in_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
+			if (chars_in_input_buffer(tty) > TTY_THRESHOLD_UNTHROTTLE)
 				break;
 			if (!tty->count)
 				break;
@@ -2206,7 +2206,6 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.open            = n_tty_open,
 	.close           = n_tty_close,
 	.flush_buffer    = n_tty_flush_buffer,
-	.chars_in_buffer = n_tty_chars_in_buffer,
 	.read            = n_tty_read,
 	.write           = n_tty_write,
 	.ioctl           = n_tty_ioctl,
-- 
1.7.11.7


--------------020304020400070202030504--
