Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935863Ab3BOP0C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:26:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935707Ab3BOPZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:25:58 -0500
Date: Fri, 15 Feb 2013 13:25:30 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 07/13] edac: add support for raw error reports
Message-ID: <20130215132530.4f3b7dab@redhat.com>
In-Reply-To: <20130215141330.GF14387@pd.tnic>
References: <cover.1360931635.git.mchehab@redhat.com>
	<e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
	<20130215141330.GF14387@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 15 Feb 2013 15:13:30 +0100
Borislav Petkov <bp@alien8.de> escreveu:

> On Fri, Feb 15, 2013 at 10:44:55AM -0200, Mauro Carvalho Chehab wrote:
> > That allows APEI GHES driver to report errors directly, using
> > the EDAC error report API.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> >  drivers/edac/edac_core.h |  17 ++++++++
> >  drivers/edac/edac_mc.c   | 109 ++++++++++++++++++++++++++++++++++++-----------
> >  2 files changed, 100 insertions(+), 26 deletions(-)
> > 
> > diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
> > index 23bb99f..9c5da11 100644
> > --- a/drivers/edac/edac_core.h
> > +++ b/drivers/edac/edac_core.h
> > @@ -453,6 +453,23 @@ extern struct mem_ctl_info *find_mci_by_dev(struct device *dev);
> >  extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
> >  extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
> >  				      unsigned long page);
> > +
> > +void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
> > +			  struct mem_ctl_info *mci,
> > +			  long grain,
> > +			  const u16 error_count,
> > +			  const int top_layer,
> > +			  const int mid_layer,
> > +			  const int low_layer,
> > +			  const unsigned long page_frame_number,
> > +			  const unsigned long offset_in_page,
> > +			  const unsigned long syndrome,
> > +			  const char *msg,
> > +			  const char *location,
> > +			  const char *label,
> > +			  const char *other_detail,
> > +			  const bool enable_per_layer_report);
> 
> The argument count of this one looks like an overkill. Maybe it would be
> nicer, cleaner to do this:
> 
> void __edac_handle_mc_error(const enum hw_event_mc_err_type type,
> 			    struct mem_ctl_info *mci,
> 			    struct error_desc *e);
> 
> and struct error_desc collects all the remaining arguments.
> 
> This way you can't get the arguments order wrong, forget one or
> whatever; and it would be much less stack pressure on the function
> calls.

Well, for sure using an structure will help to avoid missing a parameter
or exchanging its order. The stack usage won't reduce, though, because
the structure will keep using the stack. As I can't foresee the usage
of this function call outside the core and by the GHES driver, I'm not
sure what would be the better.

Anyway, I moved it to an structure in the enclosed patch.

Regards,
Mauro

--


edac: put all arguments for the raw error handling call into a struct

The number of arguments for edac_raw_mc_handle_error() is too big;
put them into a structure.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 9c5da11..1574fec 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -381,6 +381,25 @@ struct edac_pci_ctl_info {
 	struct completion kobj_complete;
 };
 
+/*
+ * Raw error report structure
+ */
+struct edac_raw_error_desc {
+	long grain;
+	u16 error_count;
+	int top_layer;
+	int mid_layer;
+	int low_layer;
+	unsigned long page_frame_number;
+	unsigned long offset_in_page;
+	unsigned long syndrome;
+	const char *msg;
+	const char *location;
+	const char *label;
+	const char *other_detail;
+	bool enable_per_layer_report;
+};
+
 #define to_edac_pci_ctl_work(w) \
 		container_of(w, struct edac_pci_ctl_info,work)
 
@@ -455,20 +474,8 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 				      unsigned long page);
 
 void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
