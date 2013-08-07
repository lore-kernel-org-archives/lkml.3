Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3HGGSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:18:34 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17557 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab3HGGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:18:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 06 Aug 2013 23:18:30 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>
CC: <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Wei Ni <wni@nvidia.com>
Subject: [PATCH v4 2/3] hwmon: (lm90) add support to handle IRQ
Date: Wed, 7 Aug 2013 14:18:25 +0800
Message-ID: <1375856306-14415-3-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375856306-14415-1-git-send-email-wni@nvidia.com>
References: <1375856306-14415-1-git-send-email-wni@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the temperature exceed the limit range value,
the driver can handle the interrupt.

Signed-off-by: Wei Ni <wni@nvidia.com>
---
 drivers/hwmon/lm90.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 1da2eff..2e68773 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -89,6 +89,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/interrupt.h>
 
 /*
  * Addresses to scan
@@ -1433,6 +1434,16 @@ static bool lm90_is_tripped(struct i2c_client *client)
 	return true;
 }
 
+static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
+{
+	struct i2c_client *client = dev_id;
+
+	if (lm90_is_tripped(client))
+		return IRQ_HANDLED;
+	else
+		return IRQ_NONE;
+}
+
 static int lm90_probe(struct i2c_client *client,
 		      const struct i2c_device_id *id)
 {
@@ -1509,6 +1520,18 @@ static int lm90_probe(struct i2c_client *client,
 		goto exit_remove_files;
 	}
 
+	if (client->irq) {
+		dev_dbg(dev, "IRQ: %d\n", client->irq);
+		err = devm_request_threaded_irq(dev, client->irq,
+						NULL, lm90_irq_thread,
+						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+						"lm90", client);
+		if (err < 0) {
+			dev_err(dev, "cannot request IRQ: %d\n", client->irq);
+			goto exit_remove_files;
+		}
+	}
+
 	return 0;
 
 exit_remove_files:
-- 
1.7.9.5

