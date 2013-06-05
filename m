Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab3FEV20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:28:26 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48343 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756Ab3FEV2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:28:25 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] tty/serial/sirf: fix error propagation in sirfsoc_uart_probe()
Date: Thu,  6 Jun 2013 01:28:12 +0400
Message-Id: <1370467692-4468-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pinctrl_get_select_default() fails, sirfsoc_uart_probe()
returns IS_ERR(result) instead of PTR_ERR(result).

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/tty/serial/sirfsoc_uart.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index 03465b6..1fd564b 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -687,9 +687,10 @@ int sirfsoc_uart_probe(struct platform_device *pdev)
 
 	if (sirfport->hw_flow_ctrl) {
 		sirfport->p = pinctrl_get_select_default(&pdev->dev);
-		ret = IS_ERR(sirfport->p);
-		if (ret)
+		if (IS_ERR(sirfport->p)) {
+			ret = PTR_ERR(sirfport->p);
 			goto err;
+		}
 	}
 
 	sirfport->clk = clk_get(&pdev->dev, NULL);
-- 
1.8.1.2

