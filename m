Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbaCDUqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:46:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbaCDUEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.13 154/172] Input - arizona-haptics: Fix double lock of dapm_mutex
Date: Tue,  4 Mar 2014 12:03:58 -0800
Message-Id: <20140304200304.643571248@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

commit c4204960e9d0ba99459dbf1db918f99a45e7a62a upstream.

snd_soc_dapm_sync takes the dapm_mutex internally, but we currently take
it externally as well. This patch fixes this.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/misc/arizona-haptics.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/input/misc/arizona-haptics.c
+++ b/drivers/input/misc/arizona-haptics.c
@@ -77,16 +77,14 @@ static void arizona_haptics_work(struct
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
@@ -99,16 +97,15 @@ static void arizona_haptics_work(struct
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


