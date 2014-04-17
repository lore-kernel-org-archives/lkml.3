Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbaDQKK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:56 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:54615
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756553AbaDQKKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:50 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <daniel.lezcano@linaro.org>, <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] clocksource: fix clocksource_mmio_readX_down
Date: Thu, 17 Apr 2014 17:27:54 +0800
Message-ID: <1397726874-6349-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some clocksource devices, for example, the registers are 32-bit, while
the lower 16-bit is used for timer counting(And reading the upper 16-bit
will return 0).

For example, when the counter value is 0x00001111, and then the
~readl_relaxed(to_mmio_clksrc(c)->reg) will return the value of 0xFFFFEEEE,
but it should be 0x0000EEEE.

So just using the c->mask to mask the unused bits.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/clocksource/mmio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
index c0e2512..f17a0d1 100644
--- a/drivers/clocksource/mmio.c
+++ b/drivers/clocksource/mmio.c
@@ -27,7 +27,7 @@ cycle_t clocksource_mmio_readl_up(struct clocksource *c)
 
 cycle_t clocksource_mmio_readl_down(struct clocksource *c)
 {
-	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
+	return ~readl_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 cycle_t clocksource_mmio_readw_up(struct clocksource *c)
@@ -37,7 +37,7 @@ cycle_t clocksource_mmio_readw_up(struct clocksource *c)
 
 cycle_t clocksource_mmio_readw_down(struct clocksource *c)
 {
-	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
+	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg) & c->mask;
 }
 
 /**
-- 
1.8.4


