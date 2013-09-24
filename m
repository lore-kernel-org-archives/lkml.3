Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3IXTUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:20:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36830 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab3IXTUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:20:41 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, kernel@pengutronix.de
Subject: [PATCH] [RFC] devm: drop devm_clk_put
Date: Tue, 24 Sep 2013 21:20:21 +0200
Message-Id: <1380050421-19762-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1379951159-8294-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1379951159-8294-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_clk_put isn't really necessary as a driver usually keeps the
reference during its lifetime and there are no in-tree users. So
drop it.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
The "no in-tree users" part of the commit log isn't true yet, as there
is no agreed-on patch for sound/soc/kirkwood/kirkwood-i2s.c yet and the
other patches in this thread are not applied/acked yet.
---
 Documentation/driver-model/devres.txt |  1 -
 drivers/clk/clk-devres.c              | 10 ----------
 include/linux/clk.h                   | 19 +++----------------
 3 files changed, 3 insertions(+), 27 deletions(-)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index 5bdc8cb..9d04836 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -287,7 +287,6 @@ REGULATOR
 
 CLOCK
   devm_clk_get()
-  devm_clk_put()
 
 PINCTRL
   devm_pinctrl_get()
diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index 8f57154..0943d8f 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -43,13 +43,3 @@ static int devm_clk_match(struct device *dev, void *res, void *data)
 	}
 	return *c == data;
 }
-
-void devm_clk_put(struct device *dev, struct clk *clk)
-{
-	int ret;
-
-	ret = devres_release(dev, devm_clk_release, devm_clk_match, clk);
-
-	WARN_ON(ret);
-}
-EXPORT_SYMBOL(devm_clk_put);
diff --git a/include/linux/clk.h b/include/linux/clk.h
index 9a6d045..5115bc6 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -154,7 +154,9 @@ struct clk *clk_get(struct device *dev, const char *id);
  * devm_clk_get should not be called from within interrupt context.
  *
  * The clock will automatically be freed when the device is unbound
- * from the bus.
+ * from the bus. Note there is deliberately no devm_clk_put function as a
+ * driver usally keeps the reference to its clocks during the complete driver
+ * live time.
  */
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
@@ -205,19 +207,6 @@ unsigned long clk_get_rate(struct clk *clk);
  */
 void clk_put(struct clk *clk);
 
-/**
- * devm_clk_put	- "free" a managed clock source
- * @dev: device used to acuqire the clock
- * @clk: clock source acquired with devm_clk_get()
- *
- * Note: drivers must ensure that all clk_enable calls made on this
- * clock source are balanced by clk_disable calls prior to calling
- * this function.
- *
- * clk_put should not be called from within interrupt context.
- */
-void devm_clk_put(struct device *dev, struct clk *clk);
-
 /*
  * The remaining APIs are optional for machine class support.
  */
@@ -290,8 +279,6 @@ static inline struct clk *devm_clk_get(struct device *dev, const char *id)
 
 static inline void clk_put(struct clk *clk) {}
 
-static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
-
 static inline int clk_enable(struct clk *clk)
 {
 	return 0;
-- 
1.8.4.rc3

