Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab3BUPj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:39:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875Ab3BUPjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:39:39 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDACv2 11/12] ghes_edac: Make it compliant with UEFI spec 2.3.1
Date: Thu, 21 Feb 2013 12:39:09 -0300
Message-Id: <189f4ddfb9b5ee6e2411f10fe589e856ac34a26a.1361459782.git.mchehab@redhat.com>
In-Reply-To: <cover.1361459782.git.mchehab@redhat.com>
References: <cover.1361459782.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UEFI spec defines the memory error types ans the bits that
validate each field on the memory error record, at
Appendix N om items N.2.5 (Memory Error Section) and
N.2.11 (Error Status). Make the error description compliant with
it, only showing the valid fields.

The EDAC error log is now properly reporting the error:

[  281.556854] mce: [Hardware Error]: Machine check events logged
[  281.557042] {2}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
[  281.557044] {2}[Hardware Error]: APEI generic hardware error status
[  281.557046] {2}[Hardware Error]: severity: 2, corrected
[  281.557048] {2}[Hardware Error]: section: 0, severity: 2, corrected
[  281.557050] {2}[Hardware Error]: flags: 0x01
[  281.557052] {2}[Hardware Error]: primary
[  281.557053] {2}[Hardware Error]: section_type: memory error
[  281.557055] {2}[Hardware Error]: error_status: 0x0000000000000400
[  281.557056] {2}[Hardware Error]: node: 3
[  281.557057] {2}[Hardware Error]: card: 0
[  281.557058] {2}[Hardware Error]: module: 1
[  281.557059] {2}[Hardware Error]: device: 0
[  281.557061] {2}[Hardware Error]: error_type: 18, unknown
[  281.557067] EDAC DEBUG: ghes_edac_report_mem_error: error validation_bits: 0x000040b9
[  281.557084] EDAC MC0: 1 CE reserved error (18) on unknown label (node:3 card:0 module:1 page:0x0 offset:0x0 grain:0 syndrome:0x0 - status(0x0000000000000400): Storage error in DRAM memory)

Tested on a 4 CPUs E5-4650 Sandy Bridge machine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 195 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 180 insertions(+), 15 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index b4acc4f..1bde451 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -22,6 +22,10 @@ struct ghes_edac_pvt {
 	struct list_head list;
 	struct ghes *ghes;
 	struct mem_ctl_info *mci;
+
+	/* Buffers for the error handling routine */
+	char other_detail[160];
+	char msg[80];
 };
 
 static LIST_HEAD(ghes_reglist);
@@ -186,6 +190,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 	struct edac_raw_error_desc *e;
 	struct mem_ctl_info *mci;
 	struct ghes_edac_pvt *pvt = NULL;
+	char *p;
 
 	list_for_each_entry(pvt, &ghes_reglist, list) {
 		if (ghes == pvt->ghes)
@@ -201,15 +206,14 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 	/* Cleans the error report buffer */
 	memset(e, 0, sizeof (*e));
 	e->error_count = 1;
-	e->msg = "APEI";
-	strcpy(e->label, "unknown");
-	e->other_detail = "";
-
-	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
-		e->page_frame_number = mem_err->physical_addr >> PAGE_SHIFT;
-		e->offset_in_page = mem_err->physical_addr & ~PAGE_MASK;
-		e->grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
-	}
+	strcpy(e->label, "unknown label");
+	e->msg = pvt->msg;
+	e->other_detail = pvt->other_detail;
+	e->top_layer = -1;
+	e->mid_layer = -1;
+	e->low_layer = -1;
+	*pvt->other_detail = '\0';
+	*pvt->msg = '\0';
 
 	switch (sev) {
 	case GHES_SEV_CORRECTED:
@@ -226,12 +230,173 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		type = HW_EVENT_ERR_INFO;
 	}
 
