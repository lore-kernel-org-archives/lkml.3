Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab3APQFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36275 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab3APQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 125/222] mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup problems
Date: Wed, 16 Jan 2013 13:55:25 -0200
Message-Id: <1358351822-7675-126-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <w.sang@pengutronix.de>

commit 6f2a6a52560ad8d85710aabd92b7a3239b3a6b07 upstream.

It could happen (1 out of 100 times) that NAND did not start up
correctly after warm rebooting, so the kernel could not find the UBI or
DMA timed out due to a stalled BCH. When resetting BCH together with
GPMI, the issue could not be observed anymore (after 10000+ reboots). We
probably need the consistent state already before sending any command to
NAND, even when no ECC is needed. I chose to keep the extra reset for
BCH when changing the flash layout to be on the safe side.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
index a1f4332..b27e215 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -136,6 +136,15 @@ int gpmi_init(struct gpmi_nand_data *this)
 	if (ret)
 		goto err_out;
 
+	/*
+	 * Reset BCH here, too. We got failures otherwise :(
+	 * See later BCH reset for explanation of MX23 handling
+	 */
+	ret = gpmi_reset_block(r->bch_regs, GPMI_IS_MX23(this));
+	if (ret)
+		goto err_out;
+
+
 	/* Choose NAND mode. */
 	writel(BM_GPMI_CTRL1_GPMI_MODE, r->gpmi_regs + HW_GPMI_CTRL1_CLR);
 
-- 
1.7.9.5

