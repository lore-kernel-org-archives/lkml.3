Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaLIJVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:21:09 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:62491 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbaLIJMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:12:00 -0500
From: Jiada Wang <jiada_wang@mentor.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <jiada_wang@mentor.com>, <anton_bondarenko@mentor.com>,
        <dirk.behme@de.bosch.com>
Subject: [PATCH v1 14/15] serial: imx: Fix issue in software flow control
Date: Tue, 9 Dec 2014 18:11:35 +0900
Message-ID: <1418116296-12082-15-git-send-email-jiada_wang@mentor.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
References: <1418116296-12082-1-git-send-email-jiada_wang@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After send out x_char in UART driver, x_char needs to be cleared
by UART driver itself, otherwise data in TXFIFO can no longer be
sent out.
Also tx counter needs to be increased to keep track of correct
number of transmitted data.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/tty/serial/imx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 94ee7c5..301cf8c 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -471,6 +471,8 @@ static inline void imx_transmit_buffer(struct imx_port *sport)
 	if (sport->port.x_char) {
 		/* Send next char */
 		writel(sport->port.x_char, sport->port.membase + URTX0);
+		sport->port.icount.tx++;
+		sport->port.x_char = 0;
 		return;
 	}
 
-- 
1.9.3

