Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaLEXXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:23:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaLEW4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.14 34/73] USB: ssu100: fix overrun-error reporting
Date: Fri,  5 Dec 2014 14:44:40 -0800
Message-Id: <20141205224434.962903968@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 75bcbf29c284dd0154c3e895a0bd1ef0e796160e upstream.

Fix reporting of overrun errors, which should only be reported once
using the inserted null character.

Fixes: 6b8f1ca5581b ("USB: ssu100: set tty_flags in ssu100_process_packet")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ssu100.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -490,10 +490,9 @@ static void ssu100_update_lsr(struct usb
 			if (*tty_flag == TTY_NORMAL)
 				*tty_flag = TTY_FRAME;
 		}
-		if (lsr & UART_LSR_OE){
+		if (lsr & UART_LSR_OE) {
 			port->icount.overrun++;
-			if (*tty_flag == TTY_NORMAL)
-				*tty_flag = TTY_OVERRUN;
+			tty_insert_flip_char(&port->port, 0, TTY_OVERRUN);
 		}
 	}
 
@@ -511,12 +510,8 @@ static void ssu100_process_read_urb(stru
 	if ((len >= 4) &&
 	    (packet[0] == 0x1b) && (packet[1] == 0x1b) &&
 	    ((packet[2] == 0x00) || (packet[2] == 0x01))) {
-		if (packet[2] == 0x00) {
+		if (packet[2] == 0x00)
 			ssu100_update_lsr(port, packet[3], &flag);
-			if (flag == TTY_OVERRUN)
-				tty_insert_flip_char(&port->port, 0,
-						TTY_OVERRUN);
-		}
 		if (packet[2] == 0x01)
 			ssu100_update_msr(port, packet[3]);
 


