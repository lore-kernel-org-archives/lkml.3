Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaBQFDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 00:03:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:32560 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaBQFDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 00:03:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,858,1384329600"; 
   d="scan'208";a="341479378"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC Patch v1 3/6] acpi_pad: use acpi_evaluate_pad() to replace open-coded version
Date: Mon, 17 Feb 2014 13:02:50 +0800
Message-Id: <1392613373-11003-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com>
 <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use public function acpi_evaluate_pad() to replace open-coded
version of evaluating ACPI _OST method.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/acpi_pad.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index 1e3ce76..86b4e11 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -408,28 +408,14 @@ static int acpi_pad_pur(acpi_handle handle)
 	return num;
 }
 
-/* Notify firmware how many CPUs are idle */
-static void acpi_pad_ost(acpi_handle handle, int stat,
-	uint32_t idle_cpus)
-{
-	union acpi_object params[3] = {
-		{.type = ACPI_TYPE_INTEGER,},
-		{.type = ACPI_TYPE_INTEGER,},
-		{.type = ACPI_TYPE_BUFFER,},
-	};
-	struct acpi_object_list arg_list = {3, params};
-
-	params[0].integer.value = ACPI_PROCESSOR_AGGREGATOR_NOTIFY;
-	params[1].integer.value =  stat;
-	params[2].buffer.length = 4;
-	params[2].buffer.pointer = (void *)&idle_cpus;
-	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
-}
-
 static void acpi_pad_handle_notify(acpi_handle handle)
 {
 	int num_cpus;
 	uint32_t idle_cpus;
+	struct acpi_buffer param = {
+		.length = 4,
+		.pointer = (void *)&idle_cpus,
+	};
 
 	mutex_lock(&isolated_cpus_lock);
 	num_cpus = acpi_pad_pur(handle);
@@ -439,7 +425,7 @@ static void acpi_pad_handle_notify(acpi_handle handle)
 	}
 	acpi_pad_idle_cpus(num_cpus);
 	idle_cpus = acpi_pad_idle_cpus_num();
-	acpi_pad_ost(handle, 0, idle_cpus);
+	acpi_evaluate_ost(handle, ACPI_PROCESSOR_AGGREGATOR_NOTIFY, 0, &param);
 	mutex_unlock(&isolated_cpus_lock);
 }
 
-- 
1.7.10.4

