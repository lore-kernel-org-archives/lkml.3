Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab3BSMCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:02:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473Ab3BSMB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:01:57 -0500
Date: Tue, 19 Feb 2013 08:56:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-acpi@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, Tony Luck <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH EDAC 07/13] edac: add support for raw error reports
Message-ID: <20130219085628.6ebc5e99@redhat.com>
In-Reply-To: <20130218122429.239584aa@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
	<e08f797b129a50b4e1b39e8c31bff82904aea65d.1360931635.git.mchehab@redhat.com>
	<20130215141330.GF14387@pd.tnic>
	<20130215132530.4f3b7dab@redhat.com>
	<20130215154123.GH14387@pd.tnic>
	<20130215134929.3909cfa2@redhat.com>
	<20130215160257.GK14387@pd.tnic>
	<20130215162029.3bcbf50a@redhat.com>
	<20130216165748.GC27207@pd.tnic>
	<20130217074404.05786692@redhat.com>
	<20130218135251.GC16622@pd.tnic>
	<20130218122429.239584aa@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 18 Feb 2013 12:24:29 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:

> Em Mon, 18 Feb 2013 14:52:51 +0100
> Borislav Petkov <bp@alien8.de> escreveu:
> 
> > On Sun, Feb 17, 2013 at 07:44:04AM -0300, Mauro Carvalho Chehab wrote:
> > > We could do it for the location. The space for label, however, depends on
> > > how many DIMMs are in the system, as multiple dimm's may be present, and
> > > the core will point to all possible affected DIMMs.
> > > 
> > > Ok, perhaps we could just allocate one big area for it (like one page), 
> > > as this would very likely be enough for it, and change the logic to take
> > > the buffer size into account when filling it.
> > 
> > Or, in the case where ->label is all dimms on the mci, you simply put
> > "All DIMMs on MCI%d" in there and done. Simple.
> 
> The core does this already when it has no glue at all about where is the
> error.
> 
> The core is prepared to the case where the location is only half-filled,
> as this is a common scenario on the drivers, and important enough on
> some memory controllers.
> 
> As already discussed, on most memory controllers nowadays, the memory
> controller can't point to a single DIMM, as the error correction code
> takes 128 bits (2 DIMMs). It is impossible for the error correction
> code to determine on what DIMM an uncorrected error happened[1].
> 
> With Nehalem memory controllers, depending on the memory configuration,
> the minimal DIMM granularity for an uncorrected error can be even worse: 
> 4 DIMMs, if 128-bits error correction code and mirror mode are both enabled.
> 
> There are some border cases where the driver can simply not discover on
> what channel or on what dimm(or csrow) inside a channel the error
> happened. The error could be associated with some failure at the logic
> or at the bus that communicated with the Advanced Memory Buffers on an
> FB-DIMM memory controller, for example.
> 
> So, the real core's worse case scenario would be if the driver can't
> determine on what DIMM inside a channel the error happened. As a channel
> can have a large number of DIMMs[2] the allocated area for the label
> should be conservative.
> 
> 
>  (16? Not sure what's the worse case),
> 
> [1] such error can even not be fatal, if that particular address is
> unused.
> 
> [2] Currently, up to 8, according with:
> 	$for i in $(git grep "layers.*size\s*=" drivers/edac|perl -ne 'print "$1 " if (m/\=\s*([A-Z][^\s]+);/);'); do echo $i; git grep $i drivers/edac; done|grep define|perl -ne 'print "$1 " if (m/define\s+[^\s]+\s(\d+)/)'
> 	8 8 2 2 4 2 3 3 3 8 4 4 3 3 1 1 4 
> 
> and
> 	$ git grep "layers.*size\s*=" drivers/edac|perl -ne 'print "$1 " if (m/\=\s*(\d+);/);'
> 	1 1 1 1 2 2 8 4 1 1 1 1 
> 
> Nothing prevents that a driver would have more than 8 DIMMs per layer
> in the future.

I suspect that you'll be happy with the enclosed patch ;)

It embeds the two string buffers at the mci structure. There are space there
for up to EDAC_MAX_LABELS at the "mci->label" string. If an error affects
more than EDAC_MAX_LABELS, the report logic will write "any memory", just like
what happens when the driver can't discover where the error is.

Tested with sb_edac driver.

Regards,
Mauro

[PATCH EDAC] edac: put all arguments for the raw error handling call into a struct

The number of arguments for edac_raw_mc_handle_error() is too big;
put them into a structure and allocate space for it inside
edac_mc_alloc().

That reduces a lot the stack usage and simplifies the raw API call.

Tested with sb_edac driver and MCE error injection. Worked as expected:

[  143.066100] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
[  143.086424] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
[  143.106570] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
[  143.126712] EDAC MC0: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x320 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 9c5da11..3c2625e 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -455,20 +455,8 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
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
+			      struct edac_raw_error_desc *e);
 
 void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  struct mem_ctl_info *mci,
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 8fddf65..ab1ef5c 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1066,78 +1067,49 @@ static void edac_ue_error(struct mem_ctl_info *mci,
 	edac_inc_ue_error(mci, enable_per_layer_report, pos, error_count);
 }
 
