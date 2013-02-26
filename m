Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab3B0Az5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:55:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42098 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146Ab3BZX6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ryo Tsutsui <ryo.tsutsui@wolfsonmicro.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 100/150] ASoC: arizona: Fixed a bug in FLL fractional calculation
Date: Tue, 26 Feb 2013 15:55:57 -0800
Message-Id: <20130226235534.430497486@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryo Tsutsui <ryo.tsutsui@wolfsonmicro.com>

commit 01f58153aefc158fd690b337d29ad140e963959d upstream.

Previously arizona_calc_fll() was checking if the target frequency is
exactly divisible by reference frequency, but should have been product
of the ratio and the reference frequency.

Also scale down the Lamba and Theta coefficients be under 16-bits in
order to match the registers.

Signed-off-by: Ryo Tsutsui <ryo.tsutsui@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/arizona.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/arizona.c
+++ b/sound/soc/codecs/arizona.c
@@ -910,7 +910,7 @@ static int arizona_calc_fll(struct arizo
 
 	cfg->n = target / (ratio * Fref);
 
-	if (target % Fref) {
+	if (target % (ratio * Fref)) {
 		gcd_fll = gcd(target, ratio * Fref);
 		arizona_fll_dbg(fll, "GCD=%u\n", gcd_fll);
 
@@ -922,6 +922,15 @@ static int arizona_calc_fll(struct arizo
 		cfg->lambda = 0;
 	}
 
+	/* Round down to 16bit range with cost of accuracy lost.
+	 * Denominator must be bigger than numerator so we only
+	 * take care of it.
+	 */
+	while (cfg->lambda >= (1 << 16)) {
+		cfg->theta >>= 1;
+		cfg->lambda >>= 1;
+	}
+
 	arizona_fll_dbg(fll, "N=%x THETA=%x LAMBDA=%x\n",
 			cfg->n, cfg->theta, cfg->lambda);
 	arizona_fll_dbg(fll, "FRATIO=%x(%d) OUTDIV=%x REFCLK_DIV=%x\n",


