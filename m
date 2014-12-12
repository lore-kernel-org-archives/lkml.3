Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718AbaLLGd1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:33:27 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51947 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759328AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Hurley" <peter@hurleysoftware.com>,
        "Robert =?UTF-8?Q?=C5=9Awi=C4=99cki?=" <robert@swiecki.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.749088556@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 116/164] serial: Fix divide-by-zero fault in
 uart_get_divisor()
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/serial_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -360,7 +360,7 @@ uart_get_baud_rate(struct uart_port *por
 		 * The spd_hi, spd_vhi, spd_shi, spd_warp kludge...
 		 * Die! Die! Die!
 		 */
-		if (baud == 38400)
+		if (try == 0 && baud == 38400)
 			baud = altbaud;
 
 		/*

