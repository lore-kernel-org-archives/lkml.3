Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934240AbaGXG7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 02:59:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37631 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaGXG7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 02:59:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-42-53d0aed3781f
Message-id: <53D0AD7E.3050705@samsung.com>
Date: Thu, 24 Jul 2014 10:53:50 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCHv3 1/2] mm: introduce vm_ops->map_pages()
References: <1393530827-25450-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1393530827-25450-2-git-send-email-kirill.shutemov@linux.intel.com>
 <53D07E96.5000006@oracle.com>
In-reply-to: <53D07E96.5000006@oracle.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42I5/e/4Fd3L6y4EG2w6oWFxfIKlxZz1a9gs
	XmxoZ7TYcr2JyWLLsXuMFjefz2GxWNn5gNViz96TLBaXd81hs7i35j+rxYHlR1ksJr97xmix
	55i1xd8r61ksFh+5zWzxqO8tu8X5v8dZHQQ9Ti2S8Ng56y67x+I9L5k8Nn2axO5xYsZvFo95
	JwM9Pj69xeLxft9VNo/Np6s9Pm+S89j05C1TAHcUl01Kak5mWWqRvl0CV8aaP3MZC7YbVuy9
	s5OpgfGhRhcjJ4eEgInEt6+zmCFsMYkL99azgdhCAksZJR4tNOti5AKym5kkGnYfYQdJ8Apo
	Saxb/oQFxGYRUJV4vLUTrJlNQE/i36ztYM2iAhESB/qesULUC0r8mHyPBWSQiEAjk8TN1UdZ
	QRxmgW5miScn+sE6hAVsJA4/O8gGsW4ro8TK+dfAxnICrTv3uRvMZhbQkdjfOo0NwpaX2Lzm
	LfMERoFZSLbMQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghEfh1B+PSY1aH
	GAU4GJV4eDlenAoWYk0sK67MPcQowcGsJMJbWnohWIg3JbGyKrUoP76oNCe1+BAjEwenVAOj
	f8HHZJXfYuHf9ItuTt0rKtt+2CBX81nxt0u7101ael07xO4Cw3+G7VHbEzIcwhx/rD09z03u
	kmNS2IK9lw4W2fzSuN4gERjzeNsG0xKxY9z5BU4RkYIbNtrUP6lfpt4ePNlP2FByyU+Olfsn
	2bpvv+Vf1DZ1vUVK6OfJCzeK2DLtCzy1t3qKEktxRqKhFnNRcSIAy4FlFZ4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/14 07:33, Sasha Levin wrote:
> On 02/27/2014 02:53 PM, Kirill A. Shutemov wrote:
>> The patch introduces new vm_ops callback ->map_pages() and uses it for
>> mapping easy accessible pages around fault address.
>>
>> On read page fault, if filesystem provides ->map_pages(), we try to map
>> up to FAULT_AROUND_PAGES pages around page fault address in hope to
>> reduce number of minor page faults.
>>
>> We call ->map_pages first and use ->fault() as fallback if page by the
>> offset is not ready to be mapped (cold page cache or something).
>>
>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> ---
> 
> Hi all,
> 
> This patch triggers use-after-free when fuzzing using trinity and the KASAN
> patchset.
> 

I think this should be fixed already by following patch:

From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: mm: do not call do_fault_around for non-linear fault

Ingo Korb reported that "repeated mapping of the same file on tmpfs using
remap_file_pages sometimes triggers a BUG at mm/filemap.c:202 when the
process exits".  He bisected the bug to d7c1755179b82d ("mm: implement
->map_pages for shmem/tmpfs"), although the bug was actually added by
8c6e50b0290c4 ("mm: introduce vm_ops->map_pages()").

Problem is caused by calling do_fault_around for _non-linear_ faiult.  In
this case pgoff is shifted and might become negative during calculation.

