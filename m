Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329Ab3DZJUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:20:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:56632 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759216Ab3DZJUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:20:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,557,1363158000"; 
   d="scan'208";a="232978467"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: rjw@sisk.pl, lenb@kernel.org, eduardo.valentin@ti.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH] ACPI thermal: do not always return THERMAL_TREND_RAISING for active trip points
Date: Fri, 26 Apr 2013 17:19:53 +0800
Message-Id: <1366967993-3812-1-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4ae46befb49d4173122e0afa995c4e93d01948a2
introduces a regression that the fan is always on
even if the system is in idle state.

My original idea in that commit is that:
when the current temperature is above the trip point,
keep the fan on, even if the temperature is dropping.
when the current temperature is below the trip point,
turn on the fan when the temperature is raising,
turn off the fan when the temperature is dropping.

But this is what the code actually does:
when the current temperature is above the trip point,
the fan keeps on.
when the current temperature is below the trip point,
the fan is always on because thermal_get_trend()
in driver/acpi/thermal.c returns THERMAL_TREND_RAISING.
Thus the fan keeps running even if the system is idle.

Fix this in drivers/acpi/thermal.c.

https://bugzilla.kernel.org/show_bug.cgi?id=56591
https://bugzilla.kernel.org/show_bug.cgi?id=56601
https://bugzilla.kernel.org/show_bug.cgi?id=50041#c45

Patch should be applied to 3.7 stable kernel and later.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Matthias <morpheusxyz123@yahoo.de>
Tested-by: Ville Syrjälä <syrjala@sci.fi>
Cc: <stable@vger.kernel.org> # v3.7+
---
 drivers/acpi/thermal.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 8470771..a33821c 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -723,9 +723,19 @@ static int thermal_get_trend(struct thermal_zone_device *thermal,
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
-- 
1.7.9.5

