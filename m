Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaK3BOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 20:14:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:33054 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaK3BOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 20:14:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,485,1413270000"; 
   d="scan'208";a="645573144"
Message-ID: <547A6F75.6050806@intel.com>
Date: Sun, 30 Nov 2014 09:14:29 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, ntrrgc@gmail.com,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI / video: update the condition to check if a device is
 in _DOD list
References: <542A4949.2020208@intel.com> <1648939.GaN1bonAuX@vostro.rjw.lan> <5436470B.3030306@intel.com> <20141128095928.GA5106@norris-Latitude-E6410> <54786294.5030105@intel.com> <20141128171812.GA3658@norris-Latitude-E6410> <5479C3BB.5080905@intel.com> <20141129173447.GA3608@norris-Latitude-E6410>
In-Reply-To: <20141129173447.GA3608@norris-Latitude-E6410>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 01:34 AM, Brian Norris wrote:
> Tested-by: Brian Norris <computersforpeace@gmail.com>

Thanks for the test! Updated patch with changelog:

>From 0b11bb529245ddceb69eb558477b9b4a81208f4b Mon Sep 17 00:00:00 2001
From: Aaron Lu <aaron.lu@intel.com>
Date: Sun, 30 Nov 2014 09:01:15 +0800
Subject: [PATCH] ACPI / video: update the condition to check if a device is in _DOD list

Commit 0b8db271f159 ("ACPI / video: check _DOD list when creating
backlight devices") checks if the video device is in the bind devices
list to decide if we should create backlight device for it, that causes
problem for one Dell Latitude E6410, where none of the video output
devices are properly bound due to the way how we did the comparing
between its _ADR and the _DOD's values. Solve this problem by comparing
the lower 12 bits of both the device's _ADR and the _DOD's values instead
of relying on bind result.

Fixes: 0b8db271f159 ("ACPI / video: check _DOD list when creating backlight devices")
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Tested-by: Brian Norris <computersforpeace@gmail.com>
---
 drivers/acpi/video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 41e6b977ceb2..185a57d13723 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1164,7 +1164,8 @@ static bool acpi_video_device_in_dod(struct acpi_video_device *device)
 		return true;
 
 	for (i = 0; i < video->attached_count; i++) {
-		if (video->attached_array[i].bind_info == device)
+		if ((video->attached_array[i].value.int_val & 0xfff) ==
+		    (device->device_id & 0xfff))
 			return true;
 	}
 
-- 
1.9.3

