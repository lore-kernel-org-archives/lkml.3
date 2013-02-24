Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3BXOe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 09:34:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58456 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757294Ab3BXOe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 09:34:57 -0500
Date: Sun, 24 Feb 2013 15:34:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, Andreas Mohr <andi@lisas.de>,
        Alexander Lam <azl@andrew.cmu.edu>, bp@suse.de
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130224143452.GE19609@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Durgadoss R <durgadoss.r@intel.com>, Andreas Mohr <andi@lisas.de>,
	Alexander Lam <azl@andrew.cmu.edu>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1361706175.908398.1806.1000@galar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 12:42:55PM +0100, Peter Feuerer wrote:
> Please test my last patch with the 4 trip points ;) - even if you
> don't really like it, it is working great! - And to be honest, I still
> prefer this solution!

Ok, I remember everything now - had to add some debug output to see what
the stepwise governor hands us down.

Btw, Zhang, is there any way we can tell the upper layer to not
poll trips and temps for this driver? I mean, ->get_trip_type and
->get_trip_temp get called every polling interval and the data it
receives back each time is static and don't change so polling the same
values each time for this driver doesn't make any sense.

Can we pass trip points and temperature levels upon registration time
instead?

@Peter: I took your patch, removed one trip point and added comments so
that we don't forget why we do what we do. Please take a look - it works
fine here.

--
>From 1827ed71ff1b73a83d81d21f9dd167fe8e0d4198 Mon Sep 17 00:00:00 2001
From: Peter Feuerer <peter@piie.net>
Date: Sun, 24 Feb 2013 15:04:17 +0100
Subject: [PATCH] acerhdf: Fix fan activation with new thermal governor

After recent thermal subsys rework, acerhdf couldn't cope with the
stepwise governor since it had only one trip point and this didn't fit
into the stepwise scheme. Therefore, add two more trip points - an
active one where we turn on the fan, and a critical one.

However, we still need to flatten out peaks of turning the fan on
and off in acerhdf_set_cur_state because stepwise looks also at the
direction the temperature is going and applies respective policy. This
results in short bursts of interchanging on and off which are really
annoying.

So, we keep the old logic where we turn on the fan only if we exceed
'fanon' temperature and leave it on until we go under 'fanoff'. Document
this behavior while at it.

Signed-off-by: Peter Feuerer <peter@piie.net>
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/platform/x86/acerhdf.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index f94467c05225..b06cdb099e6a 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -400,7 +400,13 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
 				 enum thermal_trip_type *type)
 {
 	if (trip == 0)
+		*type = THERMAL_TRIP_PASSIVE;
+	else if (trip == 1)
 		*type = THERMAL_TRIP_ACTIVE;
+	else if (trip == 2)
+		*type = THERMAL_TRIP_CRITICAL;
+	else
+		WARN_ONCE(1, "%s: Funny trip point %d\n", KBUILD_MODNAME, trip);
 
 	return 0;
 }
@@ -409,7 +415,13 @@ static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 				 unsigned long *temp)
 {
 	if (trip == 0)
+		*temp = 0;
+	else if (trip == 1)
 		*temp = fanon;
+	else if (trip == 2)
+		*temp = ACERHDF_TEMP_CRIT;
+	else
+		WARN_ONCE(1, "%s: Funny trip point %d\n", KBUILD_MODNAME, trip);
 
 	return 0;
 }
@@ -459,7 +471,9 @@ static int acerhdf_get_cur_state(struct thermal_cooling_device *cdev,
 	return 0;
 }
 
-/* change current fan state - is overwritten when running in kernel mode */
+/*
+ * Change current fan state - is overwritten when running in kernel mode
+ */
 static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long state)
 {
@@ -480,15 +494,23 @@ static int acerhdf_set_cur_state(struct thermal_cooling_device *cdev,
 		goto err_out;
 	}
 
+	/*
+	 * We need to flatten out the on-off peaks we get from the stepwise
+	 * governor into the wider span between fanoff and fanon because
+	 * otherwise we turn on/off the fan in short bursts, everytime the
+	 * thermal zone decides to throttle and this is annoying.
+	 */
 	if (state == 0) {
 		/* turn fan off only if below fanoff temperature */
 		if ((cur_state == ACERHDF_FAN_AUTO) &&
-		    (cur_temp < fanoff))
+		    (cur_temp <= fanoff))
 			acerhdf_change_fanstate(ACERHDF_FAN_OFF);
 	} else {
-		if (cur_state == ACERHDF_FAN_OFF)
+		if ((cur_state == ACERHDF_FAN_OFF) &&
+		    (cur_temp >= fanon))
 			acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
 	}
+
 	return 0;
 
 err_out:
@@ -661,7 +683,7 @@ static int acerhdf_register_thermal(void)
 	if (IS_ERR(cl_dev))
 		return -EINVAL;
 
-	thz_dev = thermal_zone_device_register("acerhdf", 1, 0, NULL,
+	thz_dev = thermal_zone_device_register("acerhdf", 3, 0, NULL,
 					      &acerhdf_dev_ops, NULL, 0,
 					      (kernelmode) ? interval*1000 : 0);
 	if (IS_ERR(thz_dev))
-- 
1.8.1.3.535.ga923c31


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
