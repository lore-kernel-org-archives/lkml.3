Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab3IBKcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 06:32:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:44353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab3IBKcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 06:32:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,1006,1367942400"; 
   d="scan'208";a="8376278"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: mingo@redhat.com, hpa@zytor.com, yinghai@kernel.org, penberg@kernel.org,
        jacob.shin@amd.com, tglx@linutronix.de, lenb@kernel.org, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, x86@kernel.org
Subject: [PATCH RESEND 2/3] x86, mm: Update min_pfn_mapped in add_pfn_range_mapped().
Date: Mon, 2 Sep 2013 18:30:28 +0800
Message-Id: <1378117829-9095-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378117829-9095-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378117829-9095-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/02 18:29:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/02 18:29:38,
	Serialize complete at 2013/09/02 18:29:38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current kernel, we update min_pfn_mapped and max_pfn_mapped like this:

init_mem_mapping()
{
	while ( a loop iterates all memory ranges ) {
		init_range_memory_mapping();
		 |->init_memory_mapping()
		     |->kernel_physical_mapping_init()
		     |->add_pfn_range_mapped()
		         |-> update max_pfn_mapped;

		update min_pfn_mapped;
	}
}

max_pfn_mapped is updated in add_pfn_range_mapped() when a range of memory
is mapped. But min_pfn_mapped is updated in init_mem_mapping(). We can also
update min_pfn_mapped in add_pfn_range_mapped().

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 5b2eaca..a97749f 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -313,6 +313,7 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
 	nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_X_MAX);
 
 	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
+	min_pfn_mapped = min(min_pfn_mapped, start_pfn);
 }
 
 bool pfn_range_is_mapped(unsigned long start_pfn, unsigned long end_pfn)
@@ -442,7 +443,6 @@ void __init init_mem_mapping(void)
 		new_mapped_ram_size = init_range_memory_mapping(start,
 							last_start);
 		last_start = start;
-		min_pfn_mapped = last_start >> PAGE_SHIFT;
 		/* only increase step_size after big range get mapped */
 		if (new_mapped_ram_size > mapped_ram_size)
 			step_size <<= STEP_SIZE_SHIFT;
-- 
1.7.1

