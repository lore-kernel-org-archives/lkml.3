Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3BWTUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 14:20:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54220 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980Ab3BWTUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 14:20:14 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Borislav Petkov <bp@suse.de>, Peter Feuerer <peter@piie.net>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Subject: [PATCH] acerhdf: Fix fan activation with new thermal governor
Date: Sat, 23 Feb 2013 20:20:10 +0100
Message-Id: <1361647210-12983-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <20130222111521.GA25473@pd.tnic>
References: <20130222111521.GA25473@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

The new step_wise thermal governor wasn't able to handle the one-trip
point design of acerhdf where we want to turn off the fan if we go under
the 'fanoff' temperature and to turn it on only after exceeding the
'fanon' temperature.

Do that by looking at the current fan state and return the temperature
accordingly.

Suggested-by: Zhang Rui <rui.zhang@intel.com>
Cc: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Alexander Lam <azl@andrew.cmu.edu>
Signed-off-by: Borislav Petkov <bp@suse.de>
---

Guys,

this fixes acerhdf to the old behavior. Testing here looks ok - I'd
appreciate if you could verify this too.

Thanks.

 drivers/platform/x86/acerhdf.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index f94467c05225..b44033756909 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -405,13 +405,33 @@ static int acerhdf_get_trip_type(struct thermal_zone_device *thermal, int trip,
 	return 0;
 }
 
+/*
+ * This is more or less a quirky wagging the dog so that a one-trip
+ * point can still work with the step_wise governor. Basically, we cheat
+ * with the trip temperature depending on whether the current state of
+ * the fan (on vs off).
+ */
 static int acerhdf_get_trip_temp(struct thermal_zone_device *thermal, int trip,
 				 unsigned long *temp)
 {
-	if (trip == 0)
+	int err = 0, state;
+
+	err = acerhdf_get_fanstate(&state);
+	if (err) {
+		/*
+		 * We want to be conservative here: in the unlikely event that
+		 * reading the fanstate failed, we want to leave the fan on.
+		 */
 		*temp = fanon;
+		return err;
+	}
 
-	return 0;
+	if (state == ACERHDF_FAN_AUTO)
+		*temp = fanoff;
+	else
+		*temp = fanon;
+
+	return err;
 }
 
 static int acerhdf_get_crit_temp(struct thermal_zone_device *thermal,
-- 
1.8.1.3.535.ga923c31

