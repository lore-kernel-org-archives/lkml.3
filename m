Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248Ab3GDBwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:52:24 -0400
Received: from vps1.hno.se ([31.192.227.87]:59451 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab3GDBwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:52:23 -0400
Message-ID: <1372902699.12955.6.camel@localhost>
Subject: [PATCH] tty/8250_early: Don't truncate last character of options
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 04 Jul 2013 03:51:39 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8b278828cb439b3b9b723a1de28ae10ce3e0cc44 Mon Sep 17 00:00:00 2001
From: Henrik Nordstrom <henrik@henriknordstrom.net>
Date: Thu, 4 Jul 2013 03:24:41 +0200
Subject: [PATCH] tty/8250_early: Don't truncate last character of options

the 3,9 change to use strlcpy to save options uncovered a bug in the
options argument length calculation causing last character of the
string to be truncated by strlcpy. This caused the actual console
to be configured with bad parameters when specifying the console
using console=uart,... syntax.

Example:

Kernel command line: console=uart,mmio,0x90000000,115200
Early serial console at MMIO 0x90000000 (options '11520')

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



