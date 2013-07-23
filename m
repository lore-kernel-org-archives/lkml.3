Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933990Ab3GWTHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:07:07 -0400
Received: from vps1.hno.se ([31.192.227.87]:37425 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933129Ab3GWTHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:07:05 -0400
Message-ID: <1374606367.5864.4.camel@localhost>
Subject: [PATCH RESEND #1] tty/8250_early: Don't truncate last character of
 options
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Jul 2013 21:06:07 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The earlier change to use strlcpy uncovered a bug in the options
argument length calculation causing last character to be truncated.
This makes the actual console to be configured with incorrect
baudrate when specifying the console using console=uart,... syntax.

Bug symptom seen in kernel log output:

Kernel command line: console=uart,mmio,0x90000000,115200
Early serial console at MMIO 0x90000000 (options '11520')

which then results in a invalid baud rate 11520 instead of the
expected 115200 when the console is switched to ttyS0 later
in the boot process.

Signed-off-by: Henrik Nordstrom <henrik@henriknordstrom.net>
---
 drivers/tty/serial/8250/8250_early.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index 721904f..946ddd2 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -193,7 +193,8 @@ static int __init parse_options(struct early_serial8250_device *device,
 	if (options) {
 		options++;
 		device->baud = simple_strtoul(options, NULL, 0);
-		length = min(strcspn(options, " "), sizeof(device->options));
+		length = min(strcspn(options, " ") + 1,
+			     sizeof(device->options));
 		strlcpy(device->options, options, length);
 	} else {
 		device->baud = probe_baud(port);
-- 
1.8.3.1



