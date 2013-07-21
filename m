Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab3GUG74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 02:59:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40080 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635Ab3GUG7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 02:59:06 -0400
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
        Balaji TK <balajitk@ti.com>, Gururaja Hebbar <gururaja.hebbar@ti.com>,
        Chris Ball <cjb@laptop.org>, Jason Kridner <jkridner@beagleboard.org>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [RFC 3/5] ARM: edma: Add function to manually trigger an EDMA channel
Date: Sun, 21 Jul 2013 01:58:16 -0500
Message-ID: <1374389896-32584-1-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manual trigger for events missed as a result of splitting a
scatter gather list and DMA'ing it in batches. Add a helper
function to trigger a channel incase any such events are missed.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 arch/arm/common/edma.c             |   21 +++++++++++++++++++++
 include/linux/platform_data/edma.h |    2 ++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 3567ba1..205f5da 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1236,6 +1236,27 @@ void edma_resume(unsigned channel)
 }
 EXPORT_SYMBOL(edma_resume);
 
+int edma_manual_trigger(unsigned channel)
+{
+	unsigned ctlr;
+	int j;
+	unsigned int mask;
+
+	ctlr = EDMA_CTLR(channel);
+	channel = EDMA_CHAN_SLOT(channel);
+	mask = BIT(channel & 0x1f);
+
+	j = channel >> 5;
+
+	/* EDMA channels without event association */
+	edma_shadow0_write_array(ctlr, SH_ESR, j, mask);
+
+	pr_debug("EDMA: ESR%d %08x\n", j,
+		edma_shadow0_read_array(ctlr, SH_ESR, j));
+	return 0;
+}
+EXPORT_SYMBOL(edma_manual_trigger);
+
 /**
  * edma_start - start dma on a channel
  * @channel: channel being activated
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 57300fd..0e11eca 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -180,4 +180,6 @@ struct edma_soc_info {
 	const s16	(*xbar_chans)[2];
 };
 
+int edma_manual_trigger(unsigned);
+
 #endif
-- 
1.7.9.5

