Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab3HGLfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:35:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56107 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932814Ab3HGLe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:34:58 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 07:34:58 EDT
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: myungjoo.ham@samsung.com, cw00.choi@samsung.com
Cc: broonie@kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH v2] extcon: arizona: Clear trig_sts bits on all paths
Date: Wed,  7 Aug 2013 12:17:14 +0100
Message-Id: <1375874234-30549-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want the trig_sts bits to be cleared in all cases where we consider
the jack detection interrupt to have been handled. Specifically, if a
duplicate detection event was suppressed these bits were not cleared
causing the CODEC to not enter a low power state. This patch clears the
bits on the duplicate detection code path.

Reported-by: Ryo Tsutsui <ryo.tsutsui@wolfsonmicro.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 7a1b4a7..4df68de 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1034,6 +1034,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 	else
 		info->micd_timeout = DEFAULT_MICD_TIMEOUT;
 
+out:
 	/* Clear trig_sts to make sure DCVDD is not forced up */
 	regmap_write(arizona->regmap, ARIZONA_AOD_WKUP_AND_TRIG,
 		     ARIZONA_MICD_CLAMP_FALL_TRIG_STS |
@@ -1041,7 +1042,6 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 		     ARIZONA_JD1_FALL_TRIG_STS |
 		     ARIZONA_JD1_RISE_TRIG_STS);
 
-out:
 	mutex_unlock(&info->lock);
 
 	pm_runtime_mark_last_busy(info->dev);
-- 
1.7.2.5

