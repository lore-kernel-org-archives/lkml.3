Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab3FGNPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:15:44 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:62112 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3FGNPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:15:42 -0400
From: Lotfi Manseur <lotfi.manseur@gmail.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Lotfi Manseur <lotfi.manseur@imag.fr>, Willy Tarreau <w@1wt.eu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] USB: serial/ftdi_sio.c Fix kernel oops
Date: Fri,  7 Jun 2013 15:14:32 +0200
Message-Id: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle null termios in ftdi_set_termios(), introduced in
commit 552f6bf1bb0eda0011c0525dd587aa9e7ba5b846
This has been corrected in the mainline by
commits c515598e0f5769916c31c00392cc2bfe6af74e55 and
a816e3113b63753c330ca4751ea1d208e93e3015.

This is to be fixed in longterm 2.6.32.60 and 3.4.47.
This bug has been found with coccinelle.

Signed-off-by: Lotfi Manseur <lotfi.manseur@imag.fr>
Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>
---
 drivers/usb/serial/ftdi_sio.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index c374beb..615bd9e 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2364,7 +2364,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
 
 	cflag = termios->c_cflag;
 
-	if (old_termios->c_cflag == termios->c_cflag
+	if (old_termios
+	    && old_termios->c_cflag == termios->c_cflag
 	    && old_termios->c_ispeed == termios->c_ispeed
 	    && old_termios->c_ospeed == termios->c_ospeed)
 		goto no_c_cflag_changes;
@@ -2373,7 +2374,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
 	   ftdi_sio_read_bulk_callback  - need to examine what this means -
 	   don't see any problems yet */
 
-	if ((old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) ==
+	if (old_termios &&
+	    (old_termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)) ==
 	    (termios->c_cflag & (CSIZE|PARODD|PARENB|CMSPAR|CSTOPB)))
 		goto no_data_parity_stop_changes;
 
-- 
1.7.9.5

