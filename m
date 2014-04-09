Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbaDISGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:06:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34435 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933812AbaDISFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:05:52 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH 2/2] pwm: use PWM_LOOKUP to set the period and polarity
Date: Wed,  9 Apr 2014 20:04:09 +0200
Message-Id: <1397066649-3767-3-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397066649-3767-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397066649-3767-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the PWM core is able to set the period and polarity based on
the lookup table, add those to PWM_LOOKUP to ease their usage.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 Documentation/pwm.txt                          | 3 ++-
 arch/arm/mach-omap2/board-omap3beagle.c        | 3 ++-
 arch/arm/mach-pxa/hx4700.c                     | 3 ++-
 arch/arm/mach-shmobile/board-armadillo800eva.c | 3 ++-
 include/linux/pwm.h                            | 4 +++-
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
index 93cb97974986..f38f99cda64f 100644
--- a/Documentation/pwm.txt
+++ b/Documentation/pwm.txt
@@ -19,7 +19,8 @@ should instead register a static mapping that can be used to match PWM
 consumers to providers, as given in the following example:
 
 	static struct pwm_lookup board_pwm_lookup[] = {
-		PWM_LOOKUP("tegra-pwm", 0, "pwm-backlight", NULL),
+		PWM_LOOKUP("tegra-pwm", 0, "pwm-backlight", NULL,
+			   50000, PWM_POLARITY_NORMAL),
 	};
 
 	static void __init board_init(void)
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index d6ed819ff15c..54c135a5b4f7 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -61,7 +61,8 @@
 
 static struct pwm_lookup pwm_lookup[] = {
 	/* LEDB -> PMU_STAT */
-	PWM_LOOKUP("twl-pwmled", 1, "leds_pwm", "beagleboard::pmu_stat"),
+	PWM_LOOKUP("twl-pwmled", 1, "leds_pwm", "beagleboard::pmu_stat",
+		   7812500, PWM_POLARITY_NORMAL),
 };
 
 static struct led_pwm pwm_leds[] = {
diff --git a/arch/arm/mach-pxa/hx4700.c b/arch/arm/mach-pxa/hx4700.c
index a7c30eb0c8db..c66ad4edc5e3 100644
--- a/arch/arm/mach-pxa/hx4700.c
+++ b/arch/arm/mach-pxa/hx4700.c
@@ -574,7 +574,8 @@ static struct platform_device backlight = {
 };
 
 static struct pwm_lookup hx4700_pwm_lookup[] = {
-	PWM_LOOKUP("pxa27x-pwm.1", 0, "pwm-backlight", NULL),
+	PWM_LOOKUP("pxa27x-pwm.1", 0, "pwm-backlight", NULL,
+		   30923, PWM_POLARITY_NORMAL),
 };
 
 /*
diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index 2858f380beae..e2c4c5010f19 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -416,7 +416,8 @@ static struct platform_device pwm_device = {
 };
 
 static struct pwm_lookup pwm_lookup[] = {
-	PWM_LOOKUP("renesas-tpu-pwm", 2, "pwm-backlight.0", NULL),
+	PWM_LOOKUP("renesas-tpu-pwm", 2, "pwm-backlight.0", NULL,
+		   33333, PWM_POLARITY_NORMAL),
 };
 
 /* LCDC and backlight */
diff --git a/include/linux/pwm.h b/include/linux/pwm.h
index 2f45e2fe5b93..e90628cac8fa 100644
--- a/include/linux/pwm.h
+++ b/include/linux/pwm.h
@@ -278,12 +278,14 @@ struct pwm_lookup {
 	enum pwm_polarity polarity;
 };
 
-#define PWM_LOOKUP(_provider, _index, _dev_id, _con_id)	\
+#define PWM_LOOKUP(_provider, _index, _dev_id, _con_id, _period, _polarity) \
 	{						\
 		.provider = _provider,			\
 		.index = _index,			\
 		.dev_id = _dev_id,			\
 		.con_id = _con_id,			\
+		.period = _period,			\
+		.polarity = _polarity			\
 	}
 
 #if IS_ENABLED(CONFIG_PWM)
-- 
1.8.3.2

