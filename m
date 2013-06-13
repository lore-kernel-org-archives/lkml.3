Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab3FMNlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:41:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757099Ab3FMN15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:27:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,858,1363104000"; 
   d="scan'208";a="7537675"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de,
        minchan@kernel.org, mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [Part1 PATCH v5 20/22] x86, mm: Add comments for step_size shift
Date: Thu, 13 Jun 2013 21:03:07 +0800
Message-Id: <1371128589-8953-21-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/13 20:58:28,
	Serialize complete at 2013/06/13 20:58:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

As requested by hpa, add comments for why we choose 5 to be
the step size shift.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/init.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3c21f16..5f38e72 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -395,8 +395,23 @@ static unsigned long __init init_range_memory_mapping(
 	return mapped_ram_size;
 }
 
-/* (PUD_SHIFT-PMD_SHIFT)/2 */
-#define STEP_SIZE_SHIFT 5
+static unsigned long __init get_new_step_size(unsigned long step_size)
+{
+	/*
+	 * initial mapped size is PMD_SIZE, aka 2M.
+	 * We can not set step_size to be PUD_SIZE aka 1G yet.
+	 * In worse case, when 1G is cross the 1G boundary, and
+	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (aka 2M + 8k)
+	 * to map 1G range with PTE. Use 5 as shift for now.
+	 */
+	unsigned long new_step_size = step_size << 5;
+
+	if (new_step_size > step_size)
+		step_size = new_step_size;
+
+	return  step_size;
+}
+
 void __init init_mem_mapping(void)
 {
 	unsigned long end, real_end, start, last_start;
@@ -445,7 +460,7 @@ void __init init_mem_mapping(void)
 		min_pfn_mapped = last_start >> PAGE_SHIFT;
 		/* only increase step_size after big range get mapped */
 		if (new_mapped_ram_size > mapped_ram_size)
-			step_size <<= STEP_SIZE_SHIFT;
+			step_size = get_new_step_size(step_size);
 		mapped_ram_size += new_mapped_ram_size;
 	}
 
-- 
1.7.1

