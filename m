Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3KDSoD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:44:03 -0500
Received: from nm18-vm3.access.bullet.mail.gq1.yahoo.com ([216.39.63.76]:21745
	"EHLO nm18-vm3.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab3KDSoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:44:00 -0500
X-Yahoo-Newman-Id: 153335.46686.bm@smtp114.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: _WLilzYVM1kcNYhpr17vhw7ePSkkwNqXrvTDRam9HNuQ5qh
 dZ951pfCBenDoFzpn6fvt7kBxGVCVpYblBdRzPseH2I.zV_N6mFCtEDAuKkk
 YV5nhuUrzoMT7bKm.AKHTAHaBlUGYAQ62M_sOIos2dYorRpMMO1I_N5FpMuy
 y1zfT20K2NPmoQ_zNB7i8czIrQUbSZO6xqiavB3Sp5Iagswa5yo7Yyv_T68i
 tsrzHd3ElgJETLiiiuI6b.thuy1G5zOs_wr5hLaAZmtxOM1_vtleJXCXNmtV
 5_0SooWmydOlPoNTN7UkSR6QlsEF1eezgWQeVo0xWPUlF.aaSyHsy_oSKX2e
 aFRGhi2nCmqAWFlznD1ZpbQ7qZlVE44MHiKfTe_AJ4e_iQ7k2hlHW5IDpZQB
 Iw928Wsq9D.SE4w11vDW5oJkTkEKwJZB.NPC1sWH_sdZ0RUkCgcrr_XBTLZo
 wDhkt_RU7WAWCzxDAZMM.Pe5iEL54XuhZXroyrBnkt9rTEyFsMYvl.V3yFU3
 0j4pJKeL5DfJLWi0EzMIFTljiwVtAQ5TkofuLL9JmS80L56XUCVcX2nFpre_
 dcYY-
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@216.100.252.242 with )
        by smtp114.sbc.mail.gq1.yahoo.com with SMTP; 04 Nov 2013 10:44:00 -0800 PST
From: Alexey Neyman <stilor@att.net>
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Avoid needless loop in sdhci_irq() for Card Interrupt
Date: Mon, 04 Nov 2013 10:43:59 -0800
Message-ID: <3478818.ZVgDgJjmfN@mistral>
User-Agent: KMail/4.11.2 (Linux/3.11.0-12-generic; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart15375689.Pz1tcezmgv"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart15375689.Pz1tcezmgv
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

[Patch ping #3: anyone interested in making sdhci_irq a bit faster?]

Hi all,

I've discovered that the sdhci_irq() function needlessly iterates re-reading 
the interrupt status and doing nothing (until it runs out of max_loops) when 
it handles the "Card Interrupt" status in the interrupt status register.

The reason is that the "Card Interrupt" bit is not cleared until the 
sdhci_irq() calls mmc_signal_sdio_irq(), so if Card Interrupt was asserted, 
re-reading the interrupt status will find this bit set over and over, even if 
no other bits are reported.

The fix: ignore Card Interrupt bits in the interrupt status if we already know 
that mmc_signal_sdio_irq() is going to be called at the end of sdhci_irq().

Signed-off-by: Alexey Neyman <stilor@att.net>
--nextPart15375689.Pz1tcezmgv
Content-Disposition: attachment; filename="sdhci.c.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="utf-8"; name="sdhci.c.diff"

commit 7f23315b344ca51ddf22a78f326f88404fa8c81d
Author: Alexey Neyman <stilor@att.net>
Date:   Wed Oct 9 22:23:54 2013 -0700

    Avoid a loop in sdhci.c.

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 7a7fb4f..a83cd1b 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2491,6 +2491,14 @@ again:
 	result = IRQ_HANDLED;
 
 	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
+
+	/*
+	 * If we know we'll call the driver to signal SDIO IRQ, disregard
+	 * further indications of Card Interrupt in the status to avoid a
+	 * needless loop.
+	 */
+	if (cardint)
+		intmask &= ~SDHCI_INT_CARD_INT;
 	if (intmask && --max_loops)
 		goto again;
 out:

--nextPart15375689.Pz1tcezmgv--

