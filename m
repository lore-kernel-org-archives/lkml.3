Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab3BKQ2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:28:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757966Ab3BKQ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:27:14 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 09/11] extcon: arizona: Clear _trig_sts bits after jack detection
Date: Mon, 11 Feb 2013 16:27:04 +0000
Message-Id: <1360600026-16878-9-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130211162614.GH4607@opensource.wolfsonmicro.com>
 <1360600026-16878-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

It is important to clear the wake trigger status bits otherwise DCVDD
will be held high independent of the state of the LDOENA line.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c       |    7 +++++++
 include/linux/mfd/arizona/registers.h |    8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index cfd206c..aeaf217 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -939,6 +939,13 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
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
1.7.10.4

