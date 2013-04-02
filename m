Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775Ab3DBLes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:34:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46568 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760053Ab3DBLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 10/16] extcon: arizona: Retry HPDET identification for high impedance
Date: Tue,  2 Apr 2013 12:32:42 +0100
Message-Id: <1364902368-1123-10-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we can trigger measurements early if contacts are shorted during
a slow insertion. As well as debouncing add further robustness by retrying
if we get a high impedance measurement for headphones as this can indicate
that the headphones were not yet connected.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 5344f43..c18cf14 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -39,6 +39,8 @@
 #define ARIZONA_ACCDET_MODE_HPL 1
 #define ARIZONA_ACCDET_MODE_HPR 2
 
+#define ARIZONA_HPDET_MAX 10000
+
 #define HPDET_DEBOUNCE 500
 
 struct arizona_extcon_info {
@@ -64,6 +66,7 @@ struct arizona_extcon_info {
 
 	bool hpdet_active;
 	bool hpdet_done;
+	bool hpdet_retried;
 
 	int num_hpdet_res;
 	unsigned int hpdet_res[3];
@@ -112,6 +115,8 @@ static const char *arizona_cable[] = {
 	NULL,
 };
 
+static void arizona_start_hpdet_acc_id(struct arizona_extcon_info *info);
+
 static void arizona_extcon_do_magic(struct arizona_extcon_info *info,
 				    unsigned int magic)
 {
@@ -393,7 +398,7 @@ static int arizona_hpdet_read(struct arizona_extcon_info *info)
 		/* If we go out of range report top of range */
 		if (val < 100 || val > 0x3fb) {
 			dev_dbg(arizona->dev, "Measurement out of range\n");
-			return 10000;
+			return ARIZONA_HPDET_MAX;
 		}
 
 		dev_dbg(arizona->dev, "HPDET read %d in range %d\n",
@@ -518,6 +523,16 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading)
 		/* Take the headphone impedance for the main report */
 		*reading = info->hpdet_res[0];
 
+		/* Sometimes we get false readings due to slow insert */
+		if (*reading >= ARIZONA_HPDET_MAX && !info->hpdet_retried) {
+			dev_dbg(arizona->dev, "Retrying high impedance\n");
+			info->num_hpdet_res = 0;
+			info->hpdet_retried = true;
+			arizona_start_hpdet_acc_id(info);
+			pm_runtime_put(info->dev);
+			return -EAGAIN;
+		}
+
 		/*
 		 * Either the two grounds measure differently or we
 		 * measure the mic as high impedance.
@@ -953,6 +968,7 @@ static irqreturn_t arizona_jackdet(int irq, void *data)
 			info->hpdet_res[i] = 0;
 		info->mic = false;
 		info->hpdet_done = false;
+		info->hpdet_retried = false;
 
 		for (i = 0; i < info->num_micd_ranges; i++)
 			input_report_key(info->input,
-- 
1.7.10.4

