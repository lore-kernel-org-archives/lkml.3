Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbaGCKS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:18:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51512 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124AbaGCJVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 025/198] ASoC: max98090: Fix reset at resume time
Date: Thu,  3 Jul 2014 10:17:48 +0100
Message-Id: <1404379241-8590-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/max98090.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 29c368925d59..4df62ce4f96c 100644
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
@@ -2358,6 +2359,8 @@ static int max98090_runtime_resume(struct device *dev)
 
 	regcache_cache_only(max98090->regmap, false);
 
+	max98090_reset(max98090);
+
 	regcache_sync(max98090->regmap);
 
 	return 0;
-- 
1.9.1