-			  struct mem_ctl_info *mci,
-			  long grain,
-			  const u16 error_count,
-			  const int top_layer,
-			  const int mid_layer,
-			  const int low_layer,
-			  const unsigned long page_frame_number,
-			  const unsigned long offset_in_page,
-			  const unsigned long syndrome,
-			  const char *msg,
-			  const char *location,
-			  const char *label,
-			  const char *other_detail,
-			  const bool enable_per_layer_report);
+			      struct mem_ctl_info *mci,
+			      struct edac_raw_error_desc *err);
 
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 8fddf65..b36f8f8 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1074,70 +1074,43 @@ static void edac_ue_error(struct mem_ctl_info *mci,
  *
  * @type:		severity of the error (CE/UE/Fatal)
  * @mci:		a struct mem_ctl_info pointer
- * @grain:		error granularity
- * @error_count:	Number of errors of the same type
- * @top_layer:		Memory layer[0] position
- * @mid_layer:		Memory layer[1] position
- * @low_layer:		Memory layer[2] position
- * @page_frame_number:	mem page where the error occurred
- * @offset_in_page:	offset of the error inside the page
- * @syndrome:		ECC syndrome
- * @msg:		Message meaningful to the end users that
- *			explains the event\
- * @location:		location of the error, like "csrow:0 channel:1"
- * @label:		DIMM labels for the affected memory(ies)
- * @other_detail:	Technical details about the event that
- *			may help hardware manufacturers and
- *			EDAC developers to analyse the event
- * @enable_per_layer_report: should it increment per-layer error counts?
+ * @e:			error description
  *
  * This raw function is used internally by edac_mc_handle_error(). It should
  * only be called directly when the hardware error come directly from BIOS,
  * like in the case of APEI GHES driver.
  */
 void edac_raw_mc_handle_error(const enum hw_event_mc_err_type type,
-			  struct mem_ctl_info *mci,
-			  long grain,
-			  const u16 error_count,
-			  const int top_layer,
-			  const int mid_layer,
-			  const int low_layer,
-			  const unsigned long page_frame_number,
-			  const unsigned long offset_in_page,
-			  const unsigned long syndrome,
-			  const char *msg,
-			  const char *location,
-			  const char *label,
-			  const char *other_detail,
-			  const bool enable_per_layer_report)
+			      struct mem_ctl_info *mci,
+			      struct edac_raw_error_desc *e)
 {
 	char detail[80];
 	u8 grain_bits;
-	int pos[EDAC_MAX_LAYERS] = { top_layer, mid_layer, low_layer };
+	int pos[EDAC_MAX_LAYERS] = { e->top_layer, e->mid_layer, e->low_layer };
 
 	/* Report the error via the trace interface */
-	grain_bits = fls_long(grain) + 1;
-	trace_mc_event(type, msg, label, error_count,
-		       mci->mc_idx, top_layer, mid_layer, low_layer,
-		       PAGES_TO_MiB(page_frame_number) | offset_in_page,
-		       grain_bits, syndrome, other_detail);
+	grain_bits = fls_long(e->grain) + 1;
+	trace_mc_event(type, e->msg, e->label, e->error_count,
+		       mci->mc_idx, e->top_layer, e->mid_layer, e->low_layer,
+		       PAGES_TO_MiB(e->page_frame_number) | e->offset_in_page,
+		       grain_bits, e->syndrome, e->other_detail);
 
 	/* Memory type dependent details about the error */
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		snprintf(detail, sizeof(detail),
 			"page:0x%lx offset:0x%lx grain:%ld syndrome:0x%lx",
-			page_frame_number, offset_in_page,
-			grain, syndrome);
-		edac_ce_error(mci, error_count, pos, msg, location, label,
-			      detail, other_detail, enable_per_layer_report,
-			      page_frame_number, offset_in_page, grain);
+			e->page_frame_number, e->offset_in_page,
+			e->grain, e->syndrome);
+		edac_ce_error(mci, e->error_count, pos, e->msg, e->location, e->label,
+			      detail, e->other_detail, e->enable_per_layer_report,
+			      e->page_frame_number, e->offset_in_page, e->grain);
 	} else {
 		snprintf(detail, sizeof(detail),
 			"page:0x%lx offset:0x%lx grain:%ld",
-			page_frame_number, offset_in_page, grain);
+			e->page_frame_number, e->offset_in_page, e->grain);
 
-		edac_ue_error(mci, error_count, pos, msg, location, label,
-			      detail, other_detail, enable_per_layer_report);
+		edac_ue_error(mci, e->error_count, pos, e->msg, e->location, e->label,
+			      detail, e->other_detail, e->enable_per_layer_report);
 	}
 
 
