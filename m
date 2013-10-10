Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab3JJF0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:26:52 -0400
Received: from nm9-vm2.access.bullet.mail.gq1.yahoo.com ([216.39.63.37]:25789
	"EHLO nm9-vm2.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752327Ab3JJF0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:26:51 -0400
X-Yahoo-Newman-Id: 72386.71861.bm@smtp117.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6WyHa8QVM1kjKg1C8OV_SnqyofKyHKS8_7viCzT.igaLZ.0
 jy5cpcXa.Fxw.b4aZ2AFOijKb7LtoKnqQn8594yfmmkd8PaPXdDxzfDdURu7
 ZkZgFizUGnGDjdeLEbuAeMKaNxqQLJnXxlyebOJUOsDgbIFtP6vEbkkz8GMy
 Ng6T8ZyQcQ1XDU7lHsSjKEQ19uPK82eNWV7j09AY.Wzjt7BKu.gyZh9xj.9m
 nwwYQuG7NEWs_3b8wN3dVD47ffIL4P3o1yp65HuM3blsWVhM_ZoIYlG8IBWY
 i0AylbRn0wHw3A_ixMXPKmlWHckRyD4nx9JhNIEu5YsbibUF8JJz77UFzMyt
 vgYH_7mXN.9OwuJpqVlUiotNKCZ3.yHwNi1R7Le5_zYZ8BuxFFPHBlfGrcjF
 MXVgzDBO2dVadqUV_toBAESjPqKtTiXqYF8qDnUXKAWV3fAwCAEPYtpeR_KF
 rDoEu8nIslsoOyuuiCJdtxpwuPZ8oeGRJpVqf3wzVlg4h.JAlJ3HYl.6DfDR
 CHTJ0WfhxYxhr9bOt97OJRPIS4PthzJLa1yo1ZF0zkJug
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@107.200.11.181 with )
        by smtp117.sbc.mail.gq1.yahoo.com with SMTP; 10 Oct 2013 05:26:51 +0000 UTC
From: Alexey Neyman <stilor@att.net>
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Avoid needless loop in sdhci_irq() for Card Interrupt
Date: Wed, 09 Oct 2013 22:26:49 -0700
Message-ID: <2565587.cJgUu2WKHe@mistral>
User-Agent: KMail/4.10.4 (Linux/3.8.0-25-generic; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2134488.pGrcClfXyO"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2134488.pGrcClfXyO
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

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

--nextPart2134488.pGrcClfXyO
Content-Disposition: attachment; filename="sdhci.c.diff"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="sdhci.c.diff"

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

--nextPart2134488.pGrcClfXyO--

