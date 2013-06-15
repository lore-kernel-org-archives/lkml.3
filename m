Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3FOA6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 20:58:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:47618 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab3FOA5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 20:57:06 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v5 20/22] x86, mm: Add comments for step_size shift
Date: Fri, 14 Jun 2013 17:56:38 -0700
Message-Id: <1371257800-11720-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
References: <1371257800-11720-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As request by hpa, add comments for why we choose 5 for
step size shift.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/init.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

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
1.8.1.4

