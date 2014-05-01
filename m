Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaEAAsz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:48:55 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:43830 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEAAsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:48:53 -0400
From: Rob Herring <robherring2@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 1/2] tty/serial: add back missing setup_early_serial8250_console
Date: Wed, 30 Apr 2014 19:48:28 -0500
Message-Id: <1398905309-24843-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Commit d2fd6810a823bcd (tty/serial: convert 8250 to generic earlycon)
removed setup_early_serial8250_console, but there are still 2 callers
in:

arch/mips/mti-malta/malta-init.c
drivers/firmware/pcdp.c

Add back the function implemented as a wrapper to setup_earlycon.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/8250/8250_early.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_early.c b/drivers/tty/serial/8250/8250_early.c
index e83c9db..cfef801 100644
--- a/drivers/tty/serial/8250/8250_early.c
+++ b/drivers/tty/serial/8250/8250_early.c
@@ -156,6 +156,16 @@ static int __init early_serial8250_setup(struct earlycon_device *device,
 EARLYCON_DECLARE(uart8250, early_serial8250_setup);
 EARLYCON_DECLARE(uart, early_serial8250_setup);
 
+int __init setup_early_serial8250_console(char *cmdline)
+{
+	char match[] = "uart8250";
+
+	if (cmdline && cmdline[4] == ',')
+		match[4] = '\0';
+
+	return setup_earlycon(cmdline, match, early_serial8250_setup);
+}
+
 int serial8250_find_port_for_earlycon(void)
 {
 	struct earlycon_device *device = early_device;
-- 
1.9.1

