Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbbA1U3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:29:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:52234 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933210AbbA1U3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:29:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677269008"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [Patch v2 13/22] ACPI: Return translation offset when parsing ACPI address space resources
Date: Wed, 28 Jan 2015 18:57:31 +0800
Message-Id: <1422442660-455-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change function acpi_dev_resource_address_space() and
acpi_dev_resource_ext_address_space() to return address space
translation offset.

It's based on a patch from Yinghai Lu <yinghai@kernel.org>.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c        |   58 ++++++++++++++++++++++------------------
 drivers/pnp/pnpacpi/rsparser.c |   29 ++++++++++----------
 include/linux/acpi.h           |    9 +++++--
 3 files changed, 54 insertions(+), 42 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 57891a621b96..c902c8eece81 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -184,13 +184,14 @@ bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_io);
 
-static bool acpi_decode_space(struct resource *res,
+static bool acpi_decode_space(struct resource_win *win,
 			      struct acpi_resource_address *addr,
 			      struct acpi_address64_attribute *attr)
 {
 	u8 iodec = attr->granularity == 0xfff ? ACPI_DECODE_10 : ACPI_DECODE_16;
 	bool wp = addr->info.mem.write_protect;
 	u64 len = attr->address_length;
+	struct resource *res = &win->res;
 
 	/*
 	 * Filter out invalid descriptor according to ACPI Spec 5.0, section
@@ -218,6 +219,8 @@ static bool acpi_decode_space(struct resource *res,
 		return false;
 	}
 
+	win->offset = attr->translation_offset;
+
 	if (addr->producer_consumer == ACPI_PRODUCER)
 		res->flags |= IORESOURCE_WINDOW;
 
@@ -230,27 +233,28 @@ static bool acpi_decode_space(struct resource *res,
 /**
  * acpi_dev_resource_address_space - Extract ACPI address space information.
  * @ares: Input ACPI resource object.
- * @res: Output generic resource object.
+ * @win: Output generic resource object.
  *
  * Check if the given ACPI resource object represents an address space resource
  * and if that's the case, use the information in it to populate the generic
- * resource object pointed to by @res.
+ * resource object pointed to by @win.
  *
  * Return:
- * 1) false with res->flags setting to zero: not the expected resource type
- * 2) false with IORESOURCE_DISABLED in res->flags: valid unassigned resource
+ * 1) false with win->res.flags setting to zero: not the expected resource type
+ * 2) false with IORESOURCE_DISABLED in win->res.flags: valid unassigned
+ *    resource
  * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_address_space(struct acpi_resource *ares,
-				     struct resource *res)
+				     struct resource_win *win)
 {
 	struct acpi_resource_address64 addr;
 
-	res->flags = 0;
+	win->res.flags = 0;
 	if (ACPI_FAILURE(acpi_resource_to_address64(ares, &addr)))
 		return false;
 
-	return acpi_decode_space(res, (struct acpi_resource_address *)&addr,
+	return acpi_decode_space(win, (struct acpi_resource_address *)&addr,
 				 &addr.address);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
@@ -258,29 +262,30 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_address_space);
 /**
  * acpi_dev_resource_ext_address_space - Extract ACPI address space information.
  * @ares: Input ACPI resource object.
- * @res: Output generic resource object.
+ * @win: Output generic resource object.
  *
  * Check if the given ACPI resource object represents an extended address space
  * resource and if that's the case, use the information in it to populate the
- * generic resource object pointed to by @res.
+ * generic resource object pointed to by @win.
  *
  * Return:
- * 1) false with res->flags setting to zero: not the expected resource type
- * 2) false with IORESOURCE_DISABLED in res->flags: valid unassigned resource
+ * 1) false with win->res.flags setting to zero: not the expected resource type
+ * 2) false with IORESOURCE_DISABLED in win->res.flags: valid unassigned
+ *    resource
  * 3) true: valid assigned resource
  */
 bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
-					 struct resource *res)
+					 struct resource_win *win)
 {
 	struct acpi_resource_extended_address64 *ext_addr;
 
-	res->flags = 0;
+	win->res.flags = 0;
 	if (ares->type != ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64)
 		return false;
 
 	ext_addr = &ares->data.ext_address64;
 
-	return acpi_decode_space(res, (struct acpi_resource_address *)ext_addr,
+	return acpi_decode_space(win, (struct acpi_resource_address *)ext_addr,
 				 &ext_addr->address);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_resource_ext_address_space);
@@ -441,7 +446,7 @@ struct res_proc_context {
 	int error;
 };
 
-static acpi_status acpi_dev_new_resource_entry(struct resource *r,
+static acpi_status acpi_dev_new_resource_entry(struct resource_win *win,
 					       struct res_proc_context *c)
 {
 	struct resource_list_entry *rentry;
@@ -451,7 +456,7 @@ static acpi_status acpi_dev_new_resource_entry(struct resource *r,
 		c->error = -ENOMEM;
 		return AE_NO_MEMORY;
 	}
-	rentry->res = *r;
+	rentry->res = win->res;
 	list_add_tail(&rentry->node, c->list);
 	c->count++;
 	return AE_OK;
@@ -461,7 +466,8 @@ static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
 					     void *context)
 {
 	struct res_proc_context *c = context;
-	struct resource r;
+	struct resource_win win;
+	struct resource *res = &win.res;
 	int i;
 
 	if (c->preproc) {
@@ -476,18 +482,18 @@ static acpi_status acpi_dev_process_resource(struct acpi_resource *ares,
 		}
 	}
 
-	memset(&r, 0, sizeof(r));
+	memset(&win, 0, sizeof(win));
 
-	if (acpi_dev_resource_memory(ares, &r)
-	    || acpi_dev_resource_io(ares, &r)
-	    || acpi_dev_resource_address_space(ares, &r)
-	    || acpi_dev_resource_ext_address_space(ares, &r))
-		return acpi_dev_new_resource_entry(&r, c);
+	if (acpi_dev_resource_memory(ares, res)
+	    || acpi_dev_resource_io(ares, res)
+	    || acpi_dev_resource_address_space(ares, &win)
+	    || acpi_dev_resource_ext_address_space(ares, &win))
+		return acpi_dev_new_resource_entry(&win, c);
 
-	for (i = 0; acpi_dev_resource_interrupt(ares, i, &r); i++) {
+	for (i = 0; acpi_dev_resource_interrupt(ares, i, res); i++) {
 		acpi_status status;
 
-		status = acpi_dev_new_resource_entry(&r, c);
+		status = acpi_dev_new_resource_entry(&win, c);
 		if (ACPI_FAILURE(status))
 			return status;
 	}
diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 2d9bc789af0f..ff0356fb378f 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -180,20 +180,21 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 	struct pnp_dev *dev = data;
 	struct acpi_resource_dma *dma;
 	struct acpi_resource_vendor_typed *vendor_typed;
-	struct resource r = {0};
+	struct resource_win win = {{0}, 0};
+	struct resource *r = &win.res;
 	int i, flags;
 
-	if (acpi_dev_resource_address_space(res, &r)
-	    || acpi_dev_resource_ext_address_space(res, &r)) {
-		pnp_add_resource(dev, &r);
+	if (acpi_dev_resource_address_space(res, &win)
+	    || acpi_dev_resource_ext_address_space(res, &win)) {
+		pnp_add_resource(dev, &win.res);
 		return AE_OK;
 	}
 
-	r.flags = 0;
-	if (acpi_dev_resource_interrupt(res, 0, &r)) {
-		pnpacpi_add_irqresource(dev, &r);
-		for (i = 1; acpi_dev_resource_interrupt(res, i, &r); i++)
-			pnpacpi_add_irqresource(dev, &r);
+	r->flags = 0;
+	if (acpi_dev_resource_interrupt(res, 0, r)) {
+		pnpacpi_add_irqresource(dev, r);
+		for (i = 1; acpi_dev_resource_interrupt(res, i, r); i++)
+			pnpacpi_add_irqresource(dev, r);
 
 		if (i > 1) {
 			/*
@@ -209,7 +210,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 			}
 		}
 		return AE_OK;
-	} else if (r.flags & IORESOURCE_DISABLED) {
+	} else if (r->flags & IORESOURCE_DISABLED) {
 		pnp_add_irq_resource(dev, 0, IORESOURCE_DISABLED);
 		return AE_OK;
 	}
@@ -218,13 +219,13 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 	case ACPI_RESOURCE_TYPE_MEMORY24:
 	case ACPI_RESOURCE_TYPE_MEMORY32:
 	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
-		if (acpi_dev_resource_memory(res, &r))
-			pnp_add_resource(dev, &r);
+		if (acpi_dev_resource_memory(res, r))
+			pnp_add_resource(dev, r);
 		break;
 	case ACPI_RESOURCE_TYPE_IO:
 	case ACPI_RESOURCE_TYPE_FIXED_IO:
-		if (acpi_dev_resource_io(res, &r))
-			pnp_add_resource(dev, &r);
+		if (acpi_dev_resource_io(res, r))
+			pnp_add_resource(dev, r);
 		break;
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index d459cd17b477..be9eaee8f4ae 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -285,12 +285,17 @@ extern int pnpacpi_disabled;
 
 #define PXM_INVAL	(-1)
 
+struct resource_win {
+	struct resource res;
+	resource_size_t offset;
+};
+
 bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res);
 bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res);
 bool acpi_dev_resource_address_space(struct acpi_resource *ares,
-				     struct resource *res);
+				     struct resource_win *win);
 bool acpi_dev_resource_ext_address_space(struct acpi_resource *ares,
-					 struct resource *res);
+					 struct resource_win *win);
 unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
 bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 				 struct resource *res);
-- 
1.7.10.4

