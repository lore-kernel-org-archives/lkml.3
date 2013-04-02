Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268Ab3DBLdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46542 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760053Ab3DBLc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:32:59 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 02/16] extcon: arizona: Attempt more microphone measurements
Date: Tue,  2 Apr 2013 12:32:34 +0100
Message-Id: <1364902368-1123-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some pathological use cases users may insert an accessory very slowly
causing multiple indeterminate measurements. Handle this by retrying many
measurements before we give up and declare a headphone.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index b289279..4bb0e9a 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -153,6 +153,8 @@ static void arizona_extcon_set_mode(struct arizona_extcon_info *info, int mode)
 {
 	struct arizona *arizona = info->arizona;
 
+	mode %= info->num_micd_modes;
+
 	if (arizona->pdata.micd_pol_gpio > 0)
 		gpio_set_value_cansleep(arizona->pdata.micd_pol_gpio,
 					info->micd_modes[mode].gpio);
@@ -783,7 +785,7 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 	 * impedence then give up and report headphones.
 	 */
 	if (info->detecting && (val & 0x3f8)) {
-		if (info->jack_flips >= info->micd_num_modes) {
+		if (info->jack_flips >= info->micd_num_modes * 10) {
 			dev_dbg(arizona->dev, "Detected HP/line\n");
 			arizona_identify_headphone(info);
 
-- 
1.7.10.4

