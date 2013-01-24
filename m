Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3AXDaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:30:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44270 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab3AXD3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Dunn <mikedunn@newsguy.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 34/74] ALSA: pxa27x: fix ac97 cold reset
Date: Thu, 24 Jan 2013 01:26:46 -0200
Message-Id: <1358998046-613-35-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/arm/pxa2xx-ac97-lib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/arm/pxa2xx-ac97-lib.c b/sound/arm/pxa2xx-ac97-lib.c
index 48d7c0a..8cfb2c0 100644
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
 
-- 
1.7.9.5

