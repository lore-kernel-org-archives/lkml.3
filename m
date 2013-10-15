Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871Ab3JOLsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 07:48:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:50818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566Ab3JOLsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 07:48:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,498,1378882800"; 
   d="scan'208";a="419374430"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/Power: Release resource_lock after acpi_power_get_state() return error
Date: Tue, 15 Oct 2013 19:48:11 +0800
Message-Id: <1381837691-3657-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resource_lock should be released when acpi_power_get_state() fails and before
passing to next power resource on the acpi power resource list.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/power.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 0dbe5cd..0c1c3ec 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -936,8 +936,10 @@ void acpi_resume_power_resources(void)
 		mutex_lock(&resource->resource_lock);
 
 		result = acpi_power_get_state(resource->device.handle, &state);
-		if (result)
+		if (result) {
+			mutex_unlock(&resource->resource_lock);
 			continue;
+		}
 
 		if (state == ACPI_POWER_RESOURCE_STATE_OFF
 		    && resource->ref_count) {
-- 
1.8.2.1

