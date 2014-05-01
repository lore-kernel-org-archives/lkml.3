Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaEAAtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:49:07 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:56976 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaEAAtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:49:03 -0400
From: Rob Herring <robherring2@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 2/2] tty/serial: fix generic earlycon option parsing
Date: Wed, 30 Apr 2014 19:48:29 -0500
Message-Id: <1398905309-24843-2-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398905309-24843-1-git-send-email-robherring2@gmail.com>
References: <1398905309-24843-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Commit 9aac5887595 (tty/serial: add generic serial earlycon) moved
console option parsing from 8250_early.c and converted to kstrto*
functions from simple_strtoul along the way. However, kstrto* functions
are not equivalent in that they do not allow non-convertible characters
at the end such as "115200n8". Fix this by changing back to
simple_strtoul and ignore what checkpatch.pl says.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/earlycon.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
index 73bf1e2..c92e830 100644
--- a/drivers/tty/serial/earlycon.c
+++ b/drivers/tty/serial/earlycon.c
@@ -53,7 +53,7 @@ static int __init parse_options(struct earlycon_device *device,
 				char *options)
 {
 	struct uart_port *port = &device->port;
-	int mmio, mmio32, length, ret;
+	int mmio, mmio32, length;
 	unsigned long addr;
 
 	if (!options)
@@ -64,25 +64,19 @@ static int __init parse_options(struct earlycon_device *device,
 	if (mmio || mmio32) {
 		port->iotype = (mmio ? UPIO_MEM : UPIO_MEM32);
 		options += mmio ? 5 : 7;
-		ret = kstrtoul(options, 0, &addr);
-		if (ret)
-			return ret;
+		addr = simple_strtoul(options, NULL, 0);
 		port->mapbase = addr;
 		if (mmio32)
 			port->regshift = 2;
 	} else if (!strncmp(options, "io,", 3)) {
 		port->iotype = UPIO_PORT;
 		options += 3;
-		ret = kstrtoul(options, 0, &addr);
-		if (ret)
-			return ret;
+		addr = simple_strtoul(options, NULL, 0);
 		port->iobase = addr;
 		mmio = 0;
 	} else if (!strncmp(options, "0x", 2)) {
 		port->iotype = UPIO_MEM;
-		ret = kstrtoul(options, 0, &addr);
-		if (ret)
-			return ret;
+		addr = simple_strtoul(options, NULL, 0);
 		port->mapbase = addr;
 	} else {
 		return -EINVAL;
@@ -93,9 +87,7 @@ static int __init parse_options(struct earlycon_device *device,
 	options = strchr(options, ',');
 	if (options) {
 		options++;
-		ret = kstrtouint(options, 0, &device->baud);
-		if (ret)
-			return ret;
+		device->baud = simple_strtoul(options, NULL, 0);
 		length = min(strcspn(options, " ") + 1,
 			     (size_t)(sizeof(device->options)));
 		strlcpy(device->options, options, length);
-- 
1.9.1

