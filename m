Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaD3CHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:07:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:17252 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaD3CHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:07:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="503429231"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 25/27] ACPICA: Events: Update GPE handling and initialization code.
Date: Wed, 30 Apr 2014 10:06:15 +0800
Message-Id: <225a9f1bc5de7a9ec5c606bd0eccb65cfd0f545d.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

1) Eliminate most use of GAS structs, since they are not needed
for GPEs.
2) Allow raw GPE numbers > 255.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acevents.h  |    5 +++--
 drivers/acpi/acpica/aclocal.h   |    9 +++++----
 drivers/acpi/acpica/evgpe.c     |   13 +++++++------
 drivers/acpi/acpica/evgpeblk.c  |   34 ++++++++++++++++------------------
 drivers/acpi/acpica/evgpeinit.c |   12 ++++++++----
 drivers/acpi/acpica/evxfgpe.c   |    7 ++++---
 6 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index 68ec61f..7a7811a 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -104,9 +104,10 @@ acpi_status acpi_ev_finish_gpe(struct acpi_gpe_event_info *gpe_event_info);
  */
 acpi_status
 acpi_ev_create_gpe_block(struct acpi_namespace_node *gpe_device,
-			 struct acpi_generic_address *gpe_block_address,
+			 u64 address,
+			 u8 space_id,
 			 u32 register_count,
-			 u8 gpe_block_base_number,
+			 u16 gpe_block_base_number,
 			 u32 interrupt_number,
 			 struct acpi_gpe_block_info **return_gpe_block);
 
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index f68cb60..91f801a 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -450,9 +450,9 @@ struct acpi_gpe_event_info {
 struct acpi_gpe_register_info {
 	struct acpi_generic_address status_address;	/* Address of status reg */
 	struct acpi_generic_address enable_address;	/* Address of enable reg */
+	u16 base_gpe_number;	/* Base GPE number for this register */
 	u8 enable_for_wake;	/* GPEs to keep enabled when sleeping */
 	u8 enable_for_run;	/* GPEs to keep enabled when running */
-	u8 base_gpe_number;	/* Base GPE number for this register */
 };
 
 /*
@@ -466,11 +466,12 @@ struct acpi_gpe_block_info {
 	struct acpi_gpe_xrupt_info *xrupt_block;	/* Backpointer to interrupt block */
 	struct acpi_gpe_register_info *register_info;	/* One per GPE register pair */
 	struct acpi_gpe_event_info *event_info;	/* One for each GPE */
-	struct acpi_generic_address block_address;	/* Base address of the block */
+	u64 address;		/* Base address of the block */
 	u32 register_count;	/* Number of register pairs in block */
 	u16 gpe_count;		/* Number of individual GPEs in block */
-	u8 block_base_number;	/* Base GPE number for this block */
-	u8 initialized;         /* TRUE if this block is initialized */
+	u16 block_base_number;	/* Base GPE number for this block */
+	u8 space_id;
+	u8 initialized;		/* TRUE if this block is initialized */
 };
 
 /* Information about GPE interrupt handlers, one per each interrupt level used for GPEs */
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 955f83d..48f7001 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -383,7 +383,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 			if (!(gpe_register_info->enable_for_run |
 			      gpe_register_info->enable_for_wake)) {
 				ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
-						  "Ignore disabled registers for GPE%02X-GPE%02X: "
+						  "Ignore disabled registers for GPE %02X-%02X: "
 						  "RunEnable=%02X, WakeEnable=%02X\n",
 						  gpe_register_info->
 						  base_gpe_number,
@@ -416,7 +416,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 			}
 
 			ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
-					  "Read registers for GPE%02X-GPE%02X: Status=%02X, Enable=%02X, "
+					  "Read registers for GPE %02X-%02X: Status=%02X, Enable=%02X, "
 					  "RunEnable=%02X, WakeEnable=%02X\n",
 					  gpe_register_info->base_gpe_number,
 					  gpe_register_info->base_gpe_number +
@@ -706,7 +706,8 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 		status = acpi_hw_clear_gpe(gpe_event_info);
 		if (ACPI_FAILURE(status)) {
 			ACPI_EXCEPTION((AE_INFO, status,
-					"Unable to clear GPE%02X", gpe_number));
+					"Unable to clear GPE %02X",
+					gpe_number));
 			return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
 		}
 	}
@@ -723,7 +724,7 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 	status = acpi_hw_low_set_gpe(gpe_event_info, ACPI_GPE_DISABLE);
 	if (ACPI_FAILURE(status)) {
 		ACPI_EXCEPTION((AE_INFO, status,
-				"Unable to disable GPE%02X", gpe_number));
+				"Unable to disable GPE %02X", gpe_number));
 		return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
 	}
 
@@ -764,7 +765,7 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 					 gpe_event_info);
 		if (ACPI_FAILURE(status)) {
 			ACPI_EXCEPTION((AE_INFO, status,
-					"Unable to queue handler for GPE%02X - event disabled",
+					"Unable to queue handler for GPE %02X - event disabled",
 					gpe_number));
 		}
 		break;
@@ -776,7 +777,7 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 		 * a GPE to be enabled if it has no handler or method.
 		 */
 		ACPI_ERROR((AE_INFO,
-			    "No handler or method for GPE%02X, disabling event",
+			    "No handler or method for GPE %02X, disabling event",
 			    gpe_number));
 
 		break;
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
index caaed3c..d86699e 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -252,21 +252,17 @@ acpi_ev_create_gpe_info_blocks(struct acpi_gpe_block_info *gpe_block)
 
 		/* Init the register_info for this GPE register (8 GPEs) */
 
