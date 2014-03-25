Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaCYRfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:35:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbaCYRWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:22:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 54/81] Input - arizona-haptics: Fix double lock of dapm_mutex
Date: Tue, 25 Mar 2014 10:16:07 -0700
Message-Id: <1395767794-5012-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit c4204960e9d0ba99459dbf1db918f99a45e7a62a upstream.

snd_soc_dapm_sync takes the dapm_mutex internally, but we currently take
it externally as well. This patch fixes this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

