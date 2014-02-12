Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaBLPSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:18:53 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.139]:11184 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751572AbaBLPSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:18:52 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-13.tower-179.messagelabs.com!1392218329!25861073!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201402121518.s1CFIkDP009092@swsrvapps-02.lan>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Wed, 12 Feb 2014 14:11:34 +0000
Subject: [PATCH V2] ONKEY: da9052: Use correct register bit for key status
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David Dajun Chen" <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong register bit of the DA9052/3 PMIC registers was
used to determine the status on the ONKEY.

Also a failure in reading the status register will no longer
result in the work queue being rescheduled as that would result
in a (potentially) endless retry.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Acked-by: David Dajun Chen <david.chen@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140212

The bug that this patch fixes affects only the DA9052 ONKEY driver.

The problem was detected whilst running a scripted set of functional
regression tests whilst investigating a different problem.

This patch has been test compiled on an amd64 server for both x86
and arm targets.

This patch has been spot verified using an SMDK6410 platform
fly-wired to a Dialog da9053 EVB.

 drivers/input/misc/da9052_onkey.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/input/misc/da9052_onkey.c b/drivers/input/misc/da9052_onkey.c
index 1f695f2..184c8f2 100644
--- a/drivers/input/misc/da9052_onkey.c
+++ b/drivers/input/misc/da9052_onkey.c
@@ -27,29 +27,32 @@ struct da9052_onkey {
 
 static void da9052_onkey_query(struct da9052_onkey *onkey)
 {
-	int key_stat;
+	int ret;
 
-	key_stat = da9052_reg_read(onkey->da9052, DA9052_EVENT_B_REG);
-	if (key_stat < 0) {
+	ret = da9052_reg_read(onkey->da9052, DA9052_STATUS_A_REG);
+	if (ret < 0) {
 		dev_err(onkey->da9052->dev,
-			"Failed to read onkey event %d\n", key_stat);
+			"Failed to read onkey event err=%d\n", ret);
 	} else {
 		/*
 		 * Since interrupt for deassertion of ONKEY pin is not
 		 * generated, onkey event state determines the onkey
 		 * button state.
 		 */
-		key_stat &= DA9052_EVENTB_ENONKEY;
-		input_report_key(onkey->input, KEY_POWER, key_stat);
+		bool pressed = !(ret & DA9052_STATUSA_NONKEY);
+
+		input_report_key(onkey->input, KEY_POWER, pressed);
 		input_sync(onkey->input);
-	}
 
-	/*
-	 * Interrupt is generated only when the ONKEY pin is asserted.
-	 * Hence the deassertion of the pin is simulated through work queue.
-	 */
-	if (key_stat)
-		schedule_delayed_work(&onkey->work, msecs_to_jiffies(50));
+		/*
+		 * Interrupt is generated only when the ONKEY pin
+		 * is asserted.  Hence the deassertion of the pin
+		 * is simulated through work queue.
+		 */
+		if (pressed)
+			schedule_delayed_work(&onkey->work,
+						msecs_to_jiffies(50));
+	}
 }
 
 static void da9052_onkey_work(struct work_struct *work)
-- 
end-of-patch for ONKEY: da9052: Use correct register bit for key status V2

