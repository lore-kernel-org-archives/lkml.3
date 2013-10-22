Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab3JVSTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 14:19:15 -0400
Received: from nm15-vm9.access.bullet.mail.gq1.yahoo.com ([216.39.63.253]:31230
	"EHLO nm15-vm9.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655Ab3JVSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 14:19:14 -0400
X-Yahoo-Newman-Id: 596491.49519.bm@smtp117.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 0Uw7LdQVM1lG0twu2vOQC5jyAEUyFiMyYIGpeNoIYpKvb_z
 6WsYrc94e_g6A2qmQYStBGwYLaTFA2MNzCG47pSG2fEXFdUsijgs40WksL9t
 9p9LdrVz7iGajuPtODefekkYU4.KaFLwwYP3p1esbP1QUBSH4R7ndAfB5CAA
 2sXaPlZUCNywnJAgpKpUUqJ7DAJAkzjEqWsGIwgsTjlmZn2aOdYmz2_Zlc48
 PqG8ic6HWzV4kQcqy4nwJiSp0RRvO8WeeLuvD0TAvm0.LuzsR0loPTXR3Pg6
 CvCsS3uxhaerEHSgraaVT6BGbIXPtyPiUKmt0m.DMvkGo7u0A7Ccp2sSVGRE
 YN2rqg26bs6C57dCV4WaE9f1sw6x95A_lHQyPz6icsotD6nx4iMRCX8Tymqv
 ICxkFC0mfZFhkGN9MymD5.dawB16Ir.cHMGcpaT2IJCf9m1G5lnQQeyYX8jT
 vtuS1xgvAQHpTANVb2AJYYUi9w25wRXiLivF1DD.lrcUw5dm.RS.9PF_EHch
 BwtzHdsIUb6g.SdZzG_91JPb2W0o0_lpylM8zFAQKaVeU4vjpprPhIzRhCXE
 zCEc-
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@216.100.252.242 with )
        by smtp117.sbc.mail.gq1.yahoo.com with SMTP; 22 Oct 2013 18:19:13 +0000 UTC
From: Alexey Neyman <stilor@att.net>
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Avoid needless loop in sdhci_irq() for Card Interrupt
Date: Tue, 22 Oct 2013 11:19:12 -0700
Message-ID: <3529161.O27qBHpvvG@mistral>
User-Agent: KMail/4.11.2 (Linux/3.11.0-12-generic; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart1519988.raWdKt6FTN"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1519988.raWdKt6FTN
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

[Patch ping #2]

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
--nextPart1519988.raWdKt6FTN
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

--nextPart1519988.raWdKt6FTN--

