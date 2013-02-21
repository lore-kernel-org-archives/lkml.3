Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3BUPj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:39:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722Ab3BUPjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:39:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Huang Ying <ying.huang@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH EDACv2 00/12] Add a driver to report Firmware first errors (via GHES)
Date: Thu, 21 Feb 2013 12:38:58 -0300
Message-Id: <cover.1361459782.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently 3 error mechanisms inside the Linux Kernel:
edac, mcelog and ghes.

Unfortunately, not all those error mechanisms will work at the same
time, as accessing the error registers by the BIOS may interfere on
reading them from OS.

So, all those 3 mechanisms need to be integrated, in order to avoid
such problems.

This patch series adds a new EDAC driver that uses "Firmware first"
APEI/GHES as an error report mechanism. It automatically disables
the hardware-driven EDAC drivers when GHES is enabled, preventing
to have both OS and BIOS to read at the very same error mechanisms.

It was tested on a "Lizard Head Pass" Intel machine, equipped with
BIOS SE5C600.86B.99.99.x059.091020121352 (09/10/2012).

Test results:

dmesg logs:
...
[  771.616999] mce: [Hardware Error]: Machine check events logged
[  771.623635] {3}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
[  771.632872] {3}[Hardware Error]: APEI generic hardware error status
[  771.639875] {3}[Hardware Error]: severity: 2, corrected
[  771.645708] {3}[Hardware Error]: section: 0, severity: 2, corrected
[  771.652704] {3}[Hardware Error]: flags: 0x01
[  771.657470] {3}[Hardware Error]: primary
[  771.661869] {3}[Hardware Error]: section_type: memory error
[  771.668103] {3}[Hardware Error]: error_status: 0x0000000000000400
[  771.674911] {3}[Hardware Error]: physical_address: 0x000000080b7f0000
[  771.682098] {3}[Hardware Error]: node: 0
[  771.686474] {3}[Hardware Error]: card: 0
[  771.690866] {3}[Hardware Error]: module: 0
[  771.695440] {3}[Hardware Error]: device: 0
[  771.700027] {3}[Hardware Error]: error_type: 18, unknown
[  771.706013] EDAC DEBUG: ghes_edac_report_mem_error: error validation_bits: 0x000040bb
[  771.706023] EDAC MC0: 1 CE reserved error (18) on unknown label (node:0 card:0 module:0 page:0x80b7f0 offset:0x0 grain:0 syndrome:0x0 - status(0x0000000000000400): Storage error in DRAM memory)

trace logs (for 3 injected errors):
# tracer: nop
#
# entries-in-buffer/entries-written: 3/3   #P:64
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
     kworker/0:2-590   [000] ....   120.908219: mc_event: 1 Corrected error: reserved error (18) on unknown label (mc:0 location:-1:-1:-1 address:0x00000000 grain:1 syndrome:0x00000000 APEI location: node:3 card:0 module:0 status(0x0000000000000400): Storage error in DRAM memory)
     kworker/0:2-590   [000] ....   281.557076: mc_event: 1 Corrected error: reserved error (18) on unknown label (mc:0 location:-1:-1:-1 address:0x00000000 grain:1 syndrome:0x00000000 APEI location: node:3 card:0 module:1 status(0x0000000000000400): Storage error in DRAM memory)
     kworker/0:1-1989  [000] ....   771.706018: mc_event: 1 Corrected error: reserved error (18) on unknown label (mc:0 location:-1:-1:-1 address:0x000080b7 grain:1 syndrome:0x00000000 APEI location: node:0 card:0 module:0 status(0x0000000000000400): Storage error in DRAM memory)

-
Version 2: 

- for the sake of focusing on the important patches, I removed
from this patch series 4 patches that were submitted on version 1
and are just trivial cleanups and a simple EDAC internal API addition:
	c2c93db - edac: remove proc_name from mci structure
	c66b5a7 - edac: add a new memory layer type
	4ab19b0 - edac: initialize the core earlier
	3d95882 - edac: better report error conditions in debug mode

Those 4 patches can be found on my experimental git tree, at:
	http://git.infradead.org/users/mchehab/edac.git/shortlog/refs/heads/experimental

- I added in this series the 6 additional patches that improve ghes_edac
  output;

- Several patches got fold, to keep the patch series clean. So, instead
  of having 13+6 patches, the entire series has now 12 patches;

- A new patch was added from Borislav's feedback about patch 07/13:
	3897b2a - edac: put all arguments for the raw error handling call into a struct (79 minutes ago)

