Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaIXI1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:27:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48798 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaIXI1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:47 -0400
X-AuditID: cbfee61a-f79c06d000004e71-3e-542280815299
From: Lukasz Majewski <l.majewski@samsung.com>
To: Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-kernel@vger.kernel.org, Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 1/3] thermal: step_wise: fix: Prevent from binary overflow when
 trend is dropping
Date: Wed, 24 Sep 2014 10:27:10 +0200
Message-id: <1411547232-21493-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd2mBqUQgyONzBYbZ6xntZh/5Rqr
	xZtH3BZvHm5mtLi8aw6bxefeI4wWTx72sTmwe+ycdZfdY/Gel0we66a9Zfbo27KK0ePzJrkA
	1igum5TUnMyy1CJ9uwSujBVnN7AW7OSoOH59OmMD4x+2LkZODgkBE4lp09YxQdhiEhfurQeK
	c3EICSxilFjy7RIjhNPFJHFmwyxmkCo2AT2Jz3efAnVwcIgIeEtsWcMBUsMscINRYkr/ZLBJ
	wgLJEu1zG8FsFgFVib+HOxlB6nkF3CSezayFWKYo0f1sAtgRnALuEjd/P2MHsYWASg7+Osg+
	gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgkHomtYNxZYPFIUYBDkYlHt4J4koh
	QqyJZcWVuYcYJTiYlUR4T5QChXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5N
	LUgtgskycXBKNTDOVLWMvmN/ZNcUxv23L0ySscjyfZ8vf3Cnu+K9XX3/fKakKxZP3Drhg9V/
	A9P/5WqHUy+z8zPcl801uGnEMEX0wvqf54qa956J1l4/+VCk2Kv2Kz/nTBFweHExJTCDc+vn
	A2yiH8+GPtk5v+xK7/mL6qunXBWedXj3op27e79cFEt1sb915gS3mRJLcUaioRZzUXEiAKph
	w5klAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out that some boards can have instance->lower greater than 0 and
when thermal trend is dropping it results with next_target equal to -1.

Since the next_target is defined as unsigned long it is interpreted as
0xFFFFFFFF and larger than instance->upper.
As a result the next_target is set to instance->upper which ramps up to
maximal cooling device target when the temperature is steadily decreasing.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
---
 drivers/thermal/step_wise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
index 3b54c2c..fdd1f52 100644
--- a/drivers/thermal/step_wise.c
+++ b/drivers/thermal/step_wise.c
@@ -77,7 +77,7 @@ static unsigned long get_target_state(struct thermal_instance *instance,
 			next_target = instance->upper;
 		break;
 	case THERMAL_TREND_DROPPING:
-		if (cur_state == instance->lower) {
+		if (cur_state <= instance->lower) {
 			if (!throttle)
 				next_target = THERMAL_NO_TARGET;
 		} else {
-- 
2.0.0.rc2