-#define OTHER_LABEL " or "
-
 /**
  * edac_raw_mc_handle_error - reports a memory event to userspace without doing
  *			      anything to discover the error location
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
 
 
@@ -1174,18 +1146,26 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			  const char *msg,
 			  const char *other_detail)
 {
-	/* FIXME: too much for stack: move it to some pre-alocated area */
-	char location[80];
-	char label[(EDAC_MC_LABEL_LEN + 1 + sizeof(OTHER_LABEL)) * mci->tot_dimms];
 	char *p;
 	int row = -1, chan = -1;
 	int pos[EDAC_MAX_LAYERS] = { top_layer, mid_layer, low_layer };
-	int i;
-	long grain;
-	bool enable_per_layer_report = false;
+	int i, n_labels = 0;
+	struct edac_raw_error_desc *e = &mci->error_desc;
 
 	edac_dbg(3, "MC%d\n", mci->mc_idx);
 
+	/* Fills the error report buffer */
+	memset(e, 0, sizeof (*e));
+	e->error_count = error_count;
+	e->top_layer = top_layer;
+	e->mid_layer = mid_layer;
+	e->low_layer = low_layer;
+	e->page_frame_number = page_frame_number;
+	e->offset_in_page = offset_in_page;
+	e->syndrome = syndrome;
+	e->msg = msg;
+	e->other_detail = other_detail;
+
 	/*
 	 * Check if the event report is consistent and if the memory
 	 * location is known. If it is known, enable_per_layer_report will be
@@ -1208,7 +1188,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			pos[i] = -1;
 		}
 		if (pos[i] >= 0)
-			enable_per_layer_report = true;
+			e->enable_per_layer_report = true;
 	}
 
 	/*
@@ -1222,8 +1202,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	 * where each memory belongs to a separate channel within the same
 	 * branch.
 	 */
