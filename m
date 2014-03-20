Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbaCTWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:16:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587AbaCTWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:16:25 -0400
Date: Thu, 20 Mar 2014 15:15:51 -0700
From: tip-bot for WANG Chao <tipbot@zytor.com>
Message-ID: <tip-936329de1e6bf3dfa8c056074e6fc6b673e7b1d0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mulix@mulix.org, vgoyal@redhat.com, jdmason@kudzu.us,
        tglx@linutronix.de, hpa@linux.intel.com, chaowang@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mulix@mulix.org, vgoyal@redhat.com, jdmason@kudzu.us,
        tglx@linutronix.de, chaowang@redhat.com, hpa@linux.intel.com
In-Reply-To: <1394463120-26999-1-git-send-email-chaowang@redhat.com>
References: <1394463120-26999-1-git-send-email-chaowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, calgary: Use 8M TCE table size by default
Git-Commit-ID: 936329de1e6bf3dfa8c056074e6fc6b673e7b1d0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  936329de1e6bf3dfa8c056074e6fc6b673e7b1d0
Gitweb:     http://git.kernel.org/tip/936329de1e6bf3dfa8c056074e6fc6b673e7b1d0
Author:     WANG Chao <chaowang@redhat.com>
AuthorDate: Mon, 10 Mar 2014 22:52:00 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Mar 2014 14:51:39 -0700

x86, calgary: Use 8M TCE table size by default

New kexec-tools wants to pass kdump kernel needed memmap via E820
directly, instead of memmap=exactmap. This makes saved_max_pfn not
be passed down to 2nd kernel. To keep 1st kernel and 2nd kernel using
the same TCE table size, Muli suggest to hard code the size to max (8M).

We can't get rid of saved_max_pfn this time, for backward compatibility
with old first kernel and new second kernel. However new first kernel
and old second kernel can not work unfortunately.

v2->v1:
- retain saved_max_pfn so new 2nd kernel can work with old 1st kernel
  from Vivek

Signed-off-by: WANG Chao <chaowang@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Acked-by: Muli Ben-Yehuda <mulix@mulix.org>
Acked-by: Jon Mason <jdmason@kudzu.us>
Link: http://lkml.kernel.org/r/1394463120-26999-1-git-send-email-chaowang@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/pci-calgary_64.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 299d493..0497f71 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1207,23 +1207,31 @@ error:
 	return ret;
 }
 
-static inline int __init determine_tce_table_size(u64 ram)
+static inline int __init determine_tce_table_size(void)
 {
 	int ret;
 
 	if (specified_table_size != TCE_TABLE_SIZE_UNSPECIFIED)
 		return specified_table_size;
 
-	/*
-	 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
-	 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
-	 * larger table size has twice as many entries, so shift the
-	 * max ram address by 13 to divide by 8K and then look at the
-	 * order of the result to choose between 0-7.
-	 */
-	ret = get_order(ram >> 13);
-	if (ret > TCE_TABLE_SIZE_8M)
+	if (is_kdump_kernel() && saved_max_pfn) {
+		/*
+		 * Table sizes are from 0 to 7 (TCE_TABLE_SIZE_64K to
+		 * TCE_TABLE_SIZE_8M). Table size 0 has 8K entries and each
+		 * larger table size has twice as many entries, so shift the
+		 * max ram address by 13 to divide by 8K and then look at the
+		 * order of the result to choose between 0-7.
+		 */
+		ret = get_order((saved_max_pfn * PAGE_SIZE) >> 13);
+		if (ret > TCE_TABLE_SIZE_8M)
+			ret = TCE_TABLE_SIZE_8M;
+	} else {
+		/*
+		 * Use 8M by default (suggested by Muli) if it's not
+		 * kdump kernel and saved_max_pfn isn't set.
+		 */
 		ret = TCE_TABLE_SIZE_8M;
+	}
 
 	return ret;
 }
@@ -1418,8 +1426,7 @@ int __init detect_calgary(void)
 		return -ENOMEM;
 	}
 
-	specified_table_size = determine_tce_table_size((is_kdump_kernel() ?
-					saved_max_pfn : max_pfn) * PAGE_SIZE);
+	specified_table_size = determine_tce_table_size();
 
 	for (bus = 0; bus < MAX_PHB_BUS_NUM; bus++) {
 		struct calgary_bus_info *info = &bus_info[bus];
