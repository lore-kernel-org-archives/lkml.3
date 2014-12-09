Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaLINc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:32:27 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:18975 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158AbaLINcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:32:24 -0500
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <nicolas.ferre@atmel.com>, <gregkh@linuxfoundation.org>,
        <wenyou.yang@atmel.com>, <ludovic.desroches@atmel.com>,
        <leilei.zhao@atmel.com>, <voice.shen@atmel.com>, <josh.wu@atmel.com>,
        <linux-serial@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 3/5] tty/serial: at91: fix error handling in atmel_serial_probe()
Date: Tue, 9 Dec 2014 14:31:34 +0100
Message-ID: <95ff85410e2f93993a4f7c5d255c4a88993fd462.1418131298.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1418131298.git.cyrille.pitchen@atmel.com>
References: <cover.1418131298.git.cyrille.pitchen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-EDEFER error wasn't handle properly by atmel_serial_probe().
As an example, when atmel_serial_probe() is called for the first time, we pass
the test_and_set_bit() test to check whether the port has already been
initalized. Then we call atmel_init_port(), which may return -EDEFER, possibly
returned before by clk_get(). Consequently atmel_serial_probe() used to return
this error code WITHOUT clearing the port bit in the "atmel_ports_in_use" mask.
When atmel_serial_probe() was called for the second time, it used to fail on
the test_and_set_bit() function then returning -EBUSY.

When atmel_serial_probe() fails, this patch make it clear the port bit in the
"atmel_ports_in_use" mask, if needed, before returning the error code.

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/tty/serial/atmel_serial.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index c6621dc..92a8b26 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2565,7 +2565,7 @@ static int atmel_serial_probe(struct platform_device *pdev)
 
 	ret = atmel_init_port(port, pdev);
 	if (ret)
-		goto err;
+		goto err_clear_bit;
 
 	if (!atmel_use_pdc_rx(&port->uart)) {
 		ret = -ENOMEM;
@@ -2628,6 +2628,8 @@ err_alloc_ring:
 		clk_put(port->clk);
 		port->clk = NULL;
 	}
+err_clear_bit:
+	clear_bit(port->uart.line, atmel_ports_in_use);
 err:
 	return ret;
 }
-- 
1.8.2.2

