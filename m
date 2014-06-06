Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaFFLSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 07:18:52 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9463 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaFFLSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 07:18:51 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 06 Jun 2014 04:10:42 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <gregkh@linuxfoundation.org>
CC: <swarren@wwwdotorg.org>, <linux-serial@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pradeep Goudagunta <pgoudagunta@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] serial: tegra: ack the rx dma desc after transfer terminated
Date: Fri, 6 Jun 2014 16:48:09 +0530
Message-ID: <1402053489-21262-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1402053489-21262-1-git-send-email-ldewangan@nvidia.com>
References: <1402053489-21262-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pradeep Goudagunta <pgoudagunta@nvidia.com>

The Rx dma descriptor allocated without the DMA_ACK flags so that
once after tarnsfer done or terminated, client can ack the descriptor
to free it for later use.

If the Rx DMA is terminated for some reason then rx-dma descriptor
is not getting acked which causes the memory leak and list of usage
desc to grow continuously.

Hence, acknowledge the rx-dma descriptor once transfer is terminated
to avoid memory leak and desc list to grow.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/tty/serial/serial-tegra.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 117d8d1..53d7c31 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -602,6 +602,7 @@ static void tegra_uart_handle_rx_dma(struct tegra_uart_port *tup,
 
 	dmaengine_terminate_all(tup->rx_dma_chan);
 	dmaengine_tx_status(tup->rx_dma_chan,  tup->rx_cookie, &state);
+	async_tx_ack(tup->rx_dma_desc);
 	count = tup->rx_bytes_requested - state.residue;
 
 	/* If we are here, DMA is stopped */
-- 
1.8.1.5

