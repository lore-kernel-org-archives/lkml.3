Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3HYPyY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 11:54:24 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43476 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756510Ab3HYPyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 11:54:21 -0400
X-Originating-IP: 83.160.107.163
Date: Sun, 25 Aug 2013 17:54:13 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: Add devm_regulator_get_exclusive()
Message-ID: <20130825155413.GA21566@raspi>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a resource managed regulator_get_exclusive()

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
---
 drivers/regulator/core.c           |   30 ++++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |    2 ++
 2 files changed, 32 insertions(+)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 288c75a..0e8ff09 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1435,6 +1435,36 @@ static void _regulator_put(struct regulator *regulator)
 }
 
 /**
+ * devm_regulator_get_exclusive - Resource managed regulator_get_exclusive()
+ * @dev: device for regulator "consumer"
+ * @id: Supply name or regulator ID.
+ *
+ * Managed regulator_get_exclusive(). Regulators returned from this function
+ * are automatically regulator_put() on driver detach. See regulator_get() for
+ * more information.
+ */
+struct regulator *devm_regulator_get_exclusive(struct device *dev,
+					       const char *id)
+{
+	struct regulator **ptr, *regulator;
+
+	ptr = devres_alloc(devm_regulator_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return ERR_PTR(-ENOMEM);
+
+	regulator = _regulator_get(dev, id, 1);
+	if (!IS_ERR(regulator)) {
+		*ptr = regulator;
+		devres_add(dev, ptr);
+	} else {
+		devres_free(ptr);
+	}
+
+	return regulator;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get_exclusive);
+
+/**
  * regulator_put - "free" the regulator source
  * @regulator: regulator source
  *
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 3a76389..399d4a1 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -137,6 +137,8 @@ struct regulator *__must_check devm_regulator_get(struct device *dev,
 					     const char *id);
 struct regulator *__must_check regulator_get_exclusive(struct device *dev,
 						       const char *id);
+struct regulator *__must_check devm_regulator_get_exclusive(struct device *dev,
+							const char *id);
 void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
-- 
1.7.10.4

