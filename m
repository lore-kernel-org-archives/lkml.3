Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaFSNFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:05:44 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:63066 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbaFSNF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:05:27 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Arend van Spriel <arend@broadcom.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, Chris Ball <chris@printf.net>,
        Chen-Yu Tsai <wens@csie.org>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [RFC 2/2] mmc: core: Add support for power sequences
Date: Thu, 19 Jun 2014 15:04:51 +0200
Message-Id: <1403183091-27876-3-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org>
References: <1403183091-27876-1-git-send-email-ulf.hansson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MMC subsystem uses a discoverable bus which sometimes means the
power sequences to enable power to the card, is far too complex to be
handled through the regular ->set_ios() callback.

To adress these scenarios, we try to fetch a pwrseq method while
parsing the common MMC DT bindings. If a such method is found we select
the corresponding state for it from mmc_power_up|off().

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 drivers/mmc/core/core.c  |    7 +++++++
 drivers/mmc/core/host.c  |    5 +++++
 include/linux/mmc/host.h |    3 +++
 3 files changed, 15 insertions(+)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7dc0c85..46558b5 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -29,6 +29,7 @@
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/of.h>
+#include <linux/pwrseq.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -1533,6 +1534,9 @@ void mmc_power_up(struct mmc_host *host, u32 ocr)
 
 	mmc_host_clk_hold(host);
 
+	if (!IS_ERR(host->pwrseq))
+		pwrseq_select_state(host->pwrseq, PWRSEQ_POWER_ON);
+
 	host->ios.vdd = fls(ocr) - 1;
 	if (mmc_host_is_spi(host))
 		host->ios.chip_select = MMC_CS_HIGH;
@@ -1591,6 +1595,9 @@ void mmc_power_off(struct mmc_host *host)
 	host->ios.timing = MMC_TIMING_LEGACY;
 	mmc_set_ios(host);
 
+	if (!IS_ERR(host->pwrseq))
+		pwrseq_select_state(host->pwrseq, PWRSEQ_POWER_OFF);
+
 	/*
 	 * Some configurations, such as the 802.11 SDIO card in the OLPC
 	 * XO-1.5, require a short delay after poweroff before the card
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 95cceae..fdf8596 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -22,6 +22,7 @@
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <linux/suspend.h>
+#include <linux/pwrseq.h>
 
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -317,6 +318,10 @@ int mmc_of_parse(struct mmc_host *host)
 	if (!host->parent || !host->parent->of_node)
 		return 0;
 
+	host->pwrseq = devm_pwrseq_get_optional(host->parent);
+	if (IS_ERR(host->pwrseq))
+		return PTR_ERR(host->pwrseq);
+
 	np = host->parent->of_node;
 
 	/* "bus-width" is translated to MMC_CAP_*_BIT_DATA flags */
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index 7960424..306b78c 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -195,9 +195,12 @@ struct mmc_supply {
 	struct regulator *vqmmc;	/* Optional Vccq supply */
 };
 
+struct pwrseq;
+
 struct mmc_host {
 	struct device		*parent;
 	struct device		class_dev;
+	struct pwrseq		*pwrseq;
 	int			index;
 	const struct mmc_host_ops *ops;
 	unsigned int		f_min;
-- 
1.7.9.5

