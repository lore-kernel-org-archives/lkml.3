Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935746AbaBDWRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:17:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56654 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbaBDVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:08:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Roszko <mark.roszko@gmail.com>,
        Leilei Zhao <leilei.zhao@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.12 056/133] tty/serial: at91: fix race condition in atmel_serial_remove
Date: Tue,  4 Feb 2014 13:07:37 -0800
Message-Id: <20140204210738.615804950@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Roszko <mark.roszko@gmail.com>

commit f50c995f9ebf064cea1368bf361c4e29679415b4 upstream.

The _remove callback could be called when a tasklet is scheduled. tasklet_kill
was called inside the function in order to free up any scheduled tasklets.
However it was called after uart_remove_one_port which destroys tty references
needed in the port for atmel_tasklet_func.
Simply putting the tasklet_kill at the start of the function will prevent this
conflict.

Signed-off-by: Marek Roszko <mark.roszko@gmail.com>
Acked-by: Leilei Zhao <leilei.zhao@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/atmel_serial.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -2430,11 +2430,12 @@ static int atmel_serial_remove(struct pl
 	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int ret = 0;
 
+	tasklet_kill(&atmel_port->tasklet);
+
 	device_init_wakeup(&pdev->dev, 0);
 
 	ret = uart_remove_one_port(&atmel_uart, port);
 
-	tasklet_kill(&atmel_port->tasklet);
 	kfree(atmel_port->rx_ring.buf);
 
 	/* "port" is allocated statically, so we shouldn't free it */


