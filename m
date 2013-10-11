Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3JKI1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:27:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:47754 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3JKI1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:27:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1078,1371106800"; 
   d="scan'208";a="415324537"
From: tianyu.lan@intel.com
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/Power: Check physical device's runtime pm status before requesting to resume it
Date: Fri, 11 Oct 2013 16:16:25 +0800
Message-Id: <1381479385-1614-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

Currently, when one power resource is turned on, devices owning it
will be requested to resume regardless of their runtime pm status.
ACPI power resource maybe turn on in some devices' runtime pm
resume callback(E.G, usb port) while turning on the power resource
will trigger one new resume request of the device. It causes
infinite loop between resume and suspend. This has happened on
clearing usb port's PM Qos NO_POWER_OFF flag twice. This patch is
to add check of physical device's runtime pm status and request resume
if the device is suspended.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/power.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 0dbe5cd..228c138 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -250,8 +250,10 @@ static void acpi_power_resume_dependent(struct work_struct *work)
 
 	mutex_lock(&adev->physical_node_lock);
 
-	list_for_each_entry(pn, &adev->physical_node_list, node)
-		pm_request_resume(pn->dev);
+	list_for_each_entry(pn, &adev->physical_node_list, node) {
+		if (pm_runtime_suspended(pn->dev))
+			pm_request_resume(pn->dev);
+	}
 
 	list_for_each_entry(pn, &adev->power_dependent, node)
 		pm_request_resume(pn->dev);
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

