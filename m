Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaG1HtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:49:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8620 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaG1HtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:49:16 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-79-53d600797f0f
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>, stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Hugh Dickins <hughd@google.com>
Subject: [PATCH] mm: don't allow fault_around_bytes to be 0
Date: Mon, 28 Jul 2014 11:43:20 +0400
Message-id: <1406533400-6361-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <53D07E96.5000006@oracle.com>
References: <53D07E96.5000006@oracle.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7qVDNeCDY5f47PY9usRm8XxCZYW
	c9avYbN4saGd0WLL9SYmiy3H7jFaPP3Ux2Jx8/kcFouVnQ9YLfbsPclicXnXHDaLe2v+s1oc
	WH6UxWLyu2eMFnuOWVv8vbKexWLBxkeMFo/63rJbnP97nNVB2OPUIgmPnbPusnss2FTqsXjP
	SyaPTZ8msXucmPGbxWPeyUCP9/uusnn0bVnF6LH5dLXH501yHpuevGUK4InisklJzcksSy3S
	t0vgyrhx6jNLwUPFilV3bBoY/0l3MXJySAiYSDz+MosFwhaTuHBvPVsXIxeHkMBSRoml86+x
	Qzh9TBLtmx8zglSxCehJ/Ju1nQ3EFhHQlVj1fBczSBGzwCxWifUdq8FGCQtYS1x5MJsdxGYR
	UJU4fHsJmM0r4Cpx6dZONoh1ChLLls9kBbE5BbQkzn3uZgaxhQQ0JR6/esw0gZF3ASPDKkbR
	1NLkguKk9FxDveLE3OLSvHS95PzcTYyQSPiyg3HxMatDjAIcjEo8vBE3rwQLsSaWFVfmHmKU
	4GBWEuFt/3c1WIg3JbGyKrUoP76oNCe1+BAjEwenVAOj+L03e75/bgm4k8sj+a3Y+9nuOdyt
	WmuYA2fL77pSNGuCrfWtQ8xLru3ovG7xX9qM5/7nxy9Cfq7n8Re8uOb0A7aNlmlq3pP4tRv3
	nPx0vad03lnZrNOdxz4+P1jKmJP0Q0kzbO6qxGkpF9n+ir4/ZDB7ie32G3VPtiYyPApv2aHB
	7lhfdMn9jRJLcUaioRZzUXEiAPAO6QViAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin triggered use-after-free when fuzzing using trinity and the KASAN
patchset:

	AddressSanitizer: use after free in do_read_fault.isra.40+0x3c2/0x510 at addr ffff88048a733110
	page:ffffea001229ccc0 count:0 mapcount:0 mapping:          (null) index:0x0
	page flags: 0xafffff80008000(tail)
	page dumped because: kasan error
	CPU: 6 PID: 9262 Comm: trinity-c104 Not tainted 3.16.0-rc6-next-20140723-sasha-00047-g289342b-dirty #929
	 00000000000000fb 0000000000000000 ffffea001229ccc0 ffff88038ac0fb78
	 ffffffffa5e40903 ffff88038ac0fc48 ffff88038ac0fc38 ffffffffa142acfc
	 0000000000000001 ffff880509ff5aa8 ffff88038ac10038 ffff88038ac0fbb0
	Call Trace:
	dump_stack (lib/dump_stack.c:52)
	kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
	? debug_smp_processor_id (lib/smp_processor_id.c:57)
	? preempt_count_sub (kernel/sched/core.c:2606)
	? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
	? do_read_fault.isra.40 (mm/memory.c:2784 mm/memory.c:2849 mm/memory.c:2898)
	__asan_load8 (mm/kasan/kasan.c:364)
	? do_read_fault.isra.40 (mm/memory.c:2864 mm/memory.c:2898)
	do_read_fault.isra.40 (mm/memory.c:2864 mm/memory.c:2898)
	? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
	? __pte_alloc (mm/memory.c:598)
	handle_mm_fault (mm/memory.c:3092 mm/memory.c:3225 mm/memory.c:3345 mm/memory.c:3374)
	? pud_huge (./arch/x86/include/asm/paravirt.h:611 arch/x86/mm/hugetlbpage.c:76)
	__get_user_pages (mm/gup.c:286 mm/gup.c:478)
	__mlock_vma_pages_range (mm/mlock.c:262)
	__mm_populate (mm/mlock.c:710)
	SyS_remap_file_pages (mm/mmap.c:2653 mm/mmap.c:2593)
	tracesys (arch/x86/kernel/entry_64.S:541)
	Read of size 8 by thread T9262:
	Memory state around the buggy address:
	 ffff88048a732e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a732f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a732f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	>ffff88048a733100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	                         ^
	 ffff88048a733180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
	 ffff88048a733380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb


It looks like that pte pointer is invalid in do_fault_around().
This could happen if fault_around_bytes is set to 0.
fault_around_pages() and fault_around_mask() calls rounddown_pow_of_to(fault_around_bytes)
The result of rounddown_pow_of_to is undefined if parameter == 0
(in my environment it returns 0x8000000000000000).

One way to fix this would be to return 0 from fault_around_pages() if fault_around_bytes == 0,
however this would add extra code on fault path.

So let's just forbid to set fault_around_bytes to zero.
Fault around is not used if fault_around_pages() <= 1, so if anyone doesn't want to use
it, fault_around_bytes could be set to any value in range [1, 2*PAGE_SIZE - 1]
instead of 0.

Fixes: a9b0f861("mm: nominate faultaround area in bytes rather than page order")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: <stable@vger.kernel.org> # 3.15.x
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7e8d820..5927c42 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2784,7 +2784,7 @@ static int fault_around_bytes_get(void *data, u64 *val)
 
 static int fault_around_bytes_set(void *data, u64 val)
 {
-	if (val / PAGE_SIZE > PTRS_PER_PTE)
+	if (!val || val / PAGE_SIZE > PTRS_PER_PTE)
 		return -EINVAL;
 	fault_around_bytes = val;
 	return 0;
-- 
1.8.5.5

