Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab3HEQSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:18:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39240 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab3HEQP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:15:57 -0400
From: Joel Fernandes <joelf@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Mark Brown <broonie@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Balaji TK <balajitk@ti.com>,
        Gururaja Hebbar <gururaja.hebbar@ti.com>, Chris Ball <cjb@laptop.org>,
        Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH v3 02/12] ARM: edma: Don't clear EMR of channel in edma_stop
Date: Mon, 5 Aug 2013 11:14:47 -0500
Message-ID: <1375719297-12871-3-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375719297-12871-1-git-send-email-joelf@ti.com>
References: <1375719297-12871-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We certainly don't want error conditions to be cleared any other
place but the EDMA error handler, as this will make us 'forget'
about missed events we might need to know errors have occurred.

This fixes a race condition where the EMR was being cleared
by the transfer completion interrupt handler.

Basically, what was happening was:

            Missed event
             |
             |
             V
SG1-SG2-SG3-Null
         \
          \__TC Interrupt (Almost same time as ARM is executing
TC interrupt handler, an event got missed and also forgotten
by clearing the EMR).

This causes the following  problems:

1.
If error interrupt is also pending and TC interrupt clears the EMR
by calling edma_stop as has been observed in the edma_callback function,
the ARM will execute the error interrupt even though the EMR is clear.
As a result, the  dma_ccerr_handler returns IRQ_NONE. If this happens
enough number of times, IRQ subsystem disables the interrupt thinking
its spurious which makes error handler never execute again.

2.
Also even if error handler doesn't return IRQ_NONE, the removing of EMR
removes the knowledge about which channel had a missed event, and thus
a manual trigger on such channels cannot be performed.

The EMR is ultimately being cleared by the Error interrupt handler
once it is handled so we remove code that does it in edma_stop and
allow it to happen there.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/common/edma.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 3567ba1..6433b6c 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1307,7 +1307,6 @@ void edma_stop(unsigned channel)
 		edma_shadow0_write_array(ctlr, SH_EECR, j, mask);
 		edma_shadow0_write_array(ctlr, SH_ECR, j, mask);
 		edma_shadow0_write_array(ctlr, SH_SECR, j, mask);
-		edma_write_array(ctlr, EDMA_EMCR, j, mask);
 
 		pr_debug("EDMA: EER%d %08x\n", j,
 				edma_shadow0_read_array(ctlr, SH_EER, j));
-- 
1.7.9.5

