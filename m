Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934847AbaJ3VTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 17:19:12 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47771 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934812AbaJ3VTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 17:19:10 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-serial@vger.kernel.ogr
Cc: linux-kernel@vger.kernel.org, jslaby@suse.cz, gregkh@linuxfoundation.org,
        devicetree@vger.kernel.org, jingchang.lu@freescale.com, arnd@arndb.de,
        gregory.0xf0@gmail.com, Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] serial: of-serial: zero-out struct of_serial_info
Date: Thu, 30 Oct 2014 14:18:33 -0700
Message-Id: <1414703913-1343-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_platform_serial_probe() invokes of_platform_serial_setup() with a
kmalloc'd struct of_serial_info cookie, which is not much of a problem
for most of the struct of_serial_info fields we access but info->clk.

On platforms which do not provide a clock phandle for their UART nodes
but do provide a 'clock-frequency' property, we basically leave the
info->clk variable uninitialized, and this craps out during
suspend/resume with oopses, crashes or warnings in the clock code.

Fix this by using kzalloc() which also zeroes-out the structure and
provides an initialized info->clk member set to NULL.

Fixes: 2dea53bf57783 ("serial: of-serial: add PM suspend/resume support")
Fixes: e34b9c94b6e8d ("[POWERPC] of_serial: add port type checking")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
Greg, Jiri,

This fixes a regression introduced in 3.18-rc1, thanks!

 drivers/tty/serial/of_serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 8bc2563335ae..56982da4a9e9 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -158,7 +158,7 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
 		return -EBUSY;
 
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (info == NULL)
 		return -ENOMEM;
 
-- 
1.9.1

