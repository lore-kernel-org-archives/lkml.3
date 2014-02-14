Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaBNBDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:03:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaBNBDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:03:18 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mtosatti@redhat.com, mgorman@suse.de, aarcange@redhat.com,
        andi@firstfloor.org, riel@redhat.com, davidlohr@hp.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org,
        rientjes@google.com
Subject: [PATCH 3/4] hugetlb: add parse_pagesize_str()
Date: Thu, 13 Feb 2014 20:02:07 -0500
Message-Id: <1392339728-13487-4-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
References: <1392339728-13487-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luiz capitulino <lcapitulino@redhat.com>

This commit moves current setup_hugepagez() logic to function called
parse_pagesize_str(), so that it can be used by the next commit.

There should be no functional changes, except for the following:

 - When calling memparse(), setup_hugepagesz() was passing the retptr
   argument, but the result was unused. So parse_pagesize_str() pass NULL
   instead

 - Change printk(KERN_ERR) to pr_err() and make the error message a little
   bit nicer for bad command-lines like "hugepagesz=1X"

Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
---
 arch/x86/mm/hugetlbpage.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 8c9f647..968db71 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -173,18 +173,31 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #ifdef CONFIG_X86_64
-static __init int setup_hugepagesz(char *opt)
+static __init int parse_pagesize_str(char *str, unsigned *order)
 {
-	unsigned long ps = memparse(opt, &opt);
+	unsigned long ps = memparse(str, NULL);
 	if (ps == PMD_SIZE) {
-		hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
+		*order = PMD_SHIFT - PAGE_SHIFT;
 	} else if (ps == PUD_SIZE && cpu_has_gbpages) {
-		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
+		*order = PUD_SHIFT - PAGE_SHIFT;
 	} else {
-		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
-			ps >> 20);
+		/* invalid page size */
+		return -1;
+	}
+
+	return 0;
+}
+
+static __init int setup_hugepagesz(char *opt)
+{
+	unsigned order;
+
+	if (parse_pagesize_str(opt, &order)) {
+		pr_err("hugepagesz: Unsupported page size %s\n", opt);
 		return 0;
 	}
+
+	hugetlb_add_hstate(order);
 	return 1;
 }
 __setup("hugepagesz=", setup_hugepagesz);
-- 
1.8.1.4

