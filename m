Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761980Ab3JPR5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:57:23 -0400
Received: from nm23-vm10.access.bullet.mail.bf1.yahoo.com ([216.109.115.169]:29426
	"EHLO nm23-vm10.access.bullet.mail.bf1.yahoo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761668Ab3JPR5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:57:20 -0400
X-Yahoo-Newman-Id: 143774.77258.bm@smtp118.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IGKJ70QVM1kM.UD6bBzdKTJFhQOZPQM26tSrHoGFBRndhWV
 aMOyNBwqW98h6fsJManwrIE1g4hvxJGD9CJAaZfIXWe11j7RAelECWb1d24x
 6k3m_PDtESPXoQ8nrE6MU4kOCvrPhr4zYhGlBDxd5hq2ojumL5GYlBdzct8O
 4is9MJQ.MBZfaN1dO1iK0.ebRkdpfcN56IRCmBdJjqgiK..oTPNjlYpvRzKi
 ZzfP6CMjMvJxnChnR2tzYmUzhp1gRLOZ07CneLIAbemdWAXjgzelgqknq7f5
 qvwnNEFoUyrxcxZ1YInfoH8MIwKdBloWTLP4k1kAn9WBDZxaz5qIYeJwvHDB
 Qm9wfCJ2t5Gj1ObJcD2yqLa4PqfVYjMEp6.FRUfMFllLlVOQ6B7mMYfoTzJC
 02A5QY.HMzU9FVssl8gHbZSNYJ8er5FumjJ3z1KC0LHD9ppNgxHBqj6l_vDp
 Oli58cL1Inhp7l38uR9QUqJQL9Qu3k4PfAMvU6IYBz7_y4rB5jKPq4BN5v2T
 tfDU0W8IioJVLV0.2T6Rn5q3.kx4kdzvCAlRffVnDX_dyyWphiOCEk8fCzg-
 -
X-Yahoo-SMTP: 0h0Q7euswBD_g.kcEqbzJWRFfrba801gq1M1
X-Rocket-Received: from mistral.localnet (stilor@216.100.252.242 with )
        by smtp118.sbc.mail.ne1.yahoo.com with SMTP; 16 Oct 2013 17:51:13 +0000 UTC
From: Alexey Neyman <stilor@att.net>
To: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Avoid needless loop in sdhci_irq() for Card Interrupt
Date: Wed, 16 Oct 2013 10:51:12 -0700
Message-ID: <2185940.FhsbmfkKLR@mistral>
User-Agent: KMail/4.10.4 (Linux/3.8.0-25-generic; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart2065377.P7sOhBizeh"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--nextPart2065377.P7sOhBizeh
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

[Patch ping]

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
--nextPart2065377.P7sOhBizeh
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

--nextPart2065377.P7sOhBizeh--

