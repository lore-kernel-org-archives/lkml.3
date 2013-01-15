Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3APAdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:33:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:41499 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab3AOW2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:28:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wolfram Sang <w.sang@pengutronix.de>,
        Huang Shijie <b32955@freescale.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 057/221] mtd: nand: gpmi: reset BCH earlier, too, to avoid NAND startup problems
Date: Tue, 15 Jan 2013 10:49:44 -0800
Message-Id: <20130115185002.149980063@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-lib.c
@@ -166,6 +166,15 @@ int gpmi_init(struct gpmi_nand_data *thi
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
 


