Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHJItv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 04:49:51 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:57923 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaHJIts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 04:49:48 -0400
MIME-Version: 1.0
In-Reply-To: <53E6CEAA.9020105@oracle.com>
References: <53E6CEAA.9020105@oracle.com>
Date: Sun, 10 Aug 2014 12:49:47 +0400
Message-ID: <CAPAsAGxcC0+V1ZzR3LL=ASx=KXifPbw_cyvHCBBJT4mZ1grg+Q@mail.gmail.com>
Subject: Re: mm: compaction: buffer overflow in isolate_migratepages_range
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Dave Jones <davej@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-10 5:45 GMT+04:00 Sasha Levin <sasha.levin@oracle.com>:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel with the KASAN patchset, I've stumbled on the following spew:
>
>
> [ 3837.070452] ==================================================================
> [ 3837.073101] AddressSanitizer: buffer overflow in isolate_migratepages_range+0x85f/0xd90 at addr ffff88051b70eb49
> [ 3837.076310] page:ffffea00146dc380 count:0 mapcount:0 mapping:          (null) index:0x0
> [ 3837.079876] page flags: 0xafffff80008000(tail)
> [ 3837.114592] page dumped because: kasan error
> [ 3837.115897] CPU: 4 PID: 29613 Comm: trinity-c467 Not tainted 3.16.0-next-20140808-sasha-00051-gf368221 #1051
> [ 3837.118024]  00000000000000fc 0000000000000000 ffffea00146dc380 ffff8801f326f718
> [ 3837.119837]  ffffffff97e0d344 ffff8801f326f7e8 ffff8801f326f7d8 ffffffff9342d5bc
> [ 3837.121708]  ffffea00085163c0 0000000000000000 ffff8801f326f8e0 ffffffff93fe02fb
> [ 3837.123704] Call Trace:
> [ 3837.124272] dump_stack (lib/dump_stack.c:52)
> [ 3837.125166] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
> [ 3837.126128] ? trace_hardirqs_on_thunk (arch/x86/lib/thunk_64.S:33)
> [ 3837.127462] ? retint_restore_args (arch/x86/kernel/entry_64.S:828)
> [ 3837.128753] __asan_load8 (mm/kasan/kasan.c:364)
> [ 3837.129914] ? isolate_migratepages_range (./arch/x86/include/asm/bitops.h:311 include/linux/pagemap.h:70 include/linux/balloon_compaction.h:131 include/linux/balloon_compaction.h:156 mm/compaction.c:596)
> [ 3837.131613] isolate_migratepages_range (./arch/x86/include/asm/bitops.h:311 include/linux/pagemap.h:70 include/linux/balloon_compaction.h:131 include/linux/balloon_compaction.h:156 mm/compaction.c:596)
> [ 3837.132838] compact_zone (mm/compaction.c:877 mm/compaction.c:1044)
> [ 3837.133818] compact_zone_order (mm/compaction.c:1106)
> [ 3837.134982] try_to_compact_pages (mm/compaction.c:1161)
> [ 3837.135970] __alloc_pages_direct_compact (mm/page_alloc.c:2313)
> [ 3837.137217] ? next_zones_zonelist (mm/mmzone.c:72)
> [ 3837.138861] __alloc_pages_nodemask (mm/page_alloc.c:2640 mm/page_alloc.c:2806)
> [ 3837.139897] ? check_chain_key (kernel/locking/lockdep.c:2190)
> [ 3837.141220] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 3837.142434] alloc_pages_vma (mm/mempolicy.c:2046)
> [ 3837.143479] ? do_huge_pmd_wp_page (mm/huge_memory.c:774 mm/huge_memory.c:1123)
> [ 3837.144663] do_huge_pmd_wp_page (mm/huge_memory.c:774 mm/huge_memory.c:1123)
> [ 3837.145653] handle_mm_fault (mm/memory.c:3312 mm/memory.c:3370)
> [ 3837.146717] ? vmacache_find (mm/vmacache.c:100 (discriminator 1))
> [ 3837.147404] ? find_vma (mm/mmap.c:2024)
> [ 3837.147982] __do_page_fault (arch/x86/mm/fault.c:1231)
> [ 3837.148613] ? context_tracking_user_exit (kernel/context_tracking.c:184)
> [ 3837.149388] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> [ 3837.150212] ? trace_hardirqs_off_caller (kernel/locking/lockdep.c:2641 (discriminator 8))
> [ 3837.150977] ? trace_hardirqs_off (kernel/locking/lockdep.c:2647)
> [ 3837.151686] trace_do_page_fault (arch/x86/mm/fault.c:1314 include/linux/jump_label.h:115 include/linux/context_tracking_state.h:27 include/linux/context_tracking.h:45 arch/x86/mm/fault.c:1315)
> [ 3837.152870] do_async_page_fault (arch/x86/kernel/kvm.c:279)
> [ 3837.153886] async_page_fault (arch/x86/kernel/entry_64.S:1313)
> [ 3837.155293] Read of size 8 by thread T29613:
> [ 3837.156058] Memory state around the buggy address:
> [ 3837.156885]  ffff88051b70e880: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
> [ 3837.158141]  ffff88051b70e900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 3837.159492]  ffff88051b70e980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 3837.160863]  ffff88051b70ea00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 3837.162165]  ffff88051b70ea80: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
> [ 3837.163552] >ffff88051b70eb00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 3837.164866]                                               ^
> [ 3837.165914]  ffff88051b70eb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> [ 3837.167317]  ffff88051b70ec00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 3837.168616]  ffff88051b70ec80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 3837.169898]  ffff88051b70ed00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 3837.171298]  ffff88051b70ed80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [ 3837.172611] ==================================================================
>
>
> Thanks,
> Sasha

Bad access happens when we read page->mapping->flags in mapping_ballon().
Address of page->mapping->flags here is ffff88051b70eb49, so the
lowest bit is set,
which means that the lowest bit is also set in page->mapping pointer.
So page->mapping is a pointer to anon_vma, not to address_space.

I guess this could be fixed with something like following (completely
untested) patch:

--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -127,7 +127,7 @@ static inline bool page_flags_cleared(struct page *page)
  */
 static inline bool __is_movable_balloon_page(struct page *page)
 {
-       struct address_space *mapping = page->mapping;
+       struct address_space *mapping = page_mapping(page);
        return mapping_balloon(mapping);
 }

-- 
Best regards,
Andrey Ryabinin
