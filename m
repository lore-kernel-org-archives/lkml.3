Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbaDORLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:11:21 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44906 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbaDORLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:11:19 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 6/6] powerpc/perf/hv-24x7: catalog version number is be64, not be32
Date: Tue, 15 Apr 2014 10:10:55 -0700
Message-Id: <1397581855-4585-7-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041517-0320-0000-0000-000003019342
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The catalog version number was changed from a be32 (with proceeding
32bits of padding) to a be64, update the code to treat it as a be64

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-24x7.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 95a67f8..9d4badc 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -171,7 +171,7 @@ static unsigned long h_get_24x7_catalog_page_(unsigned long phys_4096,
 }
 
 static unsigned long h_get_24x7_catalog_page(char page[],
-					     u32 version, u32 index)
+					     u64 version, u32 index)
 {
 	return h_get_24x7_catalog_page_(virt_to_phys(page),
 					version, index);
@@ -185,7 +185,7 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
 	ssize_t ret = 0;
 	size_t catalog_len = 0, catalog_page_len = 0, page_count = 0;
 	loff_t page_offset = 0;
-	uint32_t catalog_version_num = 0;
+	uint64_t catalog_version_num = 0;
 	void *page = kmem_cache_alloc(hv_page_cache, GFP_USER);
 	struct hv_24x7_catalog_page_0 *page_0 = page;
 	if (!page)
@@ -197,7 +197,7 @@ static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
 		goto e_free;
 	}
 
-	catalog_version_num = be32_to_cpu(page_0->version);
+	catalog_version_num = be64_to_cpu(page_0->version);
 	catalog_page_len = be32_to_cpu(page_0->length);
 	catalog_len = catalog_page_len * 4096;
 
@@ -255,7 +255,7 @@ e_free:								\
 static DEVICE_ATTR_RO(_name)
 
 PAGE_0_ATTR(catalog_version, "%lld\n",
-		(unsigned long long)be32_to_cpu(page_0->version));
+		(unsigned long long)be64_to_cpu(page_0->version));
 PAGE_0_ATTR(catalog_len, "%lld\n",
 		(unsigned long long)be32_to_cpu(page_0->length) * 4096);
 static BIN_ATTR_RO(catalog, 0/* real length varies */);
-- 
1.9.2

