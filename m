Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaE0KR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 06:17:26 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:28345
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751684AbaE0KRX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 06:17:23 -0400
From: Liu Ying <Ying.Liu@freescale.com>
To: <linux-pwm@vger.kernel.org>
CC: <thierry.reding@gmail.com>, <s.hauer@pengutronix.de>,
        <shawn.guo@freescale.com>, <LW@KARO-electronics.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4] pwm: i.MX: Avoid sample FIFO overflow for i.MX PWM version2
Date: Tue, 27 May 2014 18:19:40 +0800
Message-ID: <1401185980-29536-2-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401185980-29536-1-git-send-email-Ying.Liu@freescale.com>
References: <1401185980-29536-1-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(86362001)(81342001)(92726001)(62966002)(88136002)(50466002)(93916002)(575784001)(74662001)(76482001)(74502001)(104016001)(31966008)(4396001)(50226001)(77156001)(64706001)(102836001)(87286001)(81542001)(87936001)(46102001)(80022001)(20776003)(47776003)(79102001)(76176999)(77096999)(50986999)(19580405001)(83322001)(19580395003)(44976005)(6806004)(26826002)(36756003)(77982001)(85852003)(83072002)(92566001)(89996001)(23676002)(99396002)(21056001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB346;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 02243C58C6
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i.MX PWM version2 is embedded in several i.MX SoCs,
such as i.MX27, i.MX51 and i.MX6SL.  There is a 4-word(16bit)
sample FIFO in this IP.  Each FIFO slot determines the duty
period of a PWM waveform in one full cycle.  The IP spec
mentions that we should not write a fourth sample because
the FIFO will become full and triggers a FIFO write error
(FWE) which will prevent the PWM from starting once it is
enabled.  In order to avoid any sample FIFO overflow issue,
this patch clears all sample FIFO by doing software reset
in the configuration hook when the controller is disabled
or waits for a full PWM cycle to get a relinquished FIFO
slot when the controller is enabled and the FIFO is fully
loaded.

The FIFO overflow issue can be reproduced by the following
commands on the i.MX6SL EVK platform, assuming we use PWM2
for the debug LED which is driven by the pin HSIC_STROBE
and the maximal brightness is 255.
echo 0   > /sys/class/leds/user/brightness
echo 0   > /sys/class/leds/user/brightness
echo 0   > /sys/class/leds/user/brightness
echo 0   > /sys/class/leds/user/brightness
echo 255 > /sys/class/leds/user/brightness
Here, FWE happens(PWMSR register reads 0x58) and the LED
can not be lighten.

Another way to reproduce the FIFO overflow issue is to run
this script:
while true;
	do echo 255 > /sys/class/leds/user/brightness;
done

Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Shawn Guo <shawn.guo@freescale.com>
Cc: Lothar Waßmann <LW@KARO-electronics.de>
Cc: linux-pwm@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v3->v4:
* To address Sascha's comment, drop the rollover event approach
  and wait for a full PWM cycle to get a relinquished FIFO slot
  when the controller is enabled and the FIFO is fully loaded.
* Update commit message accordlingly, includling a new way to
  reproduce the FIFO overflow issue.

v2->v3:
* Wait for a rollover event before configuration when PWM
  is active with non-zero duty period.  And, update commit
  message for that.
* Fix some typos in commit head and message(fifo -> FIFO,
  pwm -> PWM, etc).
* Cc linux-kernel@vger.kernel.org.

v1->v2:
* To address Lothar Waßmann's comment, add a timeout mechanism
  instead of endless polling the SWR bit to be cleared by the
  hardware.

 drivers/pwm/pwm-imx.c |   45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
index 0784554..13c24a0 100644
--- a/drivers/pwm/pwm-imx.c
+++ b/drivers/pwm/pwm-imx.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/pwm.h>
 #include <linux/of.h>
@@ -30,6 +31,7 @@
 /* i.MX27, i.MX31, i.MX35 share the same PWM function block: */
 
 #define MX3_PWMCR			0x00    /* PWM Control Register */
+#define MX3_PWMSR			0x04    /* PWM Status Register */
 #define MX3_PWMSAR			0x0C    /* PWM Sample Register */
 #define MX3_PWMPR			0x10    /* PWM Period Register */
 #define MX3_PWMCR_PRESCALER(x)		(((x - 1) & 0xFFF) << 4)
@@ -38,7 +40,12 @@
 #define MX3_PWMCR_DBGEN			(1 << 22)
 #define MX3_PWMCR_CLKSRC_IPG_HIGH	(2 << 16)
 #define MX3_PWMCR_CLKSRC_IPG		(1 << 16)
+#define MX3_PWMCR_SWR			(1 << 3)
 #define MX3_PWMCR_EN			(1 << 0)
+#define MX3_PWMSR_FIFOAV_4WORDS		0x4
+#define MX3_PWMSR_FIFOAV_MASK		0x7
+
+#define MX3_PWM_SWR_LOOP		5
 
 struct imx_chip {
 	struct clk	*clk_per;
@@ -103,9 +110,43 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 		struct pwm_device *pwm, int duty_ns, int period_ns)
 {
 	struct imx_chip *imx = to_imx_chip(chip);
+	struct device *dev = chip->dev;
 	unsigned long long c;
 	unsigned long period_cycles, duty_cycles, prescale;
-	u32 cr;
+	unsigned int period_ms;
+	bool enable = test_bit(PWMF_ENABLED, &pwm->flags);
+	int wait_count = 0, fifoav;
+	u32 cr, sr;
+
+	/*
+	 * i.MX PWMv2 has a 4-word sample FIFO.
+	 * In order to avoid FIFO overflow issue, we do software reset
+	 * to clear all sample FIFO if the controller is disabled or
+	 * wait for a full PWM cycle to get a relinquished FIFO slot
+	 * when the controller is enabled and the FIFO is fully loaded.
+	 */
+	if (enable) {
+		sr = readl(imx->mmio_base + MX3_PWMSR);
+		fifoav = sr & MX3_PWMSR_FIFOAV_MASK;
+		if (fifoav == MX3_PWMSR_FIFOAV_4WORDS) {
+			period_ms = DIV_ROUND_UP(pwm->period, NSEC_PER_MSEC);
+			msleep(period_ms);
+
+			sr = readl(imx->mmio_base + MX3_PWMSR);
+			if (fifoav == (sr & MX3_PWMSR_FIFOAV_MASK))
+				dev_warn(dev, "there is no free FIFO slot\n");
+		}
+	} else {
+		writel(MX3_PWMCR_SWR, imx->mmio_base + MX3_PWMCR);
+		do {
+			usleep_range(200, 1000);
+			cr = readl(imx->mmio_base + MX3_PWMCR);
+		} while ((cr & MX3_PWMCR_SWR) &&
+			 (wait_count++ < MX3_PWM_SWR_LOOP));
+
+		if (cr & MX3_PWMCR_SWR)
+			dev_warn(dev, "software reset timeout\n");
+	}
 
 	c = clk_get_rate(imx->clk_per);
 	c = c * period_ns;
@@ -135,7 +176,7 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
 		MX3_PWMCR_DOZEEN | MX3_PWMCR_WAITEN |
 		MX3_PWMCR_DBGEN | MX3_PWMCR_CLKSRC_IPG_HIGH;
 
-	if (test_bit(PWMF_ENABLED, &pwm->flags))
+	if (enable)
 		cr |= MX3_PWMCR_EN;
 
 	writel(cr, imx->mmio_base + MX3_PWMCR);
-- 
1.7.9.5