-		this_register->base_gpe_number =
-		    (u8) (gpe_block->block_base_number +
-			  (i * ACPI_GPE_REGISTER_WIDTH));
+		this_register->base_gpe_number = (u16)
+		    (gpe_block->block_base_number +
+		     (i * ACPI_GPE_REGISTER_WIDTH));
 
-		this_register->status_address.address =
-		    gpe_block->block_address.address + i;
+		this_register->status_address.address = gpe_block->address + i;
 
 		this_register->enable_address.address =
-		    gpe_block->block_address.address + i +
-		    gpe_block->register_count;
+		    gpe_block->address + i + gpe_block->register_count;
 
-		this_register->status_address.space_id =
-		    gpe_block->block_address.space_id;
-		this_register->enable_address.space_id =
-		    gpe_block->block_address.space_id;
+		this_register->status_address.space_id = gpe_block->space_id;
+		this_register->enable_address.space_id = gpe_block->space_id;
 		this_register->status_address.bit_width =
 		    ACPI_GPE_REGISTER_WIDTH;
 		this_register->enable_address.bit_width =
@@ -334,9 +330,10 @@ error_exit:
 
 acpi_status
 acpi_ev_create_gpe_block(struct acpi_namespace_node *gpe_device,
-			 struct acpi_generic_address *gpe_block_address,
+			 u64 address,
+			 u8 space_id,
 			 u32 register_count,
-			 u8 gpe_block_base_number,
+			 u16 gpe_block_base_number,
 			 u32 interrupt_number,
 			 struct acpi_gpe_block_info **return_gpe_block)
 {
@@ -359,15 +356,14 @@ acpi_ev_create_gpe_block(struct acpi_namespace_node *gpe_device,
 
 	/* Initialize the new GPE block */
 
+	gpe_block->address = address;
+	gpe_block->space_id = space_id;
 	gpe_block->node = gpe_device;
 	gpe_block->gpe_count = (u16)(register_count * ACPI_GPE_REGISTER_WIDTH);
 	gpe_block->initialized = FALSE;
 	gpe_block->register_count = register_count;
 	gpe_block->block_base_number = gpe_block_base_number;
 
-	ACPI_MEMCPY(&gpe_block->block_address, gpe_block_address,
-		    sizeof(struct acpi_generic_address));
-
 	/*
 	 * Create the register_info and event_info sub-structures
 	 * Note: disables and clears all GPEs in the block
@@ -408,12 +404,14 @@ acpi_ev_create_gpe_block(struct acpi_namespace_node *gpe_device,
 	}
 
 	ACPI_DEBUG_PRINT_RAW((ACPI_DB_INIT,
-			      "    Initialized GPE %02X to %02X [%4.4s] %u regs on interrupt 0x%X\n",
+			      "    Initialized GPE %02X to %02X [%4.4s] %u regs on interrupt 0x%X%s\n",
 			      (u32)gpe_block->block_base_number,
 			      (u32)(gpe_block->block_base_number +
 				    (gpe_block->gpe_count - 1)),
 			      gpe_device->name.ascii, gpe_block->register_count,
-			      interrupt_number));
+			      interrupt_number,
+			      interrupt_number ==
+			      acpi_gbl_FADT.sci_interrupt ? " (SCI)" : ""));
 
 	/* Update global count of currently available GPEs */
 
diff --git a/drivers/acpi/acpica/evgpeinit.c b/drivers/acpi/acpica/evgpeinit.c
index ae779c1..49fc7ef 100644
--- a/drivers/acpi/acpica/evgpeinit.c
+++ b/drivers/acpi/acpica/evgpeinit.c
@@ -131,8 +131,10 @@ acpi_status acpi_ev_gpe_initialize(void)
 		/* Install GPE Block 0 */
 
 		status = acpi_ev_create_gpe_block(acpi_gbl_fadt_gpe_device,
-						  &acpi_gbl_FADT.xgpe0_block,
-						  register_count0, 0,
+						  acpi_gbl_FADT.xgpe0_block.
+						  address,
+						  acpi_gbl_FADT.xgpe0_block.
+						  space_id, register_count0, 0,
 						  acpi_gbl_FADT.sci_interrupt,
 						  &acpi_gbl_gpe_fadt_blocks[0]);
 
@@ -169,8 +171,10 @@ acpi_status acpi_ev_gpe_initialize(void)
 
 			status =
 			    acpi_ev_create_gpe_block(acpi_gbl_fadt_gpe_device,
-						     &acpi_gbl_FADT.xgpe1_block,
-						     register_count1,
+						     acpi_gbl_FADT.xgpe1_block.
+						     address,
+						     acpi_gbl_FADT.xgpe1_block.
+						     space_id, register_count1,
 						     acpi_gbl_FADT.gpe1_base,
 						     acpi_gbl_FADT.
 						     sci_interrupt,
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 20a1392..cb534fa 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -599,9 +599,10 @@ acpi_install_gpe_block(acpi_handle gpe_device,
 	 * For user-installed GPE Block Devices, the gpe_block_base_number
 	 * is always zero
 	 */
-	status =
-	    acpi_ev_create_gpe_block(node, gpe_block_address, register_count, 0,
-				     interrupt_number, &gpe_block);
+	status = acpi_ev_create_gpe_block(node, gpe_block_address->address,
+					  gpe_block_address->space_id,
+					  register_count, 0, interrupt_number,
+					  &gpe_block);
 	if (ACPI_FAILURE(status)) {
 		goto unlock_and_exit;
 	}
-- 
1.7.10

