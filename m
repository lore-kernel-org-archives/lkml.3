Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaDORLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:11:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37073 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaDORLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:11:16 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        David.Laight@aculab.com, Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 4/6] powerpc/perf/hv-24x7: use (unsigned long) not (u32) values when calling plpar_hcall_norets()
Date: Tue, 15 Apr 2014 10:10:53 -0700
Message-Id: <1397581855-4585-5-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1397581855-4585-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041517-9332-0000-0000-0000008346D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 arch/powerpc/perf/hv-24x7.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index f5bca73..3e8f60a 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -155,16 +155,28 @@ static ssize_t read_offset_data(void *dest, size_t dest_len,
 	return copy_len;
 }
 
-static unsigned long h_get_24x7_catalog_page(char page[static 4096],
-					     u32 version, u32 index)
+static unsigned long h_get_24x7_catalog_page_(unsigned long phys_4096,
+					      unsigned long version,
+					      unsigned long index)
 {
-	WARN_ON(!IS_ALIGNED((unsigned long)page, 4096));
+	pr_devel("h_get_24x7_catalog_page(0x%lx, %lu, %lu)",
+			phys_4096,
+			version,
+			index);
+	WARN_ON(!IS_ALIGNED(phys_4096, 4096));
 	return plpar_hcall_norets(H_GET_24X7_CATALOG_PAGE,
-			virt_to_phys(page),
+			phys_4096,
 			version,
 			index);
 }
 
+static unsigned long h_get_24x7_catalog_page(char page[static 4096],
+					     u32 version, u32 index)
+{
+	return h_get_24x7_catalog_page_(virt_to_phys(page),
+					version, index);
+}
+
 static ssize_t catalog_read(struct file *filp, struct kobject *kobj,
 			    struct bin_attribute *bin_attr, char *buf,
 			    loff_t offset, size_t count)
-- 
1.9.2

