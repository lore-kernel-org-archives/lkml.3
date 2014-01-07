Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaAGKqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:46:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:40479 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaAGKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:46:22 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: Leilei Zhao <leilei.zhao@atmel.com>, <mark.roszko@gmail.com>,
        <mdeneen@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <stable@vger.kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/4] tty/serial: at91: prevent null dereference in tasklet function
Date: Tue, 7 Jan 2014 11:45:08 +0100
Message-ID: <69b33ebdc9427b5c036b4ba09151ae88c14a30f4.1389090437.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1389090437.git.nicolas.ferre@atmel.com>
References: <cover.1389090437.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marek Roszko <mark.roszko@gmail.com>

Something asks a tasklet to be scheduled when the uart port is closed.
Need to supress the kernel panic for now by checking if the port is NULL or
not.

Signed-off-by: Marek Roszko <mark.roszko@gmail.com>
Acked-by: Leilei Zhao <leilei.zhao@atmel.com>
Cc: <stable@vger.kernel.org> # v3.12
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/tty/serial/atmel_serial.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index c421d11b3d4c..6e68486c83cb 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1360,6 +1360,10 @@ static void atmel_tasklet_func(unsigned long data)
 	unsigned int status;
 	unsigned int status_change;
 
+	if(!port->state || !port->state->port.tty)
+		/* uart has been closed */
+		return;
+
 	/* The interrupt handler does not take the lock */
 	spin_lock(&port->lock);
 
-- 
1.8.2.2

