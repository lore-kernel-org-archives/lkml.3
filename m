Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3FNVd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 17:33:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34537 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3FNVdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 17:33:54 -0400
Date: Fri, 14 Jun 2013 14:33:43 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-7d5a256fc953dd80a4eb9a1870607ec991d23ec2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tangchen@cn.fujitsu.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1371128589-8953-21-git-send-email-tangchen@cn.fujitsu.com>
References: <1371128589-8953-21-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Add comments for step_size shift
Git-Commit-ID: 7d5a256fc953dd80a4eb9a1870607ec991d23ec2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 14 Jun 2013 14:33:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d5a256fc953dd80a4eb9a1870607ec991d23ec2
Gitweb:     http://git.kernel.org/tip/7d5a256fc953dd80a4eb9a1870607ec991d23ec2
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 21:03:07 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 14 Jun 2013 14:05:32 -0700

x86, mm: Add comments for step_size shift

As requested by hpa, add comments for why we choose 5 to be
the step size shift.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371128589-8953-21-git-send-email-tangchen@cn.fujitsu.com
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