@@ -1181,11 +1154,12 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	int row = -1, chan = -1;
 	int pos[EDAC_MAX_LAYERS] = { top_layer, mid_layer, low_layer };
 	int i;
-	long grain;
-	bool enable_per_layer_report = false;
+	struct edac_raw_error_desc e;
 
 	edac_dbg(3, "MC%d\n", mci->mc_idx);
 
+	e.enable_per_layer_report = false;
+
 	/*
 	 * Check if the event report is consistent and if the memory
 	 * location is known. If it is known, enable_per_layer_report will be
@@ -1208,7 +1182,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			pos[i] = -1;
 		}
 		if (pos[i] >= 0)
-			enable_per_layer_report = true;
+			e.enable_per_layer_report = true;
 	}
 
 	/*
@@ -1222,7 +1196,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	 * where each memory belongs to a separate channel within the same
 	 * branch.
 	 */
-	grain = 0;
+	e.grain = 0;
 	p = label;
 	*p = '\0';
 
@@ -1237,8 +1211,8 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			continue;
 
 		/* get the max grain, over the error match range */
-		if (dimm->grain > grain)
-			grain = dimm->grain;
+		if (dimm->grain > e.grain)
+			e.grain = dimm->grain;
 
 		/*
 		 * If the error is memory-controller wide, there's no need to
@@ -1246,7 +1220,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		 * channel/memory controller/...  may be affected.
 		 * Also, don't show errors for empty DIMM slots.
 		 */
-		if (enable_per_layer_report && dimm->nr_pages) {
+		if (e.enable_per_layer_report && dimm->nr_pages) {
 			if (p != label) {
 				strcpy(p, OTHER_LABEL);
 				p += strlen(OTHER_LABEL);
@@ -1274,7 +1248,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		}
 	}
 
-	if (!enable_per_layer_report) {
+	if (!e.enable_per_layer_report) {
 		strcpy(label, "any memory");
 	} else {
 		edac_dbg(4, "csrow/channel to increment: (%d,%d)\n", row, chan);
@@ -1305,11 +1279,19 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (p > location)
 		*(p - 1) = '\0';
 
-	edac_raw_mc_handle_error(type, mci, grain, error_count,
-				 top_layer, mid_layer, low_layer,
-				 page_frame_number, offset_in_page,
-				 syndrome,
-				 msg, location, label, other_detail,
-				 enable_per_layer_report);
+
+	e.error_count = error_count;
+	e.top_layer = top_layer;
+	e.mid_layer = mid_layer;
+	e.low_layer = low_layer;
+	e.page_frame_number = page_frame_number;
+	e.offset_in_page = offset_in_page;
+	e.syndrome = syndrome;
+	e.msg = msg;
+	e.location = location;
+	e.label = label;
+	e.other_detail = other_detail;
+
+	edac_raw_mc_handle_error(type, mci, &e);
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 94d5286..782ed74 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -162,15 +162,16 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 			        struct cper_sec_mem_err *mem_err)
 {
+	struct edac_raw_error_desc e;
 	enum hw_event_mc_err_type type;
-	unsigned long page = 0, offset = 0, grain = 0;
 	char location[80];
-	char *label = "unknown";
+
+	memset(&e, 0, sizeof(e));
 
 	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
-		page = mem_err->physical_addr >> PAGE_SHIFT;
-		offset = mem_err->physical_addr & ~PAGE_MASK;
-		grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
+		e.page_frame_number = mem_err->physical_addr >> PAGE_SHIFT;
+		e.offset_in_page = mem_err->physical_addr & ~PAGE_MASK;
+		e.grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
 	}
 
 	switch(sev) {
@@ -194,9 +195,12 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		mem_err->bit_pos);
 	edac_dbg(3, "error at location %s\n", location);
 
-	edac_raw_mc_handle_error(type, ghes->mci, grain, 1, 0, 0, 0,
-				 page, offset, 0,
-				 "APEI", location, label, "", 0);
+	e.error_count = 1;
+	e.msg = "APEI";
+	e.location = location;
+	e.label = "unknown";
+	e.other_detail = "";
+	edac_raw_mc_handle_error(type, ghes->mci, &e);
 }
 EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
 
