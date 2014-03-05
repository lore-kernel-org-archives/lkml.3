Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbaCEPBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:01:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41216 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbaCEO0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:50 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 102/131] Input - arizona-haptics: Fix double lock of dapm_mutex
Date: Wed,  5 Mar 2014 14:23:46 +0000
Message-Id: <1394029455-23128-103-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit c4204960e9d0ba99459dbf1db918f99a45e7a62a upstream.

snd_soc_dapm_sync takes the dapm_mutex internally, but we currently take
it externally as well. This patch fixes this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/misc/arizona-haptics.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/input/misc/arizona-haptics.c b/drivers/input/misc/arizona-haptics.c
index 7a04f54..e7e12a5 100644
--- a/drivers/input/misc/arizona-haptics.c
+++ b/drivers/input/misc/arizona-haptics.c
@@ -77,16 +77,14 @@ static void arizona_haptics_work(struct work_struct *work)
 			return;
 		}
 
+		mutex_unlock(dapm_mutex);
+
 		ret = snd_soc_dapm_sync(arizona->dapm);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to sync DAPM: %d\n",
 				ret);
-			mutex_unlock(dapm_mutex);
 			return;
 		}
-
-		mutex_unlock(dapm_mutex);
-
 	} else {
 		/* This disable sequence will be a noop if already enabled */
 		mutex_lock_nested(dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
@@ -99,16 +97,15 @@ static void arizona_haptics_work(struct work_struct *work)
 			return;
 		}
 
+		mutex_unlock(dapm_mutex);
+
 		ret = snd_soc_dapm_sync(arizona->dapm);
 		if (ret != 0) {
 			dev_err(arizona->dev, "Failed to sync DAPM: %d\n",
 				ret);
-			mutex_unlock(dapm_mutex);
 			return;
 		}
 
-		mutex_unlock(dapm_mutex);
-
 		ret = regmap_update_bits(arizona->regmap,
 					 ARIZONA_HAPTICS_CONTROL_1,
 					 ARIZONA_HAP_CTRL_MASK,
-- 
1.9.0

