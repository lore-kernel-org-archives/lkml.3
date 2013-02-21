Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3BUPjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:39:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab3BUPjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:39:41 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDACv2 12/12] ghes_edac: Fix RAS tracing
Date: Thu, 21 Feb 2013 12:39:10 -0300
Message-Id: <ca154bf4bb0ee52ef1d43baa576c640620e12492.1361459782.git.mchehab@redhat.com>
In-Reply-To: <cover.1361459782.git.mchehab@redhat.com>
References: <cover.1361459782.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current version of CPER, there's no way to associate an
error with the memory error. So, the error location in EDAC
layers is unused.

As CPER has its own idea about memory architectural layers, just
output whatever is there inside the driver's detail at the RAS
tracepoint.

The EDAC location keeps untouched, in the case that, in some future,
we could actually map the error into the dimm labels.

Now, the error message:

[   72.396625] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
[   72.396627] {1}[Hardware Error]: APEI generic hardware error status
[   72.396628] {1}[Hardware Error]: severity: 2, corrected
[   72.396630] {1}[Hardware Error]: section: 0, severity: 2, corrected
[   72.396632] {1}[Hardware Error]: flags: 0x01
[   72.396634] {1}[Hardware Error]: primary
[   72.396635] {1}[Hardware Error]: section_type: memory error
[   72.396637] {1}[Hardware Error]: error_status: 0x0000000000000400
[   72.396638] {1}[Hardware Error]: node: 3
[   72.396639] {1}[Hardware Error]: card: 0
[   72.396640] {1}[Hardware Error]: module: 0
[   72.396641] {1}[Hardware Error]: device: 0
[   72.396643] {1}[Hardware Error]: error_type: 18, unknown
[   72.396666] EDAC MC0: 1 CE reserved error (18) on unknown label (node:3 card:0 module:0 page:0x0 offset:0x0 grain:0 syndrome:0x0 - status(0x0000000000000400): Storage error in DRAM memory)

Is properly represented on the trace event:

     kworker/0:2-584   [000] ....    72.396657: mc_event: 1 Corrected error: reserved error (18) on unknown label (mc:0 location:-1:-1:-1 address:0x00000000 grain:1 syndrome:0x00000000 APEI location: node:3 card:0 module:0 status(0x0000000000000400): Storage error in DRAM memory)

Tested on a 4 sockets E5-4650 Sandy Bridge machine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c   | 16 ++++++++--------
 drivers/edac/ghes_edac.c | 13 +++++++++++++
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 501061d..cdb81aa 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1082,16 +1082,8 @@ void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
 			      struct edac_raw_error_desc *e)
 {
 	char detail[80];
-	u8 grain_bits;
 	int pos[EDAC_MAX_LAYERS] = { e->top_layer, e->mid_layer, e->low_layer };
 
-	/* Report the error via the trace interface */
-	grain_bits = fls_long(e->grain) + 1;
-	trace_mc_event(type, e->msg, e->label, e->error_count,
-		       mci->mc_idx, e->top_layer, e->mid_layer, e->low_layer,
-		       PAGES_TO_MiB(e->page_frame_number) | e->offset_in_page,
-		       grain_bits, e->syndrome, e->other_detail);
-
 	/* Memory type dependent details about the error */
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		snprintf(detail, sizeof(detail),
@@ -1148,6 +1140,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	int row = -1, chan = -1;
 	int pos[EDAC_MAX_LAYERS] = { top_layer, mid_layer, low_layer };
 	int i, n_labels = 0;
+	u8 grain_bits;
 	struct edac_raw_error_desc *e = &mci->error_desc;
 
 	edac_dbg(3, "MC%d\n", mci->mc_idx);
@@ -1287,6 +1280,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (p > e->location)
 		*(p - 1) = '\0';
 
+	/* Report the error via the trace interface */
+	grain_bits = fls_long(e->grain) + 1;
+	trace_mc_event(type, e->msg, e->label, e->error_count,
+		       mci->mc_idx, e->top_layer, e->mid_layer, e->low_layer,
+		       PAGES_TO_MiB(e->page_frame_number) | e->offset_in_page,
+		       grain_bits, e->syndrome, e->other_detail);
+
 	edac_raw_mc_handle_error(type, mci, e);
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 1bde451..636dcf1 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -15,6 +15,7 @@
 #include <linux/edac.h>
 #include <linux/dmi.h>
 #include "edac_core.h"
+#include <ras/ras_event.h>
 
 #define GHES_EDAC_REVISION " Ver: 1.0.0"
 
@@ -24,6 +25,7 @@ struct ghes_edac_pvt {
 	struct mem_ctl_info *mci;
 
 	/* Buffers for the error handling routine */
+	char detail_location[240];
 	char other_detail[160];
 	char msg[80];
 };
@@ -191,6 +193,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 	struct mem_ctl_info *mci;
 	struct ghes_edac_pvt *pvt = NULL;
 	char *p;
+	u8 grain_bits;
 
 	list_for_each_entry(pvt, &ghes_reglist, list) {
 		if (ghes == pvt->ghes)
@@ -398,6 +401,16 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 	if (p > pvt->other_detail)
 		*(p - 1) = '\0';
 
+	/* Generate the trace event */
+	grain_bits = fls_long(e->grain);
+	sprintf(pvt->detail_location, "APEI location: %s %s",
+		e->location, e->other_detail);
+	trace_mc_event(type, e->msg, e->label, e->error_count,
+		       mci->mc_idx, e->top_layer, e->mid_layer, e->low_layer,
+		       PAGES_TO_MiB(e->page_frame_number) | e->offset_in_page,
+		       grain_bits, e->syndrome, pvt->detail_location);
+
+	/* Report the error via EDAC API */
 	edac_raw_mc_handle_error(type, mci, e);
 }
 EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
-- 
1.8.1.2

