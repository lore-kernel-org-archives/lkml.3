Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab3BQCuD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 21:50:03 -0500
Received: from smtprelay02.ispgateway.de ([80.67.31.36]:42120 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab3BQCuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 21:50:01 -0500
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Feb 2013 21:50:00 EST
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de> <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com> <20130215154931.GA26213@rhlx01.hs-esslingen.de> <CACWwPiuk0GynEwe3RuKndWnsYwTuPhO0ob6sJ6ve34u1_RtkYw@mail.gmail.com> <20130216214712.GA13494@pd.tnic>
Message-ID: <cone.1361068993.271211.4532.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Alexander Lam <azl@andrew.cmu.edu>,
        =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: thermal governor: does it actually work??
Date: Sun, 17 Feb 2013 03:43:13 +0100
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris, Alex, Andreas,

what do you think about this acerhdf patch?
I think it makes things straight and implements the two-point regulation of 
acerhdf to be for correctly handled by the thermal layer:


>From 7b39bd8837de6dc5658ac3e54ac5d4df9d351528 Mon Sep 17 00:00:00 2001
From: Peter Feuerer <peter@piie.net>
Date: Sun, 17 Feb 2013 03:29:19 +0100
Subject: [PATCH] added two more trip points to acerhdf, this allows thermal
 layer to correctly handle the two point regulation of acerhdf. Trip point 0
 will be active from 0 degree to "fanoff" and is marked as passive, then trip
 point 1 is valid from "fanoff" to "fanon" value and is marked as active,
 even if it's only really active in case temperature is going down from trip
 point 2. Trip point 2 will be valid above "fanon" value and is also marked
 as active.

---
 drivers/platform/x86/acerhdf.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index f94467c..c36633b 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -400,6 +400,10 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
 				 enum thermal_trip_type *type)
 {
 	if (trip == 0)
+		*type = THERMAL_TRIP_PASSIVE;
+	if (trip == 1)
+		*type = THERMAL_TRIP_ACTIVE;
+	if (trip == 2)
 		*type = THERMAL_TRIP_ACTIVE;
 
 	return 0;
@@ -409,6 +413,10 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 				 unsigned long *temp)
 {
 	if (trip == 0)
+		*temp = 0;
+	if (trip == 1)
+		*temp = fanoff;
+	if (trip == 2)
 		*temp = fanon;
 
 	return 0;
@@ -486,7 +494,8 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
 		    (cur_temp < fanoff))
 			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
 	} else {
-		if (cur_state == ACERHDF_FAN_OFF)
+		if ((cur_state == ACERHDF_FAN_OFF) &&
+		    (cur_temp > fanon))
 			acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
 	}
 	return 0;
@@ -661,8 +670,8 @@ static int acerhdf_register_thermal(void)
 	if (IS_ERR(cl_dev))
 		return -EINVAL;
 
-	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
-					      &acerhdf_dev_ops, NULL, 0,
+	thz_dev = thermal_zone_device_register("acerhdf", 3, 0, NULL,
+					      &acerhdf_dev_ops, (kernelmode) ? interval*1000 : 0,
 					      (kernelmode) ? interval*1000 : 0);
 	if (IS_ERR(thz_dev))
 		return -EINVAL;
-- 
1.8.1.3

