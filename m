Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3BCOzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34166 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541Ab3BCOzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:19 -0500
Message-Id: <20130203144646.350902952@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:10 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mike Dunn <mikedunn@newsguy.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 026/128] ALSA: pxa27x: fix ac97 cold reset
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Dunn <mikedunn@newsguy.com>

commit 41b645c8624df6ace020a8863ad1449d69140f7d upstream.

Cold reset on the pxa27x currently fails and

     pxa2xx_ac97_try_cold_reset: cold reset timeout (GSR=0x44)

appears in the kernel log.  Through trial-and-error (the pxa270 developer's
manual is mostly incoherent on the topic of ac97 reset), I got cold reset to
complete by setting the WARM_RST bit in the GCR register (and later noticed that
pxa3xx does this for cold reset as well).  Also, a timeout loop is needed to
wait for the reset to complete.

Tested on a palm treo 680 machine.

Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/arm/pxa2xx-ac97-lib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/arm/pxa2xx-ac97-lib.c b/sound/arm/pxa2xx-ac97-lib.c
index 6fc0ae9..1ecd0a66 100644
--- a/sound/arm/pxa2xx-ac97-lib.c
+++ b/sound/arm/pxa2xx-ac97-lib.c
@@ -148,6 +148,8 @@ static inline void pxa_ac97_warm_pxa27x(void)
 
 static inline void pxa_ac97_cold_pxa27x(void)
 {
+	unsigned int timeout;
+
 	GCR &=  GCR_COLD_RST;  /* clear everything but nCRST */
 	GCR &= ~GCR_COLD_RST;  /* then assert nCRST */
 
@@ -157,8 +159,10 @@ static inline void pxa_ac97_cold_pxa27x(void)
 	clk_enable(ac97conf_clk);
 	udelay(5);
 	clk_disable(ac97conf_clk);
-	GCR = GCR_COLD_RST;
-	udelay(50);
+	GCR = GCR_COLD_RST | GCR_WARM_RST;
+	timeout = 100;     /* wait for the codec-ready bit to be set */
+	while (!((GSR | gsr_bits) & (GSR_PCR | GSR_SCR)) && timeout--)
+		mdelay(1);
 }
 #endif
 


