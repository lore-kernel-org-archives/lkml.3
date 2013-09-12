Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab3ILHeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:34:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:21537 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab3ILHeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:34:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,889,1371106800"; 
   d="scan'208";a="293903984"
From: tianyu.lan@intel.com
To: tianyu.lan@intel.com, lenb@kernel.org, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ACPI/Sys: make gpe's sysfs attribute only accept correct value
Date: Thu, 12 Sep 2013 03:32:05 -0400
Message-Id: <1378971125-8896-4-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1378971125-8896-1-git-send-email-tianyu.lan@intel.com>
References: <1378971125-8896-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

According to design, gpe's sysfs attribute should accept "disable", "enable",
"clear" and integer number as params. Current code checks "disable",
"enable" and "clear" first. If the param didn't belong to previous kinds,
pass the param to strtoul as a string of integer number and assign the
return value to gpe number. It losses the check of whether the param
is a string of integer number and strtoul will return 0 if the string
is not a number.  This causes any params except for "enable"
, "disable", "clear" and number to make the gpe number to become 0. This
patch is to use kstrtoul() to replace strtoul() and check the return
value. If convertion is successful, assign to gpe number. If not, return
err.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/sysfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 05306a5..b557787 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -564,6 +564,7 @@ static ssize_t counter_set(struct kobject *kobj,
 	acpi_event_status status;
 	acpi_handle handle;
 	int result = 0;
+	unsigned long tmp;
 
 	if (index == num_gpes + ACPI_NUM_FIXED_EVENTS + COUNT_SCI) {
 		int i;
@@ -596,8 +597,10 @@ static ssize_t counter_set(struct kobject *kobj,
 		else if (!strcmp(buf, "clear\n") &&
 			 (status & ACPI_EVENT_FLAG_SET))
 			result = acpi_clear_gpe(handle, index);
+		else if (!kstrtoul(buf, 0, &tmp))
+			all_counters[index].count = tmp;
 		else
-			all_counters[index].count = strtoul(buf, NULL, 0);
+			result = -EINVAL;
 	} else if (index < num_gpes + ACPI_NUM_FIXED_EVENTS) {
 		int event = index - num_gpes;
 		if (!strcmp(buf, "disable\n") &&
@@ -609,8 +612,10 @@ static ssize_t counter_set(struct kobject *kobj,
 		else if (!strcmp(buf, "clear\n") &&
 			 (status & ACPI_EVENT_FLAG_SET))
 			result = acpi_clear_event(event);
+		else if (!kstrtoul(buf, 0, &tmp))
+			all_counters[index].count = tmp;
 		else
-			all_counters[index].count = strtoul(buf, NULL, 0);
+			result = -EINVAL;
 	} else
 		all_counters[index].count = strtoul(buf, NULL, 0);
 
-- 
1.8.2.1

