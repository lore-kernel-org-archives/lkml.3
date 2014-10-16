Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaJPRrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:47:10 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50170 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752032AbaJPRrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:47:08 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        <robert@swiecki.net>, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>, <stable@vger.kernel.org>
Subject: [PATCH] serial: Fix divide-by-zero fault in uart_get_divisor()
Date: Thu, 16 Oct 2014 13:46:38 -0400
Message-Id: <1413481598-20416-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uart_get_baud_rate() will return baud == 0 if the max rate is set
to the "magic" 38400 rate and the SPD_* flags are also specified.
On the first iteration, if the current baud rate is higher than the
max, the baud rate is clamped at the max (which in the degenerate
case is 38400). On the second iteration, the now-"magic" 38400 baud
rate selects the possibly higher alternate baud rate indicated by
the SPD_* flag. Since only two loop iterations are performed, the
loop is exited, a kernel WARNING is generated and a baud rate of
0 is returned.

Reproducible with:
 setserial /dev/ttyS0 spd_hi base_baud 38400

Only perform the "magic" 38400 -> SPD_* baud transform on the first
loop iteration, which prevents the degenerate case from recognizing
the clamped baud rate as the "magic" 38400 value.

Reported-by: Robert Święcki <robert@swiecki.net>
Cc: <stable@vger.kernel.org> # all
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index de74621..c4cc2f2 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -363,7 +363,7 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		 * The spd_hi, spd_vhi, spd_shi, spd_warp kludge...
 		 * Die! Die! Die!
 		 */
-		if (baud == 38400)
+		if (try == 0 && baud == 38400)
 			baud = altbaud;
 
 		/*
-- 
2.1.1

