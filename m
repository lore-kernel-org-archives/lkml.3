Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbaFMGwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:52:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:35651 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbaFMGv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:51:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,470,1400050800"; 
   d="scan'208";a="445043489"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 6/7] ACPICA: Events: Fix edge-triggered GPE by disabling before acknowledging it.
Date: Fri, 13 Jun 2014 14:51:54 +0800
Message-Id: <1bae7754d30f72caaedcddd9fb2f1f90bbd9c630.1402641700.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1402641700.git.lv.zheng@intel.com>
References: <cover.1402641700.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to ACPI specificiation 5, chapter 5.6.4 General-Purpose Event Hnadling,
OSPMs need to disable GPE before clearing the status bit for edge-triggered
GPEs.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Gareth Williams <gareth@garethwilliams.me.uk>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
---
 drivers/acpi/acpica/evgpe.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 48f7001..e4ba4de 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -698,21 +698,6 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 	}
 
 	/*
-	 * If edge-triggered, clear the GPE status bit now. Note that
-	 * level-triggered events are cleared after the GPE is serviced.
-	 */
-	if ((gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
-	    ACPI_GPE_EDGE_TRIGGERED) {
-		status = acpi_hw_clear_gpe(gpe_event_info);
-		if (ACPI_FAILURE(status)) {
-			ACPI_EXCEPTION((AE_INFO, status,
-					"Unable to clear GPE %02X",
-					gpe_number));
-			return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
-		}
-	}
-
-	/*
 	 * Always disable the GPE so that it does not keep firing before
 	 * any asynchronous activity completes (either from the execution
 	 * of a GPE method or an asynchronous GPE handler.)
@@ -729,6 +714,23 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 	}
 
 	/*
+	 * If edge-triggered, clear the GPE status bit now. Note that
+	 * level-triggered events are cleared after the GPE is serviced.
+	 */
+	if ((gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
+	    ACPI_GPE_EDGE_TRIGGERED) {
+		status = acpi_hw_clear_gpe(gpe_event_info);
+		if (ACPI_FAILURE(status)) {
+			ACPI_EXCEPTION((AE_INFO, status,
+					"Unable to clear GPE %02X",
+					gpe_number));
+			(void)acpi_hw_low_set_gpe(gpe_event_info,
+						  ACPI_GPE_CONDITIONAL_ENABLE);
+			return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
+		}
+	}
+
+	/*
 	 * Dispatch the GPE to either an installed handler or the control
 	 * method associated with this GPE (_Lxx or _Exx). If a handler
 	 * exists, we invoke it and do not attempt to run the method.
-- 
1.7.10