-	grain = 0;
-	p = label;
+	p = e->label;
 	*p = '\0';
 
 	for (i = 0; i < mci->tot_dimms; i++) {
@@ -1237,8 +1216,8 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			continue;
 
 		/* get the max grain, over the error match range */
-		if (dimm->grain > grain)
-			grain = dimm->grain;
+		if (dimm->grain > e->grain)
+			e->grain = dimm->grain;
 
 		/*
 		 * If the error is memory-controller wide, there's no need to
@@ -1246,8 +1225,13 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		 * channel/memory controller/...  may be affected.
 		 * Also, don't show errors for empty DIMM slots.
 		 */
-		if (enable_per_layer_report && dimm->nr_pages) {
-			if (p != label) {
+		if (e->enable_per_layer_report && dimm->nr_pages) {
+			if (n_labels >= EDAC_MAX_LABELS) {
+				e->enable_per_layer_report = false;
+				break;
+			}
+			n_labels++;
+			if (p != e->label) {
 				strcpy(p, OTHER_LABEL);
 				p += strlen(OTHER_LABEL);
 			}
@@ -1274,12 +1258,12 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 		}
 	}
 
-	if (!enable_per_layer_report) {
-		strcpy(label, "any memory");
+	if (!e->enable_per_layer_report) {
+		strcpy(e->label, "any memory");
 	} else {
 		edac_dbg(4, "csrow/channel to increment: (%d,%d)\n", row, chan);
-		if (p == label)
-			strcpy(label, "unknown memory");
+		if (p == e->label)
+			strcpy(e->label, "unknown memory");
 		if (type == HW_EVENT_ERR_CORRECTED) {
 			if (row >= 0) {
 				mci->csrows[row]->ce_count += error_count;
@@ -1292,7 +1276,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	}
 
 	/* Fill the RAM location data */
-	p = location;
+	p = e->location;
 
 	for (i = 0; i < mci->n_layers; i++) {
 		if (pos[i] < 0)
@@ -1302,14 +1286,9 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			     edac_layer_name[mci->layers[i].type],
 			     pos[i]);
 	}
-	if (p > location)
+	if (p > e->location)
 		*(p - 1) = '\0';
 
-	edac_raw_mc_handle_error(type, mci, grain, error_count,
-				 top_layer, mid_layer, low_layer,
-				 page_frame_number, offset_in_page,
-				 syndrome,
-				 msg, location, label, other_detail,
-				 enable_per_layer_report);
+	edac_raw_mc_handle_error(type, mci, e);
 }
 EXPORT_SYMBOL_GPL(edac_mc_handle_error);
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index ef54829..9d7f797 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -175,15 +175,20 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 			        struct cper_sec_mem_err *mem_err)
 {
+	struct edac_raw_error_desc *e = &ghes->mci->error_desc;
 	enum hw_event_mc_err_type type;
-	unsigned long page = 0, offset = 0, grain = 0;
-	char location[80];
-	char *label = "unknown";
+
+	/* Cleans the error report buffer */
+	memset(e, 0, sizeof (*e));
+	e->error_count = 1;
+	e->msg = "APEI";
+	strcpy(e->label, "unknown");
+	e->other_detail = "";
 
 	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
-		page = mem_err->physical_addr >> PAGE_SHIFT;
-		offset = mem_err->physical_addr & ~PAGE_MASK;
-		grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
+		e->page_frame_number = mem_err->physical_addr >> PAGE_SHIFT;
+		e->offset_in_page = mem_err->physical_addr & ~PAGE_MASK;
+		e->grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
 	}
 
 	switch(sev) {
@@ -201,15 +206,14 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		type = HW_EVENT_ERR_INFO;
 	}
 
-	sprintf(location,"node:%d card:%d module:%d bank:%d device:%d row: %d column:%d bit_pos:%d",
+	sprintf(e->location,
+		"node:%d card:%d module:%d bank:%d device:%d row: %d column:%d bit_pos:%d",
 		mem_err->node, mem_err->card, mem_err->module,
 		mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
 		mem_err->bit_pos);
-	edac_dbg(3, "error at location %s\n", location);
+	edac_dbg(3, "error at location %s\n", e->location);
 
-	edac_raw_mc_handle_error(type, ghes->mci, grain, 1, 0, 0, 0,
-				 page, offset, 0,
-				 "APEI", location, label, "", 0);
+	edac_raw_mc_handle_error(type, ghes->mci, e);
 }
 EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index bd14f5c..1cd4472 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -47,8 +47,18 @@ static inline void opstate_init(void)
 	return;
 }
 
+/* Max length of a DIMM label*/
 #define EDAC_MC_LABEL_LEN	31
 
+/* Maximum size of the location string */
+#define LOCATION_SIZE 80
+
+/* Defines the maximum number of labels that can be reported */
+#define EDAC_MAX_LABELS		8
+
+/* String used to join two or more labels */
+#define OTHER_LABEL " or "
+
 /**
  * enum dev_type - describe the type of memory DRAM chips used at the stick
  * @DEV_UNKNOWN:	Can't be determined, or MC doesn't support detect it
@@ -554,6 +564,46 @@ struct errcount_attribute_data {
 	int layer0, layer1, layer2;
 };
 
+/**
+ * edac_raw_error_desc - Raw error report structure
+ * @grain:			minimum granularity for an error report, in bytes
+ * @error_count:		number of errors of the same type
+ * @top_layer:			top layer of the error (layer[0])
+ * @mid_layer:			middle layer of the error (layer[1])
+ * @low_layer:			low layer of the error (layer[2])
+ * @page_frame_number:		page where the error happened
+ * @offset_in_page:		page offset
+ * @syndrome:			syndrome of the error (or 0 if unknown or if
+ * 				the syndrome is not applicable)
+ * @msg:			error message
+ * @location:			location of the error
+ * @label:			label of the affected DIMM(s)
+ * @other_detail:		other driver-specific detail about the error
+ * @enable_per_layer_report:	if false, the error affects all layers
+ *				(typically, a memory controller error)
+ */
+struct edac_raw_error_desc {
+	/*
+	 * NOTE: everything before grain won't be cleaned by
+	 * edac_raw_error_desc_clean()
+	 */
+	char location[LOCATION_SIZE];
+	char label[(EDAC_MC_LABEL_LEN + 1 + sizeof(OTHER_LABEL)) * EDAC_MAX_LABELS];
+	long grain;
+
+	/* the vars below and grain will be cleaned on every new error report */
+	u16 error_count;
+	int top_layer;
+	int mid_layer;
+	int low_layer;
+	unsigned long page_frame_number;
+	unsigned long offset_in_page;
+	unsigned long syndrome;
+	const char *msg;
+	const char *other_detail;
+	bool enable_per_layer_report;
+};
+
 /* MEMORY controller information structure
  */
 struct mem_ctl_info {
@@ -661,6 +711,12 @@ struct mem_ctl_info {
 	/* work struct for this MC */
 	struct delayed_work work;
 
+	/*
+	 * Used to report an error - by being at the global struct
+	 * makes the memory allocated by the EDAC core
+	 */
+	struct edac_raw_error_desc error_desc;
+
 	/* the internal state of this controller instance */
 	int op_state;
 



