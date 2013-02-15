Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936015Ab3BOMph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935977Ab3BOMpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:33 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 08/13] ghes_edac: add support for reporting errors via EDAC
Date: Fri, 15 Feb 2013 10:44:56 -0200
Message-Id: <7f8d2d0491f2abdba43bc2a8123ae360eaeb64c2.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the EDAC core is capable of just forward the errors via
the userspace API, add a report mechanism for the GHES errors.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 36 +++++++++++++++++++++++++++++++++++-
 include/linux/edac.h     |  1 +
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 1badac6..52625b5 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -9,8 +9,42 @@ static DEFINE_MUTEX(ghes_edac_lock);
 static int ghes_edac_mc_num;
 
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
-                               struct cper_sec_mem_err *mem_err)
+			        struct cper_sec_mem_err *mem_err)
 {
+	enum hw_event_mc_err_type type;
+	unsigned long page = 0, offset = 0, grain = 0;
+	char location[80];
+	char *label = "unknown";
+
+	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+		page = mem_err->physical_addr >> PAGE_SHIFT;
+		offset = mem_err->physical_addr & ~PAGE_MASK;
+		grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
+	}
+
+	switch(sev) {
+	case GHES_SEV_CORRECTED:
+		type = HW_EVENT_ERR_CORRECTED;
+		break;
+	case GHES_SEV_RECOVERABLE:
+		type = HW_EVENT_ERR_UNCORRECTED;
+		break;
+	case GHES_SEV_PANIC:
+		type = HW_EVENT_ERR_FATAL;
+		break;
+	default:
+	case GHES_SEV_NO:
+		type = HW_EVENT_ERR_INFO;
+	}
+
+	sprintf(location,"node:%d card:%d module:%d bank:%d device:%d row: %d column:%d bit_pos:%d",
+		mem_err->node, mem_err->card, mem_err->module,
+		mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
+		mem_err->bit_pos);
+
+	edac_raw_mc_handle_error(type, ghes->mci, grain, 1, 0, 0, 0,
+				 page, offset, 0,
+				 "APEI", location, label, "", 0);
 }
 EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 1b7744c..28232a0 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -100,6 +100,7 @@ enum hw_event_mc_err_type {
 	HW_EVENT_ERR_CORRECTED,
 	HW_EVENT_ERR_UNCORRECTED,
 	HW_EVENT_ERR_FATAL,
+	HW_EVENT_ERR_INFO,
 };
 
 /**
-- 
1.8.1.2