-	sprintf(e->location,
-		"node:%d card:%d module:%d bank:%d device:%d row: %d column:%d bit_pos:%d",
-		mem_err->node, mem_err->card, mem_err->module,
-		mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
-		mem_err->bit_pos);
-	edac_dbg(3, "error at location %s\n", e->location);
+	edac_dbg(1, "error validation_bits: 0x%08llx\n",
+		 (long long)mem_err->validation_bits);
+
+	/* Error type, mapped on e->msg */
+	if (mem_err->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
+		p = pvt->msg;
+		switch (mem_err->error_type) {
+		case 0:
+			p += sprintf(p, "Unknown");
+			break;
+		case 1:
+			p += sprintf(p, "No error");
+			break;
+		case 2:
+			p += sprintf(p, "Single-bit ECC");
+			break;
+		case 3:
+			p += sprintf(p, "Multi-bit ECC");
+			break;
+		case 4:
+			p += sprintf(p, "Single-symbol ChipKill ECC");
+			break;
+		case 5:
+			p += sprintf(p, "Multi-symbol ChipKill ECC");
+			break;
+		case 6:
+			p += sprintf(p, "Master abort");
+			break;
+		case 7:
+			p += sprintf(p, "Target abort");
+			break;
+		case 8:
+			p += sprintf(p, "Parity Error");
+			break;
+		case 9:
+			p += sprintf(p, "Watchdog timeout");
+			break;
+		case 10:
+			p += sprintf(p, "Invalid address");
+			break;
+		case 11:
+			p += sprintf(p, "Mirror Broken");
+			break;
+		case 12:
+			p += sprintf(p, "Memory Sparing");
+			break;
+		case 13:
+			p += sprintf(p, "Scrub corrected error");
+			break;
+		case 14:
+			p += sprintf(p, "Scrub uncorrected error");
+			break;
+		case 15:
+			p += sprintf(p, "Physical Memory Map-out event");
+			break;
+		default:
+			p += sprintf(p, "reserved error (%d)",
+				     mem_err->error_type);
+		}
+	} else {
+		strcpy(pvt->msg, "unknown error");
+	}
+
+	/* Error address */
+	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+		e->page_frame_number = mem_err->physical_addr >> PAGE_SHIFT;
+		e->offset_in_page = mem_err->physical_addr & ~PAGE_MASK;
+	}
+
+	/* Error grain */
+	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK) {
+		e->grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
+	}
+
+	/* Memory error location, mapped on e->location */
+	p = e->location;
+	if (mem_err->validation_bits & CPER_MEM_VALID_NODE)
+		p += sprintf(p, "node:%d ", mem_err->node);
+	if (mem_err->validation_bits & CPER_MEM_VALID_CARD)
+		p += sprintf(p, "card:%d ", mem_err->card);
+	if (mem_err->validation_bits & CPER_MEM_VALID_MODULE)
+		p += sprintf(p, "module:%d ", mem_err->module);
+	if (mem_err->validation_bits & CPER_MEM_VALID_BANK)
+		p += sprintf(p, "bank:%d ", mem_err->bank);
+	if (mem_err->validation_bits & CPER_MEM_VALID_ROW)
+		p += sprintf(p, "row:%d ", mem_err->row);
+	if (mem_err->validation_bits & CPER_MEM_VALID_COLUMN)
+		p += sprintf(p, "col:%d ", mem_err->column);
+	if (mem_err->validation_bits & CPER_MEM_VALID_BIT_POSITION)
+		p += sprintf(p, "bit_pos:%d ", mem_err->bit_pos);
+	if (p > e->location)
+		*(p - 1) = '\0';
+
+	/* All other fields are mapped on e->other_detail */
+	p = pvt->other_detail;
+	if (mem_err->validation_bits & CPER_MEM_VALID_ERROR_STATUS) {
+		u64 status = mem_err->error_status;
+
+		p += sprintf(p, "status(0x%016llx): ", (long long)status);
+		switch ((status >> 8) & 0xff) {
+		case 1:
+			p += sprintf(p, "Error detected internal to the component ");
+			break;
+		case 16:
+			p += sprintf(p, "Error detected in the bus ");
+			break;
+		case 4:
+			p += sprintf(p, "Storage error in DRAM memory ");
+			break;
+		case 5:
+			p += sprintf(p, "Storage error in TLB ");
+			break;
+		case 6:
+			p += sprintf(p, "Storage error in cache ");
+			break;
+		case 7:
+			p += sprintf(p, "Error in one or more functional units ");
+			break;
+		case 8:
+			p += sprintf(p, "component failed self test ");
+			break;
+		case 9:
+			p += sprintf(p, "Overflow or undervalue of internal queue ");
+			break;
+		case 17:
+			p += sprintf(p, "Virtual address not found on IO-TLB or IO-PDIR ");
+			break;
+		case 18:
+			p += sprintf(p, "Improper access error ");
+			break;
+		case 19:
+			p += sprintf(p, "Access to a memory address which is not mapped to any component ");
+			break;
+		case 20:
+			p += sprintf(p, "Loss of Lockstep ");
+			break;
+		case 21:
+			p += sprintf(p, "Response not associated with a request ");
+			break;
+		case 22:
+			p += sprintf(p, "Bus parity error - must also set the A, C, or D Bits ");
+			break;
+		case 23:
+			p += sprintf(p, "Detection of a PATH_ERROR ");
+			break;
+		case 25:
+			p += sprintf(p, "Bus operation timeout ");
+			break;
+		case 26:
+			p += sprintf(p, "A read was issued to data that has been poisoned ");
+			break;
+		default:
+			p += sprintf(p, "reserved ");
+			break;
+		}
+	}
+	if (mem_err->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
+		p += sprintf(p, "requestorID: 0x%016llx ",
+			     (long long)mem_err->requestor_id);
+	if (mem_err->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
+		p += sprintf(p, "responderID: 0x%016llx ",
+			     (long long)mem_err->responder_id);
+	if (mem_err->validation_bits & CPER_MEM_VALID_TARGET_ID)
+		p += sprintf(p, "targetID: 0x%016llx ",
+			     (long long)mem_err->responder_id);
+	if (p > pvt->other_detail)
+		*(p - 1) = '\0';
 
 	edac_raw_mc_handle_error(type, mci, e);
 }
-- 
1.8.1.2

