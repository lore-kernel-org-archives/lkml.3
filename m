Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3DBLdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:33:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46557 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760321Ab3DBLdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:33:03 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 14/16] extcon: arizona: Clear existing button reports before reporting new one
Date: Tue,  2 Apr 2013 12:32:46 +0100
Message-Id: <1364902368-1123-14-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130402113157.GJ23065@opensource.wolfsonmicro.com>
 <1364902368-1123-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the user moves directly from one button to another then we won't get a
no buttons pressed event and will therefore end up reporting that two
buttons are simultaneously pressed which isn't supported by the hardware.
Make sure we clear any existing button reports before reporting any new
ones.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/extcon/extcon-arizona.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index e2d881a..26f9a1a 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -852,6 +852,10 @@ static irqreturn_t arizona_micdet(int irq, void *data)
 			lvl = val & ARIZONA_MICD_LVL_MASK;
 			lvl >>= ARIZONA_MICD_LVL_SHIFT;
 
+			for (i = 0; i < info->num_micd_ranges; i++)
+				input_report_key(info->input,
+						 info->micd_ranges[i].key, 0);
+
 			WARN_ON(!lvl);
 			WARN_ON(ffs(lvl) - 1 >= info->num_micd_ranges);
 			if (lvl && ffs(lvl) - 1 < info->num_micd_ranges) {
-- 
1.7.10.4

