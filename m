Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbaGODIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:08:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:45690 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797AbaGODIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="561821140"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 8/9] ACPICA: Events: Add a flag to disable internal auto GPE clearing.
Date: Tue, 15 Jul 2014 11:08:04 +0800
Message-Id: <934969ef53f0a0ed06fec048cca0c01b0199eb9f.1405306438.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405306438.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405306438.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearing the status bit means OSPM acknowledges the GPE and the hardware
then can bring follow-up events up. Acklowdging it too early causes OSPM
seeing level triggered GPE storms or missing edge-triggered GPEs if the
OSPM driver responds slowly. Some drivers may choose to implement GPE
condition clearing code in a position that is different from where it
should be disabled or re-enabled, in which case, the internal auto GPE
clearing operations should be abandoned.

This flag facilitates such driver designs and implementations.

Note that drivers will need to invoke acpi_clear_gpe() manually in a proper
position where the causes and conditions of the GPE have been solved and
the GPE status can be safely cleared. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/evgpe.c |    6 ++++--
 include/acpi/actypes.h      |   16 +++++++++-------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 64f6d41..7589956 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -633,7 +633,8 @@ acpi_status acpi_ev_finish_gpe(struct acpi_gpe_event_info * gpe_event_info)
 {
 	acpi_status status;
 
-	if ((gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
+	if (!(gpe_event_info->flags & ACPI_GPE_NO_AUTO_CLEAR) &&
+	    (gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
 	    ACPI_GPE_LEVEL_TRIGGERED) {
 		/*
 		 * GPE is level-triggered, we clear the GPE status bit after
@@ -719,7 +720,8 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 	 * If edge-triggered, clear the GPE status bit now. Note that
 	 * level-triggered events are cleared after the GPE is serviced.
 	 */
-	if ((gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
+	if (!(gpe_event_info->flags & ACPI_GPE_NO_AUTO_CLEAR) &&
+	    (gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK) ==
 	    ACPI_GPE_EDGE_TRIGGERED) {
 		status = acpi_hw_clear_gpe(gpe_event_info);
 		if (ACPI_FAILURE(status)) {
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 608a040..18f341f 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -738,13 +738,14 @@ typedef u32 acpi_event_status;
 
 /*
  * GPE info flags - Per GPE
- * +-------+-+-+---+
- * |  7:4  |3|2|1:0|
- * +-------+-+-+---+
- *     |    | |  |
- *     |    | |  +-- Type of dispatch:to method, handler, notify, or none
- *     |    | +----- Interrupt type: edge or level triggered
- *     |    +------- Is a Wake GPE
+ * +-------+-+-+-+---+
+ * |  7:5  |4|3|2|1:0|
+ * +-------+-+-+-+---+
+ *     |    | | |  |
+ *     |    | | |  +-- Type of dispatch:to method, handler, notify, or none
+ *     |    | | +----- Interrupt type: edge or level triggered
+ *     |    | +------- Is a Wake GPE
+ *     |    +--------- Do not clear GPE automatically
  *     +------------ <Reserved>
  */
 #define ACPI_GPE_DISPATCH_NONE          (u8) 0x00
@@ -758,6 +759,7 @@ typedef u32 acpi_event_status;
 #define ACPI_GPE_XRUPT_TYPE_MASK        (u8) 0x04
 
 #define ACPI_GPE_CAN_WAKE               (u8) 0x08
+#define ACPI_GPE_NO_AUTO_CLEAR          (u8) 0x10
 
 /*
  * Flags for GPE and Lock interfaces
-- 
1.7.10

