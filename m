Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab3BUPlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:41:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754791Ab3BUPja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:39:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDACv2 06/12] ghes_edac: add support for reporting errors via EDAC
Date: Thu, 21 Feb 2013 12:39:04 -0300
Message-Id: <6115804fd87e5b21df965ddfce96482d6dd2a01f.1361459782.git.mchehab@redhat.com>
In-Reply-To: <cover.1361459782.git.mchehab@redhat.com>
References: <cover.1361459782.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the EDAC core is capable of just forward the errors via
the userspace API, add a report mechanism for the GHES errors.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index d8e54b4..e6f1426 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -27,8 +27,54 @@ static DEFINE_MUTEX(ghes_edac_lock);
 static int ghes_edac_mc_num;
 
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
-                               struct cper_sec_mem_err *mem_err)
+				struct cper_sec_mem_err *mem_err)
 {
+	enum hw_event_mc_err_type type;
+	struct mem_ctl_info *mci;
+	struct ghes_edac_pvt *pvt = NULL;
+	unsigned long page = 0, offset = 0, grain = 0;
+	char location[80];
+	char *label = "unknown";
+
+	list_for_each_entry(pvt, &ghes_reglist, list) {
+		if (ghes == pvt->ghes)
+			break;
+	}
+	if (!pvt) {
+		pr_err("Internal error: Can't find EDAC structure\n");
+		return;
+	}
+	mci = pvt->mci;
+
+	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
+		page = mem_err->physical_addr >> PAGE_SHIFT;
+		offset = mem_err->physical_addr & ~PAGE_MASK;
+		grain = ~(mem_err->physical_addr_mask & ~PAGE_MASK);
+	}
+
+	switch (sev) {
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
+	sprintf(location, "node:%d card:%d module:%d bank:%d device:%d row: %d column:%d bit_pos:%d",
+		mem_err->node, mem_err->card, mem_err->module,
+		mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
+		mem_err->bit_pos);
+
+	edac_raw_mc_handle_error(type, mci, grain, 1, 0, 0, 0,
+				 page, offset, 0,
+				 "APEI", location, label, "", 0);
 }
 EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
 
@@ -60,7 +106,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 
 	pvt = mci->pvt_info;
 	memset(pvt, 0, sizeof(*pvt));
-        list_add_tail(&pvt->list, &ghes_reglist);
+	list_add_tail(&pvt->list, &ghes_reglist);
 	pvt->ghes = ghes;
 	pvt->mci  = mci;
 	mci->pdev = dev;
-- 
1.8.1.2