- Patch 03/13 was changed according with Huang's feedback. It is now
  patch 04/12. Due to the removal of mci from ghes structure, patch
  05/12 was changed to store the ghes <==> mci association inside the
  driver's private data. Subsequent patches required changes as well
  to cope with the new way to retrieve data;

- the buffer usage by ghes_edac_report_mem_error() was reduced, by storing
  the temporary buffers inside the private structure;

- minor cleanups.

To help reviewers, I'm enclosing the diff between v1 and v2 at the end of
this email.

Mauro Carvalho Chehab (12):
  edac: add support for raw error reports
  edac: add support for error type "Info"
  ghes: move structures/enum to a header file
  ghes: add the needed hooks for EDAC error report
  ghes_edac: Register at EDAC core the BIOS report
  ghes_edac: add support for reporting errors via EDAC
  ghes_edac: do a better job of filling EDAC DIMM info
  ghes_edac: Don't credit the same memory dimm twice
  ghes_edac: Improve driver's printk messages
  edac: put all arguments for the raw error handling call into a struct
  ghes_edac: Make it compliant with UEFI spec 2.3.1
  ghes_edac: Fix RAS tracing

 MAINTAINERS              |   7 +
 drivers/acpi/apei/ghes.c |  71 ++-----
 drivers/edac/Kconfig     |  23 ++
 drivers/edac/Makefile    |   1 +
 drivers/edac/edac_core.h |   5 +
 drivers/edac/edac_mc.c   | 119 +++++++----
 drivers/edac/ghes_edac.c | 537 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/ghes.h      |  70 ++++++
 include/linux/edac.h     |  72 +++++++
 include/ras/ras_event.h  |   4 +-
 10 files changed, 814 insertions(+), 95 deletions(-)
 create mode 100644 drivers/edac/ghes_edac.c
 create mode 100644 include/acpi/ghes.h

----------------------------
Difference against version 1:
----------------------------

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index a21d7da..19092dc 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -903,6 +903,11 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		ghes = NULL;
 		goto err;
 	}
+
+	rc = ghes_edac_register(ghes, &ghes_dev->dev);
+	if (rc < 0)
+		goto err;
+
 	switch (generic->notify.type) {
 	case ACPI_HEST_NOTIFY_POLLED:
 		ghes->timer.function = ghes_poll_func;
@@ -915,13 +920,13 @@ static int ghes_probe(struct platform_device *ghes_dev)
 		if (acpi_gsi_to_irq(generic->notify.vector, &ghes->irq)) {
 			pr_err(GHES_PFX "Failed to map GSI to IRQ for generic hardware error source: %d\n",
 			       generic->header.source_id);
-			goto err;
+			goto err2;
 		}
 		if (request_irq(ghes->irq, ghes_irq_func,
 				0, "GHES IRQ", ghes)) {
 			pr_err(GHES_PFX "Failed to register IRQ for generic hardware error source: %d\n",
 			       generic->header.source_id);
-			goto err;
+			goto err2;
 		}
 		break;
 	case ACPI_HEST_NOTIFY_SCI:
@@ -946,11 +951,9 @@ static int ghes_probe(struct platform_device *ghes_dev)
 	}
 	platform_set_drvdata(ghes_dev, ghes);
 
-	rc = ghes_edac_register(ghes, &ghes_dev->dev);
-	if (rc < 0)
-		goto err;
-
 	return 0;
+err2:
+	ghes_edac_unregister(ghes);
 err:
 	if (ghes) {
 		ghes_fini(ghes);
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 8d89bc0..cdb81aa 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -818,9 +818,8 @@ struct mem_ctl_info *edac_mc_del_mc(struct device *dev)
 		return NULL;
 	}
 
-	if (!del_mc_from_global_list(mci)) {
+	if (!del_mc_from_global_list(mci))
 		edac_mc_owner = NULL;
-	}
 	mutex_unlock(&mem_ctls_mutex);
 
 	/* flush workq processes */
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 2126aab..636dcf1 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -19,6 +19,18 @@
 
 #define GHES_EDAC_REVISION " Ver: 1.0.0"
 
+struct ghes_edac_pvt {
+	struct list_head list;
+	struct ghes *ghes;
+	struct mem_ctl_info *mci;
+
+	/* Buffers for the error handling routine */
+	char detail_location[240];
+	char other_detail[160];
+	char msg[80];
+};
+
+static LIST_HEAD(ghes_reglist);
 static DEFINE_MUTEX(ghes_edac_lock);
 static int ghes_edac_mc_num;
 
