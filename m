Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab3AOWcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:32:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:42900 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758485Ab3AOWcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:32:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mike Dunn <mikedunn@newsguy.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 138/221] ALSA: pxa27x: fix ac97 cold reset
Date: Tue, 15 Jan 2013 10:51:05 -0800
Message-Id: <20130115185008.031648212@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/arm/pxa2xx-ac97-lib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/sound/arm/pxa2xx-ac97-lib.c
+++ b/sound/arm/pxa2xx-ac97-lib.c
@@ -148,6 +148,8 @@ static inline void pxa_ac97_warm_pxa27x(
 
 static inline void pxa_ac97_cold_pxa27x(void)
 {
+	unsigned int timeout;
+
 	GCR &=  GCR_COLD_RST;  /* clear everything but nCRST */
 	GCR &= ~GCR_COLD_RST;  /* then assert nCRST */
 
@@ -157,8 +159,10 @@ static inline void pxa_ac97_cold_pxa27x(
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
 


