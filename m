Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3AOE5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:57:53 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:58093 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab3AOE5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:57:49 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/4] serial: vt8500: ioremap'd resource is never freed
Date: Tue, 15 Jan 2013 17:58:04 +1300
Message-Id: <1358225886-5686-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
References: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory mapped via ioremap call is never released. Rather than add an
iounmap call, change allocation function to devm_request_and_ioremap.

Also, change the error on failure for this call to -EBUSY rather than
-EADDRNOTAVAIL.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/tty/serial/vt8500_serial.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 4c4a58d..3e76dff 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -615,9 +615,9 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
 		 "VT8500 UART%d", pdev->id);
 
-	vt8500_port->uart.membase = ioremap(mmres->start, resource_size(mmres));
+	vt8500_port->uart.membase = devm_request_and_ioremap(&pdev->dev, mmres);
 	if (!vt8500_port->uart.membase) {
-		ret = -ENOMEM;
+		ret = -EADDRNOTAVAIL;
 		goto err;
 	}
 
-- 
1.7.9.5

