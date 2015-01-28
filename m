Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388AbbA1Eho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:37:44 -0500
Received: from mail.kernel.org ([198.145.29.136]:40889 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965167AbbA1EYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:55 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 139/177] serial: Fix divide-by-zero fault in uart_get_divisor()
Date: Wed, 28 Jan 2015 12:09:57 +0800
Message-Id: <1422418236-12852-230-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 547039ec502076e60034eeb79611df3433a99b7d upstream.

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
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/tty/serial/serial_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 4185cc5..82aac29 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -355,7 +355,7 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		 * The spd_hi, spd_vhi, spd_shi, spd_warp kludge...
 		 * Die! Die! Die!
 		 */
-		if (baud == 38400)
+		if (try == 0 && baud == 38400)
 			baud = altbaud;
 
 		/*
-- 
1.9.1

