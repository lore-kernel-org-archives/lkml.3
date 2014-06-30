Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbaF3MMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51995 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/181] ASoC: max98090: Fix reset at resume time
Date: Mon, 30 Jun 2014 13:51:28 +0200
Message-Id: <f533949021d85f3bba663901a66dc95720a500f7.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liam Girdwood <liam.r.girdwood@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 25b4ab430f8e166c9b63f4db28e7e812d5a59396 upstream.

Reset needs to wait 20ms before other codec IO is performed. This wait
was not being performed. Fix this by making sure the reset register is not
restored with the cache, but use the manual reset method in resume with
the wait.

Signed-off-by: Liam Girdwood <liam.r.girdwood@linux.intel.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/soc/codecs/max98090.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index 8bddf3f20a5e..9ad8f019adcd 100644
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
2.0.0

