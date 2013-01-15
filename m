Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006Ab3AOEg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 23:36:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33108 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab3AOEf4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 23:35:56 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/4] regulator-core: free requested GPIOs and manage the
 enable list
Thread-Topic: [PATCH v2 3/4] regulator-core: free requested GPIOs and manage
 the enable list
Thread-Index: Ac3y2cunsGm1Eie5TbmHVOsn2pOGDw==
Date: Tue, 15 Jan 2013 04:35:50 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E12B3D@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The regulator_ena_gpio_request() allocates the enable GPIO and add the list.
 Related resources should be released if they are not used any more.
 To free requested GPIO and remove it from the enable GPIO list,
 new function, 'regulator_ena_gpio_free()' is added.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/regulator/core.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dc713c4..8631234 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1501,6 +1501,19 @@ static int regulator_ena_gpio_request(struct regulator_dev *rdev,
 	return 0;
 }
 
+static void regulator_ena_gpio_free(struct regulator_dev *rdev)
+{
+	struct regulator_enable_gpio *pin, *n;
+
+	list_for_each_entry_safe(pin, n, &regulator_ena_gpio_list, list) {
+		if (pin->regulator == rdev && pin->gpio) {
+			gpio_free(pin->gpio);
+			list_del(&pin->list);
+			kfree(pin);
+		}
+	}
+}
+
 /**
  * Balance enable_count of each GPIO and actual GPIO pin control.
  * GPIO is enabled in case of initial use. (enable_count is 0)
@@ -3590,8 +3603,7 @@ unset_supplies:
 scrub:
 	if (rdev->supply)
 		_regulator_put(rdev->supply);
-	if (rdev->ena_gpio)
-		gpio_free(rdev->ena_gpio);
+	regulator_ena_gpio_free(rdev);
 	kfree(rdev->constraints);
 wash:
 	device_unregister(&rdev->dev);
@@ -3626,8 +3638,7 @@ void regulator_unregister(struct regulator_dev *rdev)
 	unset_regulator_supplies(rdev);
 	list_del(&rdev->list);
 	kfree(rdev->constraints);
-	if (rdev->ena_gpio)
-		gpio_free(rdev->ena_gpio);
+	regulator_ena_gpio_free(rdev);
 	device_unregister(&rdev->dev);
 	mutex_unlock(&regulator_list_mutex);
 }
-- 
1.7.9.5


Best Regards,
Milo


