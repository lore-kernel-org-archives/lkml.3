Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaGaJWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:22:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:29248 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbaGaJWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:22:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,771,1400050800"; 
   d="scan'208";a="569866355"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/Processor: Add CPU_STARTING_FROZEN check in the acpi_cpu_soft_notify()
Date: Thu, 31 Jul 2014 17:20:26 +0800
Message-Id: <1406798426-16483-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callback of CPU_STARTING event can't sleep and so acpi_cpu_soft_notify()
return directly when CPU_STARTING event is triggered. But cpu hotplug also
happens during S2RAM. The action will become CPU_STARTING_FROZEN. This
patch is to fix missing check the frozen event.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/processor_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 4fcbd67..66e2249 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -125,7 +125,7 @@ static int acpi_cpu_soft_notify(struct notifier_block *nfb,
 	 * CPU_STARTING and CPU_DYING must not sleep. Return here since
 	 * acpi_bus_get_device() may sleep.
 	 */
-	if (action == CPU_STARTING || action == CPU_DYING)
+	if ((action & ~CPU_TASKS_FROZEN) == CPU_STARTING || action == CPU_DYING)
 		return NOTIFY_DONE;
 
 	if (!pr || acpi_bus_get_device(pr->handle, &device))
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

