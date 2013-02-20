Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935272Ab3BTLN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:13:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935237Ab3BTLNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:13:06 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 6/6] ghes_edac: Fix RAS tracing
Date: Wed, 20 Feb 2013 08:12:52 -0300
Message-Id: <13e7eeb2d8892a01f096694e37ce53f2f038659d.1361358127.git.mchehab@redhat.com>
In-Reply-To: <cover.1361358127.git.mchehab@redhat.com>
References: <cover.1361358127.git.mchehab@redhat.com>
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

[   61.562475] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 0
[   61.562477] {1}[Hardware Error]: APEI generic hardware error status
[   61.562479] {1}[Hardware Error]: severity: 2, corrected
[   61.562481] {1}[Hardware Error]: section: 0, severity: 2, corrected
[   61.562483] {1}[Hardware Error]: flags: 0x01
[   61.562485] {1}[Hardware Error]: primary
[   61.562486] {1}[Hardware Error]: section_type: memory error
[   61.562488] {1}[Hardware Error]: error_status: 0x0000000000000400
[   61.562489] {1}[Hardware Error]: node: 3
[   61.562490] {1}[Hardware Error]: card: 0
[   61.562491] {1}[Hardware Error]: module: 1
[   61.562492] {1}[Hardware Error]: device: 0
[   61.562493] {1}[Hardware Error]: error_type: 18, unknown
[   61.562518] EDAC MC0: 1 CE reserved error (18) on unknown label (node:3 card:0 module:1 page:0x0 offset:0x0 grain:0 syndrome:0x0 - status(0x0000000000000400): Storage error in memory (DRAM))

Is properly represented on the trace event:

mc_event: 1 Corrected error: reserved error (18) on unknown label (mc:0 location:-1:-1:-1 address:0x00000000 grain:1 syndrome:0x00000000 APEI location: node:3 card:0 module:1 status(0x0000000000000400): Storage error in memory (DRAM))

Tested on a 4 sockets E5-4650 Sandy Bridge machine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c   | 16 ++++++++--------
 drivers/edac/ghes_edac.c | 16 +++++++++++++++-
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index e436565..8d89bc0 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1083,16 +1083,8 @@ void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
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
@@ -1149,6 +1141,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	int row = -1, chan = -1;
 	int pos[EDAC_MAX_LAYERS] = { top_layer, mid_layer, low_layer };
 	int i, n_labels = 0;
+	u8 grain_bits;
 	struct edac_raw_error_desc *e = &mci->error_desc;
 
 	edac_dbg(3, "MC%d\n", mci->mc_idx);
@@ -1288,6 +1281,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
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
index 41db89a..2126aab 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -15,6 +15,7 @@
 #include <linux/edac.h>
 #include <linux/dmi.h>
 #include "edac_core.h"
+#include <ras/ras_event.h>
 
 #define GHES_EDAC_REVISION " Ver: 1.0.0"
 
@@ -177,9 +178,11 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 {
 	struct edac_raw_error_desc *e = &ghes->mci->error_desc;
 	enum hw_event_mc_err_type type;
+	char detail_location[240];
 	char other_detail[160] = "";
-	char msg[80] = "";
+	char msg[40] = "";
 	char *p;
+	u8 grain_bits;
 
 	/* Cleans the error report buffer */
 	memset(e, 0, sizeof (*e));
@@ -371,6 +374,17 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 	if (p > other_detail)
 		*(p - 1) = '\0';
 
+	/* Generate the trace event */
+	grain_bits = fls_long(e->grain);
+	sprintf(detail_location, "APEI location: %s %s",
+		e->location, e->other_detail);
+	trace_mc_event(type, e->msg, e->label, e->error_count,
+		       ghes->mci->mc_idx,
+		       e->top_layer, e->mid_layer, e->low_layer,
+		       PAGES_TO_MiB(e->page_frame_number) | e->offset_in_page,
+		       grain_bits, e->syndrome, detail_location);
+
+	/* Report the error via EDAC API */
 	edac_raw_mc_handle_error(type, ghes->mci, e);
 }
 EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
-- 
1.8.1.2