@@ -107,7 +119,7 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 				dimm->nr_pages = MiB_TO_PAGES(entry->size);
 		}
 
-		switch(entry->memory_type) {
+		switch (entry->memory_type) {
 		case 0x12:
 			if (entry->type_detail & 1 << 13)
 				dimm->mtype = MEM_RDDR;
@@ -163,7 +175,7 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 			edac_dbg(1, "DIMM%i: %s size = %d MB%s\n",
 				dimm_fill->count, memory_type[dimm->mtype],
 				PAGES_TO_MiB(dimm->nr_pages),
-				(dimm->edac_mode != EDAC_NONE)? "(ECC)" : "");
+				(dimm->edac_mode != EDAC_NONE) ? "(ECC)" : "");
 			edac_dbg(2, "\ttype %d, detail 0x%02x, width %d(total %d)\n",
 				entry->memory_type, entry->type_detail,
 				entry->total_width, entry->data_width);
@@ -174,27 +186,39 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 }
 
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
-			        struct cper_sec_mem_err *mem_err)
+				struct cper_sec_mem_err *mem_err)
 {
-	struct edac_raw_error_desc *e = &ghes->mci->error_desc;
 	enum hw_event_mc_err_type type;
-	char detail_location[240];
-	char other_detail[160] = "";
-	char msg[40] = "";
+	struct edac_raw_error_desc *e;
+	struct mem_ctl_info *mci;
+	struct ghes_edac_pvt *pvt = NULL;
 	char *p;
 	u8 grain_bits;
 
+	list_for_each_entry(pvt, &ghes_reglist, list) {
+		if (ghes == pvt->ghes)
+			break;
+	}
+	if (!pvt) {
+		pr_err("Internal error: Can't find EDAC structure\n");
+		return;
+	}
+	mci = pvt->mci;
+	e = &mci->error_desc;
+
 	/* Cleans the error report buffer */
 	memset(e, 0, sizeof (*e));
 	e->error_count = 1;
 	strcpy(e->label, "unknown label");
-	e->msg = msg;
-	e->other_detail = other_detail;
+	e->msg = pvt->msg;
+	e->other_detail = pvt->other_detail;
 	e->top_layer = -1;
 	e->mid_layer = -1;
 	e->low_layer = -1;
+	*pvt->other_detail = '\0';
+	*pvt->msg = '\0';
 
-	switch(sev) {
+	switch (sev) {
 	case GHES_SEV_CORRECTED:
 		type = HW_EVENT_ERR_CORRECTED;
 		break;
@@ -209,9 +233,12 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		type = HW_EVENT_ERR_INFO;
 	}
 
+	edac_dbg(1, "error validation_bits: 0x%08llx\n",
+		 (long long)mem_err->validation_bits);
+
 	/* Error type, mapped on e->msg */
 	if (mem_err->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
-		p = msg;
+		p = pvt->msg;
 		switch (mem_err->error_type) {
 		case 0:
 			p += sprintf(p, "Unknown");
@@ -266,7 +293,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 				     mem_err->error_type);
 		}
 	} else {
-		strcpy(msg, "unknown error");
+		strcpy(pvt->msg, "unknown error");
 	}
 
 	/* Error address */
@@ -300,7 +327,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		*(p - 1) = '\0';
 
 	/* All other fields are mapped on e->other_detail */
-	p= other_detail;
+	p = pvt->other_detail;
 	if (mem_err->validation_bits & CPER_MEM_VALID_ERROR_STATUS) {
 		u64 status = mem_err->error_status;
 
@@ -313,7 +340,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 			p += sprintf(p, "Error detected in the bus ");
 			break;
 		case 4:
-			p += sprintf(p, "Storage error in memory (DRAM) ");
+			p += sprintf(p, "Storage error in DRAM memory ");
 			break;
 		case 5:
 			p += sprintf(p, "Storage error in TLB ");
@@ -346,7 +373,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 			p += sprintf(p, "Response not associated with a request ");
 			break;
 		case 22:
-			p += sprintf(p, "Bus parity error (must also set the A, C, or D Bits) ");
+			p += sprintf(p, "Bus parity error - must also set the A, C, or D Bits ");
 			break;
 		case 23:
 			p += sprintf(p, "Detection of a PATH_ERROR ");
@@ -363,29 +390,28 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		}
 	}
 	if (mem_err->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
-		p += sprintf(p, "requestor ID: 0x%016llx ",
+		p += sprintf(p, "requestorID: 0x%016llx ",
 			     (long long)mem_err->requestor_id);
 	if (mem_err->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
-		p += sprintf(p, "responder ID: 0x%016llx ",
+		p += sprintf(p, "responderID: 0x%016llx ",
 			     (long long)mem_err->responder_id);
 	if (mem_err->validation_bits & CPER_MEM_VALID_TARGET_ID)
-		p += sprintf(p, "target ID: 0x%016llx ",
+		p += sprintf(p, "targetID: 0x%016llx ",
 			     (long long)mem_err->responder_id);
-	if (p > other_detail)
+	if (p > pvt->other_detail)
 		*(p - 1) = '\0';
 
 	/* Generate the trace event */
 	grain_bits = fls_long(e->grain);
-	sprintf(detail_location, "APEI location: %s %s",
+	sprintf(pvt->detail_location, "APEI location: %s %s",
 		e->location, e->other_detail);
 	trace_mc_event(type, e->msg, e->label, e->error_count,
-		       ghes->mci->mc_idx,
-		       e->top_layer, e->mid_layer, e->low_layer,
+		       mci->mc_idx, e->top_layer, e->mid_layer, e->low_layer,
 		       PAGES_TO_MiB(e->page_frame_number) | e->offset_in_page,
-		       grain_bits, e->syndrome, detail_location);
+		       grain_bits, e->syndrome, pvt->detail_location);
 
 	/* Report the error via EDAC API */
-	edac_raw_mc_handle_error(type, ghes->mci, e);
+	edac_raw_mc_handle_error(type, mci, e);
 }
 EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
 
@@ -395,6 +421,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	int rc, num_dimm = 0;
 	struct mem_ctl_info *mci;
 	struct edac_mc_layer layers[1];
+	struct ghes_edac_pvt *pvt;
 	struct ghes_edac_dimm_fill dimm_fill;
 
 	/* Get the number of DIMMs */
@@ -415,14 +442,19 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	 * to avoid duplicated memory controller numbers
 	 */
 	mutex_lock(&ghes_edac_lock);
-	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers, 0);
+	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers,
+			    sizeof(*pvt));
 	if (!mci) {
 		pr_info("Can't allocate memory for EDAC data\n");
 		mutex_unlock(&ghes_edac_lock);
 		return -ENOMEM;
 	}
 
-	mci->pvt_info = ghes;
+	pvt = mci->pvt_info;
+	memset(pvt, 0, sizeof(*pvt));
+	list_add_tail(&pvt->list, &ghes_reglist);
+	pvt->ghes = ghes;
+	pvt->mci  = mci;
 	mci->pdev = dev;
 
 	mci->mtype_cap = MEM_FLAG_EMPTY;
@@ -461,7 +493,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 		if (!ghes_edac_mc_num) {
 			dimm_fill.count = 0;
 			dimm_fill.mci = mci;
-			dmi_walk (ghes_edac_dmidecode, &dimm_fill);
+			dmi_walk(ghes_edac_dmidecode, &dimm_fill);
 		}
 	} else {
 		struct dimm_info *dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
@@ -482,8 +514,6 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 		return -ENODEV;
 	}
 
-
-	ghes->mci = mci;
 	ghes_edac_mc_num++;
 	mutex_unlock(&ghes_edac_lock);
 	return 0;
@@ -492,12 +522,16 @@ EXPORT_SYMBOL_GPL(ghes_edac_register);
 
 void ghes_edac_unregister(struct ghes *ghes)
 {
-	struct mem_ctl_info *mci = ghes->mci;
-
-	if (!mci)
-		return;
-
-	edac_mc_del_mc(mci->pdev);
-	edac_mc_free(mci);
+	struct mem_ctl_info *mci;
+	struct ghes_edac_pvt *pvt;
+
+	list_for_each_entry(pvt, &ghes_reglist, list) {
+		if (ghes == pvt->ghes) {
+			mci = pvt->mci;
+			edac_mc_del_mc(mci->pdev);
+			edac_mc_free(mci);
+			list_del(&pvt->list);
+		}
+	}
 }
 EXPORT_SYMBOL_GPL(ghes_edac_unregister);
diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
index c6fef72..9015ec2 100644
--- a/include/acpi/ghes.h
+++ b/include/acpi/ghes.h
@@ -22,8 +22,6 @@ struct ghes {
 		struct timer_list timer;
 		unsigned int irq;
 	};
-
-	struct mem_ctl_info *mci;
 };
 
 struct ghes_estatus_node {

