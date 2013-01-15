Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3AOE5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:57:52 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:51274 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3AOE5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:57:49 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 4/4] serial: tty: Cleanup code using devm_ function
Date: Tue, 15 Jan 2013 17:58:06 +1300
Message-Id: <1358225886-5686-5-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
References: <1358225886-5686-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the last memory allocation (vt8500_port) to use devm_kzalloc
and remove the fail path cleanup code from vt8500_serial_probe.

Reorder iomem mapping above clk_enable to simplify fail code. The
clock is only enabled if all other resources are available.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/tty/serial/vt8500_serial.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 7f9e578..1fc6f3d 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -589,7 +589,8 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	vt8500_port = kzalloc(sizeof(struct vt8500_port), GFP_KERNEL);
+	vt8500_port = devm_kzalloc(&pdev->dev, sizeof(struct vt8500_port),
+				   GFP_KERNEL);
 	if (!vt8500_port)
 		return -ENOMEM;
 
@@ -600,14 +601,13 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	vt8500_port->clk = of_clk_get(pdev->dev.of_node, 0);
 	if (IS_ERR(vt8500_port->clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
-		ret = -EINVAL;
-		goto err;
+		return  -EINVAL;
 	}
 
 	ret = clk_prepare_enable(vt8500_port->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
- 		goto err;
+ 		return ret;
  	}
 
 	vt8500_port->uart.type = PORT_VT8500;
@@ -631,10 +631,6 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, vt8500_port);
 
 	return 0;
-
-err:
-	kfree(vt8500_port);
-	return ret;
 }
 
 static int vt8500_serial_remove(struct platform_device *pdev)
@@ -644,7 +640,6 @@ static int vt8500_serial_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	clk_disable_unprepare(vt8500_port->clk);
 	uart_remove_one_port(&vt8500_uart_driver, &vt8500_port->uart);
-	kfree(vt8500_port);
 
 	return 0;
 }
-- 
1.7.9.5