Faulting around non-linear page-fault has no sense and breaks logic in
do_fault_around because pgoff is shifted.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: Ingo Korb <ingo.korb@tu-dortmund.de>
Tested-by: Ingo Korb <ingo.korb@tu-dortmund.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ning Qu <quning@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memory.c~mm-do-not-call-do_fault_around-for-non-linear-fault mm/memory.c
--- a/mm/memory.c~mm-do-not-call-do_fault_around-for-non-linear-fault
+++ a/mm/memory.c
@@ -2882,7 +2882,8 @@ static int do_read_fault(struct mm_struc
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages && fault_around_pages() > 1) {
+	if (vma->vm_ops->map_pages && !(flags & FAULT_FLAG_NONLINEAR) &&
+	    fault_around_pages() > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))


> KASAN's report is:
> 
> [  663.269187] AddressSanitizer: use after free in do_read_fault.isra.40+0x3c2/0x510 at addr ffff88048a733110
> [  663.275260] page:ffffea001229ccc0 count:0 mapcount:0 mapping:          (null) index:0x0
> [  663.277061] page flags: 0xafffff80008000(tail)
> [  663.278759] page dumped because: kasan error
> [  663.280645] CPU: 6 PID: 9262 Comm: trinity-c104 Not tainted 3.16.0-rc6-next-20140723-sasha-00047-g289342b-dirty #929
> [  663.282898]  00000000000000fb 0000000000000000 ffffea001229ccc0 ffff88038ac0fb78
> [  663.288759]  ffffffffa5e40903 ffff88038ac0fc48 ffff88038ac0fc38 ffffffffa142acfc
> [  663.291496]  0000000000000001 ffff880509ff5aa8 ffff88038ac10038 ffff88038ac0fbb0
> [  663.294379] Call Trace:
> [  663.294806] dump_stack (lib/dump_stack.c:52)
> [  663.300665] kasan_report_error (mm/kasan/report.c:98 mm/kasan/report.c:166)
> [  663.301659] ? debug_smp_processor_id (lib/smp_processor_id.c:57)
> [  663.304645] ? preempt_count_sub (kernel/sched/core.c:2606)
> [  663.305800] ? put_lock_stats.isra.13 (./arch/x86/include/asm/preempt.h:98 kernel/locking/lockdep.c:254)
> [  663.306839] ? do_read_fault.isra.40 (mm/memory.c:2784 mm/memory.c:2849 mm/memory.c:2898)
> [  663.307515] __asan_load8 (mm/kasan/kasan.c:364)
> [  663.308038] ? do_read_fault.isra.40 (mm/memory.c:2864 mm/memory.c:2898)
> [  663.309158] do_read_fault.isra.40 (mm/memory.c:2864 mm/memory.c:2898)
> [  663.310311] ? _raw_spin_unlock (./arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
> [  663.311282] ? __pte_alloc (mm/memory.c:598)
> [  663.312331] handle_mm_fault (mm/memory.c:3092 mm/memory.c:3225 mm/memory.c:3345 mm/memory.c:3374)
> [  663.313895] ? pud_huge (./arch/x86/include/asm/paravirt.h:611 arch/x86/mm/hugetlbpage.c:76)
> [  663.314793] __get_user_pages (mm/gup.c:286 mm/gup.c:478)
> [  663.315775] __mlock_vma_pages_range (mm/mlock.c:262)
> [  663.316879] __mm_populate (mm/mlock.c:710)
> [  663.317813] SyS_remap_file_pages (mm/mmap.c:2653 mm/mmap.c:2593)
> [  663.318848] tracesys (arch/x86/kernel/entry_64.S:541)
> [  663.319683] Read of size 8 by thread T9262:
> [  663.320580] Memory state around the buggy address:
> [  663.321392]  ffff88048a732e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.322573]  ffff88048a732f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.323802]  ffff88048a732f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.325080]  ffff88048a733000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.326327]  ffff88048a733080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.327572] >ffff88048a733100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.328840]                          ^
> [  663.329487]  ffff88048a733180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.330762]  ffff88048a733200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.331994]  ffff88048a733280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.333262]  ffff88048a733300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  663.334488]  ffff88048a733380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> 
> This also proceeds with the traditional:
> 
> [  663.474532] BUG: unable to handle kernel paging request at ffff88048a635de8
> [  663.474548] IP: do_read_fault.isra.40 (mm/memory.c:2864 mm/memory.c:2898)
> 
> But the rest of it got scrambled between the KASAN prints and the other BUG info + trace (who
> broke printk?!).
> 
> 
> Thanks,
> Sasha
> 

