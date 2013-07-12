Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3GLHuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:50:14 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14696 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3GLHuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:50:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 12 Jul 2013 00:48:29 -0700
From: Wei Ni <wni@nvidia.com>
To: <khali@linux-fr.org>, <linux@roeck-us.net>, <thierry.reding@gmail.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Wei Ni <wni@nvidia.com>
Subject: [PATCH v3 3/4] hwmon: (lm90) add support to handle IRQ
Date: Fri, 12 Jul 2013 15:48:06 +0800
Message-ID: <1373615287-18502-4-git-send-email-wni@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373615287-18502-1-git-send-email-wni@nvidia.com>
References: <1373615287-18502-1-git-send-email-wni@nvidia.com>
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
 drivers/hwmon/lm90.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index c90037f..1cc3d19 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -89,6 +89,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/interrupt.h>
 
 /*
  * Addresses to scan
@@ -1460,6 +1461,17 @@ static bool lm90_is_tripped(struct i2c_client *client)
 	return true;
 }
 
+static irqreturn_t lm90_irq_thread(int irq, void *dev_id)
+{
+	struct lm90_data *data = dev_id;
+	struct i2c_client *client = to_i2c_client(data->hwmon_dev->parent);
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
@@ -1536,6 +1548,18 @@ static int lm90_probe(struct i2c_client *client,
 		goto exit_remove_files;
 	}
 
+	if (client->irq >= 0) {
+		dev_dbg(dev, "lm90 IRQ: %d\n", client->irq);
+		err = devm_request_threaded_irq(dev, client->irq,
+						NULL, lm90_irq_thread,
+						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+						"lm90", data);
+		if (err < 0) {
+			dev_err(dev, "cannot request interrupt\n");
+			goto exit_remove_files;
+		}
+	}
+
 	return 0;
 
 exit_remove_files:
-- 
1.7.9.5

