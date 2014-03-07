Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaCGIKx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:10:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaCGIKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:10:52 -0500
From: WANG Chao <chaowang@redhat.com>
To: Muli Ben-Yehuda <muli@cs.technion.ac.il>,
        "Jon D. Mason" <jdmason@kudzu.us>, "H. Peter Anvin" <hpa@zytor.com>,
        Vivek Goyal <vgoyal@redhat.com>, Baoquan He <bhe@redhat.com>
Cc: kexec@lists.infradead.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, calgary: use 8M TCE table size by default
Date: Fri,  7 Mar 2014 16:10:16 +0800
Message-Id: <1394179816-15435-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kexec-tools wants to pass kdump kernel needed memmap via E820 directly,
instead of memmap=exactmap. That'll make saved_max_pfn totally useless.

Muli suggest to hard code TCE table size to max (8M) so that kdump
kernel could use this default size and kexec-tools doesn't need to pass
saved_max_pfn to kdump kernel in any way.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 arch/x86/kernel/pci-calgary_64.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 299d493..b26ab94 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1207,25 +1207,17 @@ error:
 	return ret;
 }
 
-static inline int __init determine_tce_table_size(u64 ram)
+static inline int __init determine_tce_table_size(void)
 {
-	int ret;
-
 	if (specified_table_size != TCE_TABLE_SIZE_UNSPECIFIED)
 		return specified_table_size;
+	else
+		/*
+		 * Use 8M by default to get rid of saved_max_pfn,
+		 * suggested by Muli
+		 */
+		return TCE_TABLE_SIZE_8M;
 
-	/*
-	 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
-	 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
-	 * larger table size has twice as many entries, so shift the
-	 * max ram address by 13 to divide by 8K and then look at the
-	 * order of the result to choose between 0-7.
-	 */
-	ret = get_order(ram >> 13);
-	if (ret > TCE_TABLE_SIZE_8M)
-		ret = TCE_TABLE_SIZE_8M;
-
-	return ret;
 }
 
 static int __init build_detail_arrays(void)
@@ -1418,8 +1410,7 @@ int __init detect_calgary(void)
 		return -ENOMEM;
 	}
 
-	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
-					saved_max_pfn : max_pfn) * PAGE_SIZE);
+	specified_table_size = determine_tce_table_size();
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
-- 
1.8.5.3

