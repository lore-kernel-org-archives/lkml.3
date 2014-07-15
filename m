Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933877AbaGOVhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:37:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbaGOVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:25 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 033/198] ASoC: max98090: Fix reset at resume time
Date: Tue, 15 Jul 2014 14:28:23 -0700
Message-Id: <1405459868-15089-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam Girdwood <liam.r.girdwood@linux.intel.com>

commit 25b4ab430f8e166c9b63f4db28e7e812d5a59396 upstream.

Reset needs to wait 20ms before other codec IO is performed. This wait
was not being performed. Fix this by making sure the reset register is not
restored with the cache, but use the manual reset method in resume with
the wait.

Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/max98090.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 8bddf3f..9ad8f01 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -255,6 +255,7 @@ static struct reg_default max98090_reg[] = {
 static bool max98090_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case M98090_REG_SOFTWARE_RESET:
 	case M98090_REG_DEVICE_STATUS:
 	case M98090_REG_JACK_STATUS:
 	case M98090_REG_REVISION_ID:
@@ -2360,6 +2361,8 @@ static int max98090_runtime_resume(struct device *dev)
 
 	regcache_cache_only(max98090->regmap, false);
 
+	max98090_reset(max98090);
+
 	regcache_sync(max98090->regmap);
 
 	return 0;
-- 
1.9.1

