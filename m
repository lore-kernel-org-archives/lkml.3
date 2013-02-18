Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3BRQri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:47:38 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:46564 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3BRQrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:47:37 -0500
References: <20130214153255.GA5033@rhlx01.hs-esslingen.de> <744357E9AAD1214791ACBA4B0B90926329ED72@SHSMSX101.ccr.corp.intel.com> <20130215154931.GA26213@rhlx01.hs-esslingen.de> <CACWwPiuk0GynEwe3RuKndWnsYwTuPhO0ob6sJ6ve34u1_RtkYw@mail.gmail.com> <20130216214712.GA13494@pd.tnic> <cone.1361068993.271211.4532.1000@galar> <20130217140908.GA20323@pd.tnic> <cone.1361115717.636831.25189.1000@galar> <20130218135012.GB16622@pd.tnic>
Message-ID: <cone.1361206053.493518.2246.1000@galar>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <bp@alien8.de>,
        =?UTF-8?B?Wmhhbmcs?= Rui <rui.zhang@intel.com>
Cc: Alexander Lam <azl@andrew.cmu.edu>,
        =?UTF-8?B?bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw==?= 
	<linux-kernel@vger.kernel.org>,
        Andreas Mohr <andi@lisas.de>
Subject: Re: thermal governor: does it actually work??
Date: Mon, 18 Feb 2013 17:47:33 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: NDA0MDk0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris, Hi Rui,

@Rui, would be great, if you could review the patch and verify, whether
everything I'm telling is the truth, thanks.


Borislav Petkov writes:

> On Sun, Feb 17, 2013 at 04:41:57PM +0100, Peter Feuerer wrote:
>> Don't think so, I think this was already in since 2.6.<something> and
>> I assume with this patch applied, acerhdf works from at least this
>> 2.6.<something> up to new 3.8 and will still work in the future.
> 
> Well, it can't be because there wouldn't be breakage otherwise, right?
> I've been running 3.5 on the atom for a long time and it was ok but 3.8
> is showing the issue. So something *has* changed.

I think previous 3.7 were two methods possible, the method with one trippoint,
on which the state gets switched on and off using this code in thermal_sys.c:
1060                                if (temp >= trip_temp)
1061                                        cdev->ops->set_cur_state(cdev, 1);
1062                                else
1063                                        cdev->ops->set_cur_state(cdev, 0);


And the other method with all the different trip points, which is used after 
applying my patch.
The older way has been removed intentionally or not, I don't know. But as
acerhdf was depending on this old way, it stopped working.


> But, as you say above, I guess the two-point scheme of acerhdf doesn't
> have a governor that fits. So maybe the correct solution is to have an
> "on_off" stupid governor which gets used by acerhdf and does simply call
> into acerhdf to switch on the fan to auto above a specified trip point.
> 
> It could be a lot of overhead for nothing in the end, though.

I think adding a two-point governor would maybe be the somehow cleaner way...
Rui, what do you think, is there a way, you could provide a two-point governor
with upper temperature for turning on the fan and a lower temperature for
turning it off again?


>> >Maybe the critical and hot types need to go here? I.e., 3 and 4?
>> 
>> Yes, crit has to go there.
> 
> Right, I'll wait for that version of the patch to test. :)

I added crit to the patch below.



>From 74af34f3099828d5c7c2b4fd4ccf445edfdc6f1e Mon Sep 17 00:00:00 2001
From: Peter Feuerer <peter@piie.net>
Date: Mon, 18 Feb 2013 17:23:34 +0100
Subject: [PATCH] added three more trip points to acerhdf, this allows thermal
 layer to correctly handle the two point regulation of acerhdf. Trip point 0
 will be active from 0 degree to "fanoff" and is marked as passive, then trip
 point 1 is valid from "fanoff" to "fanon" value and is marked as active, even
 if it's only really active in case temperature is going down from trip point
 2. Trip point 2 will be valid above "fanon" value and is also marked as
 active. Trip point 3 is when hitting the critical temperature.

---
 drivers/platform/x86/acerhdf.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index f94467c..b121449 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -400,7 +400,13 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
 				 enum thermal_trip_type *type)
 {
 	if (trip == 0)
+		*type = THERMAL_TRIP_PASSIVE;
+	if (trip == 1)
 		*type = THERMAL_TRIP_ACTIVE;
+	if (trip == 2)
+		*type = THERMAL_TRIP_ACTIVE;
+	if (trip == 3)
+		*type = THERMAL_TRIP_CRITICAL;
 
 	return 0;
 }
@@ -409,7 +415,13 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 				 unsigned long *temp)
 {
 	if (trip == 0)
+		*temp = 0;
+	if (trip == 1)
+		*temp = fanoff;
+	if (trip == 2)
 		*temp = fanon;
+	if (trip == 3)
+		*temp = ACERHDF_TEMP_CRIT;
 
 	return 0;
 }
@@ -431,6 +443,7 @@ static struct thermal_zone_device_ops acerhdf_dev_ops = {
 	.get_trip_type = acerhdf_get_trip_type,
 	.get_trip_temp = acerhdf_get_trip_temp,
 	.get_crit_temp = acerhdf_get_crit_temp,
+	.notify = NULL,
 };
 
 
@@ -486,7 +499,8 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
 		    (cur_temp < fanoff))
 			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
 	} else {
-		if (cur_state == ACERHDF_FAN_OFF)
+		if ((cur_state == ACERHDF_FAN_OFF) &&
+		    (cur_temp > fanon))
 			acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
 	}
 	return 0;
@@ -661,8 +675,9 @@ static int acerhdf_register_thermal(void)
 	if (IS_ERR(cl_dev))
 		return -EINVAL;
 
-	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
-					      &acerhdf_dev_ops, NULL, 0,
+	thz_dev = thermal_zone_device_register("acerhdf", 4, 0, NULL,
+					      &acerhdf_dev_ops,
+					      (kernelmode) ? interval*1000 : 0,
 					      (kernelmode) ? interval*1000 : 0);
 	if (IS_ERR(thz_dev))
 		return -EINVAL;
-- 
1.8.1.3

