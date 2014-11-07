Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaKGOPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:15:22 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54368 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752926AbaKGOPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:15:17 -0500
Message-ID: <545CD3D7.5010300@arm.com>
Date: Fri, 07 Nov 2014 14:14:47 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 4/5] serial: pl011: Don't enable RX DMA if residue processing
 not supported
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If the DMA engine doesn't support residue processing then the RX DMA
handling won't work terribly well if polling is enabled.  So, disable
RX DMA if residue handling isn't available.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 drivers/tty/serial/amba-pl011.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 7c5e263..79b9c93 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -322,7 +322,22 @@ static void pl011_dma_probe_initcall(struct device *dev, struct uart_amba_port *
 			.src_maxburst = uap->fifosize >> 2,
 			.device_fc = false,
 		};
+		struct dma_slave_caps caps;
 
+		/*
+		 * Some DMA controllers provide information on their capabilities.
+		 * If the controller does, check for suitable residue processing
+		 * otherwise assime all is well.
+		 */
+		if (0 == dma_get_slave_caps(chan, &caps)) {
+			if (caps.residue_granularity ==
+					DMA_RESIDUE_GRANULARITY_DESCRIPTOR) {
+				dma_release_channel(chan);
+				dev_info(uap->port.dev,
+					"RX DMA disabled - no residue processing\n");
+				return;
+			}
+		}
 		dmaengine_slave_config(chan, &rx_conf);
 		uap->dmarx.chan = chan;
 
-- 
1.7.1

