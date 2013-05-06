Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3EFXN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:13:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3EFXNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, Matthias <morpheusxyz123@yahoo.de>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <syrjala@sci.fi>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 072/104] ACPI / thermal: do not always return THERMAL_TREND_RAISING for active trip points
Date: Mon,  6 May 2013 16:12:31 -0700
Message-Id: <20130506230051.040908116@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit 94a409319561ec1847fd9bf996a2d5843ad00932 upstream.

Commit 4ae46be "Thermal: Introduce thermal_zone_trip_update()"
introduced a regression causing the fan to be always on even when
the system is idle.

My original idea in that commit is that:
 - when the current temperature is above the trip point,
   keep the fan on, even if the temperature is dropping.
 - when the current temperature is below the trip point,
   turn on the fan when the temperature is raising,
   turn off the fan when the temperature is dropping.

But this is what the code actually does:
 - when the current temperature is above the trip point,
   the fan keeps on.
 - when the current temperature is below the trip point,
   the fan is always on because thermal_get_trend()
   in driver/acpi/thermal.c returns THERMAL_TREND_RAISING.
Thus the fan keeps running even if the system is idle.

Fix this in drivers/acpi/thermal.c.

[rjw: Changelog]
References: https://bugzilla.kernel.org/show_bug.cgi?id=56591
References: https://bugzilla.kernel.org/show_bug.cgi?id=56601
References: https://bugzilla.kernel.org/show_bug.cgi?id=50041#c45
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Matthias <morpheusxyz123@yahoo.de>
Tested-by: Ville Syrjälä <syrjala@sci.fi>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/thermal.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -719,9 +719,19 @@ static int thermal_get_trend(struct ther
 		return -EINVAL;
 
 	if (type == THERMAL_TRIP_ACTIVE) {
-		/* aggressive active cooling */
-		*trend = THERMAL_TREND_RAISING;
-		return 0;
+		unsigned long trip_temp;
+		unsigned long temp = KELVIN_TO_MILLICELSIUS(tz->temperature,
+							tz->kelvin_offset);
+		if (thermal_get_trip_temp(thermal, trip, &trip_temp))
+			return -EINVAL;
+
+		if (temp > trip_temp) {
+			*trend = THERMAL_TREND_RAISING;
+			return 0;
+		} else {
+			/* Fall back on default trend */
+			return -EINVAL;
+		}
 	}
 
 	/*


