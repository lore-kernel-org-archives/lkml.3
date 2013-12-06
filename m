Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3LFAWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:22:39 -0500
Received: from ring0.de ([91.143.88.219]:39857 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756328Ab3LFAWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:22:34 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ucw.cz]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Luciano Coelho <luca@coelho.fi>,
        Tony Lindgren <tony@atomide.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 3/5] wl1251: spi: add vio regulator support
Date: Fri,  6 Dec 2013 01:22:14 +0100
Message-Id: <1386289336-26704-4-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386289336-26704-1-git-send-email-sre@debian.org>
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for requesting the regulator powering
the vio pin.

Signed-off-by: Sebastian Reichel <sre@debian.org>
Reviewed-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/net/wireless/ti/wl1251/spi.c    | 19 +++++++++++++++++--
 drivers/net/wireless/ti/wl1251/wl1251.h |  2 ++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index 6abcbc3..0a8aacc 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -27,6 +27,7 @@
 #include <linux/spi/spi.h>
 #include <linux/wl12xx.h>
 #include <linux/gpio.h>
+#include <linux/regulator/consumer.h>
 
 #include "wl1251.h"
 #include "reg.h"
@@ -306,13 +307,26 @@ static int wl1251_spi_probe(struct spi_device *spi)
 
 	irq_set_irq_type(wl->irq, IRQ_TYPE_EDGE_RISING);
 
-	ret = wl1251_init_ieee80211(wl);
+	wl->vio = devm_regulator_get(&spi->dev, "vio");
+	if (IS_ERR(wl->vio)) {
+		ret = PTR_ERR(wl->vio);
+		wl1251_error("vio regulator missing: %d", ret);
+		goto out_free;
+	}
+
+	ret = regulator_enable(wl->vio);
 	if (ret)
 		goto out_free;
 
+	ret = wl1251_init_ieee80211(wl);
+	if (ret)
+		goto disable_regulator;
+
 	return 0;
 
- out_free:
+disable_regulator:
+	regulator_disable(wl->vio);
+out_free:
 	ieee80211_free_hw(hw);
 
 	return ret;
@@ -324,6 +338,7 @@ static int wl1251_spi_remove(struct spi_device *spi)
 
 	free_irq(wl->irq, wl);
 	wl1251_free_hw(wl);
+	regulator_disable(wl->vio);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ti/wl1251/wl1251.h b/drivers/net/wireless/ti/wl1251/wl1251.h
index f396a95..b0bfdf5 100644
--- a/drivers/net/wireless/ti/wl1251/wl1251.h
+++ b/drivers/net/wireless/ti/wl1251/wl1251.h
@@ -279,6 +279,8 @@ struct wl1251 {
 	int irq;
 	bool use_eeprom;
 
+	struct regulator *vio;
+
 	spinlock_t wl_lock;
 
 	enum wl1251_state state;
-- 
1.8.4.3

