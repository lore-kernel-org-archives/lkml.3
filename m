Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaJWIPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:15:30 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5556 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaJWIP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:15:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 23 Oct 2014 01:11:25 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] ASoC: jack: update calls to gpiod_get*()
Date: Thu, 23 Oct 2014 17:15:18 +0900
Message-ID: <1414052118-19742-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new flags argument to calls of (devm_)gpiod_get*() and
remove any direction setting code afterwards.

Currently both forms (with or without the flags argument)
are valid thanks to transitional macros in
<linux/gpio/consumer.h>. These macros will be removed once
all consumers are updated and the flags argument will become
compulsary.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 sound/soc/soc-jack.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-jack.c b/sound/soc/soc-jack.c
index ab47fea997a3..f921d0098518 100644
--- a/sound/soc/soc-jack.c
+++ b/sound/soc/soc-jack.c
@@ -309,7 +309,7 @@ int snd_soc_jack_add_gpios(struct snd_soc_jack *jack, int count,
 			/* GPIO descriptor */
 			gpios[i].desc = gpiod_get_index(gpios[i].gpiod_dev,
 							gpios[i].name,
-							gpios[i].idx);
+							gpios[i].idx, GPIOD_IN);
 			if (IS_ERR(gpios[i].desc)) {
 				ret = PTR_ERR(gpios[i].desc);
 				dev_err(gpios[i].gpiod_dev,
@@ -327,17 +327,14 @@ int snd_soc_jack_add_gpios(struct snd_soc_jack *jack, int count,
 				goto undo;
 			}
 
-			ret = gpio_request(gpios[i].gpio, gpios[i].name);
+			ret = gpio_request_one(gpios[i].gpio, GPIOF_IN,
+					       gpios[i].name);
 			if (ret)
 				goto undo;
 
 			gpios[i].desc = gpio_to_desc(gpios[i].gpio);
 		}
 
-		ret = gpiod_direction_input(gpios[i].desc);
-		if (ret)
-			goto err;
-
 		INIT_DELAYED_WORK(&gpios[i].work, gpio_work);
 		gpios[i].jack = jack;
 
-- 
2.1.2

