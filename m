Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbaJHAfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 20:35:13 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:43770 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820AbaJHAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 20:35:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,674,1406617200"; 
   d="scan'208";a="47511224"
From: Ray Jui <rjui@broadcom.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Heikki Krogerus" <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chen-Yu Tsai <wens@csie.org>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        Loic Poulain <loic.poulain@intel.com>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
        Ray Jui <rjui@broadcom.com>
Subject: [PATCH] serial: 8250_dw: Add DMA support for non-ACPI platforms
Date: Tue, 7 Oct 2014 17:35:47 -0700
Message-ID: <1412728547-4126-1-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Ray Jui <rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dma pointer under struct uart_8250_port is currently left
unassigned for non-ACPI platforms. It should be pointing to the dma
member in struct dw8250_data like how it was done for ACPI, so the core
8250 code will try to request for DMA when registering the port

If DMA is not enabled in device tree, request DMA will fail and the
driver will fall back to PIO

Signed-off-by: Ray Jui <rjui@broadcom.com>
Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
Reviewed-by: Scott Branden <sbranden@broadcom.com>
Tested-by: Scott Branden <sbranden@broadcom.com>
---
 drivers/tty/serial/8250/8250_dw.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 4db7987..1038ea8 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -293,6 +293,14 @@ static int dw8250_probe_of(struct uart_port *p,
 	if (has_ucv)
 		dw8250_setup_port(up);
 
+	/* if we have a valid fifosize, try hooking up DMA here */
+	if (p->fifosize) {
+		up->dma = &data->dma;
+
+		up->dma->rxconf.src_maxburst = p->fifosize / 4;
+		up->dma->txconf.dst_maxburst = p->fifosize / 4;
+	}
+
 	if (!of_property_read_u32(np, "reg-shift", &val))
 		p->regshift = val;
 
-- 
1.7.9.5

