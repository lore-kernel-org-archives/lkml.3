Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab3HTSL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:11:56 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35772 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3HTSLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:11:55 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, mm: Avoid step_size overflow and add comments
Date: Tue, 20 Aug 2013 11:11:10 -0700
Message-Id: <1377022270-20303-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code
1. shift step_size directly, and this could have overflow problem
   after we shift step_size several times.
2. use MACRO to have shift to set to 5, but there is not
   explanation about selection.

We can fix them with:
1. Add get_new_step_size(), and check overflow by comparing new_size
   with old step_size.
2. add comment in it about why we are using 5.

That will make code more readable while not increasing size of
init_mem_mapping().

-v2: According to Ingo, update changelog and comments.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>

---
 arch/x86/mm/init.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -399,8 +399,23 @@ static unsigned long __init init_range_m
 	return mapped_ram_size;
 }
 
-/* (PUD_SHIFT-PMD_SHIFT)/2 */
-#define STEP_SIZE_SHIFT 5
+static unsigned long __init get_new_step_size(unsigned long step_size)
+{
+	/*
+	 * initial mapped size is PMD_SIZE (2M).
+	 * We can not set step_size to be PUD_SIZE (1G) yet.
+	 * In worse case, when we cross the 1G boundary, and
+	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M + 8k)
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
@@ -449,7 +464,7 @@ void __init init_mem_mapping(void)
 		min_pfn_mapped = last_start >> PAGE_SHIFT;
 		/* only increase step_size after big range get mapped */
 		if (new_mapped_ram_size > mapped_ram_size)
-			step_size <<= STEP_SIZE_SHIFT;
+			step_size = get_new_step_size(step_size);
 		mapped_ram_size += new_mapped_ram_size;
 	}
 
