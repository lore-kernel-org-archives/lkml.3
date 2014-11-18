Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbaKROV1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:21:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932205AbaKROKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 143/206] serial: Fix divide-by-zero fault in uart_get_divisor()
Date: Tue, 18 Nov 2014 15:08:18 +0100
Message-Id: <7261d5fa0fdea0d53ed58c7ce2efad1b2485218e.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Hurley <peter@hurleysoftware.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/serial_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b5180c10f71d..6015b6c7708f 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -353,7 +353,7 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		 * The spd_hi, spd_vhi, spd_shi, spd_warp kludge...
 		 * Die! Die! Die!
 		 */
-		if (baud == 38400)
+		if (try == 0 && baud == 38400)
 			baud = altbaud;
 
 		/*
-- 
2.1.3

