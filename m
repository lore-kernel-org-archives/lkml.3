Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab3JCF14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 01:27:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3JCEMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:12:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Stephen Warren <swarren@nvidia.com>
Subject: [ 19/52] serial: tegra: fix tty-kref leak
Date: Wed,  2 Oct 2013 21:05:37 -0700
Message-Id: <20131003040523.496519452@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040522.190209641@linuxfoundation.org>
References: <20131003040522.190209641@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit cfd29aa0e81b791985e8428e6507e80e074e6730 upstream.

Fix potential tty-kref leak in stop_rx path.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/serial-tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -726,7 +726,7 @@ static irqreturn_t tegra_uart_isr(int ir
 static void tegra_uart_stop_rx(struct uart_port *u)
 {
 	struct tegra_uart_port *tup = to_tegra_uport(u);
-	struct tty_struct *tty = tty_port_tty_get(&tup->uport.state->port);
+	struct tty_struct *tty;
 	struct tty_port *port = &u->state->port;
 	struct dma_tx_state state;
 	unsigned long ier;
@@ -738,6 +738,8 @@ static void tegra_uart_stop_rx(struct ua
 	if (!tup->rx_in_progress)
 		return;
 
+	tty = tty_port_tty_get(&tup->uport.state->port);
+
 	tegra_uart_wait_sym_time(tup, 1); /* wait a character interval */
 
 	ier = tup->ier_shadow;


