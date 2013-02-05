Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3BEKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:09:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39196 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab3BEKJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:09:25 -0500
Date: Tue, 5 Feb 2013 10:09:23 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: broonie@opensource.wolfsonmicro.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] extcon: arizona: Clear _trig_sts bits after jack
	detection
Message-ID: <20130205100923.GA21695@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is important to clear the wake trigger status bits otherwise DCVDD
will be held high independent of the state of the LDOENA line.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c       |    7 +++++++
 include/linux/mfd/arizona/registers.h |    8 ++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 5f91711..5d07a71 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -861,6 +861,13 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 				   ARIZONA_MICD_CLAMP_DB | ARIZONA_JD1_DB);
 	}
 
+	/* Clear trig_sts to make sure DCVDD is not forced up */
+	regmap_write(arizona->regmap, ARIZONA_AOD_WKUP_AND_TRIG,
+		     ARIZONA_MICD_CLAMP_FALL_TRIG_STS |
+		     ARIZONA_MICD_CLAMP_RISE_TRIG_STS |
+		     ARIZONA_JD1_FALL_TRIG_STS |
+		     ARIZONA_JD1_RISE_TRIG_STS);
+
 	mutex_unlock(&info->lock);
 
 	pm_runtime_mark_last_busy(info->dev);
diff --git a/include/linux/mfd/arizona/registers.h b/include/linux/mfd/arizona/registers.h
index 79e9dd4..188d89a 100644
--- a/include/linux/mfd/arizona/registers.h
+++ b/include/linux/mfd/arizona/registers.h
@@ -5267,6 +5267,14 @@
 /*
  * R3408 (0xD50) - AOD wkup and trig
  */
+#define ARIZONA_MICD_CLAMP_FALL_TRIG_STS         0x0080  /* MICD_CLAMP_FALL_TRIG_STS */
+#define ARIZONA_MICD_CLAMP_FALL_TRIG_STS_MASK    0x0080  /* MICD_CLAMP_FALL_TRIG_STS */
+#define ARIZONA_MICD_CLAMP_FALL_TRIG_STS_SHIFT        7  /* MICD_CLAMP_FALL_TRIG_STS */
+#define ARIZONA_MICD_CLAMP_FALL_TRIG_STS_WIDTH        1  /* MICD_CLAMP_FALL_TRIG_STS */
+#define ARIZONA_MICD_CLAMP_RISE_TRIG_STS         0x0040  /* MICD_CLAMP_RISE_TRIG_STS */
+#define ARIZONA_MICD_CLAMP_RISE_TRIG_STS_MASK    0x0040  /* MICD_CLAMP_RISE_TRIG_STS */
+#define ARIZONA_MICD_CLAMP_RISE_TRIG_STS_SHIFT        6  /* MICD_CLAMP_RISE_TRIG_STS */
+#define ARIZONA_MICD_CLAMP_RISE_TRIG_STS_WIDTH        1  /* MICD_CLAMP_RISE_TRIG_STS */
 #define ARIZONA_GP5_FALL_TRIG_STS                0x0020  /* GP5_FALL_TRIG_STS */
 #define ARIZONA_GP5_FALL_TRIG_STS_MASK           0x0020  /* GP5_FALL_TRIG_STS */
 #define ARIZONA_GP5_FALL_TRIG_STS_SHIFT               5  /* GP5_FALL_TRIG_STS */
-- 
1.7.2.5

