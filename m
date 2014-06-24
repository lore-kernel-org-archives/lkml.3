Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaFXQT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:19:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbaFXPy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.14 50/68] ASoC: max98090: Fix reset at resume time
Date: Tue, 24 Jun 2014 11:51:09 -0400
Message-Id: <20140624154726.211101606@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/max98090.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -255,6 +255,7 @@ static struct reg_default max98090_reg[]
 static bool max98090_volatile_register(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
+	case M98090_REG_SOFTWARE_RESET:
 	case M98090_REG_DEVICE_STATUS:
 	case M98090_REG_JACK_STATUS:
 	case M98090_REG_REVISION_ID:
@@ -2360,6 +2361,8 @@ static int max98090_runtime_resume(struc
 
 	regcache_cache_only(max98090->regmap, false);
 
+	max98090_reset(max98090);
+
 	regcache_sync(max98090->regmap);
 
 	return 0;


